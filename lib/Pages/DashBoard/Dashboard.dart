import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technicalserviceadmin/Data/Controller.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Pages/DashBoard/Calls/Calls.dart';
import 'package:technicalserviceadmin/Pages/DashBoard/Chart/Chart.dart';
import 'package:technicalserviceadmin/Pages/DashBoard/LastComment/Comment.dart';
import 'package:technicalserviceadmin/Pages/MainMenu/Menu.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  void updatePage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: selectedtheme == true
            ? Color.fromARGB(255, 29, 36, 51)
            : Colors.white,
        body: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(UpdateParent: this.updatePage),
              SizedBox(height: defaultPadding),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Comment(),
                        SizedBox(height: defaultPadding),
                        CallsWidget(),
                        SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context)) ChartDetails(),
                      ],
                    )),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [ChartDetails()],
                      ))
              ]),
            ],
          ),
        ));
  }
}

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.UpdateParent,
  }) : super(key: key);

  final Function UpdateParent;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
              icon: Icon(Icons.menu,
                  color: selectedtheme == true ? Colors.white : Colors.black),
              onPressed: () {
                if (!scaffoldKey.currentState!.isDrawerOpen) {
                  scaffoldKey.currentState!.openDrawer();
                }
              }),
        Text(
          "Dashboard",
          style: Theme.of(context)
              .textTheme
              .apply(
                  bodyColor:
                      selectedtheme == true ? Colors.white : Colors.black)
              .headline6,
        ),
        Spacer(flex: 2),
        ElevatedButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding * 1.5,
              vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
            ),
          ),
          onPressed: () {
            drm = true;
            UpdateParent();
          },
          icon: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          label: Text(
            "Yenile",
            style: Theme.of(context)
                .textTheme
                .apply(
                  bodyColor: Colors.white,
                )
                .bodyMedium,
          ),
        ),
      ],
    );
  }
}
