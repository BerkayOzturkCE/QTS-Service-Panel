import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Pages/MainMenu/MainMenuPage.dart';
import 'package:technicalserviceadmin/Pages/SignInPage/SigninPage.dart';
import 'package:technicalserviceadmin/Widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
  String MailErrorText = "";
  String PasswordErrorText = "";

  bool hidePassword = true;
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController mailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
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
              padding: EdgeInsets.only(top: 50, left: 30, right: 30),
              width: double.infinity,
              height: Responsive.isMobile(context) ? double.infinity : 700,
              decoration: BoxDecoration(
                  color: Color.fromARGB(150, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      height: 200,
                      width: 200,
                      child: Image.asset("assets/icons/logo2.png")),
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: mailController,
                    style: Theme.of(context)
                        .textTheme
                        .apply(bodyColor: Colors.black)
                        .headline6,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline, color: Colors.black),
                      hintText: "Mail adresinizi giriniz.",
                      hintStyle: Theme.of(context).textTheme.headline6,
                      errorText: widget.MailErrorText == ""
                          ? null
                          : widget.MailErrorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(150, 255, 255, 255),
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  TextField(
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
                            widget.hidePassword = !widget.hidePassword;
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
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.black,
                      ),
                      hintText: "Şifrenizi giriniz.",
                      hintStyle: Theme.of(context).textTheme.headline6,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(150, 255, 255, 255),
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Hesabınız yok mu? hesap oluşturmak için ",
                        style: Theme.of(context).textTheme.labelMedium,
                        children: [
                          TextSpan(
                              text: "tıklayın",
                              style: Theme.of(context)
                                  .textTheme
                                  .apply(bodyColor: Colors.blue)
                                  .labelMedium,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, "/Signin");
                                })
                        ]),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      LoginWithMail();
                    },
                    child: Text(
                      "Giriş yap",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
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
            ),
          ),
          if (!Responsive.isMobile(context))
            Expanded(flex: 1, child: Container())
        ],
      ),
    ));
  }

  void LoginWithMail() async {
    try {
      if (mailController.text == "") {
        widget.MailErrorText = "Lütfen bu kısmı doldurun!";
        setState(() {});
      } else if (PasswordController.text == "") {
        widget.MailErrorText = "";
        widget.PasswordErrorText = "Lütfen bu kısmı doldurun!";
        setState(() {});
      } else {
        showLoaderDialog(context);

        UserCredential _credential = await _auth.signInWithEmailAndPassword(
            email: mailController.text, password: PasswordController.text);
        activeUser = _credential.user!;

        drm = true;
        Navigator.pop(context);
        Navigator.pushNamed(context, "/MainMenu");
      }
    } catch (e) {
      Navigator.pop(context);

      WarningWidget(e.toString() + " hatası alındı.", "Hata", context);
    }
  }
}
