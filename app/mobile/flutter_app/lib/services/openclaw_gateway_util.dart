/// Normalizes user input into a base URL without trailing slash (e.g. `http://192.168.1.10:18789`).
String normalizeOpenClawGatewayBaseUrl(String raw) {
  String s = raw.trim();
  if (s.isEmpty) {
    return '';
  }
  if (!s.startsWith('http://') && !s.startsWith('https://')) {
    s = 'http://$s';
  }
  while (s.endsWith('/')) {
    s = s.substring(0, s.length - 1);
  }
  return s;
}

Uri openClawGatewayUri(String normalizedBase, String path) {
  final String p = path.startsWith('/') ? path : '/$path';
  return Uri.parse('$normalizedBase$p');
}

/// WebSocket URL for the gateway control plane (same host/port as HTTP).
Uri httpBaseToWsUri(String normalizedHttpBase) {
  final Uri u = Uri.parse(normalizedHttpBase);
  final String scheme = u.scheme == 'https' ? 'wss' : 'ws';
  final String path = u.path.isEmpty ? '/' : u.path;
  return Uri(
    scheme: scheme,
    host: u.host,
    port: u.hasPort ? u.port : null,
    path: path,
  );
}
