/// Where the OpenClaw gateway / runtime is expected to run.
///
/// **Phone-first:** [RuntimeDeploymentKind.thisPhone] is the default product path.
enum RuntimeDeploymentKind {
  /// OpenClaw runs on this device (primary goal for PocketClaw).
  thisPhone,

  /// User runs a gateway on another machine on the LAN (e.g. PC/NAS).
  homeNetworkLan,

  /// Managed / hosted OpenClaw (remote).
  openClawCloud,

  /// User-supplied gateway URL (advanced).
  customGateway,
}

class RuntimeDeploymentModel {
  const RuntimeDeploymentModel({required this.kind});

  final RuntimeDeploymentKind kind;

  /// Persisted radio labels (must stay stable for [fromSelectionLabel]).
  static const String labelThisPhone = 'This phone';
  static const String labelHomeNetworkLan = 'Home network (LAN)';
  static const String labelOpenClawCloud = 'OpenClaw Cloud';
  static const String labelCustomGateway = 'Custom gateway';

  String get displayLabel => switch (kind) {
        RuntimeDeploymentKind.thisPhone => labelThisPhone,
        RuntimeDeploymentKind.homeNetworkLan => labelHomeNetworkLan,
        RuntimeDeploymentKind.openClawCloud => labelOpenClawCloud,
        RuntimeDeploymentKind.customGateway => labelCustomGateway,
      };

  /// Short line for settings / status.
  String get shortDescription => switch (kind) {
        RuntimeDeploymentKind.thisPhone =>
          'Gateway targets this device (local-first).',
        RuntimeDeploymentKind.homeNetworkLan =>
          'Gateway runs on another device on your Wi‑Fi or LAN.',
        RuntimeDeploymentKind.openClawCloud =>
          'Hosted OpenClaw runtime (remote).',
        RuntimeDeploymentKind.customGateway =>
          'Connect to your own gateway URL.',
      };

  /// Shown in runtime “mode” line while mock is active.
  String get runtimeModeSummary => switch (kind) {
        RuntimeDeploymentKind.thisPhone => 'On-device gateway (target)',
        RuntimeDeploymentKind.homeNetworkLan => 'LAN gateway (target)',
        RuntimeDeploymentKind.openClawCloud => 'Cloud gateway (target)',
        RuntimeDeploymentKind.customGateway => 'Custom gateway (target)',
      };

  factory RuntimeDeploymentModel.fromSelectionLabel(String label) {
    switch (label) {
      case labelThisPhone:
        return const RuntimeDeploymentModel(kind: RuntimeDeploymentKind.thisPhone);
      case labelHomeNetworkLan:
        return const RuntimeDeploymentModel(kind: RuntimeDeploymentKind.homeNetworkLan);
      case labelOpenClawCloud:
        return const RuntimeDeploymentModel(kind: RuntimeDeploymentKind.openClawCloud);
      case labelCustomGateway:
        return const RuntimeDeploymentModel(kind: RuntimeDeploymentKind.customGateway);
      default:
        return const RuntimeDeploymentModel(kind: RuntimeDeploymentKind.thisPhone);
    }
  }
}
