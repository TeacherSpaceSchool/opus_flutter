import 'package:flutter/material.dart';
import '../dialog/signin.dart';
import '../dialog/confirmation.dart';
import '../dialog/index.dart';
import './memoized.dart';
import '../../main.dart';
import '../../gql/index.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../../module/app_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../riverpod/app.dart';

class MyAppBar extends HookConsumerWidget with PreferredSizeWidget {
  final String title;

  const MyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //provider
    final bool authenticated = ref.watch(appProvider.select((app) => app.authenticated));
    return AppBar(
        title: Memoized(child: Text(title)),
        actions: [
          Memoized(
              keys: [authenticated],
              child: IconButton(
                icon: Icon(authenticated?Icons.logout:Icons.login),
                onPressed: ()  {
                  if(authenticated) {
                    showConfirmation(context: context, function: () async {
                      profile = {};
                      await box.put('jwt', null);
                      await generateGqlClient(null);
                      FlutterBackgroundService().invoke('reinitGQL', {'jwt': null});
                      ref.read(appProvider.notifier).setAuthenticated(false);
                    });
                  }
                  else {
                    showMyDialog(context: context, content: const SignIn(), title: 'Вход');
                  }
                },
              )
          )
        ]
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
