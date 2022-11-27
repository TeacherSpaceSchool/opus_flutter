import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../redux/state/index.dart';

class MyStoreConnector extends HookWidget {

  final Function builder;
  final List keys;

  const MyStoreConnector({super.key, required this.builder, this.keys = const []});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<IndexState, IndexState>(
      converter: (store) => store.state,
      builder: (context, state) => builder(context, state),
    );
  }
}
