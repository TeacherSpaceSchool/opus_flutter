import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widget/app/layout.dart';
import '../gql/contact.dart';
import '../gql/index.dart';
import '../../riverpod/app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const String title = 'Contact';

class ContactPage extends HookConsumerWidget {

  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool loading = ref.watch(appProvider.select((app) => app.loading));
    final gqlData = useFuture(useMemoized(() async {
      Map<String, dynamic>? res = await getQuery(
          queries: [getContactQuery],
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
              Text(
                  loading.toString()
              ),
            ],
          )
      ),
    );
  }
}