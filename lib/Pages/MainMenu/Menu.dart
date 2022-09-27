import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/MenuItem.dart';

class Menu extends StatefulWidget {
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void update() {
    setState(() {
      ChatRead = true;
      getChats = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 23, 28, 40),
      child: ListView(children: [
        DrawerHeader(
          child: Image.asset("assets/icons/logo.png"),
        ),
        DrawerListTile(
          title: "Dashboard",
          svgSrc: "assets/icons/menu_dashbord.svg",
          id: 0,
          update: this.update,
        ),
        DrawerListTile(
          title: "Chat",
          svgSrc: "assets/icons/chat.svg",
          id: 1,
          update: this.update,
        ),
        DrawerListTile(
          title: "Task",
          svgSrc: "assets/icons/menu_task.svg",
          id: 2,
          update: this.update,
        ),
        /*   DrawerListTile(
          title: "Notification",
          svgSrc: "assets/icons/menu_notification.svg",
          id: 3,
          update: this.update,
        ),*/
        DrawerListTile(
          title: "Profile",
          svgSrc: "assets/icons/menu_profile.svg",
          id: 4,
          update: this.update,
        ),
        DrawerListTile(
          title: "Settings",
          svgSrc: "assets/icons/menu_setting.svg",
          id: 5,
          update: this.update,
        ),
      ]),
    );
  }
}

class DrawerListTile extends StatefulWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.id,
    required this.update,
  }) : super(key: key);

  @override
  final String title, svgSrc;
  final int id;
  final Function update;

  State<DrawerListTile> createState() => _DrawerListTileState();
}

class _DrawerListTileState extends State<DrawerListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        pageIndex = widget.id;
        pageController.jumpToPage(pageIndex);
        widget.update();
      },
      hoverColor: Color.fromARGB(255, 30, 33, 45),
      selected: pageIndex == widget.id,
      selectedColor: Colors.white,
      selectedTileColor: Color.fromARGB(255, 30, 33, 45),
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        widget.svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        widget.title,
        style: GoogleFonts.poppins(
            color: pageIndex == widget.id ? Colors.white : Colors.white54),
      ),
    );
  }
}
