import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FirebaseStorageService extends ChangeNotifier {
  FirebaseStorageService();

  static Future<dynamic> loadFromStorage(BuildContext context, String image) async{
    // print("$image");
    return await FirebaseStorage.instance.ref().child("$image").getDownloadURL();
  }

  
}