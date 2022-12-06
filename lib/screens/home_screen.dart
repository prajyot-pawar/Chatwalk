import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/screens/pageviews/join_with_code.dart';
import 'package:skype_clone/screens/pageviews/rooms_screen.dart';
import '/enum/user_state.dart';
import '/provider/user_provider.dart';
import '/resources/auth_methods.dart';
import '/screens/callscreens/pickup/pickup_layout.dart';
import '/screens/pageviews/chat_list_screen.dart';
import '/utils/universal_variables.dart';
import 'pageviews/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;
  UserProvider userProvider;

  final AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );
    });

    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    double _labelFontSize = 10;

    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: <Widget>[
            Container(
              child: ChatListScreen(),
            ),
            Container(
              child: RoomsScreen(),
            ),
            Center(
              child: Text(
                "Notificaitons Screen",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Center(
                child: Text(
              "Settings Screen",
              style: TextStyle(color: Colors.white),
            )),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_box,
                      color: (_page == 0)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  label: 
                    "Profile",
                    // style: TextStyle(
                    //     fontSize: _labelFontSize,
                    //     color: (_page == 0)
                    //         ? UniversalVariables.lightBlueColor
                    //         : Colors.grey),
                 
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.meeting_room,
                      color: (_page == 1)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  label: 
                    "Rooms",
                  //   style: TextStyle(
                  //       fontSize: _labelFontSize,
                  //       color: (_page == 1)
                  //           ? UniversalVariables.lightBlueColor
                  //           : Colors.grey),
                  // ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications,
                      color: (_page == 2)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  label: 
                    "Notifications",
                  //   style: TextStyle(
                  //       fontSize: _labelFontSize,
                  //       color: (_page == 2)
                  //           ? UniversalVariables.lightBlueColor
                  //           : Colors.grey),
                  // ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings,
                      color: (_page == 3)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  label: 
                    "Settings",
                    // style: TextStyle(
                    //     fontSize: _labelFontSize,
                    //     color: (_page == 3)
                    //         ? UniversalVariables.lightBlueColor
                    //         : Colors.grey),
                  // ),
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
