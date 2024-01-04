import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hopethelasone/ServicesActivity.dart';
import 'Login.dart';
import 'Login.dart';

class CustomerSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
      builder: (BuildContext context, Widget? child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String selectedCity = 'Istanbul';
  TextEditingController tcController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  Future<void> addCustomer() async {
    final String tc = tcController.text.trim();
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String phone = phoneController.text.trim();
    final String city = selectedCity;
    final String address = addressController.text.trim();

    final String apiUrl = 'https://romani-au.digital/APIs/BiServis/api/?add_custumer';

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
        // Delay for a short period to ensure that the dialog is fully displayed
        dynamic responseData = json.decode(response.body);
        print(responseData);
        EasyLoading.dismiss();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(isCustomer:true)),
        );


        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Talepiniz Gönderildi, En Kısa Zamanda Hizimitlerimizi Kullanmaya başlayabilrisiniz;)'),
            ),
          );
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('İşlem Tamamlanmadı, Bilgilerinizi Yeniden Giriniz Ve Kontrol Edin'),
            ),
          );
        }

        // TODO: Handle the response data as needed
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



  @override
  Widget build(BuildContext context) {
    return Material( // Wrap the UyeOlPage with Material
      child: Scaffold(
        appBar: AppBar(
          title: Text('Üye Ol'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
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
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Adı Soyadı'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'E-posta'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Şifre'),
                      obscureText: true,
                    ),
                    TextField(
                      controller: repeatPasswordController,
                      decoration: InputDecoration(labelText: 'Şifreyi Tekrarla'),
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
                        hintText: 'Adresinizi Bu Alanda Yazın...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (passwordController.text == repeatPasswordController.text) {
                          addCustomer();
                        } else {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Şifre Aynı Olmalıdır!'),
                              );
                            },
                          );
                        }
                      },
                      child: Text('GÖNDER'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
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
