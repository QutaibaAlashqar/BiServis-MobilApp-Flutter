import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hopethelasone/WorkerActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hopethelasone/detailServisM1.dart';
import 'package:hopethelasone/detailServisM2.dart';
import 'package:hopethelasone/detailServisM3.dart';
import 'package:hopethelasone/detailServisM4.dart';
import 'package:hopethelasone/detailServisM5.dart';

import 'CustomerAktifSiparisler.dart';


class WorkerAktifSiparisler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AktifSiparislerPage(),
      builder: (BuildContext context, Widget? child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}

class AktifSiparislerPage extends StatefulWidget {
  @override
  _AktifSiparislerPageState createState() => _AktifSiparislerPageState();
}

class _AktifSiparislerPageState extends State<AktifSiparislerPage> {

  String eposta = '', userName = '', tc = '', bolum = '';
  bool _dataLoaded = false;


  Future<List<Orders>> _loadStoredValue2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    eposta = prefs.getString('eposta') ?? '';
    userName = prefs.getString('userName') ?? '';
    tc = prefs.getString('tcno') ?? '';
    bolum = prefs.getString('bolum') ?? '';
    _dataLoaded = true;
    return fetchData();
  }

  Future<List<Orders>> fetchData() async {

    final response = await http.get(Uri.parse('https://romani-au.digital/APIs/BiServis/api/?get_worker_services&worker_id='+tc+'&bolum='+bolum));
    print(response.body);
    if (response.statusCode == 200) {

      Map<String, dynamic> jsonResponse = json.decode(response.body);

      String stat = jsonResponse['stat'];
      List<dynamic> orders = jsonResponse['orders'];

      print('Stat: $stat');

      List<Orders> data = orders.map((data) => Orders(
        sdId: data['sd_id']  ?? '',
        salonCount: data['salon_count']  ?? '',
        salonMetresi: data['salon_metresi']  ?? '',
        mutfakCount: data['mutfak_count']  ?? '',
        mutfakMetresi: data['mutfak_metresi']  ?? '',
        buroCount: data['buro_count']  ?? '',
        buroMetresi: data['buro_metresi']  ?? '',
        depoCount: data['depo_count']  ?? '',
        depoMetresi: data['depo_metresi']  ?? '',
        banyoCount: data['banyo_count']  ?? '',
        banyoMetresi: data['banyo_metresi']  ?? '',
        tuvaletCount: data['tuvalet_count']  ?? '',
        tuvaletMetresi: data['tuvalet_metresi']  ?? '',
        odaCount: data['oda_count']  ?? '',
        odaMetresi: data['oda_metresi']  ?? '',
        bahceCount: data['bahce_count']  ?? '',
        bahcaMetresi: data['bahca_metresi']  ?? '',
        balkonCount: data['balkon_count']  ?? '',
        balkonMetresi: data['balkon_metresi']  ?? '',
        agacCount: data['agac_count']  ?? '',
        sdNot: data['sd_not']  ?? '',
        saatSayisi: data['saat_sayisi']  ?? '',
        gunSayisi: data['gun_sayisi']  ?? '',
        orderDate: data['order_date']  ?? '',
        baslangicTarihi: data['baslangic_tarihi']  ?? '',
        cuId: data['cu_id']  ?? '',
        image: data['image']  ?? '',
        sId: data['s_id']  ?? '',
        sdStat: data['sd_stat'].toString()  ?? '',
        sName: data['s_name']  ?? '',
        sLogo: data['s_logo']  ?? '',
        sViewMode: data['s_view_mode']  ?? '',
        cu_name: data['cu_name']  ?? '',
        cu_city: data['cu_city']  ?? '',
        cu_addres: data['cu_addres']  ?? '',
        cu_tel: data['cu_tel']  ?? '',
        te_fiyat: data['te_fiyat']  ?? '',
        te_date: data['te_date']  ?? '',
        te_stat: data['te_stat'].toString()  ?? '',
        wo_name: data['wo_name'].toString()  ?? '',
        wo_id: data['wo_id'].toString()  ?? '',
        wo_tel: data['wo_tel'].toString()  ?? '',
        children: (data['children'] as List<dynamic>?)
            ?.map<ChildrenList>((dynamic child) {
          if (child is Map<String, dynamic>) {
            return ChildrenList.fromJson(child);
          } else {
            // Handle other cases or return a default value as needed
            return ChildrenList(Age: '', Sex: '');
          }
        })
            .toList() ?? [],
      )).toList();
      List<Orders> toreturn=[];
      data.forEach((element) {
        if(element.te_fiyat!=''){
          toreturn.add(element);
        }
      });
      print(toreturn);

      return toreturn;

    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aktif Hizmetler (Teklifler)'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WorkerActivity()),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Orders>>(
          future: _loadStoredValue2(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // or any loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data available');
            } else {
              List<Orders> actifSiparisList = snapshot.data!;
              return ListView.builder(
                itemCount: actifSiparisList.length,
                itemBuilder: (context, index) {
                  Orders orders = actifSiparisList[index];
                  return ActifSiparisItemView(order: orders);
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
  final Orders order;

  ActifSiparisItemView({required this.order});

  @override
  Widget build(BuildContext context) {
    //subtitle: Text('Order Date: ${order.baslangic_tarihi}'),
    return Card(
      elevation: 8.0, // Adds a shadow to the card
      color: Color(0xFF333333), // Card color
      child: Padding(
        padding: const EdgeInsets.all(9.0), // Aesthetic spacing
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use the minimum space necessary
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.browse_gallery_rounded, color: Colors.white,
              ), // Icon for the list tile
              title: Text(order.cu_name,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Telap Tarihi: ${order
                    .orderDate}\nİşlem Yapılması İstediği Tarih : ${order.baslangicTarihi}\nHizmet No: ${order.sdId}'
                    '\nTel No. : ${order.cu_tel}\n\nVerilen Teklif : ${order.te_fiyat}\nTeklif Durumu : ${_getOfferStatus(order.te_stat)}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              isThreeLine: true, // Allows for an additional line in the subtitle if needed
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // Remove default padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    // Rounded corners
                    side: BorderSide(
                      width: 2.0,
                      color: Color(0xFF333333), // Border color
                    ),
                  ),
                ),
                onPressed: () {
                  if (order.sViewMode == "M1") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          detailServicsM1(
                              actifSiparis: order)), // Pass the item data to the detail page if needed
                    );
                  } else if (order.sViewMode == "M2") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          detailServicsM2(
                              actifSiparis: order)), // Pass the item data to the detail page if needed
                    );
                  } else if (order.sViewMode == "M3") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          detailServicsM3(
                              actifSiparis: order)), // Pass the item data to the detail page if needed
                    );
                  } else if (order.sViewMode == "M4") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          detailServisM4(
                              actifSiparis: order)), // Pass the item data to the detail page if needed
                    );
                  } else if (order.sViewMode == "M5") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          detailServisM5(
                              actifSiparis: order)), // Pass the item data to the detail page if needed
                    );
                  }
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFFDF78),
                        Color(0xFFFF69B4)
                      ], // Gradient colors
                    ),
                    borderRadius: BorderRadius.circular(
                        20.0), // Match the shape of the button
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  // Padding within the button
                  child: Text('Detaylar', style: TextStyle(color: Colors.white,
                  ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _getOfferStatus(String status) {
    switch (status) {
      case "-1":
        return "Teklif Rededildi.";
      case "0":
        return "Yanıt Verilmedi.";
      case "1":
        return "Kabul Edildi.";
      default:
        return "Durum Bilinmiyor."; // Default or unknown status
    }
  }
}


