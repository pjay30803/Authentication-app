import 'package:authentication_app/views/screens/favrourite_user_screen.dart';
import 'package:authentication_app/views/screens/home_page.dart';
import 'package:authentication_app/views/screens/login_screen.dart';
import 'package:authentication_app/views/screens/signup_screen.dart';
import 'package:authentication_app/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomePage(),
        '/favourites': (context) => FavouriteUsersScreen(),
      },
    );
  }
}
