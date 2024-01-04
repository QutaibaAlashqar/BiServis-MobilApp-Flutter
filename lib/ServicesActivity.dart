import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hopethelasone/GizlilikPolitikasi.dart';
import 'package:hopethelasone/Notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hopethelasone/CustomerAktifSiparisler.dart';
import 'package:hopethelasone/CustomerGecmisSiparisler.dart';
import 'package:hopethelasone/ServisM1.dart';
import 'package:hopethelasone/ServisM2.dart';
import 'package:hopethelasone/ServisM3.dart';
import 'package:hopethelasone/ServisM4.dart';
import 'package:hopethelasone/ServisM5.dart';
import 'package:hopethelasone/WorkerProfil.dart';
import 'package:http/http.dart' as http;
import 'package:hopethelasone/editCustomerProfile.dart';
import 'package:hopethelasone/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class ServicesActivity extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ServicesActivity> {

  @override
  void initState() {
    super.initState();
    _loadStoredValue();
  }

  final List<String> items = List.generate(10, (index) => 'Item $index');

  String eposta = '', userName = '';
  bool _dataLoaded = false;

  _loadStoredValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    eposta = prefs.getString('eposta') ?? '';
    userName = prefs.getString('userName') ?? '';
    _dataLoaded = true;
  }

  Future<List<YourDataModel>> fetchData() async {
    final response = await http.get(Uri.parse('https://romani-au.digital/APIs/BiServis/api/?get_servis'));

    if (response.statusCode == 200) {
      // Parse the JSON response and create a list of YourDataModel
      String body = response.body.replaceAll("<pre>", "");
      body = body.replaceAll("pre/", "");
      body = body.replaceAll("<>", "");
      final Map<String, dynamic> jsonData = json.decode(body);

      print(jsonData);

      if (jsonData['stat'] == 'ok') {
        final List<dynamic> servisList = jsonData['servis'];

        List<YourDataModel> data = servisList.map((data) => YourDataModel(
          servis_id: data['servis_id'],
          servis_name: data['servis_name'],
          service_logo: data['servis_logo'],
          servis_view_mode: data['servis_view_mode'],
          servis_wo_count: data['servis_wo_count'],
        )).toList();

        return data;
      } else {
        throw Exception('API returned an error: ${jsonData['message']}');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Image.asset(
                  'assets/335541.png', // Path to your app icon image file
                  width: 15, // Adjust the width of the app icon as needed
                ),
              SizedBox(width: 5,),
              Text(
                'BiServis',
                style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black,),
            onPressed: () {
              // Handle notifications button press
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    CustomerNotification()), // Pass the item data to the detail page if needed
              );
            },
          ),
        ],
      ),

      drawer: Drawer(

        child: FutureBuilder(
          future: _loadStoredValue(),
          builder: (context, snapshot) {
            if (!_dataLoaded) {
              return SpinKitFoldingCube(
                color: Colors.blue,
                size: 40.0,
              ); // Or any loading indicator
            }

          return Container(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[

                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue, // Your desired header color
                  ),
                  accountName: Text(userName),
                  accountEmail: Text(eposta),

                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Ana Sayfa'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.account_box),
                  title: Text('Profil'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            editCustomerProfile()), // Pass the item data to the detail page if needed
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.schedule_send),
                  title: Text('Aktif Talepler (Teklifler)'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          CustomerAktifSiparisler()), // Pass the item data to the detail page if needed
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.receipt_long),
                  title: Text('Geçmiş Talepler'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          CustomerOldSiparisler()), // Pass the item data to the detail page if needed
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications_none),
                  title: Text('Bildirimler'),
                  onTap: () {
                    // Handle logout logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          CustomerNotification()), // Pass the item data to the detail page if needed
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.report),
                  title: Text('Hakkımızda'),
                  onTap: () {
                    // Handle logout logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          GizlilikPolitikasi()), // Pass the item data to the detail page if needed
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text('Gizlilik Politikası'),
                  onTap: () {
                    // Handle logout logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          GizlilikPolitikasi()), // Pass the item data to the detail page if needed
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Çıkış'),
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('tcno', "");
                    prefs.setString('eposta', "");
                    prefs.setString('userName', "");
                    prefs.setString('stat', "");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          MainActivity()), // Pass the item data to the detail page if needed
                    );
                  },
                ),
              ],
            ),
          );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Servisler',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '8 Servis Mevcuttur',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Expanded( // Wrap the GridView.builder with Expanded
            child: FutureBuilder<List<YourDataModel>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitThreeBounce(
                      color: Colors.blue,
                      size: 30.0,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Data has been loaded successfully
                  List<YourDataModel> data = snapshot.data!;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GridItem(data[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),

    );
  }
}

class GridItem extends StatelessWidget {
  YourDataModel dataModel;

  GridItem(this.dataModel);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(dataModel.servis_view_mode=="M1") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ServicsM1(s_id: dataModel.servis_id,)), // Pass the item data to the detail page if needed
          );
        }else if(dataModel.servis_view_mode=="M2") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ServicsM2(s_id: dataModel.servis_id,)), // Pass the item data to the detail page if needed
          );
        }else if(dataModel.servis_view_mode=="M3") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ServicsM3(s_id: dataModel.servis_id,)), // Pass the item data to the detail page if needed
          );
        }else if(dataModel.servis_view_mode=="M4") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ServisM4(s_id: dataModel.servis_id,)), // Pass the item data to the detail page if needed
          );
        }else if(dataModel.servis_view_mode=="M5") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ServisM5(s_id: dataModel.servis_id,)), // Pass the item data to the detail page if needed
          );
        }
      },
      child: Card(
        elevation: 2,
        child: Stack(
          children: <Widget>[
          Positioned.fill(
            child: Image.network(
              dataModel.service_logo, // URL of the background image
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error); // Display an error icon if image loading fails
              },
            ),
          ),

          Padding(
          padding: EdgeInsets.only(right: 8, top: 8), // Adjust the right and top padding as needed
          child: Align(
          alignment: Alignment.topRight,
          child: Container(
              height: 28,
              padding: const EdgeInsets.only(top: 4, left: 8, right: 10, bottom: 4),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
              color: Colors.black.withOpacity(0.75),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              ),
              ),
              child: Text(
                dataModel.servis_name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              ),),),

              Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8), // Adjust the right and top padding as needed
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 28,
                    padding: const EdgeInsets.only(top: 4, left: 8, right: 10, bottom: 4),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.black.withOpacity(0.75),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      dataModel.servis_wo_count+" Çalışan",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),),)

        ],
      ),),
    );
  }
}

class YourDataModel {
  final String servis_id;
  final String servis_name;
  final String service_logo;
  final String servis_view_mode;
  final String servis_wo_count;


  YourDataModel({required this.servis_id, required this.servis_name, required this.service_logo, required this.servis_view_mode, required this.servis_wo_count});
}



