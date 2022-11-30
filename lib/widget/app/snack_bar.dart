import 'package:flutter/material.dart';
import '../../main.dart';

showSnackBar({required text, type = 'w'}) {
  final SnackBar snackBar = SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(text, style: const TextStyle(fontSize: 16)),
    backgroundColor: (type=='s'?Colors.green:type=='e'?Colors.red:Colors.orange)
  );
  snackbarKey.currentState?.showSnackBar(snackBar);
}