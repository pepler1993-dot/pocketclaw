import 'package:flutter_test/flutter_test.dart';
import 'package:pocketclaw_flutter_app/services/openai_chat_service.dart';

void main() {
  test('parses delta content from SSE data line', () {
    const String line = 'data: {"choices":[{"delta":{"content":"Hi"}}]}';
    expect(openAiChatCompletionDeltaFromSseLine(line), 'Hi');
  });

  test('returns null for [DONE]', () {
    expect(openAiChatCompletionDeltaFromSseLine('data: [DONE]'), isNull);
  });

  test('returns null for empty delta content', () {
    const String line = 'data: {"choices":[{"delta":{"role":"assistant"}}]}';
    expect(openAiChatCompletionDeltaFromSseLine(line), isNull);
  });

  test('ignores non-data lines', () {
    expect(openAiChatCompletionDeltaFromSseLine(': ping'), isNull);
    expect(openAiChatCompletionDeltaFromSseLine(''), isNull);
  });

  test('concatenates are handled by caller; single chunk is one delta', () {
    const String line =
        'data: {"choices":[{"index":0,"delta":{"content":" world"}}]}';
    expect(openAiChatCompletionDeltaFromSseLine(line), ' world');
  });
}
