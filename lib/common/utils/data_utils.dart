import 'dart:convert';

import 'package:flutterskills/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String path) => 'http://$ip$path';

  static List<String> listPathToUrl(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain) {
    // String -> base64
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    // 인코딩
    String encoded = stringToBase64.encode(plain);

    return encoded;
  }
}
