import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hopethelasone/MusteriTeklifleri.dart';
import 'package:hopethelasone/ServicesActivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hopethelasone/editServisM1.dart';
import 'package:hopethelasone/editServisM2.dart';
import 'package:hopethelasone/editServisM3.dart';
import 'package:hopethelasone/editServisM4.dart';
import 'package:hopethelasone/editServisM5.dart';


class CustomerAktifSiparisler extends StatelessWidget {
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

  _AktifSiparislerPageState() : tc = '';

  String? tc;

  @override
  void initState() {
    super.initState();
    getSharedPreferencesData();
  }

  Future<List<ActifSiparis>> getSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedValue = prefs.getString('tcno');
    if (storedValue != null) {
      tc = storedValue;
    }
    return getActifSiparisler();
  }

  Future<List<ActifSiparis>> getActifSiparisler() async {
    if (tc == null) {
      await getSharedPreferencesData();
      return getActifSiparisler();
    } else {
      final String apiUrl = 'https://romani-au.digital/APIs/BiServis/api/?get_actif_talep';

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
          List<ActifSiparis> actifSiparisList = responseData.map((item) {
            return ActifSiparis.fromJson(item);
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
        title: Text('Aktif Telapler (Teklifler)'),
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
        child: FutureBuilder<List<ActifSiparis>>(
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
              List<ActifSiparis> actifSiparisList = snapshot.data!;
              return ListView.builder(
                itemCount: actifSiparisList.length,
                itemBuilder: (context, index) {
                  ActifSiparis actifSiparis = actifSiparisList[index];
                  return ActifSiparisItemView(actifSiparis: actifSiparis, tc: tc!,);
                },
              );
            }
          },
        ),
      ),
    );
  }

}



void deletSiparis(String order_id, String tc, BuildContext context) async {

  EasyLoading.show();
  final String apiUrl = 'https://romani-au.digital/APIs/BiServis/api/?delet_order';

  print(tc);

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'cu_id': tc!,
        'order_id': order_id,
      },
    );

    if (response.statusCode == 200) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerAktifSiparisler()),
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

