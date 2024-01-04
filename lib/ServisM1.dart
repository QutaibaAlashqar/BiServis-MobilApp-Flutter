import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import the Cupertino package for iOS-style pickers
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:hopethelasone/ServicesActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicsM1 extends StatelessWidget {
  final String s_id;

  ServicsM1({required this.s_id});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ServicsM1Page(s_id: s_id),
    );
  }
}

class ServicsM1Page extends StatefulWidget {
  final String s_id;

  ServicsM1Page({required this.s_id});
  @override
  _ServicsM1PageState createState() => _ServicsM1PageState(s_id: s_id);
}

class _ServicsM1PageState extends State<ServicsM1Page> {

  final String s_id;
  _ServicsM1PageState({required this.s_id}) : tc = '';

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late String tc ;

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
    String url = 'https://romani-au.digital/APIs/BiServis/add_service.php';

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
        's_id': s_id,
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
        's_id': s_id,
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
              MaterialPageRoute(builder: (context) => ServicesActivity()),
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
                    'Seçtiğiniz Gün: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Seçtiğiniz Saat: ${selectedTime.format(context)}',
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
