import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import './memoized.dart';

class MyDrawer extends HookWidget {

  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Memoized(
        child: Drawer(
            child : ListView(
                children : ListTile.divideTiles(
                    context: context,
                    tiles: [
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: const Text('Home', style: TextStyle(fontSize: 22)),
                        selected: ModalRoute.of(context)?.settings.name=='/',
                        onTap: () {
                          if(ModalRoute.of(context)?.settings.name!='/') {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, '/');
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.contact_page_outlined),
                        title: const Text('Contact', style: TextStyle(fontSize: 22)),
                        selected: ModalRoute.of(context)?.settings.name=='/contact',
                        onTap: () {
                          if(ModalRoute.of(context)?.settings.name!='/contact') {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, '/contact');
                          }
                        },
                      ),
                    ]
                ).toList()
            )
        )
    );
  }
}
