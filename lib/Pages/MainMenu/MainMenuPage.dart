import 'package:flutter/material.dart';
import 'package:technicalserviceadmin/Data/Controller.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/MenuItem.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Pages/Chat/Chat.dart';
import 'package:technicalserviceadmin/Pages/DashBoard/Dashboard.dart';
import 'package:technicalserviceadmin/Pages/MainMenu/Menu.dart';
import 'package:provider/provider.dart';
import 'package:technicalserviceadmin/Pages/Notification/Notification.dart';
import 'package:technicalserviceadmin/Pages/Profile/Profile.dart';
import 'package:technicalserviceadmin/Pages/Settings/Settings.dart';
import 'package:technicalserviceadmin/Pages/Tasks/Tasks.dart';

class MainMenuPage extends StatefulWidget {
  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
  Menu menu = new Menu();
}

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey1,
      drawer: widget.menu,
      drawerEdgeDragWidth: Responsive.isDesktop(context) ? 0 : 20,
      body: SafeArea(
          child: Row(
        children: [
          if (Responsive.isDesktop(context))
            Expanded(
              child: widget.menu,
            ),
          Expanded(
              flex: 5,
              child: PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Dashboard(),
                  Chat(),
                  TasksPage(),
                  NotificationPage(),
                  ProfilePage(),
                  SettingsPage(),
                ],
              )),
        ],
      )),
    );
  }
}
