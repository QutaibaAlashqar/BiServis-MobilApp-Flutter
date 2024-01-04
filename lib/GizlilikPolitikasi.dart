import 'package:flutter/material.dart';

class GizlilikPolitikasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gizlilik Politikası'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
                'Güvenliğiniz bizim için önemli. '
                'Bu sebeple bizimle paylaşacağınız '
                'kişisel verileriniz hassasiyetle '
                'korunmaktadır.\n\n'
                'Biz, BiServis, veri sorumlusu '
                'olarak, bu gizlilik ve kişisel '
                'verilerin korunması politikası '
                'ile, hangi kişisel, verilerinizin '
                'hangi amaçla işleneceği, işlenen '
                'verilerin kimlerle ve neden '
                'paylaşılabileceği, veri işleme '
                'yöntemimiz ve hukuki '
                'sebeplerimiz ile; işlenen '
                'verilerinize ilişkin haklarınızın '
                'neler olduğu hususunda sizleri '
                'aydınlatmayı amaçlıyoruz. '
                '\n\nOnun için merak ettiğiniz yada '
                'sormak istediğiniz şeyler varsa bizimle '
                'iletişime geçebilirsiniz.\n\n'
                '\'qbworkk@gmail.com\' Mail adresimize yazarak. Yada '
                'Çağırı marekezi arayarak bilgi '
                'albilirisiniz.\n \'+90 552 530 04 77\'',
            style: TextStyle(fontSize: 18, color: Colors.black),
        ),
    )
   );
  }
}

