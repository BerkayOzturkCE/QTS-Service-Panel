import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Rate.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Utils/Function.dart';
import 'package:technicalserviceadmin/Widgets/widgets.dart';

class Comment extends StatefulWidget {
  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    GetCommentFromFireStore();
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Son Yorumlar",
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
        SizedBox(height: defaultPadding),
        if (drm == true) CircularProgressIndicator(),
        if (drm == false)
          Responsive(
            mobile: CommentGridView(
              crossAxisCount: _size.width < 650 ? 2 : 3,
              childAspectRatio: _size.width < 650 ? 1.3 : 1,
              rates: rateList,
            ),
            tablet: CommentGridView(
              crossAxisCount: _size.width < 1100 ? 3 : 4,
              rates: rateList,
            ),
            desktop: CommentGridView(
              childAspectRatio: _size.width < 1400 ? 1.2 : 1.4,
              crossAxisCount: _size.width < 1400 ? 3 : 4,
              rates: rateList,
            ),
          ),
      ],
    );
  }

  void GetCommentFromFireStore() async {
    try {
      if (drm == true) {
        rateList.clear();
        var veriler = await _firestore
            .collection("Ratings")
            .where("ServiceId", isEqualTo: activeUser.uid)
            .get();

        for (var veri in veriler.docs) {
          RateModel rateModel = new RateModel();
          rateModel.CallId = veri.get("CallId").toString();
          rateModel.Comment =
              Cryptology().Decryption(veri.get("Comment").toString(), context);
          rateModel.UserName =
              Cryptology().Decryption(veri.get("UserName").toString(), context);
          rateModel.RateCount = int.parse(
              Cryptology().Decryption(veri.get("RateCount"), context));
          rateModel.ServiceId = veri.get("ServiceId").toString();
          rateModel.UserId = veri.get("UserId").toString();
          Timestamp date = veri.get("Date");
          rateModel.date = date.toDate();
          rateModel.UserName = NameSecret(rateModel.UserName);
          rateList.add(rateModel);
          print(veri);
        }
        setState(() {
          drm = false;
        });
      }
    } catch (e) {
      print(e.toString());
      WarningWidget(e.toString() + " Hatası alındı!", "Hata", context);
    }
  }

  String NameSecret(String Name) {
    var NameList = Name.split(" ");
    String NameSecret = "";
    for (var i = 0; i < NameList.length; i++) {
      String nameTemp = NameList[i][0];

      for (var j = 1; j < NameList[i].length; j++) {
        nameTemp += "*";
      }
      NameList[i] = nameTemp;
      NameSecret += NameList[i];
      NameSecret += " ";
    }
    return NameSecret;
  }

  void dnm() {
    RateModel rateModel = new RateModel();
    rateModel.Comment = "Cok iyi";
    rateModel.UserName = "berkay";
    rateModel.RateCount = 6;
    rateList.add(rateModel);
  }
}

class CommentGridView extends StatelessWidget {
  const CommentGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.rates,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final List rates;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: rateList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => CommentCard(rateModel: rates[index]),
    );
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard({
    Key? key,
    required this.rateModel,
  }) : super(key: key);

  final RateModel rateModel;

  @override
  Widget build(BuildContext context) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rateModel.UserName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .apply(
                      bodyColor:
                          selectedtheme == true ? Colors.white : Colors.black,
                    )
                    .bodyMedium,
              ),
              ShowPoint(rateModel.RateCount, context),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rateModel.Comment,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .apply(
                      displayColor:
                          selectedtheme == true ? Colors.white : Colors.black,
                    )
                    .bodySmall,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget ShowPoint(int RateCount, BuildContext context) {
    return Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Functions().ColorDetecter(rateModel.RateCount.toDouble())),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Puan",
                style: Theme.of(context)
                    .textTheme
                    .apply(
                      displayColor: Colors.white,
                    )
                    .bodySmall,
              ),
              Text(
                RateCount.toString(),
                style: Theme.of(context)
                    .textTheme
                    .apply(
                      displayColor: Colors.white,
                    )
                    .bodySmall,
              ),
            ],
          ),
        ));
  }
}
