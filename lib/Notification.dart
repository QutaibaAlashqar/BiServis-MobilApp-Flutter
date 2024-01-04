import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hopethelasone/ServicesActivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class CustomerNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationPage(),
      builder: (BuildContext context, Widget? child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  _NotificationPageState() : tc = '';

  String? tc;

  @override
  void initState() {
    super.initState();
    getSharedPreferencesData();
  }

  Future<List<Notif>> getSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedValue = prefs.getString('tcno');
    if (storedValue != null) {
      tc = storedValue;
    }
    return getActifSiparisler();
  }

  Future<List<Notif>> getActifSiparisler() async {
    if (tc == null) {
      await getSharedPreferencesData();
      return getActifSiparisler();
    } else {
      final String apiUrl = 'https://romani-au.digital/APIs/BiServis/api/?get_bildirim';

      print(tc);

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'cu_id': tc!,
          },
        );

        if (response.statusCode == 200) {
          List<Map<String, dynamic>> responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
          List<Notif> actifSiparisList = responseData.map((item) {
            return Notif.fromJson(item);
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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bildirimler'),
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
        child: FutureBuilder<List<Notif>>(
          future: getSharedPreferencesData(),
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
              List<Notif> notifList = snapshot.data!;
              return ListView.builder(
                itemCount: notifList.length,
                itemBuilder: (context, index) {
                  Notif notif = notifList[index];
                  return ActifSiparisItemView(notif: notif, tc: tc!,);
                },
              );
            }
          },
        ),
      ),
    );
  }

}

class ActifSiparisItemView extends StatelessWidget {
  final Notif notif;
  final String tc;

  ActifSiparisItemView({required this.notif, required this.tc});

  @override
  Widget build(BuildContext context) {

    Widget? myPaddingWidgets;

    if(notif.cu_stat=="0"){

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
                subtitle: Text(
                  '${notif.sd_id} : ${notif.wo_name} size bir Teklif verdi , Teklif Fiyati : ${notif.te_fiyat} ******************',
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

    }else {

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
                subtitle: Text(
                  '${notif.sd_id} : ${notif.wo_name} size bir Teklif verdi , Teklif Fiyati : ${notif.te_fiyat}',
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



    // Customize this widget based on your ActifSiparis data
    /*
    return Card(
      child: ListTile(
        title: Text(actifSiparis.sName),
        subtitle: Text('Order Date: ${actifSiparis.orderDate}'),
        subtitle: Text('O: ${actifSiparis.orderDate}'),
        // Add more widgets to display other information
      ),
    );
     */
  }
}




class Notif {
  final String sd_id;
  final String order_date;
  final String te_date;
  final String te_fiyat;
  final String wo_name;
  final String wo_tecrube;
  final String wo_id;
  final String cu_stat;
  final String wo_stat;

  Notif({
    required this.sd_id,
    required this.order_date,
    required this.te_date,
    required this.te_fiyat,
    required this.wo_name,
    required this.wo_tecrube,
    required this.wo_id,
    required this.cu_stat,
    required this.wo_stat,
  });

  factory Notif.fromJson(Map<String, dynamic> json) {
    return Notif(
      sd_id: json['sd_id'] ?? '',
      order_date: json['order_date'] ?? '',
      te_date: json['te_date'] ?? '',
      te_fiyat: json['te_fiyat'] ?? '',
      wo_name: json['wo_name'] ?? '',
      wo_tecrube: json['wo_tecrube'] ?? '',
      wo_id: json['wo_id'] ?? '',
      cu_stat: json['cu_stat'] ?? '',
      wo_stat: json['wo_stat'] ?? '',
    );
  }
}


