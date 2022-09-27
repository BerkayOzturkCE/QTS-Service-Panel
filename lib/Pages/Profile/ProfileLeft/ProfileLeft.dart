import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Data/Services.dart';
import 'package:technicalserviceadmin/Utils/Function.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:technicalserviceadmin/Widgets/widgets.dart';
import 'dart:html';

class ProfileLeft extends StatefulWidget {
  ProfileLeft({
    Key? key,
    required this.services,
    this.NameErrorText = "",
    this.PriceErrorText = "",
  }) : super(key: key);
  final Services services;
  final String NameErrorText;
  final String PriceErrorText;

  @override
  State<ProfileLeft> createState() => _ProfileLeftState();
  bool isHoverOnImage = false;

  bool ToTextfield = true;
}

class _ProfileLeftState extends State<ProfileLeft> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    DataToTextField();
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        Center(
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              ChangePhoto();
            },
            onHover: (value) {
              if (value != widget.isHoverOnImage) {
                setState(() {
                  widget.isHoverOnImage = value;
                  print(value);
                });
              }
            },
            child: Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(180)),
                    child: Image.network(
                      widget.services.Image,
                      fit: BoxFit.fill,
                      width: 250,
                      height: 250,
                    )),
                if (widget.isHoverOnImage)
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(180)),
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration:
                          BoxDecoration(color: Colors.grey.withOpacity(0.4)),
                      child: Center(
                          child: Text(
                        "Fotoğrafı değiştir",
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                    ),
                  )
              ],
            ),
          ),
        ),
        SizedBox(
          height: Responsive.isMobile(context) ? 30 : 60,
        ),
        TextField(
          controller: nameController,
          style: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.black)
              .headline6,
          decoration: InputDecoration(
            prefixIcon:
                Icon(Icons.corporate_fare_outlined, color: Colors.black),
            hintText: "İsim giriniz.",
            hintStyle: Theme.of(context).textTheme.headline6,
            errorText: widget.NameErrorText == "" ? null : widget.NameErrorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            filled: true,
            fillColor: Color.fromARGB(150, 255, 255, 255),
          ),
        ),
        SizedBox(
          height: Responsive.isMobile(context) ? defaultPadding : 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                controller: mailController,
                readOnly: true,
                style: Theme.of(context)
                    .textTheme
                    .apply(bodyColor: Colors.black)
                    .headline6,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline, color: Colors.black),
                  hintText: "Mail Giriniz.",
                  hintStyle: Theme.of(context).textTheme.headline6,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(150, 255, 255, 255),
                ),
              ),
            ),
            SizedBox(
              width: defaultPadding,
            ),
            Expanded(
              flex: 1,
              child: TextField(
                controller: PriceController,
                keyboardType: TextInputType.number,
                style: Theme.of(context)
                    .textTheme
                    .apply(bodyColor: Colors.black)
                    .headline6,
                onChanged: (input) {},
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.currency_lira, color: Colors.black),
                  hintText: "Minimum Ücret.",
                  hintStyle: Theme.of(context).textTheme.headline6,
                  errorText: widget.PriceErrorText == ""
                      ? null
                      : widget.PriceErrorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(150, 255, 255, 255),
                ),
              ),
            )
          ],
        )
      ]),
    );
  }

  Future<void> DataToTextField() async {
    if (widget.ToTextfield) {
      setState(() {
        nameController.text = widget.services.Name;
        mailController.text = activeUser.email!;
        PriceController.text = widget.services.Fiyat.toString();

        widget.ToTextfield = false;
      });
    }
  }

  void ChangePhoto() async {
    try {
      String resimUrl;

      var resim = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);

      showLoaderDialog(context);
      print("veriii");

      if (resim != null) {
        final fileBytes = resim.files.first.bytes;
        final fileName =
            activeUser.uid + DateTime.now().toString() + resim.files.first.name;
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child("images/$fileName");
        firebase_storage.UploadTask uploadTask = ref.putData(fileBytes!);

        debugPrint(resim.toString());

        resimUrl =
            await (await uploadTask.whenComplete(() => Navigator.pop(context)))
                .ref
                .getDownloadURL();
        debugPrint(resimUrl);
        await _firestore
            .collection("Services")
            .doc(activeUser.uid)
            .update({'Image': resimUrl})
            .whenComplete(() =>
                WarningWidget("Fotoğraf Güncellendi", "Başarılı", context))
            .onError((error, stackTrace) =>
                WarningWidget("Fotoğraf güncellenemedi", "Başarısız", context))
            .timeout(Duration(seconds: 10));
        widget.services.Image = resimUrl;
        setState(() {});
      } else {
        Navigator.pop(context);
      }
    } catch (error) {
      print(error);
    }
  }
}
