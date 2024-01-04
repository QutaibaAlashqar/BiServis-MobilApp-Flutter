import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:hopethelasone/ServicesActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;

class ServicsM3 extends StatelessWidget {
  final String s_id;
  ServicsM3({required this.s_id});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ServicsM3Page(s_id: s_id,),
    );
  }
}

class ServicsM3Page extends StatefulWidget {
  final String s_id;
  ServicsM3Page({required this.s_id});
  @override
  _ServicsM3PageState createState() => _ServicsM3PageState(s_id: s_id);
}

class _ServicsM3PageState extends State<ServicsM3Page> {

  final String s_id;
  _ServicsM3PageState({required this.s_id}) : tc = '';


  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late String tc ;

  TextEditingController bahceSayisi = TextEditingController();
  TextEditingController bahceMetresi = TextEditingController();
  TextEditingController agacSayisi = TextEditingController();
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
            content: Text('Fotoğraf Eklendi'),
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
        'bahce_count': bahceSayisi.text,
        'bahca_metresi': bahceMetresi.text,
        'balkon_count': agacSayisi.text,
        'balkon_metresi': '',
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
        'bahce_count': bahceSayisi.text,
        'bahca_metresi': bahceMetresi.text,
        'balkon_count': agacSayisi.text,
        'balkon_metresi': '',
        'agac_count': '',
        'sd_not': not.text,
        'saat_sayisi': '',
        'gun_sayisi': '',
        'order_date': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        'baslangic_tarihi':finalFormattedDateTime,
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
        title: Text('Maragoz'),
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
                  child: Text('Fotoğraf Ekle'),
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    uploadData();
                  },
                  child: Text('Talep Gönder'),
                ),
              ],
            ),),
          ],
        ),
      ),
    );
  }
}
