import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;
import 'package:hopethelasone/WorkerActivity.dart';

import 'CustomerAktifSiparisler.dart';

class detailServicsM2 extends StatelessWidget {
  final Orders actifSiparis;
  detailServicsM2({required this.actifSiparis});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: detailServicsM2Page(actifSiparis: actifSiparis,),
    );
  }
}

class detailServicsM2Page extends StatefulWidget {
  final Orders actifSiparis;
  detailServicsM2Page({required this.actifSiparis});
  @override
  _detailServicsM2PageState createState() => _detailServicsM2PageState(actifSiparis: actifSiparis);
}

class _detailServicsM2PageState extends State<detailServicsM2Page> {
  final Orders actifSiparis;
  _detailServicsM2PageState({required this.actifSiparis});

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
        title: Text('Sign In'),
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
                SizedBox(height: 20),
                Text('Ne islem yapmak istiyorsunuz ?'),
                SizedBox(height: 20),

                TextField(
                  controller: not,
                  decoration: InputDecoration(
                    labelText: ' Yapmak istediğiniz işlemler detaylı bir şekilde açıklayınız lütfen. ',
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
                  'Selected Date: ${Date}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Selected Time: ${Time}',
                  style: TextStyle(fontSize: 16),
                ),

                SizedBox(height: 5),

              ],
            ),),
          ],
        ),
      ),
    );
  }
}
