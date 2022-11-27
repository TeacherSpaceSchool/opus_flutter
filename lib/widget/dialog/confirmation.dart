import 'package:flutter/material.dart';
import '../app/my_button.dart';

showConfirmation({required BuildContext context, function, mutation, onCompleted}) {
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
                            Navigator.pop(context);
                            await function ();
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