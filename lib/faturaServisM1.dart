import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import the Cupertino package for iOS-style pickers
import 'package:hopethelasone/CustomerGecmisSiparisler.dart';
import 'package:hopethelasone/WorkerGecmisSiparisler.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';


class fatureServicsM1 extends StatelessWidget {
  final GecmisSiparis actifSiparis;
  final int from;

  fatureServicsM1({required this.actifSiparis, required this.from});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: fatureServicsM1Page(actifSiparis: actifSiparis, from: from,),
    );
  }
}

class fatureServicsM1Page extends StatefulWidget {
  final GecmisSiparis actifSiparis;
  final int from;

  fatureServicsM1Page({required this.actifSiparis, required this.from});
  @override
  _fatureServicsM1PageState createState() => _fatureServicsM1PageState(actifSiparis: actifSiparis, from: from);
}

class _fatureServicsM1PageState extends State<fatureServicsM1Page> {
  final GecmisSiparis actifSiparis;
  final int from;

  _fatureServicsM1PageState({required this.actifSiparis, required this.from}) ;



  // The function to generate and save PDF
  Future<void> generateAndSavePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text('Bill Details'), // Replace with your dynamic data
        ),
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/bill.pdf');
      await file.writeAsBytes(await pdf.save());
      print('PDF Saved: ${file.path}');
      // Optionally open the file or share it here
    } catch (e) {
      print("Error: $e");
    }
  }



  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String Date="", Time="", image = "";

  TextEditingController salonSayisi = TextEditingController();
  TextEditingController salonMetresi = TextEditingController();
  TextEditingController mutfakSayisi = TextEditingController();
  TextEditingController mutfakMetresi = TextEditingController();
  TextEditingController buroSayisi = TextEditingController();
  TextEditingController buroMetresi = TextEditingController();
  TextEditingController depoSayisi = TextEditingController();
  TextEditingController depoMetresi = TextEditingController();
  TextEditingController banyoSayisi = TextEditingController();
  TextEditingController banyoMetresi = TextEditingController();
  TextEditingController tuvaletSayisi = TextEditingController();
  TextEditingController tuvaletMetresi = TextEditingController();
  TextEditingController odaSayisi = TextEditingController();
  TextEditingController odaMetresi = TextEditingController();
  TextEditingController bahceSayisi = TextEditingController();
  TextEditingController bahceMetresi = TextEditingController();
  TextEditingController balkonSayisi = TextEditingController();
  TextEditingController balkonMetresi = TextEditingController();
  TextEditingController not = TextEditingController();

  @override
  void initState() {
    super.initState();
    salonSayisi.text = actifSiparis.salonCount.toString();
    salonMetresi.text = actifSiparis.salonMetresi.toString();
    mutfakSayisi.text = actifSiparis.mutfakCount.toString();
    mutfakMetresi.text = actifSiparis.mutfakMetresi.toString();
    buroSayisi.text = actifSiparis.buroCount.toString();
    buroMetresi.text = actifSiparis.buroMetresi.toString();
    depoSayisi.text = actifSiparis.depoCount.toString();
    depoMetresi.text = actifSiparis.depoMetresi.toString();
    banyoSayisi.text = actifSiparis.banyoCount.toString();
    banyoMetresi.text = actifSiparis.banyoMetresi.toString();
    tuvaletSayisi.text = actifSiparis.tuvaletCount.toString();
    tuvaletMetresi.text = actifSiparis.tuvaletMetresi.toString();
    odaSayisi.text = actifSiparis.odaCount.toString();
    odaMetresi.text = actifSiparis.odaMetresi.toString();
    bahceSayisi.text = actifSiparis.bahceCount.toString();
    bahceMetresi.text = actifSiparis.bahcaMetresi.toString();
    balkonSayisi.text = actifSiparis.balkonCount.toString();
    balkonMetresi.text = actifSiparis.balkonMetresi.toString();
    not.text = actifSiparis.children.toString();
    List<String> dates = actifSiparis.baslangicTarihi.split('T');
    Date = dates[0];
    Time = dates[1];
    if(actifSiparis.image.toString()!=""){
      image = 'https://romani-au.digital/APIs/BiServis/uploads/'+actifSiparis.image.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temizleyici'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if(from==1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerOldSiparisler()),
              );
            }else{
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WorkerGecmisSiparisler()),
              );
            }
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            controller: salonSayisi,
                            decoration: InputDecoration(
                              labelText: 'Salon Sayisi',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            controller: salonMetresi,
                            decoration: InputDecoration(
                              labelText: 'Salon Metresi',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            controller: mutfakSayisi,
                            decoration: InputDecoration(
                              labelText: 'Mutfak Sayisi',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            controller: mutfakMetresi,
                            decoration: InputDecoration(
                              labelText: 'Mutfak Metresi',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: buroSayisi,
                          decoration: InputDecoration(
                            labelText: 'Buro Sayisi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: buroMetresi,
                          decoration: InputDecoration(
                            labelText: 'Buro Metresi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: depoSayisi,
                          decoration: InputDecoration(
                            labelText: 'Depo Sayisi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: depoMetresi,
                          decoration: InputDecoration(
                            labelText: 'Depo Metresi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: banyoSayisi,
                          decoration: InputDecoration(
                            labelText: 'Banyo Sayisi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: banyoMetresi,
                          decoration: InputDecoration(
                            labelText: 'Banyo Metresi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: tuvaletSayisi,
                          decoration: InputDecoration(
                            labelText: 'Tuvalet Sayisi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: tuvaletMetresi,
                          decoration: InputDecoration(
                            labelText: 'Tuvalet Metresi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: odaSayisi,
                          decoration: InputDecoration(
                            labelText: 'Oda Sayisi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: odaMetresi,
                          decoration: InputDecoration(
                            labelText: 'Oda Metresi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: bahceSayisi,
                          decoration: InputDecoration(
                            labelText: 'Bahce Sayisi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: bahceMetresi,
                          decoration: InputDecoration(
                            labelText: 'Bahce Metresi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: balkonSayisi,
                          decoration: InputDecoration(
                            labelText: 'Balkon Sayisi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: balkonMetresi,
                          decoration: InputDecoration(
                            labelText: 'Balkon Metresi',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),

                  SizedBox(height: 20),

                  TextField(
                    controller: not,
                    decoration: InputDecoration(
                      labelText: 'Not',
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 20),
                    maxLines: 8,
                    minLines: 8,
                  ),

                  SizedBox(height: 20),

                  // Display the selected date and time

                  Text(
                    'Fatura Tarihi: ${Date}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fatura Saatı: ${Time}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Divider(), // A thin line between text sections
                  Text(
                    'Sipariş Tarihi: ${actifSiparis.orderDate}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Müşteri Adı: ${actifSiparis.cu_name}',
                    style: TextStyle(fontSize: 16),
                  ),
                  // ... continue listing other details
                  Text(
                    'Müşteri No: ${actifSiparis.cuId}\n',
                    style: TextStyle(fontSize: 16),
                  ),

                  Text(
                    'Çalışan Adı: ${actifSiparis.wo_name}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Çalışan No.: ${actifSiparis.wo_id}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Çalışan Tel.: ${actifSiparis.wo_tel}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '\nTelap No.: ${actifSiparis.sdId}',
                    style: TextStyle(fontSize: 16),
                  ),
                  // ... continue listing other details
                  Text(
                    'Adres: ${actifSiparis.cu_addres}',
                    style: TextStyle(fontSize: 16),
                  ),
                  // ... continue listing other details
                  Text(
                    'Toplam Fiyat: ${actifSiparis.te_fiyat} ₺',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  // ... continue listing other details
                  Divider(), // Another divider before the download button
                  Divider(),

                  ElevatedButton(
                    onPressed: () {
                      generateAndSavePdf(); // Calling the function when the button is pressed
                    },
                    child: Text('Fatura\'yı PDF Olarak İndir'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


