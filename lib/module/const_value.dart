import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

const String ipv4 = '192.168.1.102';
/*final*/ const String mainUrl = /*kDebugMode?defaultTargetPlatform==TargetPlatform.android||defaultTargetPlatform==TargetPlatform.iOS?
                          'http://$ipv4:3000'
                            :
                          'http://localhost:3000'
                            :
                          */'https://opus.kg:3000';
/*final*/ const String urlGQLws = /*kDebugMode?defaultTargetPlatform==TargetPlatform.android||defaultTargetPlatform==TargetPlatform.iOS?
                          'ws://$ipv4:3000/graphql'
                              :
                          'ws://localhost:3000/graphql'
                              :
                          */'wss://opus.kg:3000/graphql';
/*final*/ const String urlGQL = '$mainUrl/graphql';

const Map<int, Color> mainMaterialColorPalete = {
  50:Color.fromRGBO(0,169,72, 1),
  100:Color.fromRGBO(0,169,72, 1),
  200:Color.fromRGBO(0,169,72, 1),
  300:Color.fromRGBO(0,169,72, 1),
  400:Color.fromRGBO(0,169,72, 1),
  500:Color.fromRGBO(0,169,72, 1),
  600:Color.fromRGBO(0,169,72, 1),
  700:Color.fromRGBO(0,169,72, 1),
  800:Color.fromRGBO(0,169,72, 1),
  900:Color.fromRGBO(0,169,72, 1),
};
const MaterialColor mainMaterialColor = MaterialColor(0xFF00a948, mainMaterialColorPalete);
const Color mainColor = Color(0xFF00a948);
const double regularTextSize = 15;
const double headerTextSize = 17;

const List<String> cities = ['Бишкек'];

const List<String> allIntS = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
const List<String> allDoubleS = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '.', ','];
int checkInt (String intS) {
  int intI;
  if(intS.length>1&&intS[0]=='0') {
    intS = intS.substring(1);
  }
  try {
    intI = int.parse(intS);
  }
  catch(error) {
    intI = 0;
  }
  if(intI<0) {
    intI *= -1;
  }
  return intI;
}
String inputInt (String intS) {
  String oldIntS = intS.substring(0, intS.length-1);
  try {
    int.parse(oldIntS);
  }
  catch(error) {
    oldIntS = '';
  }
  String newChr = intS[intS.length-1];
  if(!allIntS.contains(newChr)) {
    return oldIntS;
  }
  if(intS.length==2&&intS[0]=='0') {
    return intS[1];
  }
  return intS;
}
double checkDouble (String doubleS) {
  double doubleI;
  try {
    doubleI = double.parse(doubleS);
  }
  catch(error) {
    doubleI = 0;
  }
  if(doubleI<0) {
    doubleI *= -1;
  }
  doubleI = double.parse(doubleI.toStringAsFixed(1));
  return doubleI;
}
String inputDouble (String doubleS) {
  String oldDoubleS = doubleS.substring(0, doubleS.length-1);
  try {
    double.parse(oldDoubleS);
  }
  catch(error) {
    oldDoubleS = '';
  }
  String newChr = doubleS[doubleS.length-1];
  if(!allDoubleS.contains(newChr)) {
    return oldDoubleS;
  }
  if(newChr==',') {
    doubleS = '$oldDoubleS.';
    newChr = '.';
  }
  if(newChr=='.'&&oldDoubleS.contains('.')) {
    return oldDoubleS;
  }
  if(doubleS.length==2&&doubleS[0]=='0'&&newChr!='.') {
    return doubleS[1];
  }
  return doubleS;
}
String inputPhoneLogin (String phoneLoginS) {
  String oldPhoneLoginS = phoneLoginS.substring(0, phoneLoginS.length-1);
  String newChr = phoneLoginS[phoneLoginS.length-1];
  if(!allIntS.contains(newChr)) {
    return oldPhoneLoginS;
  }
  return phoneLoginS;
}

String pdDDMMYYYY_I (int dateI) {
  DateTime dateT = DateTime.fromMillisecondsSinceEpoch(dateI);
  return '${dateT.day<10?'0':''}${dateT.day}.${dateT.month<10?'0':''}${dateT.month}.${dateT.year}';
}
String pdDDMMYYYY_DT (DateTime dateT) {
  return '${dateT.day<10?'0':''}${dateT.day}.${dateT.month<10?'0':''}${dateT.month}.${dateT.year}';
}
String pdHHMM_I (int dateI) {
  DateTime dateT = DateTime.fromMillisecondsSinceEpoch(dateI);
  return '${dateT.hour<10?'0':''}${dateT.hour}:${dateT.minute<10?'0':''}${dateT.minute}';
}
String pdHHMM_DT (DateTime dateT) {
  return '${dateT.hour<10?'0':''}${dateT.hour}:${dateT.minute<10?'0':''}${dateT.minute}';
}
String pdDDMMYYHHMM_I (int dateI) {
  DateTime dateT = DateTime.fromMillisecondsSinceEpoch(dateI);
  String date = '${dateT.day<10?'0':''}${dateT.day}.${dateT.month<10?'0':''}${dateT.month}.${dateT.year.toString().substring(2)} ${dateT.hour<10?'0':''}${dateT.hour}:${dateT.minute<10?'0':''}${dateT.minute}';
  return date;
}
String pdDDMMYYHHMM_T (DateTime dateT) {
  String date = '${dateT.day<10?'0':''}${dateT.day}.${dateT.month<10?'0':''}${dateT.month}.${dateT.year.toString().substring(2)} ${dateT.hour<10?'0':''}${dateT.hour}:${dateT.minute<10?'0':''}${dateT.minute}';
  return date;
}

bool validEmail (String mail) {
  RegExp exp = RegExp(r'^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()\.,;\s@\"]+\.{0,1})+([^<>()\.,;:\s@\"]{2,}|[\d\.]+))$');
  return exp.hasMatch(mail);
}
bool validPhone (String phone) {
  RegExp exp = RegExp(r'^[+]{1}996[0-9]{9}$');
  return exp.hasMatch(phone);
}
bool validPhoneLogin (String phone) {
  RegExp exp = RegExp(r'^[0-9]{9}$');
  return exp.hasMatch(phone);
}