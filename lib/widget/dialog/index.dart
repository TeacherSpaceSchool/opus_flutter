import 'package:flutter/material.dart';
import '../../module/app_data.dart';

showMyDialog({required BuildContext context, required Widget content, required String title}) {
  showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) =>
          Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: insetPaddingDialog, vertical: 32),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    content
                  ],
                ),
              )
          )
  );
}
