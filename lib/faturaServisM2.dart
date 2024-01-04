import 'package:flutter/material.dart';

import 'package:hopethelasone/CustomerGecmisSiparisler.dart';
import 'package:hopethelasone/WorkerGecmisSiparisler.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';


class faturaServicsM2 extends StatelessWidget {
  final GecmisSiparis actifSiparis;
  final int from;
  faturaServicsM2({required this.actifSiparis,required this.from});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: faturaServicsM2Page(actifSiparis: actifSiparis,from: from,),
    );
  }
}

class faturaServicsM2Page extends StatefulWidget {
  final GecmisSiparis actifSiparis;
  final int from;
  faturaServicsM2Page({required this.actifSiparis,required this.from});
  @override
  _faturaServicsM2PageState createState() => _faturaServicsM2PageState(actifSiparis: actifSiparis,from: from);
}

class _faturaServicsM2PageState extends State<faturaServicsM2Page> {
  final GecmisSiparis actifSiparis;
  final int from;
  _faturaServicsM2PageState({required this.actifSiparis,required this.from});


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
  late String tc ;
  String Date="", Time="", image = "";

  TextEditingController not = TextEditingController();

  @override
  void initState() {
    super.initState();
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
        title: Text('Tesisatcı'),
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
