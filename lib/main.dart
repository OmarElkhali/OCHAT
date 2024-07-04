import 'package:flutter/material.dart';
import 'package:ochat/screens/Home.dart';
import 'package:ochat/screens/group.dart';
import 'package:ochat/services/auth_gate.dart';
import 'package:ochat/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'screens/welcome.dart';
import 'screens/Chat.dart';
import 'screens/LogIn.dart';
import 'screens/SignIn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  //  const
  MyApp({super.key});
  // This widget is the root of your application.
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'O-Chat',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 0, 0)),
      ),
      home: Authgate(),
      // initialRoute:
      // // 'Welcome',
      // _auth.currentUser != null
      // ? ('chat')
      // : 'Welcome',
      routes: {
        'Welcome': (context) => welcomS(),
        'LogIn': (context) => LogIn(
              onTap: () {},
            ),
        'SingIn': (context) => SignIn(),
        'Chat': (context) => Chat(
              receiverUserEmail: 'email',
              receiverUserID: 'UID',
            ),
        'Home': (context) => Home(),
        'group': (context) => group(
              receiverUserEmail: 'email',
              receiverUserID: 'UID',
            ),
      },
    );
    return materialApp;
  }
}
