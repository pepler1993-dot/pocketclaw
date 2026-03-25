import 'openai_chat_service.dart';
import 'openclaw_gateway_chat_service.dart';

/// Routes chat to **OpenClaw Gateway** (HTTP) when enabled and configured, else **direct OpenAI**.
class UnifiedChatService {
  UnifiedChatService._();

  /// True if streaming chat can use a live backend (gateway or OpenAI).
  static Future<bool> hasLiveStreamBackend() async {
    if (await OpenClawGatewayChatService.gatewayReady()) {
      return true;
    }
    return OpenAiChatService.hasBearerForChat();
  }

  static Stream<String> streamCompletionAccumulated({
    required String model,
    required String userText,
  }) async* {
    if (await OpenClawGatewayChatService.gatewayReady()) {
      yield* OpenClawGatewayChatService.streamCompletionAccumulated(
        model: model,
        userText: userText,
      );
    } else {
      yield* OpenAiChatService.streamCompletionAccumulated(
        model: model,
        userText: userText,
      );
    }
  }

  static Future<String?> completeOrNull({
    required String model,
    required String userText,
  }) async {
    if (await OpenClawGatewayChatService.gatewayReady()) {
      return OpenClawGatewayChatService.completeOrNull(
        model: model,
        userText: userText,
      );
    }
    return OpenAiChatService.completeOrNull(
      model: model,
      userText: userText,
    );
  }
}
