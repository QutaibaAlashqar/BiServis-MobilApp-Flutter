import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import the Cupertino package for iOS-style pickers
import 'package:image_picker/image_picker.dart';
import 'package:hopethelasone/CustomerAktifSiparisler.dart';
import 'package:hopethelasone/WorkerActivity.dart';

class detailServicsM1 extends StatelessWidget {
  final Orders actifSiparis;

  detailServicsM1({required this.actifSiparis});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: detailServicsM1Page(actifSiparis: actifSiparis),
    );
  }
}

class detailServicsM1Page extends StatefulWidget {
  final Orders actifSiparis;

  detailServicsM1Page({required this.actifSiparis});
  @override
  _detailServicsM1PageState createState() => _detailServicsM1PageState(actifSiparis: actifSiparis);
}

class _detailServicsM1PageState extends State<detailServicsM1Page> {
  final Orders actifSiparis;

  _detailServicsM1PageState({required this.actifSiparis}) : tc = '';

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  late String tc ;
  String Date="", Time="", image = "";

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
    if(actifSiparis.image.toString()!=""){
      image = 'https://romani-au.digital/APIs/BiServis/uploads/'+actifSiparis.image.toString();
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

                  // Display the selected date and time
                  Text(
                    'Seçildiği Gün: ${Date}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Seçildiği Saat: ${Time}',
                    style: TextStyle(fontSize: 16),
                  ),

                  SizedBox(height: 5),



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
