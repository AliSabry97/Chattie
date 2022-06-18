import 'package:ecommerce_app/view_model/AuthModel.dart';
import 'package:ecommerce_app/view_model/People_controller.dart';
import 'package:get/get.dart';

class Binding extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthViewModel());
 
  }


}