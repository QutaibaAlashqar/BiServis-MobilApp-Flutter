import 'package:flutter/material.dart';
import 'package:hopethelasone/GizlilikPolitikasi.dart';
import 'package:hopethelasone/WorkerActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:hopethelasone/ServicesActivity.dart';

class LoginPage extends StatefulWidget {
  final bool isCustomer;

  LoginPage({required this.isCustomer});
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LoginPage> {
  bool isHovering = false; // Add this line for hover effect

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    final String apiUrl = 'https://romani-au.digital/APIs/BiServis/api/?check_user';

    showDialog(
      context: context,
      barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logging In'),
          content: Row(
            children: [
              CircularProgressIndicator(), // You can replace this with your custom loader widget
              SizedBox(width: 7.5), // Add spacing between the loader and text
              Text('Please wait...'), // Add custom text
            ],
          ),
        );
      },
    );

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'username': email, 'password': password},
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        // Successful login, parse and handle the response
        Map<String, dynamic> responseData = json.decode(response.body);
        print('Response Data: $responseData');
        UserData userData = UserData.fromJson(responseData);

        if (widget.isCustomer && userData.stat != null && userData.stat.toString().contains("1")) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('tcno', userData.cuTC);
          prefs.setString('eposta', email);
          prefs.setString('userName', userData.cuName);
          prefs.setString('stat', "1");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ServicesActivity()),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ServicesActivity()),
          );
        }else if (!widget.isCustomer && userData.stat != null && userData.stat.toString().contains("2")) {

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('tcno', userData.woTC);
          prefs.setString('eposta', email);
          prefs.setString('userName', userData.woName);
          prefs.setString('stat', "2");
          prefs.setString('bolum', userData.woBolum);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkerActivity()),
          );
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WorkerActivity()),
          );

        }else{
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Şifreiniz Yada Kullancı Adınız Yanlış'),
              );
            },
          );
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Şifreiniz Yada Kullancı Adınız Yanlış'),
              );
            },
          );
        }

        print('stat: ${userData.stat}');
        print('cuName: ${userData.cuName}');
        print('cuTC: ${userData.cuTC}');
        print('woName: ${userData.woName}');
        print('woTC: ${userData.woTC}');
        print('userName: ${userData.userName}');
        print('woBolum: ${userData.woBolum}');
        print('is Customer: ${widget.isCustomer}');
        Navigator.pop(context);
        // TODO: Handle the response data as needed
      } else {
        // Handle login failure, show an error message, etc.
        print('Login failed: ${response.statusCode}');
        Navigator.pop(context);
      }
    } catch (e) {
      // Handle exceptions or errors during the login process
      print('Exception during login: $e');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          Positioned(
            left: -35,
            top: -55,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
          ),
          Positioned(
            right: -115,
            bottom: -145,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 8,
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 30),
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.black,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/335541.png'),
                    ),
                  ),
                ),
                Text(
                  'BiServis',
                  style: TextStyle(
                    fontFamily: 'Schyler',
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'E-Posta', border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: 'Şifre', border: OutlineInputBorder()),
                        obscureText: true,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Get the values from the controllers
                          String email = emailController.text;
                          String password = passwordController.text;

                          // Use email and password as needed
                          print('Email: $email, Password: $password');

                          loginUser();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(300, 60),
                        ),
                        child: Text(
                          'Giriş Yap',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inika',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MouseRegion(
                  onEnter: (_) => setState(() => isHovering = true),
                  onExit: (_) => setState(() => isHovering = false),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GizlilikPolitikasi(),
                      ));
                    },
                    child: Text(
                      'Gizlilik Politikası',
                      style: TextStyle(
                        color: isHovering ? Colors.deepPurple : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserData {
  final String stat;
  final String cuName;
  final String cuTC;
  final String woName;
  final String woTC;
  final String userName;
  final String woBolum;

  UserData({
    required this.stat,
    required this.cuName,
    required this.cuTC,
    required this.woName,
    required this.woTC,
    required this.userName,
    required this.woBolum,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      stat: json['stat'] ?? '',
      cuName: json['Cuname'] ?? '',
      cuTC: json['CuTC'] ?? '',
      woName: json['Wo_name'] ?? '',
      woTC: json['WoTC'] ?? '',
      userName: json['User_name'] ?? '',
      woBolum: json['WoBolum'] ?? '',
    );
  }
}