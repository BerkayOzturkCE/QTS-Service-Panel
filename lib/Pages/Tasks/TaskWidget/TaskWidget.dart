import 'dart:html';
import 'dart:ui' as ui;
import 'package:data_table_2/data_table_2.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Data/UserCalls.dart';

class TaskWidget extends StatefulWidget {
  TaskWidget({
    Key? key,
    required this.userCallList,
  }) : super(key: key);
  final List<UserCalls> userCallList;
  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
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
                minWidth: 1178,
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
                  DataColumn(
                    label: Text(
                      "Bina No",
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
                      "Kat",
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
                      "Daire No",
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
                      "Adres Açıklaması",
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
                      "Konum",
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

  DataRow recentFileDataRow(UserCalls userCalls) {
    print(userCalls.AdresAciklama);
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
              SizedBox(
                width: defaultPadding,
              ),
              Text(
                userCalls.UserName,
                style: Theme.of(context)
                    .textTheme
                    .apply(
                      bodyColor:
                          selectedtheme == true ? Colors.white : Colors.black,
                    )
                    .bodyMedium,
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
        DataCell(Text(userCalls.apt,
            style: Theme.of(context)
                .textTheme
                .apply(
                  bodyColor:
                      selectedtheme == true ? Colors.white : Colors.black,
                )
                .bodyMedium)),
        DataCell(Text(userCalls.kat,
            style: Theme.of(context)
                .textTheme
                .apply(
                  bodyColor:
                      selectedtheme == true ? Colors.white : Colors.black,
                )
                .bodyMedium)),
        DataCell(Text(userCalls.no,
            style: Theme.of(context)
                .textTheme
                .apply(
                  bodyColor:
                      selectedtheme == true ? Colors.white : Colors.black,
                )
                .bodyMedium)),
        DataCell(Text(userCalls.adres,
            style: Theme.of(context)
                .textTheme
                .apply(
                  bodyColor:
                      selectedtheme == true ? Colors.white : Colors.black,
                )
                .bodyMedium)),
        DataCell(
          ElevatedButton(
            child: Text(
              "Konum",
              style: Theme.of(context)
                  .textTheme
                  .apply(
                    bodyColor: Colors.white,
                  )
                  .bodyMedium,
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding * 1.5,
                vertical:
                    defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
              ),
            ),
            onPressed: () {
              showDialog(
                  context: context, builder: (context) => Map(userCalls));
            },
          ),
        ),
      ],
    );
  }
}

class Map extends StatefulWidget {
  late UserCalls userCallsItem;
  String adresDetail = "";

  Map(this.userCallsItem);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController _controller;
  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(const Radius.circular(15))),
      backgroundColor: Colors.grey[400],
      title: Text(
        "Konum",
        style: GoogleFonts.roboto(
            color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [getMap()],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(230, 0, 113, 227),
                  )),
              child: Text(
                'Tamam',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }

  void onmapcreated() {
    if (selectedtheme == true) {
      _controller.setMapStyle(util.DarkmapStyle);
    } else {
      _controller.setMapStyle(util.LightmapStyle);
    }
    markers.clear;
    setState(() {
      markers.add(Marker(
          markerId: MarkerId("id-1"),
          position:
              LatLng(widget.userCallsItem.lat, widget.userCallsItem.lon)));
    });
  }

  Widget getMap() {
    return Container(
      width: ScreenUtil.getWidth(context) / 2,
      height: ScreenUtil.getHeight(context) / 2,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        child: GoogleMap(
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          gestureRecognizers: Set()
            ..add(Factory<EagerGestureRecognizer>(
                () => EagerGestureRecognizer())),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            onmapcreated();
          },
          markers: markers,
          myLocationButtonEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.userCallsItem.lat, widget.userCallsItem.lon),
            zoom: 15.0,
          ),
        ),
      ),
    );
  }
}

class util {
  static String DarkmapStyle = '''

[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8ec3b9"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1a3646"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#4b6878"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#64779e"
      }
    ]
  },
  {
    "featureType": "administrative.province",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#4b6878"
      }
    ]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#334e87"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#283d6a"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6f9ba5"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3C7680"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#304a7d"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#98a5be"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2c6675"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#255763"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#b0d5ce"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#98a5be"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#283d6a"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3a4762"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#0e1626"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#4e6d70"
      }
    ]
  }
]
  ''';

  static String LightmapStyle = '''[]''';
}
