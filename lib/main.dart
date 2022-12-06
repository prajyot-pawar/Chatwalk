import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/screens/pageviews/join_with_code.dart';
import 'package:skype_clone/screens/pageviews/new_meeting.dart';
import 'package:skype_clone/screens/pageviews/video_call.dart';
import '/models/user.dart';
import '/provider/image_upload_provider.dart';
import '/provider/user_provider.dart';
import '/resources/auth_methods.dart';
import '/screens/home_screen.dart';
import '/screens/login_screen.dart';
import '/screens/search_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: "ChatWalk",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/new_meeting': (context) => NewMeeting(),
          '/call_screen': (context) => CallPage(
                call: null,
                channelName: '',
              ),
          '/join_with_code': (context) => Joinwithcode(),
          '/search_screen': (context) => SearchScreen(),
        },
        theme: ThemeData(brightness: Brightness.dark),
        home: FutureBuilder(
          future: _authMethods.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authMethods.getUserDetails(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
