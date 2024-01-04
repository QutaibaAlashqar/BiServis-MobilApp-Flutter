import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hopethelasone/ServicesActivity.dart';

import 'Login.dart';

class editCustomerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomerPage(),
      builder: (BuildContext context, Widget? child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {

  _CustomerPageState() : eposta = '';

  String selectedCity = 'Istanbul';
  TextEditingController tcController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? eposta;

  @override
  void initState() {
    super.initState();
    getSharedPreferencesData();
  }

  Future<void> getSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedValue = prefs.getString('eposta');
    if (storedValue != null) {
      eposta = storedValue;
    }
    fetchCustomerData();
  }

  Future<void> editCustomer() async {
    final String tc = tcController.text.trim();
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String phone = phoneController.text.trim();
    final String city = selectedCity;
    final String address = addressController.text.trim();

    final String apiUrl = 'https://romani-au.digital/APIs/BiServis/api/?edit_custumer';

    EasyLoading.show(status: 'Loading...');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'tcnu': tc,
          'name': name,
          'eposta': email,
          'password': password,
          'telephon': phone,
          'sehir': city,
          'adres': address,
        },
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userName', nameController.text);
        EasyLoading.dismiss();
      } else {
        // Handle login failure, show an error message, etc.
        print('Signin failed: ${response.statusCode}');
        EasyLoading.dismiss();
      }
    } catch (e) {
      // Handle exceptions or errors during the sign-in process
      print('Exception during sign-in: $e');
      EasyLoading.dismiss();
    }
  }

  Future<void> fetchCustomerData() async {
    if (eposta == null) {
      getSharedPreferencesData();
    }else {
      final String apiUrl = 'https://romani-au.digital/APIs/BiServis/api/?get_user';

      EasyLoading.show(status: 'Loading...');
      print(eposta);

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'witch': '1',
            'user_name': eposta!,
          },
        );

        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {

          dynamic responseData = json.decode(response.body);
          print(responseData);

          tcController.text = responseData[0]['tc'];
          nameController.text = responseData[0]['name'];
          emailController.text = responseData[0]['posta'];
          phoneController.text = responseData[0]['tel'];
          passwordController.text = responseData[0]['password'];
          repeatPasswordController.text = responseData[0]['password'];
          setState(() {
            selectedCity = responseData[0]['city'];
          });
          addressController.text = responseData[0]['addres'];

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  ServicesActivity()),
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
                  TextField(
                    controller: tcController,
                    decoration: InputDecoration(labelText: 'TC Numarası'),
                    readOnly: true,
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Adı Soyadı'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'E-posta'),
                    readOnly: true,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: repeatPasswordController,
                    decoration: InputDecoration(labelText: 'Tekrar Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Telefon Numarası'),
                  ),
                  Container(
                    height: 60,
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
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Adres',
                      hintText: 'Type your address here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if(passwordController.text == repeatPasswordController.text){
                        editCustomer();
                      }else{
                        showDialog(
                          context: context,
                          barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Sifre ayni olmasi gerekiyor'),
                            );
                          },
                        );
                      }
                    },
                    child: Text('Update profile'),
                  ),
                ],
              ),
            ),
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


