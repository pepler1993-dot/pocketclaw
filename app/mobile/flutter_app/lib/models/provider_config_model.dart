/// Selected model/runtime provider for the PocketClaw session (setup + settings).
enum ProviderKind {
  localRuntime,
  openClawCloud,
  customEndpoint,
}

class ProviderConfigModel {
  const ProviderConfigModel({
    required this.kind,
    this.customEndpoint,
  });

  final ProviderKind kind;

  /// When [kind] is [ProviderKind.customEndpoint], optional user URL.
  final String? customEndpoint;

  /// Display strings used in setup (must match [AppFlowController] selection labels).
  static const String labelLocalRuntime = 'Local Runtime';
  static const String labelOpenClawCloud = 'OpenClaw Cloud';
  static const String labelCustomEndpoint = 'Custom Endpoint';

  String get displayLabel => switch (kind) {
        ProviderKind.localRuntime => labelLocalRuntime,
        ProviderKind.openClawCloud => labelOpenClawCloud,
        ProviderKind.customEndpoint => labelCustomEndpoint,
      };

  String get shortDescription => switch (kind) {
        ProviderKind.localRuntime => 'On-device runtime bridge',
        ProviderKind.openClawCloud => 'Managed cloud runtime',
        ProviderKind.customEndpoint => 'Your own API endpoint',
      };

  /// Maps the onboarding radio label to a structured config.
  factory ProviderConfigModel.fromSelectionLabel(String label) {
    switch (label) {
      case labelLocalRuntime:
        return const ProviderConfigModel(kind: ProviderKind.localRuntime);
      case labelOpenClawCloud:
        return const ProviderConfigModel(kind: ProviderKind.openClawCloud);
      case labelCustomEndpoint:
        return const ProviderConfigModel(kind: ProviderKind.customEndpoint);
      default:
        return const ProviderConfigModel(kind: ProviderKind.localRuntime);
    }
  }
}
