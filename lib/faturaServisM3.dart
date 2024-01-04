import 'package:flutter/material.dart';
import 'package:hopethelasone/WorkerActivity.dart';
import 'package:hopethelasone/CustomerGecmisSiparisler.dart';
import 'package:hopethelasone/WorkerGecmisSiparisler.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';


class faturaServicsM3 extends StatelessWidget {
  final GecmisSiparis actifSiparis;
  final int from;
  faturaServicsM3({required this.actifSiparis,required this.from});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: faturaServisM3Page(actifSiparis: actifSiparis,from: from,),
    );
  }
}

class faturaServisM3Page extends StatefulWidget {
  final GecmisSiparis actifSiparis;
  final int from;
  faturaServisM3Page({required this.actifSiparis,required this.from});
  @override
  _faturaServisM3PageState createState() => _faturaServisM3PageState(actifSiparis: actifSiparis,from: from);
}

class _faturaServisM3PageState extends State<faturaServisM3Page> {
  final int from;
  final GecmisSiparis actifSiparis;
  _faturaServisM3PageState({required this.actifSiparis,required this.from});


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
  String Date="", Time="", image="";

  TextEditingController bahceSayisi = TextEditingController();
  TextEditingController bahceMetresi = TextEditingController();
  TextEditingController agacSayisi = TextEditingController();
  TextEditingController not = TextEditingController();

  @override
  void initState() {
    super.initState();
    bahceSayisi.text = actifSiparis.bahceCount.toString();
    bahceMetresi.text = actifSiparis.bahcaMetresi.toString();
    agacSayisi.text = actifSiparis.agacCount.toString();
    not.text = actifSiparis.sdNot.toString();
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
        title: Text('Maragoz'),
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
            Expanded(child:ListView(
              children: <Widget>[

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          controller: bahceSayisi,
                          decoration: InputDecoration(
                            labelText: 'Bahçe Sayısı',
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
                            labelText: 'Bahçe Metresi',
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
                  controller: agacSayisi,
                  decoration: InputDecoration(labelText: 'Bahçedeki Toplam Agaç Sayısı',border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),

                SizedBox(height: 20),

                TextField(
                  controller: not,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: 20),
                  maxLines: 8,
                  minLines: 8,
                ),

                SizedBox(height: 20),


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
            ),),
          ],
        ),
      ),
    );
  }
}
