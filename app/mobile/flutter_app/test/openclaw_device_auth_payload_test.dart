import 'package:flutter_test/flutter_test.dart';
import 'package:pocketclaw_flutter_app/services/openclaw_device_auth_payload.dart';

void main() {
  test('buildDeviceAuthPayloadV3 matches OpenClaw pipe format', () {
    expect(
      buildDeviceAuthPayloadV3(
        deviceId: 'dev1',
        clientId: 'pocketclaw',
        clientMode: 'operator',
        role: 'operator',
        scopes: <String>['operator.read', 'operator.write'],
        signedAtMs: 1000,
        token: 'tok',
        nonce: 'n1',
        platform: 'android',
        deviceFamily: 'phone',
      ),
      'v3|dev1|pocketclaw|operator|operator|operator.read,operator.write|1000|tok|n1|android|phone',
    );
  });

  test('normalizeDeviceMetadataForAuth lowercases ASCII', () {
    expect(normalizeDeviceMetadataForAuth('  Android  '), 'android');
    expect(normalizeDeviceMetadataForAuth(''), '');
  });
}
