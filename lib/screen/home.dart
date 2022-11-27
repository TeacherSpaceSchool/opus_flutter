import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widget/app/layout.dart';
import '../widget/app/my_text.dart';
import '../gql/index.dart';
import '../gql/contact.dart';
import '../gql/faq.dart';
import '../widget/app/memoized.dart';
import '../widget/app/snack_bar.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../riverpod/app.dart';

const String title = 'Home';

class HomePage extends HookConsumerWidget  {

  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //state
    final counter = useState(0);
    final gqlData = useState<Map<String, dynamic>?>(null);
    final serviceStream = useStream(FlutterBackgroundService().on('update'));
    //initial
    useMemoized(() async {
      Map<String, dynamic>? res = await getQuery(
          queries: [getContactQuery, getFaqsQuery],
          queryVariables: [getFaqsVariables],
          variables: [{'search': '', 'skip': 0}],
          context: context
      );
      gqlData.value = res;
    }, []);
    //render
    return Layout(
      title: title,
      body: gqlData.value!=null?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyText(title: gqlData.value!['contact']?['name'], header: true),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const MyText(title: 'counter: ', field: true),
                  MyText(title: counter.value.toString())
                ]
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const MyText(title: 'GEO-S: ', field: true),
                  MyText(title: serviceStream.data?['geoData']!=null?'${serviceStream.data?['geoData']['latitude']} | ${serviceStream.data?['geoData']['longitude']}':'loading...')
                ]
            ),
            const MyText(title: 'Flutter — комплект средств разработки и фреймворк с открытым исходным кодом для создания мобильных приложений под Android и iOS, веб-приложений, а также настольных приложений под Windows, macOS и Linux с использованием языка программирования Dart, разработанный и развиваемый корпорацией Google.'),
          ],
        ),
      ):Container(),
      floatingActionButton: Memoized(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () {
                    counter.value++;
                  },
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10,),
                FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: (){
                    showSnackBar(text: 'text', context: context);
                  },
                  tooltip: 'Increment',
                  child: const Icon(Icons.receipt),
                ),
                const SizedBox(height: 10,),
                FloatingActionButton(
                  heroTag: "btn3",
                  onPressed: (){
                    ref.read(appProvider.notifier).setLoading(true);
                  },
                  tooltip: 'Increment',
                  child: const Icon(Icons.abc),
                )
              ]
          )
      ),
    );
  }

}
