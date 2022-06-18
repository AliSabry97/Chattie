

import 'package:ecommerce_app/services/Firestoreserv.dart';
import 'package:ecommerce_app/view_model/AuthModel.dart';

import 'package:get/get.dart';

class SinglePersonController  extends GetxController{

  RxString btnTxt="Add Friend".obs;
  RxBool data=false.obs;


  String get buttonstring =>btnTxt.value;
  late String onetosearch, onetocheck;
  final authcontroller=Get.find<AuthViewModel>();
  RxBool   btnVisible=false.obs ;
 Rxn <List<String>> friendRequest=Rxn <List<String>>();
 Rxn <List<String>> friendRequest1=Rxn <List<String>>();



  
  SinglePersonController(
    {
      required this.onetosearch,
     required this.onetocheck,
    }
  );


  @override
  void onInit() {
    
  
    super.onInit();
    friendRequest.bindStream(Firestoreservice().getrequestuser1(onetosearch, onetocheck));

   friendRequest1.bindStream(Firestoreservice().getrequestuser1(onetocheck, onetosearch));
  
 
    ever(friendRequest, checkfriendship);
     ever(friendRequest1, checkfriendship);
  }
 



  
  
 
  


checkfriendship(user1)async{
  var check=await Firestoreservice().checkFriendShipBetweenUs(onetosearch, onetocheck);
   var  doublecheck=await Firestoreservice().checkFriendShipBetweenUs(onetocheck, onetosearch);
  if(check)
    {
      btnTxt.value="Send Sms";

    }
    else
    {
     
      if(doublecheck){
        btnTxt.value="Send Sms";
      }
      else
      checkRequest(user1);

    }
}

checkRequest(user1)async{

  var check1=await Firestoreservice().checkFriendRequest(onetosearch, onetocheck);
  var check2=await Firestoreservice().checkFriendRequest(onetocheck, onetosearch);
 
  if(check1){
    btnTxt.value="Accept Request";
    
  }
  else
  {
if(check2)
  {
  btnTxt.value="Cancel Request";
  } 
  else
  btnTxt.value="Add Friend";
  
  }
  

}
}