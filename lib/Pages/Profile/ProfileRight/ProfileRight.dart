import 'package:flutter/material.dart';
import 'package:technicalserviceadmin/Data/Category.dart';
import 'package:technicalserviceadmin/Data/City.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Data/Services.dart';

class ProfileRight extends StatefulWidget {
  ProfileRight(this.services);

  @override
  State<ProfileRight> createState() => _ProfileRightState();
  bool ToTextfield = true;
  Services services;
}

class _ProfileRightState extends State<ProfileRight> {
  void initState() {
    // TODO: implement initState
    SelectedCityName = widget.services.mah;
    SelectedCategory = widget.services.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataToTextField();
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(children: [
        if (!Responsive.isMobile(context))
          SizedBox(
            height: 20,
          ),
        if (!Responsive.isMobile(context))
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SelectCategory(),
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
        if (Responsive.isMobile(context)) SelectCategory(),
        if (Responsive.isMobile(context))
          SizedBox(
            height: defaultPadding,
          ),
        if (Responsive.isMobile(context)) SelectCity(),
        SizedBox(
          height: Responsive.isMobile(context) ? defaultPadding : 40,
        ),
        TextField(
          controller: DetailsController,
          style: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.black)
              .headline6,
          maxLines: 7,
          decoration: InputDecoration(
            hintText: "Açıklama giriniz.",
            hintStyle: Theme.of(context).textTheme.headline6,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            filled: true,
            fillColor: Color.fromARGB(150, 255, 255, 255),
          ),
        ),
      ]),
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
                SelectedCityName = deger.toString();
              });
            },
            value: SelectedCityName,
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

  Future<void> DataToTextField() async {
    if (widget.ToTextfield) {
      setState(() {
        DetailsController.text = widget.services.aciklama;
        widget.ToTextfield = false;
      });
    }
  }
}
