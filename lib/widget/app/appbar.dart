import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../dialog/signin.dart';
import '../dialog/confirmation.dart';
import '../dialog/index.dart';
import './memoized.dart';
import '../../main.dart';
import './connector.dart';
import '../../redux/state/index.dart';
import '../../redux/actions/app.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../gql/index.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../../module/app_data.dart';

class MyAppBar extends HookWidget with PreferredSizeWidget {
  final String title;

  const MyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return MyStoreConnector(
        builder: (context, state) => AppBar(
            title: Memoized(child: Text(title)),
            actions: [
              Memoized(
                  keys: [state.appState.authenticated],
                  child: IconButton(
                    icon: Icon(state.appState.authenticated?Icons.logout:Icons.login),
                    onPressed: ()  {
                      if(state.appState.authenticated) {
                        showConfirmation(context: context, function: () async {
                          profile = {};
                          await box.put('jwt', null);
                          await generateGqlClient(null);
                          FlutterBackgroundService().invoke('reinitGQL', {'jwt': null});
                          StoreProvider.of<IndexState>(context).dispatch(SetAuthenticated(false));
                        });
                      }
                      else {
                        showMyDialog(context: context, content: const SignIn(), title: 'Вход');
                      }
                    },
                  )
              )
            ]
        )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
