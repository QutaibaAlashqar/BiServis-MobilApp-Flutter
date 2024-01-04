import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:image/image.dart' as img;

class WorkerSignIn extends StatelessWidget {
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

  TextEditingController tcNumberController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  // ... (add other controllers)

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
      File imageFile, String tcNumber, String fullName) async {
    Dio dio = Dio();
    String url = 'https://romani-au.digital/APIs/BiServis/add_worker.php';

    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
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
      'not': noteController.text,
      // ... (add other form data as needed)
    });

    try {
      Response response = await dio.post(url, data: formData);
      print(response.data);

        if (response.data == 'ok') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Talepiniz Gönderildi, En Kısa Zamanda Sizinle Ulaşacağız ;)'),
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


    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Üye ol'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press here (e.g., navigate back to the previous screen)
            Navigator.of(context).pop();
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
                  Center(
                    child: GestureDetector(
                      onTap: _getImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                        _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? Icon(Icons.camera_alt, size: 50)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: tcNumberController,
                    decoration: InputDecoration(labelText: 'TC Numarası'),
                  ),
                  TextField(
                    controller: fullNameController,
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
                    controller: experienceController,
                    decoration: InputDecoration(labelText: 'Kaç Yıl Tecrübeniz Var?'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      labelText: 'Not',
                      hintText: 'Bize Not Bırakın...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_image != null) {
                        // Perform image upload
                        String tcNumber = tcNumberController.text;
                        String fullName = fullNameController.text;
                        // ... (other fields)
                        await uploadImage(_image!, tcNumber, fullName);
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









// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
//
// class ImageUploadScreen extends StatefulWidget {
//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }
//
// class _ImageUploadScreenState extends State<ImageUploadScreen> {
//   final ImagePicker _imagePicker = ImagePicker();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController surnameController = TextEditingController();
//
//   Future<void> _getImage(ImageSource source) async {
//     final pickedFile = await _imagePicker.getImage(source: source);
//
//     if (pickedFile != null) {
//       File imageFile = File(pickedFile.path);
//       File resizedImage = await resizeImage(imageFile);
//
//       String name = nameController.text;
//       String surname = surnameController.text;
//
//       await uploadImage(resizedImage, name, surname);
//     }
//   }
//
//   Future<File> resizeImage(File originalImage) async {
//     final rawImage = img.decodeImage(await originalImage.readAsBytes());
//     final resizedImage = img.copyResize(rawImage!, width: 100);
//
//     final resizedImageFile = File(originalImage.path.replaceAll('.jpg', '_resized.jpg'));
//     await resizedImageFile.writeAsBytes(img.encodeJpg(resizedImage));
//
//     return resizedImageFile;
//   }
//
//   Future<void> uploadImage(File imageFile, String name, String surname) async {
//     Dio dio = Dio();
//     String url = 'https://romani-au.digital/APIs/BiServis/upload.php';
//
//     FormData formData = FormData.fromMap({
//       'image': await MultipartFile.fromFile(
//         imageFile.path,
//         filename: 'image.jpg',
//       ),
//       'name': name,
//       'surname': surname,
//     });
//
//     try {
//       Response response = await dio.post(url, data: formData);
//       print(response.data);
//     } catch (error) {
//       print(error.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Upload'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 labelText: 'Name',
//               ),
//             ),
//             TextField(
//               controller: surnameController,
//               decoration: InputDecoration(
//                 labelText: 'Surname',
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () => _getImage(ImageSource.gallery),
//               child: Text('Pick from Gallery'),
//             ),
//             ElevatedButton(
//               onPressed: () => _getImage(ImageSource.camera),
//               child: Text('Take a Photo'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//}




// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class WorkerSingIn extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SignInPage(),
//     );
//   }
// }
//
// class SignInPage extends StatefulWidget {
//   @override
//   _SignInPageState createState() => _SignInPageState();
// }
//
// class _SignInPageState extends State<SignInPage> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   String selectedCity = 'Istanbul';
//   String selectedBolum = 'Temizleyici';
//
//   Future<void> _getImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = File(pickedFile!.path);
//     });
//   }
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
//         Expanded(child:ListView(
//           children: <Widget>[
//             Center(
//               child: GestureDetector(
//                 onTap: _getImage,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: _image != null ? FileImage(_image!) : null,
//                   child: _image == null ? Icon(Icons.camera_alt, size: 50) : null,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               decoration: InputDecoration(labelText: 'TC Numarası'),
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Adı Soyadı'),
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'E-posta'),
//               obscureText: true,
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Password'),
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Tekrar Password'),
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Telefon Numarası'),
//               obscureText: true,
//             ),
//             Container(
//               height: 60, // Set the height to make the dropdown scrollable
//               child: ListView(
//                 children: <Widget>[
//                   DropdownButton<String>(
//                     value: selectedCity,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedCity = newValue!;
//                       });
//                     },
//                     items: turkishCities.map((String city) {
//                       return DropdownMenuItem<String>(
//                         value: city,
//                         child: Text(city),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Adres',
//                 hintText: 'Type your address here',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             Container(
//               height: 60, // Set the height to make the dropdown scrollable
//               child: ListView(
//                 children: <Widget>[
//                   DropdownButton<String>(
//                     value: selectedBolum,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedBolum = newValue!;
//                       });
//                     },
//                     items: servisBolum.map((String city) {
//                       return DropdownMenuItem<String>(
//                         value: city,
//                         child: Text(city),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Kaç Yıl Tecrübe'),
//               obscureText: true,
//             ),
//             SizedBox(height: 10),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Not',
//                 hintText: 'Bize Not Bırakın',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle sign-in logic here
//               },
//               child: Text('Sign In'),
//             ),
//           ],
//         ),),
//             SizedBox(height: 20),
//             Text(
//               'Gizlilik Politikasi',
//               style: TextStyle(color: Colors.blue,fontSize: 10),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// List<String> turkishCities = [
//   'Istanbul',
//   'Ankara',
//   'Izmir',
//   'Bursa',
//   'Antalya',
//   'Adana',
//   'Gaziantep',
//   'Konya',
//   'Mersin',
//   'Diyarbakir',
//   'Samsun',
//   'Denizli',
//   'Kayseri',
//   'Eskisehir',
//   'Sivas',
//   'Manisa',
//   'Batman',
//   'Balikesir',
//   'Trabzon',
//   'Van',
// ];
//
// List<String> servisBolum = [
//   'Temizleyici',
//   'Tesisatçı',
//   'Electrikçi',
//   'Boyacı',
//   'Marangoz',
//   'Bahçıvan',
//   'Çocuk bakıcısı',
//   'Yaşlı bakıcısı',
// ];
