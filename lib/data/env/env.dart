
import 'package:get/get_rx/src/rx_types/rx_types.dart';



class Environment {
  // static const String baseUrl = 'http://gtv2.tn:6274/';
  static const String basUrl = 'http://onplus.me:6274/';

  // static const String urlApi = 'http://gtv2.tn:6274/api-v3';

  static const String urlDataServer = 'Https://multiacs.com';


  static RxString urlApi = 'http://onplus.me:8000/'.obs;



  static RxString code = "292150819813".obs;



  static const String assetsPath = "assets/";
  static const String assetsJsonPath = "assets/json/";
  static const String assetsImagesPath = "assets/images/";

  // Decrypt Function
  static String encryptDecrypt(String input) {
    String key = "Ax0#fc_W7k@49N+6G8/1pl7";
    String output = "";
    int keyLen = key.length;
    for (int i = 0; i < input.length; i++) {
      output += String.fromCharCode(
          input.codeUnitAt(i) ^ key.codeUnitAt(i % keyLen));
    }
    return output;
  }

}
