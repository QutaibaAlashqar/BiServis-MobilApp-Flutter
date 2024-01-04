import 'package:flutter/material.dart';
import 'GizlilikPolitikasi.dart';
import 'CustomerSingIn.dart';
import 'Login.dart';
import 'SplashScreen.dart';
import 'WorkerSingIn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class MainActivity extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<MainActivity> {
  bool isCustomerSelected = true;
  bool isHovering = false; // Add this line for hover effect

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // Use Stack to layer widgets
        children: <Widget>[
          Positioned( // Center the circle in the background
            left: -35,
            top: -55,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Make it a circle
                color: Colors.blue, // Light purple circle
              ),
            ),
          ),
          Positioned( // Center the circle in the background
            right: -115,
            bottom: -145,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Make it a circle
                color: Colors.blue, // Light purple circle
              ),
            ),
          ),
          Center( // Main content stays here
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
                  'BiServis', // Replace with your text
                  style: TextStyle(
                    fontFamily: 'Schyler',
                    fontSize: 30, // Adjust the font size as needed
                    color: Colors.black, // Adjust the color as needed
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isCustomerSelected = true;
                                  });
                                },
                                child: Text('Müşteri'),
                                style: isCustomerSelected
                                    ? ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                    ),
                                  ),
                                )
                                    : ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isCustomerSelected = false;
                                  });
                                },
                                child: Text('Çalışan'),
                                style: isCustomerSelected
                                    ? ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                  ),
                                )
                                    : ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      if (isCustomerSelected)
                        customerButtons(context)
                      else
                        workerButtons(context),
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
                        color: isHovering ? Colors.deepPurple : Colors.black, // Change color on hover
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

  Widget customerButtons(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 2),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage(isCustomer: true)),
            );
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
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomerSignIn()),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(300, 60),
          ),
          child: Text(
            'Üye Ol',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inika',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget workerButtons(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 2),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage(isCustomer: false)),
            );
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
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WorkerSignIn()),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(300, 60),
          ),
          child: Text(
            'Üye Ol',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inika',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
