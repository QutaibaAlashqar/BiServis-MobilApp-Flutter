import 'package:flutter/material.dart';
import 'package:hopethelasone/WorkerActivity.dart';

import 'package:hopethelasone/CustomerGecmisSiparisler.dart';
import 'package:hopethelasone/WorkerGecmisSiparisler.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';


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

class faturaServisM4 extends StatelessWidget {
  final GecmisSiparis actifSiparis;
  final int from;
  faturaServisM4({required this.actifSiparis,required this.from});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: faturaServisM4Screen(actifSiparis: actifSiparis,from: from,),
    );
  }
}

class faturaServisM4Screen extends StatefulWidget {
  final GecmisSiparis actifSiparis;
  final int from;
  faturaServisM4Screen({required this.actifSiparis,required this.from});
  @override
  _faturaServisM4ScreenState createState() => _faturaServisM4ScreenState(actifSiparis: actifSiparis, from: from);
}

class _faturaServisM4ScreenState extends State<faturaServisM4Screen> {
  final int from;
  final GecmisSiparis actifSiparis;
  _faturaServisM4ScreenState({required this.actifSiparis,required this.from});


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
        title: Text('Çocuk Bakıcı'),
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
              decoration: InputDecoration(labelText: 'Çocuk Sayısı'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: children.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: <Widget>[
                      Text('${index + 1}. Çocuk'),
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
    );
  }
}
