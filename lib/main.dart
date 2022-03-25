import 'package:ecommerce_app/view/controlview.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:firebase_core/firebase_core.dart';

import 'helpers/Binding.dart';

void main()async {

WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: Binding(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
    
        body: ControlView(),
      ),
    );
  }
}



