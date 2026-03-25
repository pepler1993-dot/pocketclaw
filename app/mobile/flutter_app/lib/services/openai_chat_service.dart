import 'dart:convert';

import 'package:http/http.dart' as http;

import '../persistence/openai_token_store.dart';

/// Calls OpenAI Chat Completions using an optional **API key** (preferred for `api.openai.com`)
/// or an **OAuth access token** if no key is stored (and session is not mock-only).
///
/// OpenAI’s public API expects `Authorization: Bearer` with an **API key** for most accounts.
/// OAuth tokens from external IdPs often return 401 here — use [OpenAiTokenStore.writeApiKey] for dev.
class OpenAiChatService {
  static const String _completionsUrl = 'https://api.openai.com/v1/chat/completions';

  /// Whether [completeOrNull] / streaming can authenticate (API key or non-mock OAuth token).
  static Future<bool> hasBearerForChat() async {
    final String? apiKey = await OpenAiTokenStore.readApiKey();
    final String? keyOrToken = await _resolveBearer(apiKey);
    return keyOrToken != null && keyOrToken.isNotEmpty;
  }

  /// Server-sent events stream (`stream: true`); each event is **accumulated** assistant text so far.
  static Stream<String> streamCompletionAccumulated({
    required String model,
    required String userText,
  }) async* {
    final String? apiKey = await OpenAiTokenStore.readApiKey();
    final String? keyOrToken = await _resolveBearer(apiKey);
    if (keyOrToken == null || keyOrToken.isEmpty) {
      return;
    }

    final http.Client client = http.Client();
    try {
      final http.Request request = http.Request('POST', Uri.parse(_completionsUrl));
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $keyOrToken';
      request.body = jsonEncode(<String, Object?>{
        'model': model,
        'messages': <Map<String, String>>[
          <String, String>{'role': 'user', 'content': userText},
        ],
        'stream': true,
      });
      final http.StreamedResponse response = await client.send(request);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final String body = await response.stream.bytesToString();
        throw OpenAiHttpException(response.statusCode, body);
      }

      String accumulated = '';
      await for (final String line
          in response.stream.transform(utf8.decoder).transform(const LineSplitter())) {
        final String? delta = openAiChatCompletionDeltaFromSseLine(line);
        if (delta != null && delta.isNotEmpty) {
          accumulated += delta;
          yield accumulated;
        }
      }
    } finally {
      client.close();
    }
  }

  static Future<String?> completeOrNull({
    required String model,
    required String userText,
  }) async {
    final String? apiKey = await OpenAiTokenStore.readApiKey();
    final String? keyOrToken = await _resolveBearer(apiKey);
    if (keyOrToken == null || keyOrToken.isEmpty) {
      return null;
    }

    final http.Response res = await http.post(
      Uri.parse(_completionsUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $keyOrToken',
      },
      body: jsonEncode(<String, Object?>{
        'model': model,
        'messages': <Map<String, String>>[
          <String, String>{'role': 'user', 'content': userText},
        ],
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw OpenAiHttpException(res.statusCode, res.body);
    }

    final Map<String, dynamic> json = jsonDecode(res.body) as Map<String, dynamic>;
    final List<dynamic>? choices = json['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      return null;
    }
    final Map<String, dynamic> first = choices.first as Map<String, dynamic>;
    final Map<String, dynamic>? message = first['message'] as Map<String, dynamic>?;
    return message?['content'] as String?;
  }

  /// API key wins; otherwise OAuth token unless mock OAuth session with no key.
  static Future<String?> _resolveBearer(String? apiKey) async {
    if (apiKey != null && apiKey.trim().isNotEmpty) {
      return apiKey.trim();
    }
    if (await OpenAiTokenStore.isMockSession()) {
      return null;
    }
    final String? token = await OpenAiTokenStore.readAccessToken();
    if (token == null || token.isEmpty) {
      return null;
    }
    return token;
  }
}

/// Parses one SSE line from OpenAI chat completions streaming.
/// Returns a **non-empty** content delta, or `null` for ignorable lines / `[DONE]`.
String? openAiChatCompletionDeltaFromSseLine(String line) {
  final String trimmed = line.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  const String prefix = 'data:';
  if (!trimmed.startsWith(prefix)) {
    return null;
  }
  final String payload = trimmed.substring(prefix.length).trim();
  if (payload == '[DONE]') {
    return null;
  }
  try {
    final Map<String, dynamic> json = jsonDecode(payload) as Map<String, dynamic>;
    final List<dynamic>? choices = json['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      return null;
    }
    final Map<String, dynamic> first = choices.first as Map<String, dynamic>;
    final Map<String, dynamic>? delta = first['delta'] as Map<String, dynamic>?;
    final String? content = delta?['content'] as String?;
    if (content == null || content.isEmpty) {
      return null;
    }
    return content;
  } catch (_) {
    return null;
  }
}

class OpenAiHttpException implements Exception {
  OpenAiHttpException(this.statusCode, this.body);
  final int statusCode;
  final String body;

  @override
  String toString() => 'OpenAI HTTP $statusCode: $body';
}
