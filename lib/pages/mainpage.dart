import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weatherapp/secrest.dart';

import 'package:weatherapp/utils/days_forecast.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  Future getwheather() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city,uk&APPID=$apiId'));
    var data = response.body;
    if (response.statusCode == 200) {
      return jsonDecode(data);
    } else {
      return jsonDecode(data);
    }
  }

  @override
  void initState() {
    getwheather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  getwheather();
                });
              },
              icon: const Icon(Icons.refresh))
        ],
        backgroundColor: Colors.blue,
        centerTitle: false,
        title: Text("Weather Forecast",
            style: GoogleFonts.archivo(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
            future: getwheather(),
            builder: (context, snapshot) {
              List templist = [];

              for (int i = 1; i < 10; i++) {
                templist.add(snapshot.data?['list'][i]['main']['temp']);
              }
              List iconList = [];
              for (int i = 1; i < 10; i++) {
                iconList.add(
                    "${"http://openweathermap.org/img/w/" + snapshot.data['list'][0]['weather'][0]['icon']}.png");
              }
              final time = DateTime.now();
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData ||
                  snapshot.data['list'] == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final iconUrl =
                    "${"http://openweathermap.org/img/w/" + snapshot.data['list'][0]['weather'][0]['icon']}.png";
                return Column(children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Card(
                      color: Colors.blueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Current Weather",
                                style: GoogleFonts.archivo(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                )),
                            Text(
                              snapshot.data['city']['name'],
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            Center(
                                child: Image.network(
                              iconUrl,
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  snapshot.data['list'][0]['weather'][0]
                                      ['main'],
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    '${snapshot.data['list'][0]['main']['temp']}',
                                    style: GoogleFonts.archivo(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Hourly Forecast',
                        style: GoogleFonts.archivo(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child: Card(
                      color: Colors.white70,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return days(
                                DateFormat.j()
                                    .format(time.add(Duration(hours: index))),
                                iconList[index],
                                templist[index]);
                          }),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Additional Information',
                        style: GoogleFonts.archivo(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          const Icon(
                            Icons.water_drop_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                          Text(
                            "Humidity ",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "${snapshot.data['list'][0]['main']['humidity']}", //${snapshot.data['main']['humidity']}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 19),
                          )
                        ]),
                      ),
                      Column(children: [
                        const Icon(
                          Icons.air_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "Wind Speed",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "${snapshot.data['list'][0]['wind']['speed']}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 19),
                        )
                      ]),
                      Column(children: [
                        const Icon(
                          Icons.beach_access,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "pressure",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "${snapshot.data['list'][0]['main']['pressure']}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 19),
                        )
                      ])
                    ],
                  )
                ]);
              }
            }),
      ),
    );
  }
}
