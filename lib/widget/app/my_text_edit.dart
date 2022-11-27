import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'memoized.dart';

class MyTextEdit extends HookWidget {
  final TextEditingController controller;
  final checkError;
  final Function? checkInput;
  final String? errorText;
  final String? label;
  final bool autofocus;
  final TextInputType keyboardType;
  final int? maxLength;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;

  const MyTextEdit({
    super.key,
    required this.controller,
    this.checkError,
    this.errorText,
    this.label,
    this.checkInput,
    this.maxLength,
    this.autofocus = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final error = useState(false);
    useEffect(() {
      (() async {
        if(checkError!=null) {
          error.value = await checkError(controller.text);
        }
      })();
    }, []);
    return Memoized(
      keys: [obscureText, error.value],
      child: TextField(
        maxLength: maxLength,
        obscureText: obscureText,
        keyboardType: keyboardType,
        autofocus: autofocus,
        onChanged: useCallback((text) async {
          if(checkInput!=null) {
            text = checkInput!(text);
            controller.text = text;
            controller.selection = TextSelection.collapsed(offset: text.length);
          }
          if(checkError!=null) {
            error.value = await checkError(text);
          }
        }, []),
        controller: controller,
        decoration: InputDecoration(
            prefix: prefix,
            suffix: suffix,
            labelText: label,
            errorText: error.value?errorText??'Проверьте данные':null
        ),
      )
    );
  }

}
