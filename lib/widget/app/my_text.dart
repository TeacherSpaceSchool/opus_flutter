import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../module/const_value.dart';
import 'memoized.dart';

class MyText extends HookWidget {
  final String title;
  final Color color;
  final bool bold;
  final bool field;
  final bool header;

  const MyText({super.key, required this.title, this.color = Colors.black, this.bold = false, this.header = false, this.field = false});

  @override
  Widget build(BuildContext context) {
    return Memoized(
        keys: [title],
        child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
                title,
                style: TextStyle(
                    fontSize: header?headerTextSize:regularTextSize,
                    fontWeight: bold||field||header?FontWeight.bold:FontWeight.w500,
                    color: field?const Color(0XFFA0A0A0):color
            )
            )
        )
    );
  }

}
