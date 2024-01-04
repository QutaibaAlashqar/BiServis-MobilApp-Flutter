import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hopethelasone/CustomerAktifSiparisler.dart';
import 'package:hopethelasone/CustomerGecmisSiparisler.dart';
import 'package:hopethelasone/WorkerActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hopethelasone/faturaServisM1.dart';
import 'package:hopethelasone/faturaServisM2.dart';
import 'package:hopethelasone/faturaServisM3.dart';
import 'package:hopethelasone/faturaServisM5.dart';
import 'package:hopethelasone/fatureServisM4.dart';



class WorkerGecmisSiparisler extends StatelessWidget {
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
  List<GecmisSiparis> Faturaicin = [];


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

    final response = await http.get(Uri.parse('https://romani-au.digital/APIs/BiServis/api/?get_old_worker_services&worker_id='+tc+'&bolum='+bolum));
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

      List<GecmisSiparis> toreturn=[];
      data.forEach((element) {
        List<ChildrenListt> childrennn = [];
        element.children.forEach((element) {
          ChildrenListt childrenListt = ChildrenListt(Age: element.Age, Sex: element.Sex);
          childrennn.add(childrenListt);
        });
        GecmisSiparis actifSiparis = GecmisSiparis(
            sdId: element.sdId,
            salonCount: element.salonCount,
            salonMetresi: element.salonMetresi,
            mutfakCount: element.mutfakCount,
            mutfakMetresi: element.mutfakMetresi,
            buroCount: element.buroCount,
            buroMetresi: element.buroMetresi,
            depoCount: element.depoCount,
            depoMetresi: element.depoMetresi,
            banyoCount: element.banyoCount,
            banyoMetresi: element.banyoMetresi,
            tuvaletCount: element.tuvaletCount,
            tuvaletMetresi: element.tuvaletMetresi,
            odaCount: element.odaCount,
            odaMetresi: element.odaMetresi,
            bahceCount: element.bahceCount,
            bahcaMetresi: element.bahcaMetresi,
            balkonCount: element.balkonCount,
            balkonMetresi: element.balkonMetresi,
            agacCount: element.agacCount,
            sdNot: element.sdNot,
            saatSayisi: element.saatSayisi,
            gunSayisi: element.gunSayisi,
            orderDate: element.orderDate,
            baslangicTarihi: element.baslangicTarihi,
            cuId: element.cuId,
            image: element.image,
            sId: element.sId,
            sdStat: element.sdStat,
            sName: element.sName,
            sLogo: element.sLogo,
            sViewMode: element.sViewMode,
            address: "element.address",
            cu_name: element.cu_name,
            customer_id: element.cuId,
            cu_addres: element.cu_addres,
            wo_name: element.wo_name,
            wo_id: element.wo_id,
            wo_tel: element.wo_tel,
            te_date: element.te_date,
            te_fiyat: element.te_fiyat,
            children: childrennn);
        toreturn.add(actifSiparis);

      });
      Faturaicin = toreturn;

      return data;

    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geçmiş Hizmetler'),
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
                  GecmisSiparis actifSiparis = Faturaicin[index];
                  return ActifSiparisItemView(order: orders,actifSiparis: actifSiparis,);
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
  final GecmisSiparis actifSiparis;

  ActifSiparisItemView({required this.order, required this.actifSiparis});

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
              title: Text(order.cu_name,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Telap Tarihi: ${order.orderDate}\nHizmet No.: ${order.sdId}'
                  '\nVerilen Teklif: ${order.te_fiyat}',
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
                  if(actifSiparis.sViewMode=="M1") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          fatureServicsM1(actifSiparis: actifSiparis,from: 2,)),
                    );
                  }else if(actifSiparis.sViewMode=="M2") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          faturaServicsM2(actifSiparis: actifSiparis,from: 2,)),
                    );
                  }else if(actifSiparis.sViewMode=="M3") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          faturaServicsM3(actifSiparis: actifSiparis,from: 2,)),
                    );
                  }else if(actifSiparis.sViewMode=="M4") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          faturaServisM4(actifSiparis: actifSiparis,from: 2,)),
                    );
                  }else if(actifSiparis.sViewMode=="M5") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          faturaServisM5(actifSiparis: actifSiparis,from: 2,)),
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
                  child: Text('Fatura\'yı Gör', style: TextStyle(color: Colors.white,
                  ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}