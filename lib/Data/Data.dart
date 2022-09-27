import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:technicalserviceadmin/Data/Rate.dart';
import 'package:technicalserviceadmin/Data/UserCalls.dart';
import 'package:technicalserviceadmin/Data/message.dart';
import 'package:technicalserviceadmin/Pages/Chat/Chat.dart';

bool selectedtheme = true; //true is dark
late User activeUser;
int pageIndex = 0;
bool drm = true;
List<RateModel> rateList = [];
List<UserCalls> LastCalls = [];
double average = 0;
int total = 0, low = 0, high = 0, mid = 0;

ChatModel CurrentChat = new ChatModel();
bool ChatRead = true;
bool getChats = true;
List<ChatModel> chatList = [];

late Function chatPageUpdate;

PageController pageController = new PageController(initialPage: pageIndex);
final GlobalKey<ScaffoldState> scaffoldKey1 = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> get scaffoldKey => scaffoldKey1;
String selectedChatId = "";

TextEditingController nameController = new TextEditingController();
TextEditingController mailController = new TextEditingController();
TextEditingController PriceController = new TextEditingController();
TextEditingController DetailsController = new TextEditingController();
String SelectedCityName = "Şehir seçiniz";
String SelectedCategory = "Kategori Seçiniz";
const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

class ScreenUtil {
  static getSize(context) {
    return MediaQuery.of(context).size;
  }

  static getWidth(context) {
    return MediaQuery.of(context).size.width;
  }

  static getHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  static minimumSize(context) {
    double enkucuk = getWidth(context);
    if (getWidth(context) > getHeight(context)) {
      enkucuk = getHeight(context);
    }
    return enkucuk;
  }

  static divideWidth(context, {divided = 1}) {
    return MediaQuery.of(context).size.width / divided;
  }
}
