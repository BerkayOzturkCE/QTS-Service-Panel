import 'package:flutter/material.dart';
import 'package:technicalserviceadmin/Data/Data.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedtheme == true
          ? Color.fromARGB(255, 29, 36, 51)
          : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          selectedtheme == true ? "Dark" : "Light",
          style: Theme.of(context)
              .textTheme
              .apply(
                  bodyColor:
                      selectedtheme == true ? Colors.white : Colors.black)
              .headline6,
        ),
        backgroundColor: selectedtheme == true
            ? Color.fromARGB(255, 29, 36, 51)
            : Colors.white,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Tema",
            style: Theme.of(context)
                .textTheme
                .apply(
                    bodyColor:
                        selectedtheme == true ? Colors.white : Colors.black)
                .headline6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.light_mode,
                color: selectedtheme == true ? Colors.white : Colors.black,
              ),
              Switch(
                  value: selectedtheme,
                  onChanged: (data) {
                    setState(() {
                      selectedtheme = data;
                    });
                  }),
              Icon(
                Icons.dark_mode,
                color: selectedtheme == true ? Colors.white : Colors.black,
              ),
            ],
          )
        ],
      )),
    );
  }
}
