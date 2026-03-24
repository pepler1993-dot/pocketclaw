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

class OpenAiHttpException implements Exception {
  OpenAiHttpException(this.statusCode, this.body);
  final int statusCode;
  final String body;

  @override
  String toString() => 'OpenAI HTTP $statusCode: $body';
}
