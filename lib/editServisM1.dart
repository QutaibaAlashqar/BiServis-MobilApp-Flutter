import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import the Cupertino package for iOS-style pickers
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:hopethelasone/CustomerAktifSiparisler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class editServicsM1 extends StatelessWidget {
  final ActifSiparis actifSiparis;

  editServicsM1({required this.actifSiparis});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: editServicsM1Page(actifSiparis: actifSiparis),
    );
  }
}

class editServicsM1Page extends StatefulWidget {
  final ActifSiparis actifSiparis;

  editServicsM1Page({required this.actifSiparis});
  @override
  _editServicsM1PageState createState() => _editServicsM1PageState(actifSiparis: actifSiparis);
}

class _editServicsM1PageState extends State<editServicsM1Page> {
  final ActifSiparis actifSiparis;

  _editServicsM1PageState({required this.actifSiparis}) : tc = '';

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late String tc ;
  String Date="", Time="";

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
    getSharedPreferencesData();
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

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      File resizedImage = await resizeImage(imageFile);
      setState(() {
        _image = resizedImage;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fotoğraf Eklendi.'),
          ),
        );

      });
    }
  }

  Future<File> resizeImage(File originalImage) async {
    final rawImage = img.decodeImage(await originalImage.readAsBytes());
    final resizedImage = img.copyResize(rawImage!, width: 400);

    final resizedImageFile =
    File(originalImage.path.replaceAll('.jpg', '_resized.jpg'));
    await resizedImageFile.writeAsBytes(img.encodeJpg(resizedImage));

    return resizedImageFile;
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

    FormData formData;

    final _image = this._image;
    if (_image != null) {
      formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(_image.path),
        'salon_count': salonSayisi.text,
        'salon_metresi': salonMetresi.text,
        'mutfak_count': mutfakSayisi.text,
        'mutfak_metresi': mutfakMetresi.text,
        'buro_count': buroSayisi.text,
        'buro_metresi': buroMetresi.text,
        'depo_count': depoSayisi.text,
        'depo_metresi': depoMetresi.text,
        'banyo_count': banyoSayisi.text,
        'banyo_metresi': banyoMetresi.text,
        'tuvalet_count': tuvaletSayisi.text,
        'tuvalet_metresi': tuvaletMetresi.text,
        'oda_count': odaSayisi.text,
        'oda_metresi': odaMetresi.text,
        'bahce_count': bahceSayisi.text,
        'bahca_metresi': bahceMetresi.text,
        'balkon_count': balkonSayisi.text,
        'balkon_metresi': balkonMetresi.text,
        'agac_count': '',
        'sd_not': not.text,
        'saat_sayisi': '',
        'gun_sayisi': '',
        'order_date': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        'baslangic_tarihi':finalFormattedDateTime,
        'cu_id': tc,
        's_id': actifSiparis.sId,
        'sd_id': actifSiparis.sdId,
      });
    } else {
      formData = FormData.fromMap({
        'salon_count': salonSayisi.text,
        'salon_metresi': salonMetresi.text,
        'mutfak_count': mutfakSayisi.text,
        'mutfak_metresi': mutfakMetresi.text,
        'buro_count': buroSayisi.text,
        'buro_metresi': buroMetresi.text,
        'depo_count': depoSayisi.text,
        'depo_metresi': depoMetresi.text,
        'banyo_count': banyoSayisi.text,
        'banyo_metresi': banyoMetresi.text,
        'tuvalet_count': tuvaletSayisi.text,
        'tuvalet_metresi': tuvaletMetresi.text,
        'oda_count': odaSayisi.text,
        'oda_metresi': odaMetresi.text,
        'bahce_count': bahceSayisi.text,
        'bahca_metresi': bahceMetresi.text,
        'balkon_count': balkonSayisi.text,
        'balkon_metresi': balkonMetresi.text,
        'agac_count': '',
        'sd_not': not.text,
        'saat_sayisi': '',
        'gun_sayisi': '',
        'order_date': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        'baslangic_tarihi': finalFormattedDateTime,
        'cu_id': tc,
        's_id': actifSiparis.sId,
        'sd_id': actifSiparis.sdId,
      });
    }

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
        title: Text('Temizleyici'),
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

                  SizedBox(height: 5),

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
                    'Seçtiğiniz Gün: ${Date}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Seçtiğiniz Saat: ${Time}',
                    style: TextStyle(fontSize: 16),
                  ),

                  SizedBox(height: 5),

                ElevatedButton(
                  onPressed: () {
                    _getImage();
                  },
                  child: Text('Fotograf Ekle'),
                ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Add your onPressed functionality here
                      uploadData();
                    },
                    child: Text('Talep Gönder'),
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





// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:version1/getTime.dart';
//
// class ServicsM1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ServicsM1Page(),
//     );
//   }
// }
//
// class ServicsM1Page extends StatefulWidget {
//   @override
//   _ServicsM1PageState createState() => _ServicsM1PageState();
// }
//
// class _ServicsM1PageState extends State<ServicsM1Page> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign In'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             Expanded(child:ListView(
//               children: <Widget>[
//                 SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Salon Sayisi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Salon Metresi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Mutfak Sayisi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Mutfak Metresi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Buro Sayisi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Buro Metresi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Depo Sayisi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Depo Metresi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Banyo Sayisi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Banyo Metresi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Tuvalet Sayisi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Tuvalet Metresi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Oda Sayisi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Oda Metresi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Bahce Sayisi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Bahce Metresi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Balkon Sayisi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Balkon Metresi',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle sign-in logic here
//                   },
//                   child: Text('Not/Fotograf ekle'),
//                 ),
//
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) =>
//                           DateTimePickerScreen()), // Pass the item data to the detail page if needed
//                     );
//                   },
//                   child: Text('Devam'),
//                 ),
//               ],
//             ),),
//           ],
//         ),
//       ),
//     );
//   }
// }
