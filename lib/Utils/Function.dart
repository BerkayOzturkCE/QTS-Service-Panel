import 'package:flutter/material.dart';

class Functions {
  Color ColorDetecter(double puan) {
    if (puan < 5) {
      return Colors.red;
    } else if (puan >= 8) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }
}

class Cryptology {
  int p = 11, q = 197; //p ve q asal sayılarını tanımladık.
  int e = 107; //public key tanımlandı.
  late int totient, n;

  void dataDetect() {
    totient = (p - 1) * (q - 1); // totient sayısı hesaplandı.
    n = p * q; // n base değerini bulduk.
  }

  String Encryption(String plainText, BuildContext context) {
    dataDetect();

    plainText; //şifrelenecek metini aldık.
    String kriptometin = "";
    List metin = plainText.codeUnits;

    for (int i = 0;
        i < metin.length;
        i++) //metinin boyutu kadar döngü çalışacak
    {
      int sayi = metin[i]; //mesajın ilk indisi int yapıldı
      int kripto = int.parse(BigInt.from(sayi)
          .modPow(BigInt.parse(e.toString()), BigInt.parse(n.toString()))
          .toString()); // sayi^e mod n işlemi yapıldı
      kriptometin += String.fromCharCode(
          kripto); //kripto sayi char yapılıp kripto metine eklendi.

    }

    return kriptometin; //şifreli mesaj yazdırıldı.
  }

  String Decryption(String plainText, BuildContext context) {
    dataDetect();

    plainText; //çözülecek metini aldık.
    List metin = plainText.codeUnits;
    String cozulen_mesaj = "";
    int d = oklid_algorithm(); //uzatılmış oklid algoritması çağırıldı.
    for (int i = 0;
        i < metin.length;
        i++) //metinin boyutu kadar döngü çalışacak
    {
      int sayi = metin[i]; //sifreli metinin ilk indisi int yapıldı
      int cozulen = int.parse(BigInt.from(sayi)
          .modPow(BigInt.parse(d.toString()), BigInt.parse(n.toString()))
          .toString()); //sayi^d mod n işlemi yapıldı
      cozulen_mesaj +=
          String.fromCharCode(cozulen); //cozulen sayi cozulen mesaja eklendi
    }
    return cozulen_mesaj; //çözülen metin yazıldı
  }

  int oklid_algorithm() //uzatıılmış öklid algoritması fonksiyonu.
  {
    int Q,
        x1 = 1,
        x2 = 0,
        x3 = totient,
        y1 = 0,
        y2 = 1,
        y3 = e,
        t1,
        t2,
        t3; //gerekli değişkenleri tanımladık.

    while (y3 != 1) // y3 degeri 1 değilken.
    {
      // uzatılmış öklid algoritmasının işlemleri yapılıyor
      double temp = x3 / y3;
      Q = temp.toInt();
      t1 = x1 - (y1 * Q);
      t2 = x2 - (y2 * Q);
      t3 = x3 - (y3 * Q);
      x1 = y1;
      x2 = y2;
      x3 = y3;
      y1 = t1;
      y2 = t2;
      y3 = t3;
    }

    if (y2 < 0) {
      y2 += totient;
    }
    return y2;
  }
}
