import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technicalserviceadmin/Data/Category.dart';
import 'package:technicalserviceadmin/Data/City.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Widgets/widgets.dart';

class SigninPage extends StatefulWidget {
  @override
  State<SigninPage> createState() => _SigninPageState();
  String MailErrorText = "";
  String PasswordErrorText = "";
  String NameErrorText = "";

  bool hidePassword = true;
}

class _SigninPageState extends State<SigninPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController NameController = TextEditingController();

  TextEditingController mailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  String CityName = "Şehir seçiniz";
  String SelectedCategory = "Kategori Seçiniz";

  @override
  void initState() {
    // TODO: implement initState
    CityName = "Adana";
    SelectedCategory = "Beyaz Eşya";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 29, 36, 51)),
          child: Row(
            children: [
              if (!Responsive.isMobile(context))
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              Expanded(
                  flex: Responsive.isTablet(context) ? 2 : 1,
                  child: Container(
                    padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                    width: double.infinity,
                    height:
                        Responsive.isMobile(context) ? double.infinity : 700,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(150, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            height: 200,
                            width: 200,
                            child: Image.asset("assets/icons/logo2.png")),
                        SizedBox(
                          height: 40,
                        ),
                        TextField(
                          controller: NameController,
                          style: Theme.of(context)
                              .textTheme
                              .apply(bodyColor: Colors.black)
                              .headline6,
                          decoration: InputDecoration(
                            hintText: "Şirket ismini giriniz.",
                            hintStyle: Theme.of(context).textTheme.headline6,
                            errorText: widget.NameErrorText == ""
                                ? null
                                : widget.NameErrorText,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(150, 255, 255, 255),
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: mailController,
                                style: Theme.of(context)
                                    .textTheme
                                    .apply(bodyColor: Colors.black)
                                    .headline6,
                                decoration: InputDecoration(
                                  hintText: "Mail adresinizi giriniz.",
                                  hintStyle:
                                      Theme.of(context).textTheme.headline6,
                                  errorText: widget.MailErrorText == ""
                                      ? null
                                      : widget.MailErrorText,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  filled: true,
                                  fillColor: Color.fromARGB(150, 255, 255, 255),
                                ),
                              ),
                            ),
                            if (!Responsive.isMobile(context))
                              SizedBox(
                                width: defaultPadding,
                              ),
                            if (!Responsive.isMobile(context))
                              Expanded(
                                flex: 1,
                                child: SelectCategory(),
                              )
                          ],
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(
                                obscureText: widget.hidePassword,
                                obscuringCharacter: '*',
                                controller: PasswordController,
                                style: Theme.of(context)
                                    .textTheme
                                    .apply(bodyColor: Colors.black)
                                    .headline6,
                                decoration: InputDecoration(
                                  errorText: widget.PasswordErrorText == ""
                                      ? null
                                      : widget.PasswordErrorText,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        widget.hidePassword =
                                            !widget.hidePassword;
                                        setState(() {});
                                      },
                                      icon: widget.hidePassword == true
                                          ? Icon(
                                              Icons.visibility_off_outlined,
                                              color: Colors.black,
                                            )
                                          : Icon(
                                              Icons.visibility_outlined,
                                              color: Colors.black,
                                            )),
                                  hintText: "Şifrenizi giriniz.",
                                  hintStyle:
                                      Theme.of(context).textTheme.headline6,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  filled: true,
                                  fillColor: Color.fromARGB(150, 255, 255, 255),
                                ),
                              ),
                            ),
                            if (!Responsive.isMobile(context))
                              SizedBox(
                                width: defaultPadding,
                              ),
                            if (!Responsive.isMobile(context))
                              Expanded(
                                flex: 1,
                                child: SelectCity(),
                              )
                          ],
                        ),
                        if (Responsive.isMobile(context))
                          SizedBox(
                            height: defaultPadding,
                          ),
                        if (Responsive.isMobile(context)) SelectCity(),
                        if (Responsive.isMobile(context))
                          SizedBox(
                            height: defaultPadding,
                          ),
                        if (Responsive.isMobile(context)) SelectCategory(),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            SigninWithMail();
                          },
                          child: Text(
                            "Kayıt ol",
                            style: Theme.of(context)
                                .textTheme
                                .apply(bodyColor: Colors.white)
                                .headline6,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(230, 0, 113, 227)),
                            padding: MaterialStateProperty.all(EdgeInsets.only(
                                bottom: 20, top: 20, right: 25, left: 25)),
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                      ],
                    ),
                  )),
              if (!Responsive.isMobile(context))
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
            ],
          )),
    );
  }

  Widget SelectCity() {
    return Tooltip(
      message: "Şirketiniz bulunduğu şehri seçiniz.",
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 4, bottom: 4),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Color.fromARGB(150, 255, 255, 255),
            borderRadius: BorderRadius.circular(10)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            focusColor: Color.fromARGB(150, 255, 255, 255),
            elevation: 1,
            dropdownColor: Color.fromARGB(230, 255, 255, 255),
            items: City().CityList.map((secili) {
              return DropdownMenuItem(
                child: Row(
                  children: [
                    Text(
                      secili,
                      style: Theme.of(context)
                          .textTheme
                          .apply(
                            bodyColor: Colors.black,
                          )
                          .headline6,
                    ),
                  ],
                ),
                value: secili,
              );
            }).toList(),
            onChanged: (var deger) {
              setState(() {
                CityName = deger.toString();
              });
            },
            value: CityName,
          ),
        ),
      ),
    );
  }

  Widget SelectCategory() {
    return Tooltip(
      message: "Şirketiniz hangi kategoride hizmet vermekteyse seçiniz.",
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 4, bottom: 4),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Color.fromARGB(150, 255, 255, 255),
            borderRadius: BorderRadius.circular(10)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            focusColor: Color.fromARGB(150, 255, 255, 255),
            elevation: 1,
            dropdownColor: Color.fromARGB(230, 255, 255, 255),
            items: Category().CategoryList.map((secili) {
              return DropdownMenuItem(
                child: Row(
                  children: [
                    Text(
                      secili,
                      style: Theme.of(context)
                          .textTheme
                          .apply(bodyColor: Colors.black)
                          .headline6,
                    ),
                  ],
                ),
                value: secili,
              );
            }).toList(),
            onChanged: (var deger) {
              setState(() {
                SelectedCategory = deger.toString();
              });
            },
            value: SelectedCategory,
          ),
        ),
      ),
    );
  }

  void SigninWithMail() async {
    try {
      if (NameController.text == "") {
        widget.NameErrorText = "Lütfen bu kısmı doldurun!";
        setState(() {});
      } else if (mailController.text == "") {
        widget.NameErrorText = "";
        widget.MailErrorText = "Lütfen bu kısmı doldurun!";
        setState(() {});
      } else if (PasswordController.text == "") {
        widget.NameErrorText = "";
        widget.MailErrorText = "";
        widget.PasswordErrorText = "Lütfen bu kısmı doldurun!";
        setState(() {});
      } else {
        showLoaderDialog(context);

        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: mailController.text, password: PasswordController.text);
        User? _newUser = credential.user;
        _newUser?.updateDisplayName(NameController.text);
        _newUser!.updatePhotoURL(
            "https://firebasestorage.googleapis.com/v0/b/technicalservices-2973a.appspot.com/o/ProfilePhotos%2FPngItem_1468479.png?alt=media&token=d59b7cb2-7148-4b8e-8990-29067d43428c");

        DocumentReference ref =
            FirebaseFirestore.instance.collection("Services").doc(_newUser.uid);
        String foodId;
        Map<String, dynamic> eklenecek = Map();
        eklenecek["Id"] = _newUser.uid;
        eklenecek["Name"] = NameController.text;
        eklenecek["SearchName"] = ToLowerCase(NameController.text);
        eklenecek["City"] = CityName;
        eklenecek["Category"] = SelectedCategory;
        eklenecek["Image"] =
            "https://firebasestorage.googleapis.com/v0/b/technicalservices-2973a.appspot.com/o/ProfilePhotos%2FPngItem_1468479.png?alt=media&token=d59b7cb2-7148-4b8e-8990-29067d43428c";
        eklenecek["Aciklama"] = "";
        eklenecek["OrtPuan"] = 0;
        eklenecek["CommantCount"] = 0;
        eklenecek["Fiyat"] = 0.0;

        ref.set(eklenecek);
        Navigator.pop(context);

        WarningWidgetWait("Kayıt İşlemi Başarılı.", "Başarılı", context, '/');

        print(_newUser.toString());
      }
    } catch (e) {
      Navigator.pop(context);

      WarningWidget(e.toString(), "Hata", context);
    }
  }

  String ToLowerCase(String text) {
    text.replaceAll('I', 'ı');
    text.replaceAll('İ', 'i');
    return text.toLowerCase();
  }
}
