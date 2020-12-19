import 'package:flutter/material.dart';
import 'package:gfg_jssateb/services/auth.dart';
import 'package:provider/provider.dart';

import '../components/body_container.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BodyContainer(
      child: FlatButton(
        onPressed: () => context.read<AuthService>().signOut(),
        child: const Text('Sign Out'),
      ),
    );
  }
}
