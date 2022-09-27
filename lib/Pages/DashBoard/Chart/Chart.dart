import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Rate.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Data/UserCalls.dart';
import 'package:technicalserviceadmin/Utils/Function.dart';
import 'package:technicalserviceadmin/Widgets/widgets.dart';

class ChartDetails extends StatefulWidget {
  @override
  State<ChartDetails> createState() => _ChartDetailsState();
}

class _ChartDetailsState extends State<ChartDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    GetChartFromFireStore();
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
                "İstatistikler",
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
          if (drm == false) Chart(average: average),
          if (drm == false)
            StorageInfoCard(
              rate: "assets/icons/smile.svg",
              title: "Yüksek Puan",
              amountOfFiles: high.toString(),
              numOfFiles: total,
              color: Color.fromARGB(255, 17, 169, 119),
            ),
          if (drm == false)
            StorageInfoCard(
              rate: "assets/icons/confused.svg",
              title: "Orta Puan",
              amountOfFiles: mid.toString(),
              numOfFiles: total,
              color: Color.fromARGB(255, 214, 90, 46),
            ),
          if (drm == false)
            StorageInfoCard(
              rate: "assets/icons/sad.svg",
              title: "Düşük Puan",
              amountOfFiles: low.toString(),
              numOfFiles: total,
              color: Color.fromARGB(255, 223, 50, 49),
            ),
        ],
      ),
    );
  }

  void GetChartFromFireStore() async {
    try {
      if (drm == true) {
        average = 0;
        high = 0;
        low = 0;
        mid = 0;
        total = 0;
        rateList.clear();
        var veriler = await _firestore
            .collection("Ratings")
            .where("ServiceId", isEqualTo: activeUser.uid)
            .get();

        for (var veri in veriler.docs) {
          RateModel rateModel = new RateModel();

          rateModel.RateCount = int.parse(
              Cryptology().Decryption(veri.get("RateCount"), context));
          print(veri);
          total++;
          average += rateModel.RateCount;
          if (rateModel.RateCount < 5) {
            low++;
          } else if (rateModel.RateCount >= 8) {
            high++;
          } else {
            mid++;
          }
        }
        setState(() {
          average = average / total;
          drm = false;
        });
      }
    } catch (e) {
      print(e.toString());
      WarningWidget(e.toString() + " Hatası alındı!", "Hata", context);
    }
  }
}

class Chart extends StatefulWidget {
  const Chart({
    Key? key,
    required this.average,
  }) : super(key: key);
  final double average;
  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: paiChartSelectionDatas,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text(
                  average.toStringAsFixed(2) + " / 10",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color:
                            selectedtheme == true ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text(
                  "puan",
                  style: Theme.of(context)
                      .textTheme
                      .apply(
                          displayColor: selectedtheme == true
                              ? Colors.white
                              : Colors.black)
                      .bodySmall,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> paiChartSelectionDatas = [
    PieChartSectionData(
      color: Colors.red,
      value: low == 0 && mid == 0 && high == 0 ? 1 : low.toDouble(),
      showTitle: false,
      radius: 25,
    ),
    PieChartSectionData(
      color: Colors.orange,
      value: low == 0 && mid == 0 && high == 0 ? 1 : mid.toDouble(),
      showTitle: false,
      radius: 22,
    ),
    PieChartSectionData(
      color: Colors.green,
      value: low == 0 && mid == 0 && high == 0 ? 1 : high.toDouble(),
      showTitle: false,
      radius: 19,
    ),
  ];
}

class StorageInfoCard extends StatelessWidget {
  const StorageInfoCard({
    Key? key,
    required this.title,
    required this.rate,
    required this.amountOfFiles,
    required this.numOfFiles,
    required this.color,
  }) : super(key: key);

  final String title, amountOfFiles, rate;
  final int numOfFiles;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(
            width: 2,
            color: selectedtheme == true
                ? Color.fromARGB(255, 29, 36, 51)
                : Colors.white.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 30,
            width: 30,
            child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: color),
                child: SvgPicture.asset(
                  rate,
                  color: Colors.white,
                )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .apply(
                            bodyColor: selectedtheme == true
                                ? Colors.white
                                : Colors.black)
                        .bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          Text(
            amountOfFiles,
            style: Theme.of(context)
                .textTheme
                .apply(
                    bodyColor:
                        selectedtheme == true ? Colors.white : Colors.black)
                .bodyMedium,
          )
        ],
      ),
    );
  }
}
