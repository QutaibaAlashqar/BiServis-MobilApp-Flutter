import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WorkerProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String selectedCity = 'Istanbul';
  String selectedBolum = 'Temizleyici';

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
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
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null ? Icon(Icons.camera_alt, size: 50) : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'TC Numarası'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Adı Soyadı'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'E-posta'),
              obscureText: true,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Tekrar Password'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Telefon Numarası'),
              obscureText: true,
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
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Adres',
                hintText: 'Type your address here',
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
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Kaç Yıl Tecrübe'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Not',
                hintText: 'Bize Not Bırakın',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle sign-in logic here
              },
              child: Text('Update Profile'),
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
