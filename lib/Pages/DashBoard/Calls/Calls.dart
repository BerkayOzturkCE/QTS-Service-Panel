import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Rate.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Data/UserCalls.dart';
import 'package:technicalserviceadmin/Utils/Function.dart';
import 'package:technicalserviceadmin/Widgets/widgets.dart';

class CallsWidget extends StatefulWidget {
  @override
  State<CallsWidget> createState() => _CallsWidgetState();
}

class _CallsWidgetState extends State<CallsWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    GetCallsFromFireStore();
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: selectedtheme == true
            ? Color.fromARGB(255, 23, 28, 40)
            : Colors.grey[300],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Son Çağrılar",
                style: Theme.of(context)
                    .textTheme
                    .apply(
                      bodyColor:
                          selectedtheme == true ? Colors.white : Colors.black,
                    )
                    .headline6,
              ),
            ],
          ),
          if (drm == true)
            SizedBox(
              width: double.infinity,
              child: Center(child: CircularProgressIndicator()),
            ),
          if (drm == false)
            SizedBox(
              width: double.infinity,
              child: DataTable2(
                columnSpacing: defaultPadding,
                minWidth: 600,
                columns: [
                  DataColumn(
                    label: Text(
                      "Müşteri",
                      style: Theme.of(context)
                          .textTheme
                          .apply(
                            bodyColor: selectedtheme == true
                                ? Colors.white
                                : Colors.black,
                          )
                          .bodyLarge,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Tarih",
                      style: Theme.of(context)
                          .textTheme
                          .apply(
                            bodyColor: selectedtheme == true
                                ? Colors.white
                                : Colors.black,
                          )
                          .bodyLarge,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Saat",
                      style: Theme.of(context)
                          .textTheme
                          .apply(
                            bodyColor: selectedtheme == true
                                ? Colors.white
                                : Colors.black,
                          )
                          .bodyLarge,
                    ),
                  ),
                ],
                rows: List.generate(
                  LastCalls.length,
                  (index) => recentFileDataRow(LastCalls[index]),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void GetCallsFromFireStore() async {
    try {
      if (drm == true) {
        LastCalls.clear();
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
          userCalls.date = veri.get("Date").toString();
          userCalls.hour = double.parse(veri.get("Hour").toString());

          userCalls.UserName =
              Cryptology().Decryption(veri.get("UserName"), context);

          var veriler2 = await _firestore
              .collection("Users")
              .where("Id", isEqualTo: userCalls.UserId)
              .limit(1)
              .get();
          userCalls.Image = Cryptology()
              .Decryption(veriler2.docs.first.get("Image").toString(), context);

          LastCalls.add(userCalls);
        }

        if (this.mounted) {
          setState(() {
            drm = false;
          });
        }
      }
    } catch (e) {
      print(e.toString());
      WarningWidget(e.toString() + " Hatası alındı!", "Hata", context);
    }
  }

  DataRow recentFileDataRow(UserCalls userCalls) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(180)),
                child: Image.network(
                  userCalls.Image,
                  height: 30,
                  width: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  userCalls.UserName,
                  style: Theme.of(context)
                      .textTheme
                      .apply(
                        bodyColor:
                            selectedtheme == true ? Colors.white : Colors.black,
                      )
                      .bodyMedium,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(userCalls.date,
            style: Theme.of(context)
                .textTheme
                .apply(
                  bodyColor:
                      selectedtheme == true ? Colors.white : Colors.black,
                )
                .bodyMedium)),
        DataCell(Text(userCalls.hour.toString() + ".00",
            style: Theme.of(context)
                .textTheme
                .apply(
                  bodyColor:
                      selectedtheme == true ? Colors.white : Colors.black,
                )
                .bodyMedium)),
      ],
    );
  }
}
