import 'dart:convert';

import 'package:http/http.dart' as http;

import '../persistence/openai_token_store.dart';

/// Calls OpenAI Chat Completions when a non-mock OAuth access token is present.
///
/// Many OAuth tokens are **not** accepted by `api.openai.com` (which expects API keys).
/// This is wired for when your token is valid for the OpenAI API or a compatible proxy.
class OpenAiChatService {
  static const String _completionsUrl = 'https://api.openai.com/v1/chat/completions';

  static Future<String?> completeOrNull({
    required String model,
    required String userText,
  }) async {
    if (await OpenAiTokenStore.isMockSession()) {
      return null;
    }
    final String? token = await OpenAiTokenStore.readAccessToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    final http.Response res = await http.post(
      Uri.parse(_completionsUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
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
}

class OpenAiHttpException implements Exception {
  OpenAiHttpException(this.statusCode, this.body);
  final int statusCode;
  final String body;

  @override
  String toString() => 'OpenAI HTTP $statusCode: $body';
}
