import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomerProfil extends StatelessWidget {
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
  String selectedCity = 'Istanbul';

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
              decoration: InputDecoration(labelText: 'Şifre'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Şifre Tekrarla'),
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
                hintText: 'Adresinizi Detaylı Bir Şekilde Yazın',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle sign-in logic here
              },
              child: Text('Profil Güncelleme'),
            ),
          ],
        ),),
            SizedBox(height: 20),

          ],),
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
