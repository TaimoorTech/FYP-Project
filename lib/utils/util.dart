import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class Util {
  static void normalSnackBar(BuildContext contexts, String textMsg){
    SnackBar snackBar = SnackBar(content: Text(textMsg,
        style: const TextStyle(color: Colors.white)), elevation: 5, duration: Duration(seconds: 1),
        backgroundColor: Colors.black);
    ScaffoldMessenger.of(contexts).showSnackBar(snackBar);
  }

  static void submittedSnackBar(BuildContext contexts, String textMsg){
    SnackBar snackBar = SnackBar(content: Text(textMsg,
        style: const TextStyle(color: Colors.white)), elevation: 5, duration: Duration(seconds: 1),
        backgroundColor: Colors.green);
    ScaffoldMessenger.of(contexts).showSnackBar(snackBar);
  }

  static void errorSnackBar(BuildContext contexts, String errorMsg){
    SnackBar snackBar = SnackBar(content: Text(errorMsg,
        style: const TextStyle(color: Colors.white)), elevation: 5, duration: Duration(seconds: 1),
        backgroundColor: Colors.red);
    ScaffoldMessenger.of(contexts).showSnackBar(snackBar);
  }

  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
