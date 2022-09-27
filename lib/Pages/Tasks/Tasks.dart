import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Data/UserCalls.dart';
import 'package:technicalserviceadmin/Pages/Tasks/TaskWidget/TaskWidget.dart';
import 'package:technicalserviceadmin/Utils/Function.dart';
import 'package:technicalserviceadmin/Widgets/widgets.dart';

class TasksPage extends StatefulWidget {
  @override
  State<TasksPage> createState() => _TasksPageState();
  bool drm = true;
  List<UserCalls> userCallList = [];
}

class _TasksPageState extends State<TasksPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    getDataFromFirebase();
    return Scaffold(
        backgroundColor: selectedtheme == true
            ? Color.fromARGB(255, 29, 36, 51)
            : Colors.white,
        body: widget.drm == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: ListView(
                  children: [
                    Header(),
                    SingleChildScrollView(
                      primary: false,
                      padding: EdgeInsets.all(defaultPadding),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child:
                                  TaskWidget(userCallList: widget.userCallList),
                            )
                          ]),
                    )
                  ],
                ),
              ));
  }

  void getDataFromFirebase() async {
    try {
      if (widget.drm == true) {
        widget.userCallList.clear();
        var veriler = await _firestore
            .collection("Calls")
            .where("ServiceId", isEqualTo: activeUser.uid)
            .orderBy("Tarih", descending: true)
            .get();

        for (var veri in veriler.docs) {
          UserCalls userCalls = new UserCalls();

          debugPrint(veri.data().toString());

          userCalls.Id = veri.get("Id").toString();
          userCalls.Image =
              Cryptology().Decryption(veri.get("Image").toString(), context);
          Timestamp tarih = veri.get("Tarih");
          userCalls.tarih = tarih.toDate();
          userCalls.Name =
              Cryptology().Decryption(veri.get("Name").toString(), context);
          userCalls.category =
              Cryptology().Decryption(veri.get("Category").toString(), context);
          userCalls.Fiyat = double.parse(
              Cryptology().Decryption(veri.get("Fiyat").toString(), context));
          userCalls.ServiceId = veri.get("ServiceId");
          userCalls.UserId = veri.get("UserId");
          userCalls.adres = Cryptology().Decryption(veri.get("Adres"), context);
          userCalls.apt = Cryptology().Decryption(veri.get("Apt"), context);
          userCalls.kat = Cryptology().Decryption(veri.get("Kat"), context);
          userCalls.no = Cryptology().Decryption(veri.get("No"), context);
          userCalls.lat = double.parse(
              Cryptology().Decryption(veri.get("Lat").toString(), context));
          userCalls.lon = double.parse(
              Cryptology().Decryption(veri.get("Lon").toString(), context));
          print(userCalls.AdresAciklama);
          widget.userCallList.add(userCalls);
        }

        if (this.mounted) {
          setState(() {
            widget.drm = false;
          });
        }
      }
    } catch (e) {
      print(e.toString());
      WarningWidget(e.toString() + " Hatası alındı", "Hata", context);
    }
  }

  Future<String> getAdress(UserCalls userCalls) async {
    print(
        "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
    GeoCode geoCode = new GeoCode();
    Address address = await geoCode.reverseGeocoding(
        latitude: userCalls.lat, longitude: userCalls.lon);

    String adresDetails = address.streetAddress!;
    adresDetails += " " + address.city!;
    adresDetails += " " + address.countryName!;
    print(adresDetails);

    print(
        "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
    return adresDetails;
  }

  Widget Header() {
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
          "Çağrılar",
          style: Theme.of(context)
              .textTheme
              .apply(
                  bodyColor:
                      selectedtheme == true ? Colors.white : Colors.black)
              .headline6,
        ),
        if (!Responsive.isMobile(context)) Spacer(flex: 2),
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
            setState(() {
              widget.drm = true;
            });
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
