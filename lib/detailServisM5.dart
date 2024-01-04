import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hopethelasone/CustomerAktifSiparisler.dart';
import 'package:hopethelasone/ServicesActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hopethelasone/WorkerActivity.dart';

class Child {
  TextEditingController ageController = TextEditingController();
  TextEditingController sexController = TextEditingController();

  Map<String, dynamic> toJson() {
    return {
      'Age': ageController.text,
      'Sex': sexController.text,
    };
  }
}

class detailServisM5 extends StatelessWidget {
  final Orders actifSiparis;
  detailServisM5({required this.actifSiparis}) ;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: detailServisM5Screen(actifSiparis: actifSiparis,),
    );
  }
}

class detailServisM5Screen extends StatefulWidget {
  final Orders actifSiparis;
  detailServisM5Screen({required this.actifSiparis}) ;
  @override
  _detailServisM5ScreenState createState() => _detailServisM5ScreenState(actifSiparis: actifSiparis);
}

class _detailServisM5ScreenState extends State<detailServisM5Screen> {

  final Orders actifSiparis;
  _detailServisM5ScreenState({required this.actifSiparis});

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String Date="", Time="", image="";

  TextEditingController not = TextEditingController();
  TextEditingController childrenNumber = TextEditingController();

  late int numberOfChildren;
  List<Child> children = [];
  List<String> genderOptions = ['Erkek', 'Kadın'];
  List<String> selectedSex = [];

  @override
  void dispose() {
    for (int i = 0; i < children.length; i++) {
      children[i].ageController.dispose();
      children[i].sexController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    not.text = actifSiparis.sdNot.toString();
    numberOfChildren = actifSiparis.children.length;
    childrenNumber.text = actifSiparis.children.length.toString();
    for (int i = 0; i < numberOfChildren; i++) {
      children.add(Child());
      children[i].ageController.text = actifSiparis.children[i].Age.toString();
      children[i].sexController.text = actifSiparis.children[i].Sex.toString();
      selectedSex.add(actifSiparis.children[i].Sex.toString());
    }
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
        title: Text('Yaşlı Bakıcı'),
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

            TextField(
              keyboardType: TextInputType.number,
              controller: childrenNumber,
              onChanged: (value) {
                setState(() {
                  numberOfChildren = int.tryParse(value) ?? 0;
                  children.clear();
                  for (int i = 0; i < numberOfChildren; i++) {
                    children.add(Child());
                  }
                });
              },
              decoration: InputDecoration(labelText: 'Yaşlı Sayısı'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: children.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: <Widget>[
                      Text('${index + 1}. Yaşlı'),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: children[index].ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Yaşı'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: selectedSex[index], // Default value
                          onChanged: (value) {
                            setState(() {
                              children[index].sexController.text = value.toString();
                            });
                          },
                          items: genderOptions.map((String gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          decoration: InputDecoration(labelText: 'Cinsiyet'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
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

            Text(
              'Seçildiği Gün: ${Date}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Seçildiği Saat: ${Time}',
              style: TextStyle(fontSize: 16),
            ),

          ],
        ),
      ),
    );
  }
}

