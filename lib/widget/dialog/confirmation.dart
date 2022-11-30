import 'package:flutter/material.dart';
import '../app/my_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../riverpod/app.dart';

showConfirmation({required BuildContext context, WidgetRef? ref, function, mutation, onCompleted}) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          Dialog(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const  Text('Вы уверены?', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyButton(
                            title: 'Нет',
                            secondary: true,
                            function: () => Navigator.pop(context)
                        ),
                        const SizedBox(width: 20),
                        MyButton(
                          title: 'Да',
                          function: () async {
                            ref?.read(appProvider.notifier).setLoading(true);
                            Navigator.pop(context);
                            await function ();
                            ref?.read(appProvider.notifier).setLoading(false);
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
          )
  );
}