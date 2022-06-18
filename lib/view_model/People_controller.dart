
import 'package:ecommerce_app/Model/People.dart';
import 'package:ecommerce_app/Model/UserModel.dart';
import 'package:ecommerce_app/services/Firestoreserv.dart';
import 'package:get/get.dart';

class PeopleController extends GetxController{

  Rxn <List<People>> people=Rxn<List<People>>();

  List<People>?  get  users =>people.value;

  @override
  void onInit() {
    people.bindStream(Firestoreservice().get_all_people());
  }
} 