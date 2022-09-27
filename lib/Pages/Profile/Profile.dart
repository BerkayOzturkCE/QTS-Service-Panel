import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Data/Services.dart';
import 'package:technicalserviceadmin/Pages/Profile/ProfileLeft/ProfileLeft.dart';
import 'package:technicalserviceadmin/Pages/Profile/ProfileRight/ProfileRight.dart';
import 'package:technicalserviceadmin/Widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
  Services services = new Services();
  bool drm = true;
  String NameErrorText = "";
  String PriceErrorText = "";
}

class _ProfilePageState extends State<ProfilePage> {
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
                                child: Column(
                                  children: [
                                    ProfileLeft(
                                      services: widget.services,
                                      NameErrorText: widget.NameErrorText,
                                      PriceErrorText: widget.PriceErrorText,
                                    ),
                                    SizedBox(height: defaultPadding),
                                    if (Responsive.isMobile(context))
                                      ProfileRight(widget.services),
                                  ],
                                )),
                            if (!Responsive.isMobile(context))
                              SizedBox(width: defaultPadding),
                            if (!Responsive.isMobile(context))
                              Expanded(
                                  flex: 1,
                                  child: ProfileRight(
                                    widget.services,
                                  ))
                          ]),
                    )
                  ],
                ),
              ));
  }

  void getDataFromFirebase() async {
    if (widget.drm == true) {
      var veriler = await _firestore
          .collection("Services")
          .where("Id", isEqualTo: activeUser.uid)
          .get();

      for (var veri in veriler.docs) {
        Services services = new Services();

        debugPrint(veri.data().toString());

        services.Id = veri.get("Id").toString();
        services.Image = veri.get("Image").toString();
        services.Fiyat = double.parse(veri.get("Fiyat").toString());
        services.Name = veri.get("Name").toString();
        services.mah = veri.get("City").toString();
        services.category = veri.get("Category").toString();

        services.aciklama = veri.get("Aciklama").toString();
        widget.services = services;
        if (this.mounted) {
          setState(() {
            widget.drm = false;
          });
        }
        ;
      }
    }
  }

  Future<void> UpdateData() async {
    try {
      print(nameController.text);
      print("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
      if (nameController.text == "") {
        widget.NameErrorText = "Lütfen bir isim girin!";
      } else if (PriceController.text == "") {
        widget.PriceErrorText = "Lütfen bir ücret girin!";
      } else {
        showLoaderDialog(context);
        Services newService = new Services();
        newService.Name = nameController.text;
        newService.Fiyat = double.parse(PriceController.text);
        newService.aciklama = DetailsController.text;
        newService.category = SelectedCategory;
        newService.mah = SelectedCityName;
        await _firestore
            .collection("Services")
            .doc(activeUser.uid)
            .update({
              'Name': newService.Name,
              'Fiyat': newService.Fiyat,
              'Aciklama': newService.aciklama,
              'Category': newService.category,
              'City': newService.mah,
              'SearchName': ToLowerCase(newService.Name),
            })
            .whenComplete(() {
              Navigator.pop(context);
              widget.services.Name = newService.Name;
              widget.services.aciklama = newService.aciklama;
              widget.services.Fiyat = newService.Fiyat;
              widget.services.category = newService.category;
              widget.services.mah = newService.mah;

              WarningWidget("Bilgiler güncellendi", "Başarılı", context);
            })
            .onError((error, stackTrace) =>
                WarningWidget("Güncelleme başarısız!", "Başarısız", context))
            .timeout(Duration(seconds: 10));
      }

      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  String ToLowerCase(String text) {
    text.replaceAll('I', 'ı');
    text.replaceAll('İ', 'i');
    return text.toLowerCase();
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
          "Profile",
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
            UpdateData();
          },
          icon: Icon(
            Icons.save,
            color: Colors.white,
          ),
          label: Text(
            "Kaydet",
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
