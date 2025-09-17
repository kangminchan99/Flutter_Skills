import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String accessTokenKey = 'ACCESS_TOKEN';
const String refreshTokenKey = 'REFRESH_TOKEN';

final storage = FlutterSecureStorage();

// localhost
final emulatorIp = '10.0.2.2:3000';
final simulatorIp = '127.0.0.1:3000';

final ip = Platform.isAndroid ? emulatorIp : simulatorIp;
