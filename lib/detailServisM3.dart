import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:hopethelasone/ServicesActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;
import 'package:hopethelasone/WorkerActivity.dart';

import 'CustomerAktifSiparisler.dart';

class detailServicsM3 extends StatelessWidget {
  final Orders actifSiparis;
  detailServicsM3({required this.actifSiparis});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: detailServisM3Page(actifSiparis: actifSiparis,),
    );
  }
}

class detailServisM3Page extends StatefulWidget {
  final Orders actifSiparis;
  detailServisM3Page({required this.actifSiparis});
  @override
  _detailServisM3PageState createState() => _detailServisM3PageState(actifSiparis: actifSiparis);
}

class _detailServisM3PageState extends State<detailServisM3Page> {

  final Orders actifSiparis;
  _detailServisM3PageState({required this.actifSiparis}) ;


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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomerAktifSiparisler()),
            );
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
                    labelText: 'Yapmak İstediğiniz İşlemler\nDetaylı Bir Şekilde Açıklayınız\nLütfen.',
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: 20),
                  maxLines: 8,
                  minLines: 8,
                ),

                SizedBox(height: 20),

                Text(
                  'Seçildiği Gün: ${Date}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Seçildiği Saat: ${Time}',
                  style: TextStyle(fontSize: 16),
                ),

              ],
            ),),
          ],
        ),
      ),
    );
  }
}
