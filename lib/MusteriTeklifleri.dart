import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hopethelasone/ServicesActivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hopethelasone/editServisM1.dart';
import 'package:hopethelasone/editServisM2.dart';
import 'package:hopethelasone/editServisM3.dart';
import 'package:hopethelasone/editServisM4.dart';
import 'package:hopethelasone/editServisM5.dart';


class MusteriTeklifleri extends StatelessWidget {
  String sd_id;
  MusteriTeklifleri({required this.sd_id});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MusteriTeklifleriPage(sd_id: sd_id,),
      builder: (BuildContext context, Widget? child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}

class MusteriTeklifleriPage extends StatefulWidget {
  String sd_id;
  MusteriTeklifleriPage({required this.sd_id});
  @override
  _MusteriTeklifleriPageState createState() => _MusteriTeklifleriPageState(sd_id: sd_id);
}

class _MusteriTeklifleriPageState extends State<MusteriTeklifleriPage> {

  String sd_id;
  _MusteriTeklifleriPageState({required this.sd_id});

  Future<List<Teklifler>> getActifSiparisler() async {

      final String apiUrl = 'https://romani-au.digital/APIs/BiServis/api/?get_teklifler';

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'talep_id': sd_id!,
          },
        );

        if (response.statusCode == 200) {
          List<Map<String, dynamic>> responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
          List<Teklifler> actifSiparisList = responseData.map((item) {
            return Teklifler.fromJson(item);
          }).toList();

          EasyLoading.dismiss();
          return actifSiparisList;
        } else {
          print('Failed to fetch customer data: ${response.statusCode}');
          EasyLoading.dismiss();
          throw Exception('Failed to fetch customer data');
        }
      } catch (e) {
        print('Exception during data fetching: $e');
        EasyLoading.dismiss();
        throw Exception('Exception during data fetching');
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aktif Servisler'),
        backgroundColor:Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ServicesActivity()),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Teklifler>>(
          future: getActifSiparisler(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitFadingCube(
                  color: Colors.blue,
                  size: 40.0,
                ),
              ); // or any loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data available');
            } else {
              List<Teklifler> actifSiparisList = snapshot.data!;
              return ListView.builder(
                itemCount: actifSiparisList.length,
                itemBuilder: (context, index) {
                  Teklifler actifSiparis = actifSiparisList[index];
                  return TekliflerItemView(teklifler: actifSiparis);
                },
              );
            }
          },
        ),
      ),
    );
  }

}


class TekliflerItemView extends StatelessWidget {
  final Teklifler teklifler;

  TekliflerItemView({required this.teklifler});

