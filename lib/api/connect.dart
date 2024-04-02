import 'package:http/http.dart' as http;
class Apis {
  static const Api = 'https://yamakexpress.com/vcenter/system/';
  static late String Version = '1.5.9';
  late int amount  = 0;
  int getAmountonline(){
    return amount;
  }
  void  setAmount(int amo){
    amount = amo;
  }
//by Dev Ali
}