import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:hopethelasone/CustomerAktifSiparisler.dart';
import 'package:hopethelasone/GizlilikPolitikasi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:hopethelasone/NotificationWorker.dart';
import 'package:hopethelasone/WorkerAktifSiparisler.dart';
import 'package:hopethelasone/WorkerGecmisSiparisler.dart';
import 'package:hopethelasone/detailServisM1.dart';
import 'package:hopethelasone/detailServisM2.dart';
import 'package:hopethelasone/detailServisM3.dart';
import 'package:hopethelasone/detailServisM4.dart';
import 'package:hopethelasone/detailServisM5.dart';
import 'package:hopethelasone/editWorkerProfil.dart';
import 'package:hopethelasone/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class WorkerActivity extends StatefulWidget {
  @override
  _MyWorkerPageState createState() => _MyWorkerPageState();
}

class _MyWorkerPageState extends State<WorkerActivity> {

  @override
  void initState() {
    super.initState();
    _loadStoredValue();
  }

  String eposta = '', userName = '', tc = '', bolum = '';
  bool _dataLoaded = false;


  _loadStoredValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    eposta = prefs.getString('eposta') ?? '';
    userName = prefs.getString('userName') ?? '';
    tc = prefs.getString('tcno') ?? '';
    bolum = prefs.getString('bolum') ?? '';
    _dataLoaded = true;
  }

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

          return data;

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      WorkerNotification()), // Pass the item data to the detail page if needed
                );
              // Handle notifications button press
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
              ); // Or  // Or any loading indicator
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
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage('https://romani-au.digital/APIs/BiServis/uploads/'+tc+'.jpg'),
                      ),
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
                              editWorkerPage()), // Pass the item data to the detail page if needed
                          );
                        },
                    ),

                    Divider(),
                    ListTile(
                      leading: Icon(Icons.schedule_send),
                      title: Text('Aktif Hizmetler (Teklifler)'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              WorkerAktifSiparisler()), // Pass the item data to the detail page if needed
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.receipt_long),
                      title: Text('Geçmiş Hizmetler'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              WorkerGecmisSiparisler()), // Pass the item data to the detail page if needed
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications_none),
                      title: Text('Bildirimler'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              WorkerNotification()), // Pass the item data to the detail page if needed
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                            GizlilikPolitikasi()), // Pass the item data to the detail page if needed
                        );
                        // Handle logout logic
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
                  'Telapler',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Şehirinizde İstenen Hizmetler',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Expanded( // Wrap the GridView.builder with Expanded
            child: FutureBuilder<List<Orders>>(
              future: _loadStoredValue2(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitThreeBounce(
                    color: Colors.blue,
                    size: 30.0,
                  ); // or any loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No data available');
                } else {
                  List<Orders> ordersList = snapshot.data!;
                  return ListView.builder(
                    itemCount: ordersList.length,
                    itemBuilder: (context, index) {
                      Orders order = ordersList[index];
                      return GridItem(order,tc,bolum);
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
  Orders order;
  String tc;
  String bolum;

  GridItem(this.order,this.tc,this.bolum);

  final TextEditingController fiyatController = TextEditingController();




  @override
  Widget build(BuildContext context) {


    Widget? myPaddingWidgets;

    if(order.te_fiyat=="") {
      myPaddingWidgets = Card(
        elevation: 8.0, // Adds a shadow to the card
        color: Color(0xFF333333), // Card color
        child: Padding(
          padding: const EdgeInsets.all(9.0), // Aesthetic spacing
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use the minimum space necessary
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.article_rounded,
                  color: Colors.white,
                ), // Icon for the list tile
                title: Text(
                  order.cu_name,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Talep Tarihi: ${order.orderDate}\nMüşteri Konumu: ${order
                      .cu_addres}\n\n'
                      'İstenen Tarih: ${order.baslangicTarihi.replaceAll(
                      "T", " ")}\nMüşteri Tel No. : ${order.cu_tel}\n',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                isThreeLine: true, // Allows for an additional line in the subtitle if needed
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Adjust space between elements
                children: [
                  // Smaller 'Detaylar' button with gradient
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      // Make the button transparent
                      onPrimary: Colors.white,
                      // Text color
                      shadowColor: Colors.transparent,
                      // No shadow
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
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
                          colors: [
                            Color(0xFFFFDF78), // Start color of the gradient
                            Color(0xFFFF69B4), // End color of the gradient
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        // Set minimum width and height
                        child: Text('Detaylar', textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                  // 'TextField' for price input and 'Gönder' button with gradient
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: fiyatController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Fiyat Giriniz',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xFF333333),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              // Make the button transparent
                              onPrimary: Colors.white,
                              // Text color
                              shadowColor: Colors.transparent,
                              // No shadow
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 16.0),
                            ),
                            onPressed: () {
                              teklifVer(
                                  order.sdId, tc, fiyatController.text, bolum,
                                  context);
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFFDF78),
                                    // Start color of the gradient
                                    Color(0xFFFF69B4),
                                    // End color of the gradient
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minWidth: 88.0, minHeight: 36.0),
                                // Set minimum width and height
                                child: Text(
                                    'Gönder', textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }else{
      String teklifdurumu = "";
      if(order.te_stat=="-1"){
        teklifdurumu = "Red edildi";
      }else if(order.te_stat=="0"){
        teklifdurumu = "Yanit Verilmedi";
      }else if(order.te_stat=="1"){
        teklifdurumu = "Kabul Edildi";
      }
      myPaddingWidgets = Card(
        elevation: 8.0, // Adds a shadow to the card
        color: Color(0xFF333333), // Card color
        child: Padding(
          padding: const EdgeInsets.all(9.0), // Aesthetic spacing
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use the minimum space necessary
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.article_rounded,
                  color: Colors.white,
                ), // Icon for the list tile
                title: Text(
                  order.cu_name,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Talep Tarihi: ${order.orderDate}\nMüşteri Konumu: ${order
                      .cu_addres}\n\n'
                      'İstenen Tarih: ${order.baslangicTarihi.replaceAll(
                      "T", " ")}\nMüşteri Tel No. : ${order.cu_tel}\nVerdiginiz Teklif: ${
                      order.te_fiyat}\nTeklif Zamani: ${order.te_date}\nTeklif Durumu: ${teklifdurumu}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                isThreeLine: true, // Allows for an additional line in the subtitle if needed
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Adjust space between elements
                children: [
                  // Smaller 'Detaylar' button with gradient
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      // Make the button transparent
                      onPrimary: Colors.white,
                      // Text color
                      shadowColor: Colors.transparent,
                      // No shadow
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
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
                          colors: [
                            Color(0xFFFFDF78), // Start color of the gradient
                            Color(0xFFFF69B4), // End color of the gradient
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        // Set minimum width and height
                        child: Text('Detaylar', textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return myPaddingWidgets ?? Container();

  }
}

void teklifVer(String order_id, String tc, String teklif, String bolum, BuildContext context) async {

  EasyLoading.show();
  final String apiUrl = 'https://romani-au.digital/APIs/BiServis/api/?teklif_ver';

  print(tc);

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'cu_id': tc!,
        'order_id': order_id,
        'teklif': teklif,
        'order_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'bolum': bolum,
      },
    );

    if (response.statusCode == 200) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkerActivity()),
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

class Orders {
  final String sdId;
  final String salonCount;
  final String salonMetresi;
  final String mutfakCount;
  final String mutfakMetresi;
  final String buroCount;
  final String buroMetresi;
  final String depoCount;
  final String depoMetresi;
  final String banyoCount;
  final String banyoMetresi;
  final String tuvaletCount;
  final String tuvaletMetresi;
  final String odaCount;
  final String odaMetresi;
  final String bahceCount;
  final String bahcaMetresi;
  final String balkonCount;
  final String balkonMetresi;
  final String agacCount;
  final String sdNot;
  final String saatSayisi;
  final String gunSayisi;
  final String orderDate;
  final String baslangicTarihi;
  final String cuId;
  final String image;
  final String sId;
  final String sdStat;
  final String sName;
  final String sLogo;
  final String sViewMode;
  final String cu_name;
  final String cu_city;
  final String cu_addres;
  final String cu_tel;
  final String te_fiyat;
  final String te_date;
  final String te_stat;
  final String wo_name;
  final String wo_id;
  final String wo_tel;
  final List<ChildrenList> children;

  Orders({
    required this.sdId,
    required this.salonCount,
    required this.salonMetresi,
    required this.mutfakCount,
    required this.mutfakMetresi,
    required this.buroCount,
    required this.buroMetresi,
    required this.depoCount,
    required this.depoMetresi,
    required this.banyoCount,
    required this.banyoMetresi,
    required this.tuvaletCount,
    required this.tuvaletMetresi,
    required this.odaCount,
    required this.odaMetresi,
    required this.bahceCount,
    required this.bahcaMetresi,
    required this.balkonCount,
    required this.balkonMetresi,
    required this.agacCount,
    required this.sdNot,
    required this.saatSayisi,
    required this.gunSayisi,
    required this.orderDate,
    required this.baslangicTarihi,
    required this.cuId,
    required this.image,
    required this.sId,
    required this.sdStat,
    required this.sName,
    required this.sLogo,
    required this.sViewMode,
    required this.cu_name,
    required this.cu_city,
    required this.cu_addres,
    required this.cu_tel,
    required this.te_fiyat,
    required this.te_date,
    required this.te_stat,
    required this.wo_name,
    required this.wo_id,
    required this.wo_tel,
    required this.children,
  });
}