  @override
  Widget build(BuildContext context) {

    Widget? myPaddingWidgets;

    if(teklifler.te_stat=="0"){

      myPaddingWidgets = Card(
        elevation: 8.0, // Optional: adds a shadow to the card
        color: Color(0xFF333333),
        child: Padding(
          padding: const EdgeInsets.all(9.0), // Add padding for aesthetic spacing
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use the minimum space necessary
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.add_home_work_rounded,
                  color: Colors.white,
                ), // Optional: add an icon or image
                title: Text(
                  teklifler.wo_name,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Telap Tarihi: ${teklifler.te_date}\nTelap No: ${teklifler.sd_id}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                // Adjust your data fields accordingly
                isThreeLine: true, // Allows for an additional line in the subtitle if needed
              ),

              Wrap(
                alignment: WrapAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      // Animation duration
                      curve: Curves.easeInOut,
                      // Animation curve
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          // Transparent background color
                          primary: Colors.white,
                          // Text color
                          padding: EdgeInsets.zero,
                          // Remove default padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            // Optional: Add rounded corners
                            side: BorderSide(
                              width: 2.0,
                              color: Color(
                                  0xFF333333), // Optional: Add a border
                            ),
                          ),
                        ),
                        onPressed: () {
                          changeOrderStat(teklifler.te_id, teklifler.sd_id, context, "1");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFFDF78),
                                Color(0xFFFF69B4),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                                20.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0,
                              horizontal: 16.0),
                          child: Text(
                            'Kabul Et',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 18000),
                      curve: Curves.bounceIn,
                      transform: Matrix4.identity(),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          primary: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                              width: 2.0,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                        onPressed: () {
                          changeOrderStat(teklifler.te_id, teklifler.sd_id, context, "-1");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFFDF78),
                                Color(0xFFFF69B4),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.0), // Match the shape of the button
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Padding within the button
                          child: Text(
                            'Red Et',
                            style: TextStyle(
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

    }else if(teklifler.te_stat=="-1"){

      myPaddingWidgets = Card(
        elevation: 8.0, // Optional: adds a shadow to the card
        color: Color(0xFF333333),
        child: Padding(
          padding: const EdgeInsets.all(9.0), // Add padding for aesthetic spacing
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use the minimum space necessary
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.add_home_work_rounded,
                  color: Colors.white,
                ), // Optional: add an icon or image
                title: Text(
                  teklifler.wo_name,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Telap Tarihi: ${teklifler.te_date}\nTelap No: ${teklifler.sd_id}\n\n Teklif Red Edildi',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                // Adjust your data fields accordingly
                isThreeLine: true, // Allows for an additional line in the subtitle if needed
              ),

            ],
          ),
        ),
      );

    }else if(teklifler.te_stat=="1"){

      myPaddingWidgets = Card(
        elevation: 8.0, // Optional: adds a shadow to the card
        color: Color(0xFF333333),
        child: Padding(
          padding: const EdgeInsets.all(9.0), // Add padding for aesthetic spacing
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use the minimum space necessary
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.add_home_work_rounded,
                  color: Colors.white,
                ), // Optional: add an icon or image
                title: Text(
                  teklifler.wo_name,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Telap Tarihi: ${teklifler.te_date}\nTelap No: ${teklifler.sd_id}\n\n Teklif Kabul Edildi',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                // Adjust your data fields accordingly
                isThreeLine: true, // Allows for an additional line in the subtitle if needed
              ),

            ],
          ),
        ),
      );

    }

    return myPaddingWidgets ?? Container();

  }
}

void changeOrderStat(String teklif_id, String order_id, BuildContext context, String stat) async {

  EasyLoading.show();
  final String apiUrl = 'https://romani-au.digital/APIs/BiServis/api/?change_talep_stat';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'talep_id': order_id,
        'teklif_stat': stat,
        'teklif_id': teklif_id,
      },
    );

    if (response.statusCode == 200) {

      print(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MusteriTeklifleri(sd_id: order_id)),
      );

      EasyLoading.dismiss();
    } else {
      print('Failed to fetch customer data: ${response.statusCode}');
      EasyLoading.dismiss();
      throw Exception('Failed to fetch customer data');
    }
  } catch (e) {
    print('Exception during data fetching: $e');
    EasyLoading.dismiss();
    throw Exception('Exception during data fetching');
  }

}


class Teklifler {
  final String te_id;
  final String te_fiyat;
  final String te_date;
  final String te_stat;
  final String sd_id;
  final String wo_name;
  final String wo_tel;
  final String wo_tecrube;
  final String wo_id;

  Teklifler({
    required this.te_id,
    required this.te_fiyat,
    required this.te_date,
    required this.te_stat,
    required this.sd_id,
    required this.wo_name,
    required this.wo_tel,
    required this.wo_tecrube,
    required this.wo_id,
  });

  factory Teklifler.fromJson(Map<String, dynamic> json) {
    return Teklifler(
      te_id: json['te_id'] ?? '',
      te_fiyat: json['te_fiyat'] ?? '',
      te_date: json['te_date'] ?? '',
      te_stat: json['te_stat'] ?? '',
      sd_id: json['sd_id'] ?? '',
      wo_name: json['wo_name'] ?? '',
      wo_tel: json['wo_tel'] ?? '',
      wo_tecrube: json['wo_tecrube'] ?? '',
      wo_id: json['wo_id'] ?? '',
    );
  }
}

