import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widget/app/my_text.dart';
import '../widget/app/memoized.dart';

const String title = 'Home';

class Deprecated extends HookWidget {

  const Deprecated({super.key});

  @override
  Widget build(BuildContext context) {
    //render
    return Memoized(child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  MyText(title: 'Пожалуйста обновите приложение', header: true),
                ],
              ),
            )
        )
    ));
  }

}
