/// Model + API routing for the chat/backend (OpenClaw-shell style: pick a model, then how the API is reached).
class ProviderConfigModel {
  const ProviderConfigModel({
    required this.modelProfileLabel,
    required this.apiConnectionLabel,
    this.customApiBaseUrl,
  });

  final String modelProfileLabel;

  /// How inference/API calls are routed (see [apiConnectionLabels]).
  final String apiConnectionLabel;

  /// When [apiConnectionLabel] is [apiCustomBaseUrl], optional HTTPS base URL.
  final String? customApiBaseUrl;

  // --- Model presets (shell-style first step) ---

  static const String modelDefault = 'Default';
  static const String modelFast = 'Fast (smaller context)';
  static const String modelCapable = 'Capable (larger context)';

  static const List<String> modelProfileLabels = <String>[
    modelDefault,
    modelFast,
    modelCapable,
  ];

  // --- API connection (second step: “API rein”) ---

  static const String apiGatewayEmbedded = 'Gateway default (embedded)';
  static const String apiOpenClawCloud = 'OpenClaw Cloud API';
  static const String apiOpenAiCompatible = 'OpenAI-compatible API';
  static const String apiAnthropic = 'Anthropic API';
  static const String apiCustomBaseUrl = 'Custom base URL';

  static const List<String> apiConnectionLabels = <String>[
    apiGatewayEmbedded,
    apiOpenClawCloud,
    apiOpenAiCompatible,
    apiAnthropic,
    apiCustomBaseUrl,
  ];

  /// One line for settings / headers.
  String get displayLabel {
    if (apiConnectionLabel == apiCustomBaseUrl &&
        customApiBaseUrl != null &&
        customApiBaseUrl!.trim().isNotEmpty) {
      return '$modelProfileLabel · ${customApiBaseUrl!.trim()}';
    }
    return '$modelProfileLabel · $apiConnectionLabel';
  }

  String get shortDescription => switch (apiConnectionLabel) {
        apiGatewayEmbedded =>
          'Model uses whatever API/credentials the gateway is configured with.',
        apiOpenClawCloud => 'Inference via OpenClaw Cloud.',
        apiOpenAiCompatible => 'Traffic to an OpenAI-compatible HTTP API.',
        apiAnthropic => 'Traffic to Anthropic’s API.',
        apiCustomBaseUrl => 'Traffic to your own base URL (advanced).',
        _ => 'Chat/backend routing for the assistant.',
      };

  factory ProviderConfigModel.fromSetup({
    required String modelProfileLabel,
    required String apiConnectionLabel,
    String? customApiBaseUrl,
  }) {
    return ProviderConfigModel(
      modelProfileLabel: modelProfileLabel,
      apiConnectionLabel: apiConnectionLabel,
      customApiBaseUrl: _trimOrNull(customApiBaseUrl),
    );
  }

  static String? _trimOrNull(String? s) {
    if (s == null) {
      return null;
    }
    final String t = s.trim();
    return t.isEmpty ? null : t;
  }

  /// Legacy single-field `pc_selected_provider` migration.
  factory ProviderConfigModel.fromLegacyProvider(String? legacy) {
    switch (legacy) {
      case 'OpenClaw Cloud':
        return const ProviderConfigModel(
          modelProfileLabel: modelDefault,
          apiConnectionLabel: apiOpenClawCloud,
        );
      case 'Custom Endpoint':
        return const ProviderConfigModel(
          modelProfileLabel: modelDefault,
          apiConnectionLabel: apiCustomBaseUrl,
        );
      case 'Local Runtime':
      default:
        return const ProviderConfigModel(
          modelProfileLabel: modelDefault,
          apiConnectionLabel: apiGatewayEmbedded,
        );
    }
  }

  @override
  bool operator ==(Object other) {
    return other is ProviderConfigModel &&
        other.modelProfileLabel == modelProfileLabel &&
        other.apiConnectionLabel == apiConnectionLabel &&
        other.customApiBaseUrl == customApiBaseUrl;
  }

  @override
  int get hashCode => Object.hash(modelProfileLabel, apiConnectionLabel, customApiBaseUrl);
}
