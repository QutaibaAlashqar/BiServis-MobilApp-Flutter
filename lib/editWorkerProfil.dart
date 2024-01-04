import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class editWorkerProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: editWorkerPage(),
    );
  }
}

class editWorkerPage extends StatefulWidget {
  @override
  _editWorkerPageState createState() => _editWorkerPageState();
}

class _editWorkerPageState extends State<editWorkerPage> {
  _editWorkerPageState() : eposta = '', tc = '';
  String? eposta;

  late String tc;

  @override
  void initState() {
    super.initState();
    getSharedPreferencesData();
  }

  Future<void> getSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedValue = prefs.getString('eposta');
    String? tcstoredValue = prefs.getString('tcno');
    if (storedValue != null) {
      eposta = storedValue;
      tc = tcstoredValue!;
    }
    fetchCustomerData();
  }

  File? _image;
  final ImagePicker _picker = ImagePicker();
  String selectedCity = 'Istanbul';
  String selectedBolum = 'Temizleyici';

  TextEditingController tcNumberController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController experienceController = TextEditingController();


  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      File resizedImage = await resizeImage(imageFile);
      setState(() {
        _image = resizedImage;
      });
    }
  }

  Future<File> resizeImage(File originalImage) async {
    final rawImage = img.decodeImage(await originalImage.readAsBytes());
    final resizedImage = img.copyResize(rawImage!, width: 100);

    final resizedImageFile =
    File(originalImage.path.replaceAll('.jpg', '_resized.jpg'));
    await resizedImageFile.writeAsBytes(img.encodeJpg(resizedImage));

    return resizedImageFile;
  }

  Future<void> uploadImage(
      String tcNumber, String fullName) async {
    Dio dio = Dio();
    String url = 'https://romani-au.digital/APIs/BiServis/edit_worker.php';
    FormData formData;
    if(_image!=null){
      formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          _image!.path,
          filename: 'imagehh.jpg',
        ),
        'tcnu': tcNumber,
        'name': fullName,
        'eposta': emailController.text,
        'password': passwordController.text,
        'telephon': phoneNumberController.text,
        'sehir': selectedCity,
        'adres': addressController.text,
        'bolum': selectedBolum,
        'tecrube': experienceController.text,
        'not': '',
      });
    }else{
      formData = FormData.fromMap({
        'tcnu': tcNumber,
        'name': fullName,
        'eposta': emailController.text,
        'password': passwordController.text,
        'telephon': phoneNumberController.text,
        'sehir': selectedCity,
        'adres': addressController.text,
        'bolum': selectedBolum,
        'tecrube': experienceController.text,
        'not': '',
      });
    }

    try {
      Response response = await dio.post(url, data: formData);
      print(response.data);
      if(response.data.toString().contains("ok")){
        print("yes");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userName', fullNameController.text);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> fetchCustomerData() async {
    if (eposta == null) {
      getSharedPreferencesData();
    }else {
      final String apiUrl = 'https://romani-au.digital/APIs/BiServis/api/?get_user';

      EasyLoading.show(status: 'Loading...');
      print(tc);

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'witch': '2',
            'user_name': eposta!,
          },
        );

        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {

          dynamic responseData = json.decode(response.body);
          print(responseData);


          fullNameController.text = responseData[0]['name'].toString();
          emailController.text = responseData[0]['posta'].toString();
          passwordController.text = responseData[0]['password'].toString();
          repeatPasswordController.text = responseData[0]['password'].toString();
          phoneNumberController.text = responseData[0]['tel'].toString();
          addressController.text = responseData[0]['addres'].toString();
          experienceController.text = responseData[0]['tecrube'].toString();
          setState(() {
            tcNumberController.text = responseData[0]['tc'].toString();
            selectedCity = responseData[0]['city'].toString();
            selectedBolum = servisBolum[responseData[0]['bolum']];
          });

          EasyLoading.dismiss();
        } else {
          print('Failed to fetch customer data: ${response.statusCode}');
          EasyLoading.dismiss();
        }
      } catch (e) {
        print('Exception during data fetching: $e');
        EasyLoading.dismiss();
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
        Expanded(child:ListView(
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: _getImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!) as ImageProvider<Object>?
                      : NetworkImage('https://romani-au.digital/APIs/BiServis/uploads/'+tcNumberController.text+'.jpg'),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: tcNumberController,
              decoration: InputDecoration(labelText: 'TC Numarası'),
              readOnly: true,
            ),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'Adı Soyadı'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-posta'),
              readOnly: true,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            TextField(
              controller: repeatPasswordController,
              decoration: InputDecoration(labelText: 'Şifre Tekrarla'),
              obscureText: true,
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Telefon Numarası'),
            ),
            Container(
              height: 60, // Set the height to make the dropdown scrollable
              child: ListView(
                children: <Widget>[
                  DropdownButton<String>(
                    value: selectedCity,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCity = newValue!;
                      });
                    },
                    items: turkishCities.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city, // Ensure that each value is unique
                        child: Text(city),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Adres',
                hintText: 'Adresinizi Bu Alanda Yazınız',
                border: OutlineInputBorder(),
              ),
            ),
            Container(
              height: 60, // Set the height to make the dropdown scrollable
              child: ListView(
                children: <Widget>[
                  DropdownButton<String>(
                    value: selectedBolum,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBolum = newValue!;
                      });
                    },
                    items: servisBolum.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city, // Ensure that each value is unique
                        child: Text(city),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            TextField(
              controller: experienceController,
              decoration: InputDecoration(labelText: 'Kaç Yıl Tecrübeniz Var'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String tcNumber = tcNumberController.text;
                String fullName = fullNameController.text;
                // ... (other fields)
                await uploadImage(tcNumber, fullName);
              },
              child: Text('Profil Güncelleme'),
            ),
          ],
        ),),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


List<String> turkishCities = [
  'Istanbul',
  'Ankara',
  'Izmir',
  'Bursa',
  'Antalya',
  'Adana',
  'Gaziantep',
  'Konya',
  'Mersin',
  'Diyarbakir',
  'Samsun',
  'Denizli',
  'Kayseri',
  'Eskisehir',
  'Sivas',
  'Manisa',
  'Batman',
  'Balikesir',
  'Trabzon',
  'Van',
];

List<String> servisBolum = [
  'Temizleyici',
  'Tesisatçı',
  'Electrikçi',
  'Boyacı',
  'Marangoz',
  'Bahçıvan',
  'Çocuk bakıcısı',
  'Yaşlı bakıcısı',
];
