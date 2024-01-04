import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hopethelasone/ServicesActivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hopethelasone/faturaServisM1.dart';
import 'package:hopethelasone/faturaServisM2.dart';
import 'package:hopethelasone/faturaServisM3.dart';
import 'package:hopethelasone/faturaServisM5.dart';
import 'package:hopethelasone/fatureServisM4.dart';


class CustomerOldSiparisler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OldSiparislerPage(),
      builder: (BuildContext context, Widget? child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}

class OldSiparislerPage extends StatefulWidget {
  @override
  _OldSiparislerPageState createState() => _OldSiparislerPageState();
}

class _OldSiparislerPageState extends State<OldSiparislerPage> {

  _OldSiparislerPageState() : tc = '';

  String? tc;

  @override
  void initState() {
    super.initState();
    getSharedPreferencesData();
  }

  Future<List<GecmisSiparis>> getSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedValue = prefs.getString('tcno');
    if (storedValue != null) {
      tc = storedValue;
    }
    return getActifSiparisler();
  }

  Future<List<GecmisSiparis>> getActifSiparisler() async {
    if (tc == null) {
      await getSharedPreferencesData();
      return getActifSiparisler();
    } else {
      final String apiUrl = 'https://romani-au.digital/APIs/BiServis/api/?get_old_talep';

      EasyLoading.show(status: 'Loading...');
      print(tc);


      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'cu_id': tc!,
          },
        );
        print(response.body);
        if (response.statusCode == 200) {
          List<Map<String, dynamic>> responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
          List<GecmisSiparis> actifSiparisList = responseData.map((item) {
            return GecmisSiparis.fromJson(item);
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
        title: Text('Geçmiş Telapler'),
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
        child: FutureBuilder<List<GecmisSiparis>>(
          future: getSharedPreferencesData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitFadingCube(
                  color: Colors.blue,
                  size: 40.0,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data available');
            } else {
              List<GecmisSiparis> actifSiparisList = snapshot.data!;
              return ListView.builder(
                itemCount: actifSiparisList.length,
                itemBuilder: (context, index) {
                  GecmisSiparis actifSiparis = actifSiparisList[index];
                  return ActifSiparisItemView(actifSiparis: actifSiparis);
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
  final GecmisSiparis actifSiparis;

  ActifSiparisItemView({required this.actifSiparis});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0, // Adds a shadow to the card
      color: Color(0xFF333333), // Card color
      child: Padding(
        padding: const EdgeInsets.all(9.0), // Aesthetic spacing
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use the minimum space necessary
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add_task_rounded, color: Colors.white,
              ), // Icon for the list tile
              title: Text(
                actifSiparis.sName,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Hizmet Tarihi: ${actifSiparis.baslangicTarihi.split("T")[0]}\nHizmet No: ${actifSiparis.sdId}\nFiyat : ${actifSiparis.te_fiyat}'
                    '\n\nÇalışanın Adı: ${actifSiparis.wo_name}\nÇalışan No. : ${actifSiparis.wo_id}\nTel No. : ${actifSiparis.wo_tel}',
                style: TextStyle(color: Colors.white.withOpacity(0.7),
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
                    borderRadius: BorderRadius.circular(20.0), // Rounded corners
                    side: BorderSide(
                      width: 2.0,
                      color: Color(0xFF333333), // Border color
                    ),
                  ),
                ),
                onPressed: () {
                  if(actifSiparis.sViewMode=="M1") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          fatureServicsM1(actifSiparis: actifSiparis,from: 1,)),
                    );
                  }else if(actifSiparis.sViewMode=="M2") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          faturaServicsM2(actifSiparis: actifSiparis,from: 1,)),
                    );
                  }else if(actifSiparis.sViewMode=="M3") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          faturaServicsM3(actifSiparis: actifSiparis,from: 1,)),
                    );
                  }else if(actifSiparis.sViewMode=="M4") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          faturaServisM4(actifSiparis: actifSiparis,from: 1,)),
                    );
                  }else if(actifSiparis.sViewMode=="M5") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          faturaServisM5(actifSiparis: actifSiparis,from: 1,)),
                    );
                  }
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFFFDF78), Color(0xFFFF69B4)], // Gradient colors
                    ),
                    borderRadius: BorderRadius.circular(20.0), // Match the shape of the button
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Padding within the button
                  child: Text('Fatura\'yı Gör', style: TextStyle(color: Colors.white, // Text color
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
}



class GecmisSiparis {
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
  final String address;
  final String cu_name;
  final String customer_id;
  final String cu_addres;
  final String wo_name;
  final String wo_id;
  final String wo_tel;
  final String te_date;
  final String te_fiyat;
  final List<ChildrenListt> children;

  GecmisSiparis({
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
    required this.address,
    required this.cu_name,
    required this.customer_id,
    required this.cu_addres,
    required this.wo_name,
    required this.wo_id,
    required this.wo_tel,
    required this.te_date,
    required this.te_fiyat,
    required this.children,

  });

  factory GecmisSiparis.fromJson(Map<String, dynamic> json) {
    return GecmisSiparis(
      sdId: json['sd_id'] ?? '',
      salonCount: json['salon_count'] ?? '',
      salonMetresi: json['salon_metresi'] ?? '',
      mutfakCount: json['mutfak_count'] ?? '',
      mutfakMetresi: json['mutfak_metresi'] ?? '',
      buroCount: json['buro_count'] ?? '',
      buroMetresi: json['buro_metresi'] ?? '',
      depoCount: json['depo_count'] ?? '',
      depoMetresi: json['depo_metresi'] ?? '',
      banyoCount: json['banyo_count'] ?? '',
      banyoMetresi: json['banyo_metresi'] ?? '',
      tuvaletCount: json['tuvalet_count'] ?? '',
      tuvaletMetresi: json['tuvalet_metresi'] ?? '',
      odaCount: json['oda_count'] ?? '',
      odaMetresi: json['oda_metresi'] ?? '',
      bahceCount: json['bahce_count'] ?? '',
      bahcaMetresi: json['bahca_metresi'] ?? '',
      balkonCount: json['balkon_count'] ?? '',
      balkonMetresi: json['balkon_metresi'] ?? '',
      agacCount: json['agac_count'] ?? '',
      sdNot: json['sd_not'] ?? '',
      saatSayisi: json['saat_sayisi'] ?? '',
      gunSayisi: json['gun_sayisi'] ?? '',
      orderDate: json['order_date'] ?? '',
      baslangicTarihi: json['baslangic_tarihi'] ?? '',
      cuId: json['cu_id'] ?? '',
      image: json['image'] ?? '',
      sId: json['s_id'] ?? '',
      sdStat: json['sd_stat'] ?? '',
      sName: json['s_name'] ?? '',
      sLogo: json['s_logo'] ?? '',
      sViewMode: json['s_view_mode'] ?? '',
      address: json['address'] ?? '',
      cu_name: json['cu_name'] ?? '',
      customer_id: json['customer_id'] ?? '',
      cu_addres: json['cu_addres'] ?? '',
      wo_name: json['wo_name'] ?? '',
      wo_id: json['wo_id'] ?? '',
      wo_tel: json['wo_tel'] ?? '',
      te_date: json['te_date'] ?? '',
      te_fiyat: json['te_fiyat'] ?? '',
      children: (json['children'] as List<dynamic>?)
          ?.map<ChildrenListt>((dynamic child) {
        if (child is Map<String, dynamic>) {
          return ChildrenListt.fromJson(child);
        } else {
          // Handle other cases or return a default value as needed
          return ChildrenListt(Age: '', Sex: '');
        }
      })
          .toList() ?? [],
    );
  }
}


class ChildrenListt {
  final String Age;
  final String Sex;

  ChildrenListt({
    required this.Age,
    required this.Sex,
  });

  factory ChildrenListt.fromJson(Map<String, dynamic> json) {
    return ChildrenListt(
      Age: json['cy_yas'] ?? '',
      Sex: json['cy_sex'] ?? '',
    );
  }
}