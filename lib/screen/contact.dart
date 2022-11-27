import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../widget/app/layout.dart';
import '../gql/contact.dart';
import '../gql/index.dart';
import '../redux/state/index.dart';

const String title = 'Contact';

class ContactPage extends HookWidget {

  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gqlData = useFuture(useMemoized(() async {
      Map<String, dynamic>? res = await getQuery(
          queries: [getContactQuery],
          context: context
      );
      return res;
    }, []));

    return Layout(
      showBack: true,
      title: title,
      body: Center(
        child: Column(
          children: [
            Text(
              gqlData.data!=null?(gqlData.data?['contact']?['name']):'loading',
            ),
            StoreConnector<IndexState, bool>(
              converter: (store) => store.state.appState.isLoading,
              builder: (context, isLoading) {
                return
                  Text(
                      isLoading.toString()
                  );
              },
            ),
          ],
        )
      ),
    );
  }
}
