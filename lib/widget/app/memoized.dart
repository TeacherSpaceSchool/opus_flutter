import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Memoized extends HookWidget {

  final Widget child;
  final List<dynamic> keys;

  const Memoized({super.key, required this.child, this.keys = const []});

  @override
  Widget build(BuildContext context) {
    return useMemoized(() => child, keys);
  }
}
