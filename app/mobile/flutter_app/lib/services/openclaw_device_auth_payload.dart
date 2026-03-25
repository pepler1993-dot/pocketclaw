/// Matches OpenClaw `buildDeviceAuthPayloadV3` / `buildDeviceAuthPayload`
/// ([device-auth.ts](https://github.com/openclaw/openclaw/blob/main/src/gateway/device-auth.ts)).
String normalizeDeviceMetadataForAuth(String? value) {
  final String trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) {
    return '';
  }
  return trimmed.toLowerCase();
}

String buildDeviceAuthPayloadV2({
  required String deviceId,
  required String clientId,
  required String clientMode,
  required String role,
  required List<String> scopes,
  required int signedAtMs,
  String? token,
  required String nonce,
}) {
  final String scopesJoined = scopes.join(',');
  final String t = token ?? '';
  return <String>[
    'v2',
    deviceId,
    clientId,
    clientMode,
    role,
    scopesJoined,
    signedAtMs.toString(),
    t,
    nonce,
  ].join('|');
}

String buildDeviceAuthPayloadV3({
  required String deviceId,
  required String clientId,
  required String clientMode,
  required String role,
  required List<String> scopes,
  required int signedAtMs,
  String? token,
  required String nonce,
  String? platform,
  String? deviceFamily,
}) {
  final String scopesJoined = scopes.join(',');
  final String t = token ?? '';
  final String p = normalizeDeviceMetadataForAuth(platform);
  final String df = normalizeDeviceMetadataForAuth(deviceFamily);
  return <String>[
    'v3',
    deviceId,
    clientId,
    clientMode,
    role,
    scopesJoined,
    signedAtMs.toString(),
    t,
    nonce,
    p,
    df,
  ].join('|');
}
