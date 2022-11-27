// ignore_for_file: use_build_context_synchronously

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:opus_flutter/widget/app/memoized.dart';
import '../app/my_button.dart';
import '../app/my_text.dart';
import '../app/my_text_edit.dart';
import '../../gql/index.dart';
import '../../gql/passport.dart';
import '../../redux/state/index.dart';
import '../../redux/actions/app.dart';
import '../../main.dart';
import '../../module/const_value.dart';
import '../../module/app_data.dart';

class SignIn extends HookWidget  {

  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {

    final TextEditingController loginController = useTextEditingController(text: '');
    final loginOnError = useCallback((text) => !validPhoneLogin(text), []);
    final TextEditingController passwordController = useTextEditingController(text: '');
    final passwordOnError = useCallback((text) => text.isEmpty, []);
    final hide = useState(true);
    final error = useState('');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyTextEdit(
          prefix: const Text('+996'),
          maxLength: 9,
          keyboardType: TextInputType.number,
          controller: loginController,
          checkError: loginOnError,
          checkInput: inputPhoneLogin,
          label: 'login',
          errorText: 'Заполните поле',
        ),
        MyTextEdit(
          suffix: Memoized(
            keys: [hide.value],
            child: IconButton(
              icon: Icon(hide.value?Icons.visibility_off:Icons.visibility, color: Colors.black45),
              onPressed: useCallback(() => hide.value = !hide.value, [])
            )
          ),
          controller: passwordController,
          checkError: passwordOnError,
          label: 'password',
          obscureText: hide.value,
          errorText: 'Заполните поле',
        ),
        Memoized(
          keys: [error.value],
          child: error.value.isNotEmpty? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                MyText(title: error.value, color: Colors.red, bold: true,)
              ]
          ):Container()
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MyButton(
              title: 'Закрыть',
              secondary: true,
              function: () => Navigator.pop(context)
            ),
            const SizedBox(width: 16),
            MyButton(
              title: 'Войти',
              function: () async {
                if (validPhoneLogin(loginController.text) && passwordController.text.length > 4) {
                  error.value = '';
                  Map<String, dynamic>? res = await sendMutation(variables: {
                    'login': loginController.text,
                    'password': passwordController.text
                  }, mutation: signinuser);
                  final String? jwt = res?['signinuser']?['jwt'];
                  if(jwt!=null) {
                    profile = res?['signinuser'];
                    await box.put('jwt', jwt);
                    generateGqlClient(jwt);
                    FlutterBackgroundService().invoke('reinitGQL', {'jwt': jwt});
                    StoreProvider.of<IndexState>(context).dispatch(SetAuthenticated(true));
                    Navigator.pop(context);
                  }
                  else {
                    error.value = 'Неверные данные';
                  }
                }
                else {
                  HapticFeedback.vibrate();
                  error.value = 'Заполните все поля';
                }
              },
            )
          ],
        )
      ],
    );
  }
}
