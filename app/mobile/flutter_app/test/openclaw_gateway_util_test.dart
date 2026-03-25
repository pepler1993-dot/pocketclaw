import 'package:flutter_test/flutter_test.dart';
import 'package:pocketclaw_flutter_app/services/openclaw_gateway_util.dart';

void main() {
  test('normalizeOpenClawGatewayBaseUrl adds scheme and strips slashes', () {
    expect(
      normalizeOpenClawGatewayBaseUrl('192.168.0.5:18789'),
      'http://192.168.0.5:18789',
    );
    expect(
      normalizeOpenClawGatewayBaseUrl('https://gw.example.com:443/'),
      'https://gw.example.com:443',
    );
    expect(normalizeOpenClawGatewayBaseUrl(''), '');
  });

  test('openClawGatewayUri joins path', () {
    final Uri u = openClawGatewayUri('http://127.0.0.1:18789', '/v1/models');
    expect(u.toString(), 'http://127.0.0.1:18789/v1/models');
  });
}
