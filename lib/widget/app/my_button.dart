import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../module/const_value.dart';
import 'memoized.dart';

class MyButton extends HookWidget {
  final String title;
  final bool secondary;
  final function;
  final bool text;

  const MyButton({super.key, required this.title, required this.function, this.secondary = false, this.text = false});

  @override
  Widget build(BuildContext context) {
    return Memoized(
      keys: [title],
        child: text?
          TextButton(
              onPressed: function,
              child: Text(title.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: secondary==true?Colors.red:mainColor,
                    fontSize: regularTextSize,
                  )
              )
          )
            :
          ElevatedButton(
              onPressed: function,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                  backgroundColor: secondary==true?Colors.red:mainColor),
              child: Text(title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: regularTextSize,
                  )
              )
          )
    );
  }

}
