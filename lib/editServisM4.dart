import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hopethelasone/ServicesActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomerAktifSiparisler.dart';

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

class editServisM4 extends StatelessWidget {
  final ActifSiparis actifSiparis;
  editServisM4({required this.actifSiparis}) ;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: editChildInfoScreen(actifSiparis: actifSiparis,),
    );
  }
}

class editChildInfoScreen extends StatefulWidget {
  final ActifSiparis actifSiparis;
  editChildInfoScreen({required this.actifSiparis}) ;
  @override
  _editChildInfoScreenState createState() => _editChildInfoScreenState(actifSiparis: actifSiparis);
}

class _editChildInfoScreenState extends State<editChildInfoScreen> {

  final ActifSiparis actifSiparis;
  _editChildInfoScreenState({required this.actifSiparis}) : tc = '';

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  late String tc ;
  String Date="", Time="";

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
    getSharedPreferencesData();
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
  }

  Future<void> getSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? storedValue = prefs.getString('tcno');

    if (storedValue != null) {
      tc = storedValue;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        Date = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
        Time = selectedTime.format(context);
      });
  }

  Future<void> uploadData() async {
    if (tc == null) {
      await getSharedPreferencesData();
    }

    String formattedDateTime = DateFormat('yyyy-MM-ddT').format(selectedDate);

    // Format the TimeOfDay with two digits for minutes
    String formattedTime = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

    // Combine date and time
    String finalFormattedDateTime = '$formattedDateTime$formattedTime';

    Dio dio = Dio();
    String url = 'https://romani-au.digital/APIs/BiServis/edit_service.php';

    FormData formData = FormData.fromMap({
        'salon_count': '',
        'salon_metresi': '',
        'mutfak_count': '',
        'mutfak_metresi': '',
        'buro_count': '',
        'buro_metresi': '',
        'depo_count': '',
        'depo_metresi': '',
        'banyo_count': '',
        'banyo_metresi': '',
        'tuvalet_count': '',
        'tuvalet_metresi': '',
        'oda_count': '',
        'oda_metresi': '',
        'bahce_count': '',
        'bahca_metresi': '',
        'balkon_count': '',
        'balkon_metresi': '',
        'agac_count': '',
        'sd_not': not.text,
        'saat_sayisi': '',
        'gun_sayisi': '',
        'order_date': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        'baslangic_tarihi':finalFormattedDateTime,
        'cu_id': tc,
        's_id': actifSiparis.sId,
        'sd_id': actifSiparis.sdId,
        'CocukYasli': jsonEncode(children.map((child) => child.toJson()).toList()),
      });

    try {
      Response response = await dio.post(url, data: formData);
      print(response.data);

      if (response.data == 'ok') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Talepiniz Gönderildi ;)'),
          ),
        );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('İşlem Tamamlanmadı!!!'),
          ),
        );
      }

    } catch (error) {
      print(error.toString());
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

            Padding(
              padding: EdgeInsets.only(right: 8, bottom: 8), // Adjust the right and top padding as needed
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 28,
                  padding: const EdgeInsets.only(top: 4, left: 8, right: 10, bottom: 4),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.black.withOpacity(0.23999999463558197),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    " 5000 karakter kullanabilirsiniz. ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),),),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _selectDate(context);
                _selectTime(context);
              },
              child: Text('İşlem Yapmak İstediğiniz Günü ve Saatı Seçin'),
            ),

            SizedBox(height: 10),

            // Display the selected date and time
            Text(
              'Seçtiniz Gün: ${Date}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Seçtiniz Saat: ${Time}',
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                uploadData();
              },
              child: Text('Talep Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}
