import 'package:flutterskills/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String path) => 'http://$ip$path';

  static List<String> listPathToUrl(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }
}