void changeOrderStat(String order_id, String tc, BuildContext context, String stat) async {

  EasyLoading.show();
  final String apiUrl = 'https://romani-au.digital/APIs/BiServis/api/?ChangeOrderStat';

  print(tc);

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'cu_id': tc!,
        'order_id': order_id,
        'stat': stat,
      },
    );

    if (response.statusCode == 200) {

      print(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerAktifSiparisler()),
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

class ActifSiparisItemView extends StatelessWidget {
  final ActifSiparis actifSiparis;
  final String tc;

  ActifSiparisItemView({required this.actifSiparis, required this.tc});

  @override
  Widget build(BuildContext context) {

    Widget? myPaddingWidgets;

    if(actifSiparis.sdStat=="1"){

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
                  actifSiparis.sName,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Telap Tarihi: ${actifSiparis.orderDate}\nTelap No: ${actifSiparis.sdId}',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MusteriTeklifleri(sd_id: actifSiparis.sdId)),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFFDF78), // Start color
                                Color(0xFFFF69B4), // End color
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                                20.0), // Match the shape of the button
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0,
                              horizontal: 16.0), // Padding within the button
                          child: Text(
                            'Teklifleri Gör '+'('+actifSiparis.teklifCount.toString()+')',
                            style: TextStyle(
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 18000), // Animation duration
                      curve: Curves.bounceIn, // Animation curve
                      transform: Matrix4.identity(),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent, // Transparent background color
                          primary: Colors.white, // Text color
                          padding: EdgeInsets.zero, // Remove default padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Optional: Add rounded corners
                            side: BorderSide(
                              width: 2.0,
                              color: Color(0xFF333333), // Optional: Add a border
                            ),
                          ),
                        ),
                        onPressed: () {
                          deletSiparis(actifSiparis.sdId,tc,context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFFDF78), // Start color
                                Color(0xFFFF69B4), // End color
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.0), // Match the shape of the button
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Padding within the button
                          child: Text(
                            'Sil',
                            style: TextStyle(
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200), // Animation duration
                      curve: Curves.easeInOut, // Animation curve
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent, // Transparent background color
                          primary: Colors.white, // Text color
                          padding: EdgeInsets.zero, // Remove default padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Optional: Add rounded corners
                            side: BorderSide(
                              width: 2.0,
                              color: Color(0xFF333333), // Optional: Add a border
                            ),
                          ),
                        ),
                        onPressed: () {
                          changeOrderStat(actifSiparis.sdId, tc, context, "0");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFFDF78), // Start color
                                Color(0xFFFF69B4), // End color
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.0), // Match the shape of the button
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Padding within the button
                          child: Text(
                            'İptal Et',
                            style: TextStyle(
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200), // Animation duration
                      curve: Curves.easeInOut, // Animation curve
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent, // Transparent background color
                          primary: Colors.white, // Text color
                          padding: EdgeInsets.zero, // Remove default padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Optional: Add rounded corners
                            side: BorderSide(
                              width: 2.0,
                              color: Color(0xFF333333), // Optional: Add a border
                            ),
                          ),
                        ),
                        onPressed: () {
                          if(actifSiparis.sViewMode=="M1"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  editServicsM1(actifSiparis: actifSiparis)), // Pass the item data to the detail page if needed
                            );
                          }else if(actifSiparis.sViewMode=="M2"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  editServicsM2(actifSiparis: actifSiparis)), // Pass the item data to the detail page if needed
                            );
                          }else if(actifSiparis.sViewMode=="M3"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  editServicsM3(actifSiparis: actifSiparis)), // Pass the item data to the detail page if needed
                            );
                          }
                          else if(actifSiparis.sViewMode=="M4"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  editServisM4(actifSiparis: actifSiparis)), // Pass the item data to the detail page if needed
                            );
                          }
                          else if(actifSiparis.sViewMode=="M5"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  editServisM5(actifSiparis: actifSiparis)), // Pass the item data to the detail page if needed
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFFDF78), // Start color
                                Color(0xFFFF69B4), // End color
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.0), // Match the shape of the button
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Padding within the button
                          child: Text(
                            'Güncelle',
                            style: TextStyle(
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200), // Animation duration
                      curve: Curves.easeInOut, // Animation curve
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent, // Transparent background color
                          primary: Colors.white, // Text color
                          padding: EdgeInsets.zero, // Remove default padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Optional: Add rounded corners
                            side: BorderSide(
                              width: 2.0,
                              color: Color(0xFF333333), // Optional: Add a border
                            ),
                          ),
                        ),
                        onPressed: () {
                          changeOrderStat(actifSiparis.sdId, tc, context, "2");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFFDF78), // Start color
                                Color(0xFFFF69B4), // End color
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.0), // Match the shape of the button
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Padding within the button
                          child: Text(
                            'Bitti',
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
                title: Text(
                  actifSiparis.sName,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Telap Tarihi: ${actifSiparis.orderDate}\nTelap No: ${actifSiparis.sdId}',
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
                      duration: Duration(milliseconds: 18000), // Animation duration
                      curve: Curves.bounceIn, // Animation curve
                      transform: Matrix4.identity(),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent, // Transparent background color
                          primary: Colors.white, // Text color
                          padding: EdgeInsets.zero, // Remove default padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Optional: Add rounded corners
                            side: BorderSide(
                              width: 2.0,
                              color: Color(0xFF333333), // Optional: Add a border
                            ),
                          ),
                        ),
                        onPressed: () {
                          deletSiparis(actifSiparis.sdId,tc,context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFFDF78), // Start color
                                Color(0xFFFF69B4), // End color
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.0), // Match the shape of the button
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Padding within the button
                          child: Text(
                            'Sil',
                            style: TextStyle(
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200), // Animation duration
                      curve: Curves.easeInOut, // Animation curve
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent, // Transparent background color
                          primary: Colors.white, // Text color
                          padding: EdgeInsets.zero, // Remove default padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Optional: Add rounded corners
                            side: BorderSide(
                              width: 2.0,
                              color: Color(0xFF333333), // Optional: Add a border
                            ),
                          ),
                        ),
                        onPressed: () {
                          changeOrderStat(actifSiparis.sdId, tc, context, "1");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFFDF78), // Start color
                                Color(0xFFFF69B4), // End color
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.0), // Match the shape of the button
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Padding within the button
                          child: Text(
                            'Aktif Et',
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




class ActifSiparis {
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
  final String teklifCount;
  final List<ChildrenList> children;

  ActifSiparis({
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
    required this.teklifCount,
    required this.children,
  });

  factory ActifSiparis.fromJson(Map<String, dynamic> json) {
    return ActifSiparis(
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
      teklifCount: json['teklif_count'] ?? '',
      children: (json['children'] as List<dynamic>?)
          ?.map<ChildrenList>((dynamic child) {
        if (child is Map<String, dynamic>) {
          return ChildrenList.fromJson(child);
        } else {
          // Handle other cases or return a default value as needed
          return ChildrenList(Age: '', Sex: '');
        }
      })
          .toList() ?? [],
    );
  }
}


class ChildrenList {
  final String Age;
  final String Sex;

  ChildrenList({
    required this.Age,
    required this.Sex,
  });

  factory ChildrenList.fromJson(Map<String, dynamic> json) {
    return ChildrenList(
        Age: json['cy_yas'] ?? '',
        Sex: json['cy_sex'] ?? '',
    );
    }
}