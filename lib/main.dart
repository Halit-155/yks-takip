import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'dart:io';
// Paketler
import 'package:image_picker/image_picker.dart';

// ============================================================
// 1. GLOBAL VERİ DEPOSU
// ============================================================

class VeriDeposu {
  static List<Gorev> kayitliProgram = [];
  static List<DenemeSonucu> denemeListesi = [];
  static Map<String, bool> tamamlananKonular = {};

  static List<Ogrenci> ogrenciler = [
    Ogrenci(
        id: "101",
        ad: "Ahmet Yılmaz",
        sinif: "12",
        puan: 1250,
        atananOgretmenId: "t1",
        fotoUrl: ""),
    Ogrenci(
        id: "102",
        ad: "Ayşe Demir",
        sinif: "12",
        puan: 2400,
        atananOgretmenId: "t1",
        fotoUrl: ""),
  ];

  static List<Ogretmen> ogretmenler = [
    Ogretmen(id: "t1", ad: "Mustafa Hoca", brans: "Matematik"),
    Ogretmen(id: "t2", ad: "Elif Hoca", brans: "Edebiyat"),
  ];

  static List<Mesaj> mesajlar = [];
  static List<Rozet> tumRozetler = [];
  static List<OkulDersi> okulNotlari = [
    OkulDersi(ad: "Kur'an-ı Kerim", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Arapça", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Matematik", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Türk Dili ve Edb.", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Tarih", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Coğrafya", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Fizik", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Kimya", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Biyoloji", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Felsefe", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Din Kültürü", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Hadis", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Siyer", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Fıkıh", yazili1: 0, yazili2: 0, performans: 0),
  ];

  static void baslat() {
    if (tumRozetler.isNotEmpty) return;
    for (int i = 5; i <= 100; i += 5) {
      tumRozetler.add(Rozet(
          id: "deneme_$i",
          ad: "$i. Deneme",
          aciklama: "$i deneme bitti!",
          kategori: "Deneme",
          puanDegeri: i * 2,
          ikon: Icons.edit,
          renk: Colors.blue,
          hedefSayi: i,
          mevcutSayi: 0));
    }
    tumRozetler.add(Rozet(
        id: "konu_10",
        ad: "Çırak",
        aciklama: "10 Konu",
        kategori: "Konu",
        puanDegeri: 50,
        ikon: Icons.book,
        renk: Colors.green,
        hedefSayi: 10,
        mevcutSayi: 0));
    tumRozetler.add(Rozet(
        id: "konu_50",
        ad: "Kalfa",
        aciklama: "50 Konu",
        kategori: "Konu",
        puanDegeri: 200,
        ikon: Icons.library_books,
        renk: Colors.teal,
        hedefSayi: 50,
        mevcutSayi: 0));
    tumRozetler.add(Rozet(
        id: "puan_1000",
        ad: "Hırslı",
        aciklama: "1000 Puan",
        kategori: "Seviye",
        puanDegeri: 0,
        ikon: Icons.star,
        renk: Colors.orange,
        hedefSayi: 1000,
        mevcutSayi: 0));
    tumRozetler.add(Rozet(
        id: "puan_5000",
        ad: "Efsane",
        aciklama: "5000 Puan",
        kategori: "Seviye",
        puanDegeri: 0,
        ikon: Icons.diamond,
        renk: Colors.red,
        hedefSayi: 5000,
        mevcutSayi: 0));
  }

  // EXCEL SİMÜLASYONU
  static Future<String> excelDenemeYukle() async {
    await Future.delayed(const Duration(seconds: 1));
    denemeListesi.add(DenemeSonucu(
        ogrenciId: "101",
        tur: "TYT (Excel)",
        tarih: DateTime.now(),
        turkce: 30,
        mat: 20,
        fen: 10,
        sos: 10));
    puanEkle("101", 50);
    return "Excel Yüklendi! (Simülasyon)";
  }

  static void puanEkle(String id, int p) {
    var o =
        ogrenciler.firstWhere((e) => e.id == id, orElse: () => ogrenciler[0]);
    o.puan += p;
    rozetleriGuncelle();
  }

  static void rozetleriGuncelle() {
    int dSayisi = denemeListesi.length;
    int kSayisi = tamamlananKonular.values.where((e) => e).length;
    int puan = ogrenciler[0].puan;
    for (var r in tumRozetler) {
      if (r.kategori == "Deneme") r.mevcutSayi = dSayisi;
      if (r.kategori == "Konu") r.mevcutSayi = kSayisi;
      if (r.kategori == "Seviye") r.mevcutSayi = puan;
      if (r.mevcutSayi >= r.hedefSayi && !r.kazanildi) {
        r.kazanildi = true;
        puanEkle("101", r.puanDegeri);
      }
    }
  }

  static void ogrenciGuncelle(
      String id, String ad, String sinif, String no, String foto) {
    int idx = ogrenciler.indexWhere((o) => o.id == id);
    if (idx != -1) {
      ogrenciler[idx].ad = ad;
      ogrenciler[idx].sinif = sinif;
      ogrenciler[idx].id = no;
      ogrenciler[idx].fotoUrl = foto;
    } else {
      ogrenciler
          .add(Ogrenci(id: no, ad: ad, sinif: sinif, puan: 0, fotoUrl: foto));
    }
  }

  static void programiKaydet(List<List<Map<String, dynamic>>> t) {
    kayitliProgram.clear();
    for (int i = 0; i < t.length; i++) {
      var hafta = t[i];
      int hNo = i + 1;
      for (var gun in hafta) {
        String gAd = gun['gun'];
        List blk = gun['bloklar'];
        for (var b in blk)
          kayitliProgram.add(Gorev(
              hafta: hNo,
              gun: gAd,
              saat: b['saat'],
              ders: b['ders'],
              konu: b['konu']));
      }
    }
    puanEkle("101", 100);
  }

  static void denemeEkle(DenemeSonucu d) {
    denemeListesi.add(d);
    puanEkle(d.ogrenciId, 20);
  }

  static void dersEkle(String ad) {
    if (!okulNotlari.any((d) => d.ad == ad))
      okulNotlari.add(OkulDersi(ad: ad, yazili1: 0, yazili2: 0, performans: 0));
  }

  static void dersSil(int index) {
    okulNotlari.removeAt(index);
  }

  static void konuDurumDegistir(String k, bool v) {
    tamamlananKonular[k] = v;
    if (v) puanEkle("101", 10);
  }

  static void mesajGonder(String g, String a, String i) {
    mesajlar
        .add(Mesaj(gonderen: g, aliciId: a, icerik: i, tarih: DateTime.now()));
  }
}

// MODELLER
class Ogrenci {
  String id, ad, sinif, fotoUrl;
  int puan;
  String? atananOgretmenId;
  Ogrenci(
      {required this.id,
      required this.ad,
      required this.sinif,
      required this.puan,
      this.atananOgretmenId,
      this.fotoUrl = ""});
}

class Ogretmen {
  String id, ad, brans;
  Ogretmen({required this.id, required this.ad, required this.brans});
}

class Mesaj {
  String gonderen, aliciId, icerik;
  DateTime tarih;
  Mesaj(
      {required this.gonderen,
      required this.aliciId,
      required this.icerik,
      required this.tarih});
}

class Rozet {
  String id, ad, aciklama, kategori;
  int puanDegeri, hedefSayi, mevcutSayi;
  IconData ikon;
  Color renk;
  bool kazanildi;
  Rozet(
      {required this.id,
      required this.ad,
      required this.aciklama,
      required this.kategori,
      required this.puanDegeri,
      required this.ikon,
      required this.renk,
      required this.hedefSayi,
      required this.mevcutSayi,
      this.kazanildi = false});
}

class KonuDetay {
  String ad;
  int agirlik;
  KonuDetay(this.ad, this.agirlik);
}

class Gorev {
  int hafta;
  String gun, saat, ders, konu;
  bool yapildi;
  Gorev(
      {required this.hafta,
      required this.gun,
      required this.saat,
      required this.ders,
      required this.konu,
      this.yapildi = false});
}

class DenemeSonucu {
  String ogrenciId, tur;
  DateTime tarih;
  double turkce, mat, fen, sos, toplam;
  DenemeSonucu(
      {required this.ogrenciId,
      required this.tur,
      required this.tarih,
      required this.turkce,
      required this.mat,
      required this.fen,
      required this.sos})
      : toplam = turkce + mat + fen + sos;
}

class OkulDersi {
  String ad;
  double yazili1, yazili2, performans;
  OkulDersi(
      {required this.ad,
      required this.yazili1,
      required this.yazili2,
      required this.performans});
  double get ortalama {
    int b = 0;
    if (yazili1 > 0) b++;
    if (yazili2 > 0) b++;
    if (performans > 0) b++;
    return b == 0 ? 0 : (yazili1 + yazili2 + performans) / b;
  }
}

final Map<String, List<KonuDetay>> dersKonuAgirliklari = {
  "TYT Matematik": [
    KonuDetay("Temel Kavramlar", 3),
    KonuDetay("Problemler", 10),
    KonuDetay("Fonksiyonlar", 3)
  ],
  "TYT Türkçe": [KonuDetay("Paragraf", 15), KonuDetay("Dil Bilgisi", 3)],
  "TYT Fen": [
    KonuDetay("Fizik Bilimi", 1),
    KonuDetay("Hareket", 3),
    KonuDetay("Atom", 2)
  ],
  "TYT Sosyal": [
    KonuDetay("Tarih Bilimi", 1),
    KonuDetay("Milli Mücadele", 3),
    KonuDetay("Coğrafya", 2)
  ],
  "AYT Matematik": [
    KonuDetay("Trigonometri", 5),
    KonuDetay("Logaritma", 3),
    KonuDetay("Türev", 8),
    KonuDetay("İntegral", 8)
  ],
  "AYT Fen": [
    KonuDetay("Elektrik", 5),
    KonuDetay("Organik Kimya", 6),
    KonuDetay("Sistemler", 6)
  ],
  "AYT Edebiyat-Sosyal": [
    KonuDetay("Divan Edebiyatı", 5),
    KonuDetay("Cumhuriyet", 6),
    KonuDetay("Tarih", 4)
  ]
};
final Map<String, Map<String, dynamic>> tumDerslerGlobal = {
  "TYT Türkçe": {
    "katsayi": 40,
    "konular": ["Sözcükte Anlam", "Paragraf", "Dil Bilgisi"]
  },
  "TYT Matematik": {
    "katsayi": 40,
    "konular": ["Temel Kavramlar", "Problemler", "Fonksiyonlar"]
  },
  "TYT Fen": {
    "katsayi": 20,
    "konular": ["Fizik Bilimi", "Hareket", "Atom", "Hücre"]
  },
  "TYT Sosyal": {
    "katsayi": 20,
    "konular": ["Tarih Bilimi", "Milli Mücadele", "Coğrafya", "Felsefe"]
  },
  "AYT Matematik": {
    "katsayi": 40,
    "konular": ["Trigonometri", "Logaritma", "Limit", "Türev", "İntegral"]
  },
  "AYT Fen": {
    "katsayi": 40,
    "konular": ["Elektrik", "Organik Kimya", "Sistemler"]
  },
  "AYT Edebiyat-Sosyal": {
    "katsayi": 40,
    "konular": ["Divan Edebiyatı", "Cumhuriyet", "Tarih", "Coğrafya"]
  }
};

// ============================================================
// 2. MAIN VE GİRİŞ EKRANI
// ============================================================

void main() {
  VeriDeposu.baslat();
  runApp(const YksTakipApp());
}

class YksTakipApp extends StatelessWidget {
  const YksTakipApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bayburt AİHL YKS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
        home: const GirisEkrani());
  }
}

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});
  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani>
    with SingleTickerProviderStateMixin {
  late TabController _tc;
  final _k = TextEditingController();
  final _s = TextEditingController();
  bool _g = true;
  @override
  void initState() {
    super.initState();
    _tc = TabController(length: 3, vsync: this);
  }

  void _giris() {
    String k = _k.text.trim(), s = _s.text.trim();
    int r = _tc.index;
    if (r == 2) {
      if (k == "Halit155" && s == "05376835")
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const YoneticiPaneli()));
      else
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Hatalı Yönetici Bilgisi!'),
            backgroundColor: Colors.red));
      return;
    }
    if (r == 1) {
      if (k.isNotEmpty)
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => const OgretmenPaneli(aktifOgretmenId: "t1")));
      else
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kullanıcı Adı Giriniz (Demo: t1)')));
      return;
    }
    if (r == 0) {
      if (VeriDeposu.ogrenciler.any((o) => o.id == k))
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (c) => KisiselBilgiEkrani(ogrenciId: k)));
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Öğrenci Bulunamadı (Demo: 101)')));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (c) => const KisiselBilgiEkrani(ogrenciId: "101")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            backgroundColor: Colors.grey[100],
            body: Center(
                child: SingleChildScrollView(
                    child: Column(children: [
              const Icon(Icons.school, size: 80, color: Colors.indigo),
              const SizedBox(height: 20),
              const Text("BAYBURT ANADOLU\nİMAM HATİP LİSESİ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(children: [
                        TabBar(
                            controller: _tc,
                            labelColor: Colors.indigo,
                            unselectedLabelColor: Colors.grey,
                            tabs: const [
                              Tab(text: 'Öğrenci'),
                              Tab(text: 'Öğretmen'),
                              Tab(text: 'Yönetici')
                            ]),
                        const SizedBox(height: 20),
                        TextField(
                            controller: _k,
                            decoration: const InputDecoration(
                                labelText: "Kullanıcı Adı / ID",
                                border: OutlineInputBorder())),
                        const SizedBox(height: 10),
                        TextField(
                            controller: _s,
                            obscureText: _g,
                            decoration: InputDecoration(
                                labelText: "Şifre",
                                suffixIcon: IconButton(
                                    icon: Icon(_g
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () => setState(() => _g = !_g)),
                                border: const OutlineInputBorder())),
                        const SizedBox(height: 20),
                        SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: _giris,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white),
                                child: const Text("GİRİŞ YAP")))
                      ])))
            ])))));
  }
}

// ============================================================
// 3. KİŞİSEL BİLGİ EKRANI
// ============================================================
class KisiselBilgiEkrani extends StatefulWidget {
  final String ogrenciId;
  const KisiselBilgiEkrani({super.key, required this.ogrenciId});
  @override
  State<KisiselBilgiEkrani> createState() => _KisiselBilgiEkraniState();
}

class _KisiselBilgiEkraniState extends State<KisiselBilgiEkrani> {
  late TextEditingController adCtrl, sinifCtrl, noCtrl;
  String fotoUrl = "";
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    var ogr = VeriDeposu.ogrenciler.firstWhere((o) => o.id == widget.ogrenciId,
        orElse: () => VeriDeposu.ogrenciler[0]);
    adCtrl = TextEditingController(text: ogr.ad);
    sinifCtrl = TextEditingController(text: ogr.sinif);
    noCtrl = TextEditingController(text: ogr.id);
    fotoUrl = ogr.fotoUrl;
  }

  void _kaydet() {
    VeriDeposu.ogrenciGuncelle(
        widget.ogrenciId, adCtrl.text, sinifCtrl.text, noCtrl.text, fotoUrl);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Bilgiler Güncellendi!"), backgroundColor: Colors.green));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (c) => OgrenciAnaEkrani(ogrenciId: noCtrl.text)));
  }

  Future<void> _galeridenSec() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => fotoUrl = image.path);
  }

  Future<void> _kameradanCek() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) setState(() => fotoUrl = image.path);
  }

  void _secimPenceresi() {
    showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
                child: Wrap(children: [
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galeriden Seç'),
                  onTap: () {
                    _galeridenSec();
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Kamera ile Çek'),
                  onTap: () {
                    _kameradanCek();
                    Navigator.pop(context);
                  }),
            ])));
  }

  ImageProvider _resimSaglayici() {
    if (fotoUrl.isEmpty)
      return const NetworkImage(
          "https://cdn-icons-png.flaticon.com/512/3135/3135715.png");
    if (fotoUrl.startsWith('http')) return NetworkImage(fotoUrl);
    return FileImage(File(fotoUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Profil"), backgroundColor: Colors.indigo),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
                onTap: _secimPenceresi,
                child: Stack(alignment: Alignment.bottomRight, children: [
                  CircleAvatar(radius: 60, backgroundImage: _resimSaglayici()),
                  const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt,
                          size: 20, color: Colors.indigo))
                ])),
            const SizedBox(height: 20),
            TextField(
                controller: adCtrl,
                decoration: const InputDecoration(
                    labelText: "Ad Soyad",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 15),
            TextField(
                controller: sinifCtrl,
                decoration: const InputDecoration(
                    labelText: "Sınıf",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.class_))),
            const SizedBox(height: 15),
            TextField(
                controller: noCtrl,
                decoration: const InputDecoration(
                    labelText: "Okul Numarası",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers))),
            const SizedBox(height: 30),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: _kaydet, child: const Text("KAYDET VE BAŞLA")))
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 4. ÖĞRENCİ ANA EKRANI (DASHBOARD)
// ============================================================

class OgrenciAnaEkrani extends StatelessWidget {
  final String ogrenciId;
  const OgrenciAnaEkrani({super.key, required this.ogrenciId});

  ImageProvider _avatarGoster(String url) {
    if (url.isEmpty)
      return const NetworkImage(
          "https://cdn-icons-png.flaticon.com/512/3135/3135715.png");
    if (url.startsWith('http')) return NetworkImage(url);
    return FileImage(File(url));
  }

  @override
  Widget build(BuildContext context) {
    var ogr = VeriDeposu.ogrenciler.firstWhere((e) => e.id == ogrenciId,
        orElse: () => VeriDeposu.ogrenciler[0]);
    return Scaffold(
        appBar: AppBar(title: Text(ogr.ad), backgroundColor: Colors.indigo),
        drawer: Drawer(
            child: ListView(children: [
          UserAccountsDrawerHeader(
              accountName: Text(ogr.ad),
              accountEmail: Text("XP: ${ogr.puan}"),
              currentAccountPicture:
                  CircleAvatar(backgroundImage: _avatarGoster(ogr.fotoUrl))),
          ListTile(
              leading: const Icon(Icons.message),
              title: const Text("Mesajlar"),
              onTap: () {
                var m = VeriDeposu.mesajlar
                    .where((x) => x.aliciId == ogrenciId)
                    .toList();
                showDialog(
                    context: context,
                    builder: (c) => AlertDialog(
                        title: const Text("Mesajlar"),
                        content: SizedBox(
                            width: double.maxFinite,
                            height: 300,
                            child: m.isEmpty
                                ? const Text("Mesaj Yok")
                                : ListView.builder(
                                    itemCount: m.length,
                                    itemBuilder: (c, i) => ListTile(
                                        title: Text(m[i].gonderen),
                                        subtitle: Text(m[i].icerik))))));
              }),
          ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Profili Düzenle"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) =>
                            KisiselBilgiEkrani(ogrenciId: ogrenciId)));
              })
        ])),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _btn(context, Icons.verified, "ROZETLERİM", Colors.amber,
                      RozetlerEkrani(ogrenci: ogr)),
                  _btn(context, Icons.check_box, "KONU TAKİP", Colors.blue,
                      const KonuTakipEkrani()),
                  _btn(context, Icons.table_view, "PROGRAMIM", Colors.blueGrey,
                      const TumProgramEkrani()),
                  _btn(context, Icons.check_circle, "GÜNLÜK TAKİP", Colors.teal,
                      const GunlukTakipEkrani()),
                  _btn(context, Icons.auto_awesome, "AI ASİSTAN",
                      Colors.indigoAccent, const YapayZekaAsistanEkrani()),
                  _btn(context, Icons.edit_calendar, "MANUEL PROGRAM",
                      Colors.orange, const ManuelProgramEkrani()),
                  _btn(context, Icons.add_chart, "DENEME EKLE", Colors.green,
                      DenemeEkleEkrani(ogrenciId: ogrenciId)),
                  _btn(context, Icons.bar_chart, "GRAFİK", Colors.purple,
                      BasariGrafigiEkrani(ogrenciId: ogrenciId)),
                  _btn(
                      context,
                      Icons.view_list,
                      "DENEME LİSTESİ",
                      Colors.deepPurple,
                      DenemeListesiEkrani(ogrenciId: ogrenciId)),
                  _btn(context, Icons.school, "OKUL NOTLARI", Colors.brown,
                      const OkulSinavlariEkrani()),
                  _btn(context, Icons.timer, "SAYAÇ", Colors.redAccent,
                      const SinavSayaciEkrani()),
                ])));
  }

  Widget _btn(BuildContext context, IconData i, String t, Color c, Widget p) {
    return Card(
        elevation: 3,
        child: InkWell(
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (c) => p)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(
                  backgroundColor: c.withOpacity(0.1),
                  radius: 25,
                  child: Icon(i, color: c)),
              const SizedBox(height: 5),
              Text(t,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12))
            ])));
  }
}

// --- DİĞER EKRANLAR ---
class KonuTakipEkrani extends StatefulWidget {
  const KonuTakipEkrani({super.key});
  @override
  State<KonuTakipEkrani> createState() => _KonuTakipEkraniState();
}

class _KonuTakipEkraniState extends State<KonuTakipEkrani> {
  double _oran(String d) {
    var l = dersKonuAgirliklari[d]!;
    int tot = 0, cur = 0;
    for (var k in l) {
      tot += k.agirlik;
      if (VeriDeposu.tamamlananKonular["$d - ${k.ad}"] == true)
        cur += k.agirlik;
    }
    return tot == 0 ? 0 : cur / tot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text("İlerleme"), backgroundColor: Colors.blue),
        body: ListView(
            padding: const EdgeInsets.all(10),
            children: dersKonuAgirliklari.keys.map((d) {
              double r = _oran(d);
              int p = (r * 100).toInt();
              return Card(
                  child: ExpansionTile(
                      leading: CircularProgressIndicator(
                          value: r,
                          backgroundColor: Colors.grey[200],
                          color: p == 100 ? Colors.green : Colors.blue),
                      title: Text(d),
                      subtitle: Text("%$p Bitti"),
                      children: [
                    Column(
                        children: dersKonuAgirliklari[d]!
                            .map((k) => CheckboxListTile(
                                title: Text(k.ad),
                                subtitle: Text("Ağırlık: ${k.agirlik}"),
                                value: VeriDeposu
                                        .tamamlananKonular["$d - ${k.ad}"] ??
                                    false,
                                onChanged: (v) => setState(() =>
                                    VeriDeposu.konuDurumDegistir(
                                        "$d - ${k.ad}", v!))))
                            .toList())
                  ]));
            }).toList()));
  }
}

class RozetlerEkrani extends StatefulWidget {
  final Ogrenci ogrenci;
  const RozetlerEkrani({super.key, required this.ogrenci});
  @override
  State<RozetlerEkrani> createState() => _RozetlerEkraniState();
}

class _RozetlerEkraniState extends State<RozetlerEkrani>
    with SingleTickerProviderStateMixin {
  late TabController _tc;
  @override
  void initState() {
    super.initState();
    _tc = TabController(length: 3, vsync: this);
    VeriDeposu.rozetleriGuncelle();
  }

  Widget _list(String k) {
    var l = VeriDeposu.tumRozetler.where((r) => r.kategori == k).toList();
    return ListView.builder(
        itemCount: l.length,
        itemBuilder: (c, i) {
          var r = l[i];
          return Card(
              color: r.kazanildi ? Colors.white : Colors.grey[200],
              child: ListTile(
                  leading:
                      Icon(r.ikon, color: r.kazanildi ? r.renk : Colors.grey),
                  title: Text(r.ad),
                  subtitle: Text(r.aciklama),
                  trailing: r.kazanildi
                      ? const Icon(Icons.check, color: Colors.green)
                      : Text("${r.mevcutSayi}/${r.hedefSayi}")));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Puan: ${widget.ogrenci.puan}"),
            backgroundColor: Colors.amber,
            bottom: TabBar(controller: _tc, tabs: const [
              Tab(text: "Deneme"),
              Tab(text: "Konu"),
              Tab(text: "Seviye")
            ])),
        body: TabBarView(
            controller: _tc,
            children: [_list("Deneme"), _list("Konu"), _list("Seviye")]));
  }
}

// ============================================================
// 4. PROFESYONEL DENEME EKLEME (AYRIŞTIRILMIŞ)
// ============================================================
class DenemeEkleEkrani extends StatefulWidget {
  final String ogrenciId;
  const DenemeEkleEkrani({super.key, required this.ogrenciId});
  @override
  State<DenemeEkleEkrani> createState() => _DenemeEkleEkraniState();
}

class DersGiris {
  String n;
  int s;
  TextEditingController d = TextEditingController(),
      y = TextEditingController();
  double r = 0;
  DersGiris(this.n, this.s);
}

class _DenemeEkleEkraniState extends State<DenemeEkleEkrani> {
  List<DersGiris> tytTurkce = [DersGiris("Türkçe", 40)];
  List<DersGiris> tytSosyal = [
    DersGiris("Tarih", 5),
    DersGiris("Coğrafya", 5),
    DersGiris("Felsefe", 5),
    DersGiris("Din K.", 5)
  ];
  List<DersGiris> tytMat = [
    DersGiris("Matematik", 30),
    DersGiris("Geometri", 10)
  ];
  List<DersGiris> tytFen = [
    DersGiris("Fizik", 7),
    DersGiris("Kimya", 7),
    DersGiris("Biyoloji", 6)
  ];
  List<DersGiris> aytMat = [DersGiris("Matematik", 40)];
  List<DersGiris> aytFen = [
    DersGiris("Fizik", 14),
    DersGiris("Kimya", 13),
    DersGiris("Biyoloji", 13)
  ];
  List<DersGiris> aytEa = [
    DersGiris("Edebiyat", 24),
    DersGiris("Tarih-1", 10),
    DersGiris("Coğrafya-1", 6)
  ];
  List<DersGiris> aytSoz = [
    DersGiris("Tarih-2", 11),
    DersGiris("Coğrafya-2", 11),
    DersGiris("Felsefe Grb", 12),
    DersGiris("Din K.", 6)
  ];

  void _hesapla(DersGiris d) {
    double dog = double.tryParse(d.d.text.replaceAll(',', '.')) ?? 0;
    double yan = double.tryParse(d.y.text.replaceAll(',', '.')) ?? 0;
    setState(() => d.r = dog - (yan / 4));
  }

  double _topla(List<DersGiris> l) => l.fold(0, (s, i) => s + i.r);

  void _kaydet(String tur) {
    double t = 0, m = 0, f = 0, s = 0;
    if (tur == "TYT") {
      t = _topla(tytTurkce);
      s = _topla(tytSosyal);
      m = _topla(tytMat);
      f = _topla(tytFen);
    } else {
      m = _topla(aytMat);
      f = _topla(aytFen);
      t = _topla(aytEa);
      s = _topla(aytSoz);
    }
    VeriDeposu.denemeEkle(DenemeSonucu(
        ogrenciId: widget.ogrenciId,
        tur: tur,
        tarih: DateTime.now(),
        turkce: t,
        mat: m,
        fen: f,
        sos: s));
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Deneme Kaydedildi!")));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                    title: const Text("Deneme Gir"),
                    backgroundColor: Colors.green,
                    bottom: const TabBar(
                        tabs: [Tab(text: "TYT"), Tab(text: "AYT")])),
                body: TabBarView(children: [
                  _buildForm("TYT", [
                    _baslik("TÜRKÇE (40)"),
                    ...tytTurkce.map((d) => _satir(d)),
                    _baslik("SOSYAL (20)"),
                    ...tytSosyal.map((d) => _satir(d)),
                    _baslik("MATEMATİK (40)"),
                    ...tytMat.map((d) => _satir(d)),
                    _baslik("FEN (20)"),
                    ...tytFen.map((d) => _satir(d))
                  ]),
                  _buildForm("AYT", [
                    _baslik("MATEMATİK"),
                    ...aytMat.map((d) => _satir(d)),
                    _baslik("FEN BİLİMLERİ"),
                    ...aytFen.map((d) => _satir(d)),
                    _baslik("TÜRK DİLİ VE EDB - SOS-1"),
                    ...aytEa.map((d) => _satir(d)),
                    _baslik("SOSYAL BİLİMLER-2"),
                    ...aytSoz.map((d) => _satir(d))
                  ])
                ]))));
  }

  Widget _buildForm(String tur, List<Widget> children) {
    return Column(children: [
      Expanded(
          child:
              ListView(padding: const EdgeInsets.all(10), children: children)),
      ElevatedButton(onPressed: () => _kaydet(tur), child: Text("$tur KAYDET"))
    ]);
  }

  Widget _baslik(String t) => Container(
      padding: const EdgeInsets.all(8),
      color: Colors.green[50],
      child: Text(t,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green)));
  Widget _satir(DersGiris d) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              Expanded(flex: 3, child: Text(d.n)),
              Expanded(
                  child: TextField(
                      controller: d.d,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: "D"),
                      onChanged: (v) => _hesapla(d))),
              const SizedBox(width: 5),
              Expanded(
                  child: TextField(
                      controller: d.y,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: "Y"),
                      onChanged: (v) => _hesapla(d))),
              Expanded(child: Center(child: Text(d.r.toStringAsFixed(2))))
            ])));
  }
}

// ============================================================
// 5. YAPAY ZEKA ASİSTANI
// ============================================================
class YapayZekaAsistanEkrani extends StatefulWidget {
  const YapayZekaAsistanEkrani({super.key});
  @override
  State<YapayZekaAsistanEkrani> createState() => _YapayZekaAsistanEkraniState();
}

class _YapayZekaAsistanEkraniState extends State<YapayZekaAsistanEkrani>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  bool _analizYapiliyor = false;
  bool _programHazir = false;
  String secilenSinif = "12", secilenAlan = "Sayısal", tatilGunu = "Pazar";
  TimeOfDay baslangicSaati = const TimeOfDay(hour: 18, minute: 0),
      bitisSaati = const TimeOfDay(hour: 22, minute: 0);
  Map<String, bool> konuDurumlari = {};
  List<List<Map<String, dynamic>>> akilliProgramTablosu = [];
  late TabController _tabController;
  final List<String> gunler = [
    "Pazartesi",
    "Salı",
    "Çarşamba",
    "Perşembe",
    "Cuma",
    "Cumartesi",
    "Pazar"
  ];

  @override
  void initState() {
    super.initState();
    tumDerslerGlobal.forEach((ders, detay) {
      List<String> konular = detay['konular'] as List<String>;
      for (var k in konular) konuDurumlari["$ders - $k"] = true;
    });
  }

  int _hesaplaKalanHaftalar() {
    DateTime simdi = DateTime.now();
    int sinavYili = (simdi.month > 5) ? simdi.year + 1 : simdi.year;
    DateTime sinavTarihi = DateTime(sinavYili, 5, 31);
    int hafta = (sinavTarihi.difference(simdi).inDays / 7).ceil();
    return (hafta < 1) ? 1 : (hafta > 40 ? 40 : hafta);
  }

  void _yapayZekaProgramOlustur() async {
    setState(() => _analizYapiliyor = true);
    await Future.delayed(const Duration(seconds: 2));

    akilliProgramTablosu.clear();
    List<Map<String, dynamic>> havuz = [];

    bool sadeceTYT = (secilenSinif == "9" ||
        secilenSinif == "10" ||
        secilenSinif == "11" ||
        secilenAlan.contains("Sadece TYT"));
    if (!sadeceTYT && (DateTime.now().month > 1 || DateTime.now().month == 1))
      sadeceTYT = false;

    tumDerslerGlobal.forEach((dersAdi, detay) {
      bool dersUygun = false;
      if (sadeceTYT) {
        if (dersAdi.contains("TYT")) dersUygun = true;
      } else {
        if (secilenAlan == "Sayısal" &&
            (dersAdi.contains("Mat") ||
                dersAdi.contains("Fen") ||
                dersAdi.contains("TYT")))
          dersUygun = true;
        else if (secilenAlan == "Sözel" &&
            (dersAdi.contains("Edebiyat") ||
                dersAdi.contains("Sosyal") ||
                dersAdi.contains("TYT")))
          dersUygun = true;
        else if (secilenAlan == "Eşit Ağırlık" &&
            (dersAdi.contains("Mat") ||
                dersAdi.contains("Edebiyat") ||
                dersAdi.contains("Tarih") ||
                dersAdi.contains("Coğrafya") ||
                dersAdi.contains("TYT")))
          dersUygun = true;
        else
          dersUygun = true;
      }

      if (dersUygun) {
        int katsayi = detay['katsayi'] as int;
        List<String> konular = detay['konular'] as List<String>;
        for (var k in konular) {
          if (konuDurumlari["$dersAdi - $k"] == true) {
            for (int i = 0; i < katsayi; i++)
              havuz.add({'ders': dersAdi, 'konu': k});
          }
        }
      }
    });

    if (havuz.isEmpty) havuz.add({'ders': 'Tekrar', 'konu': 'Soru Çözümü'});
    havuz.shuffle();

    int baslangicDakika = baslangicSaati.hour * 60 + baslangicSaati.minute;
    int bitisDakika = bitisSaati.hour * 60 + bitisSaati.minute;
    int dersSayisi = ((bitisDakika - baslangicDakika) / 50).floor();
    if (dersSayisi < 1) dersSayisi = 1;

    int konuSayaci = 0;
    int toplamHafta = _hesaplaKalanHaftalar();

    for (int h = 0; h < toplamHafta; h++) {
      List<Map<String, dynamic>> buHafta = [];
      for (var gun in gunler) {
        if (gun == tatilGunu) {
          buHafta.add({'gun': gun, 'bloklar': []});
          continue;
        }
        List<Map<String, dynamic>> gunlukBloklar = [];
        for (int i = 0; i < dersSayisi; i++) {
          var secilen = havuz[konuSayaci % havuz.length];
          int dersBaslamaDk = baslangicDakika + (i * 50);
          String saat =
              "${(dersBaslamaDk / 60).floor().toString().padLeft(2, '0')}:${(dersBaslamaDk % 60).toString().padLeft(2, '0')}";
          gunlukBloklar.add(
              {'saat': saat, 'ders': secilen['ders'], 'konu': secilen['konu']});
          konuSayaci++;
        }
        buHafta.add({'gun': gun, 'bloklar': gunlukBloklar});
      }
      akilliProgramTablosu.add(buHafta);
    }

    _tabController = TabController(length: toplamHafta, vsync: this);
    if (mounted)
      setState(() {
        _analizYapiliyor = false;
        _programHazir = true;
      });
  }

  void _hucreyiDuzenle(int haftaIndex, int gunIndex, int blokIndex) {
    String? yeniDers = akilliProgramTablosu[haftaIndex][gunIndex]['bloklar']
        [blokIndex]['ders'];
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Dersi Değiştir"),
              content: DropdownButton<String>(
                isExpanded: true,
                value: tumDerslerGlobal.containsKey(yeniDers) ? yeniDers : null,
                items: tumDerslerGlobal.keys
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    akilliProgramTablosu[haftaIndex][gunIndex]['bloklar']
                        [blokIndex]['ders'] = v;
                    akilliProgramTablosu[haftaIndex][gunIndex]['bloklar']
                        [blokIndex]['konu'] = "Manuel Değişim";
                  });
                  Navigator.pop(context);
                },
              ),
            ));
  }

  void _kaydetVeCik() {
    VeriDeposu.programiKaydet(akilliProgramTablosu);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Program kaydedildi!"), backgroundColor: Colors.green));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_programHazir)
      return Scaffold(
        appBar: AppBar(
            title: const Text("AI Program"),
            backgroundColor: Colors.indigo,
            bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: List.generate(_tabController.length,
                    (i) => Tab(text: "${i + 1}. Hafta")))),
        body: TabBarView(
            controller: _tabController,
            children: akilliProgramTablosu
                .asMap()
                .entries
                .map((entry) => _buildHaftaTablosu(entry.key, entry.value))
                .toList()),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: _kaydetVeCik,
            label: const Text("KAYDET"),
            icon: const Icon(Icons.save)),
      );

    if (_analizYapiliyor)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
          title: const Text("AI Asistan"), backgroundColor: Colors.indigo),
      body: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 3)
              setState(() => _currentStep++);
            else
              _yapayZekaProgramOlustur();
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep--);
          },
          controlsBuilder: (ctx, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(children: [
                ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(
                        _currentStep == 3 ? "PROGRAMI HAZIRLA" : "İLERLE")),
                const SizedBox(width: 10),
                if (_currentStep > 0)
                  TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text("Geri")),
              ]),
            );
          },
          steps: [
            Step(
                title: const Text("Sınıf"),
                content: DropdownButtonFormField(
                    value: secilenSinif,
                    items: ["9", "10", "11", "12", "Mezun"]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => secilenSinif = v.toString()))),
            Step(
                title: const Text("Alan"),
                content: DropdownButtonFormField(
                    value: secilenAlan,
                    items: [
                      "Sayısal",
                      "Sözel",
                      "Eşit Ağırlık",
                      "Dil",
                      "Sadece TYT"
                    ]
                        .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => secilenAlan = v.toString()))),
            Step(
                title: const Text("Zaman"),
                content: Column(children: [
                  Row(children: [
                    TextButton(
                        onPressed: () async {
                          var t = await showTimePicker(
                              context: context, initialTime: baslangicSaati);
                          if (t != null) setState(() => baslangicSaati = t);
                        },
                        child:
                            Text("Başla: ${baslangicSaati.format(context)}")),
                    TextButton(
                        onPressed: () async {
                          var t = await showTimePicker(
                              context: context, initialTime: bitisSaati);
                          if (t != null) setState(() => bitisSaati = t);
                        },
                        child: Text("Bitir: ${bitisSaati.format(context)}"))
                  ]),
                  const Text("Tatil Günü"),
                  Wrap(
                      children: gunler
                          .map((g) => ChoiceChip(
                              label: Text(g),
                              selected: tatilGunu == g,
                              onSelected: (v) => setState(() => tatilGunu = g)))
                          .toList())
                ])),
            Step(
                title: const Text("Konu Eleme"),
                content: Container(
                    height: 300,
                    child: ListView(
                        children: konuDurumlari.keys
                            .map((key) => CheckboxListTile(
                                title: Text(key),
                                value: konuDurumlari[key],
                                onChanged: (v) =>
                                    setState(() => konuDurumlari[key] = v!)))
                            .toList())))
          ]),
    );
  }

  Widget _buildHaftaTablosu(
      int haftaIndex, List<Map<String, dynamic>> haftaVerisi) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns: const [
                  DataColumn(label: Text("GÜN")),
                  DataColumn(label: Text("DERS 1")),
                  DataColumn(label: Text("DERS 2")),
                  DataColumn(label: Text("DERS 3")),
                  DataColumn(label: Text("DERS 4"))
                ],
                rows: haftaVerisi.asMap().entries.map((gunEntry) {
                  var gun = gunEntry.value;
                  List bloklar = gun['bloklar'];
                  if (bloklar.isEmpty)
                    return DataRow(cells: [
                      DataCell(Text(gun['gun'],
                          style: const TextStyle(color: Colors.red))),
                      const DataCell(Text("TATİL")),
                      const DataCell(Text("-")),
                      const DataCell(Text("-")),
                      const DataCell(Text("-"))
                    ]);
                  List<DataCell> cells = [
                    DataCell(Text(gun['gun'],
                        style: const TextStyle(fontWeight: FontWeight.bold)))
                  ];
                  for (int i = 0; i < 4; i++) {
                    if (i < bloklar.length)
                      cells.add(DataCell(InkWell(
                          onTap: () =>
                              _hucreyiDuzenle(haftaIndex, gunEntry.key, i),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bloklar[i]['ders'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                                Text(bloklar[i]['konu'],
                                    style: const TextStyle(fontSize: 10))
                              ]))));
                    else
                      cells.add(const DataCell(Text("-")));
                  }
                  return DataRow(cells: cells);
                }).toList())));
  }
}

// ============================================================
// 6. MANUEL PROGRAMLAMA (FULL STEPPER)
// ============================================================
class ManuelProgramEkrani extends StatefulWidget {
  const ManuelProgramEkrani({super.key});
  @override
  State<ManuelProgramEkrani> createState() => _ManuelProgramEkraniState();
}

class _ManuelProgramEkraniState extends State<ManuelProgramEkrani>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  bool _hazir = false;
  double sure = 8;
  TimeOfDay basla = const TimeOfDay(hour: 18, minute: 0),
      bitis = const TimeOfDay(hour: 22, minute: 0);
  String secilenAlan = "Sayısal", tatil = "Pazar";
  Map<String, bool> sec = {};
  List<List<Map<String, dynamic>>> tb = [];
  late TabController _tc;
  final List<String> gunler = [
    "Pazartesi",
    "Salı",
    "Çarşamba",
    "Perşembe",
    "Cuma",
    "Cumartesi",
    "Pazar"
  ];

  @override
  void initState() {
    super.initState();
    tumDerslerGlobal.forEach((k, v) => sec[k] = true);
  }

  void _olustur() {
    tb.clear();
    List<Map<String, dynamic>> hz = [];
    sec.forEach((k, v) {
      if (v)
        for (var c in tumDerslerGlobal[k]!['konular'])
          hz.add({'ders': k, 'konu': c});
    });
    hz.shuffle();
    int ds =
        ((bitis.hour * 60 + bitis.minute) - (basla.hour * 60 + basla.minute)) ~/
            50;
    if (ds < 1) ds = 1;
    int cnt = 0;
    for (int i = 0; i < sure; i++) {
      List<Map<String, dynamic>> w = [];
      for (var g in gunler) {
        List<Map<String, dynamic>> bl = [];
        if (g != tatil) {
          for (int k = 0; k < ds; k++) {
            var s = hz[cnt % hz.length];
            bl.add({
              'saat': '${basla.hour + k}:00',
              'ders': s['ders'],
              'konu': s['konu']
            });
            cnt++;
          }
        }
        w.add({'gun': g, 'bloklar': bl});
      }
      tb.add(w);
    }
    _tc = TabController(length: sure.toInt(), vsync: this);
    setState(() => _hazir = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_hazir)
      return Scaffold(
          appBar: AppBar(
              title: const Text("Manuel Sonuç"),
              backgroundColor: Colors.orange,
              bottom: TabBar(
                  controller: _tc,
                  isScrollable: true,
                  tabs: List.generate(
                      tb.length, (i) => Tab(text: "${i + 1}.H")))),
          body: TabBarView(
              controller: _tc,
              children: tb
                  .map((w) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          columns: const [
                            DataColumn(label: Text("GÜN")),
                            DataColumn(label: Text("DERSLER"))
                          ],
                          rows: w
                              .map((g) => DataRow(cells: [
                                    DataCell(Text(g['gun'])),
                                    DataCell(Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: (g['bloklar'] as List)
                                            .map((b) => Text(
                                                "${b['saat']} ${b['ders']}-${b['konu']}",
                                                style: const TextStyle(
                                                    fontSize: 10)))
                                            .toList()))
                                  ]))
                              .toList())))
                  .toList()),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                VeriDeposu.programiKaydet(tb);
                Navigator.pop(context);
              },
              child: const Icon(Icons.save)));

    return Scaffold(
      appBar: AppBar(
          title: const Text("Manuel Program"), backgroundColor: Colors.orange),
      body: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2)
              setState(() => _currentStep++);
            else
              _olustur();
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep--);
          },
          steps: [
            Step(
                title: const Text("Zaman"),
                content: Column(children: [
                  Slider(
                      value: sure,
                      min: 1,
                      max: 20,
                      onChanged: (v) => setState(() => sure = v)),
                  Text("${sure.toInt()} Hafta"),
                  Wrap(
                      children: gunler
                          .map((g) => ChoiceChip(
                              label: Text(g),
                              selected: tatil == g,
                              onSelected: (v) => setState(() => tatil = g)))
                          .toList())
                ])),
            Step(
                title: const Text("Dersler"),
                content: Container(
                    height: 300,
                    child: ListView(
                        children: sec.keys
                            .map((k) => CheckboxListTile(
                                title: Text(k),
                                value: sec[k],
                                onChanged: (v) => setState(() => sec[k] = v!)))
                            .toList()))),
            Step(
                title: const Text("Tamamla"),
                content: const Text("Hazırla butonuna bas."))
          ]),
    );
  }
}

// ============================================================
// 7. DİĞER EKRANLAR
// ============================================================
class TumProgramEkrani extends StatefulWidget {
  const TumProgramEkrani({super.key});
  @override
  State<TumProgramEkrani> createState() => _TumProgramEkraniState();
}

class _TumProgramEkraniState extends State<TumProgramEkrani>
    with SingleTickerProviderStateMixin {
  late TabController _tc;
  int len = 0;
  @override
  void initState() {
    super.initState();
    if (VeriDeposu.kayitliProgram.isNotEmpty)
      len = VeriDeposu.kayitliProgram.map((e) => e.hafta).reduce(max);
    _tc = TabController(length: len == 0 ? 1 : len, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (len == 0)
      return Scaffold(
          appBar: AppBar(title: const Text("Program")),
          body: const Center(child: Text("Kayıtlı Program Yok")));
    return Scaffold(
        appBar: AppBar(
            title: const Text("Çizelge"),
            backgroundColor: Colors.blueGrey,
            bottom: TabBar(
                controller: _tc,
                isScrollable: true,
                tabs: List.generate(len, (i) => Tab(text: "${i + 1}.H")))),
        body: TabBarView(
            controller: _tc,
            children: List.generate(len, (i) {
              int h = i + 1;
              var list =
                  VeriDeposu.kayitliProgram.where((x) => x.hafta == h).toList();
              return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      columns: const [
                        DataColumn(label: Text("GÜN")),
                        DataColumn(label: Text("DERSLER"))
                      ],
                      rows: [
                        "Pazartesi",
                        "Salı",
                        "Çarşamba",
                        "Perşembe",
                        "Cuma",
                        "Cumartesi",
                        "Pazar"
                      ].map((g) {
                        var dersler = list.where((x) => x.gun == g).toList();
                        return DataRow(cells: [
                          DataCell(Text(g)),
                          DataCell(Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: dersler
                                  .map((d) => Text(
                                      "${d.saat} ${d.ders} (${d.konu})",
                                      style: const TextStyle(fontSize: 12)))
                                  .toList()))
                        ]);
                      }).toList()));
            })));
  }
}

class GunlukTakipEkrani extends StatefulWidget {
  const GunlukTakipEkrani({super.key});
  @override
  State<GunlukTakipEkrani> createState() => _GunlukTakipEkraniState();
}

class _GunlukTakipEkraniState extends State<GunlukTakipEkrani> {
  int h = 1, maxH = 1;
  String bugun = "";
  @override
  void initState() {
    super.initState();
    if (VeriDeposu.kayitliProgram.isNotEmpty)
      maxH = VeriDeposu.kayitliProgram.map((e) => e.hafta).reduce(max);
    bugun = [
      "",
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar"
    ][DateTime.now().weekday];
  }

  @override
  Widget build(BuildContext context) {
    var list = VeriDeposu.kayitliProgram
        .where((x) => x.hafta == h && x.gun == bugun)
        .toList();
    return Scaffold(
        appBar:
            AppBar(title: Text("Bugün: $bugun"), backgroundColor: Colors.teal),
        body: Column(children: [
          DropdownButton<int>(
              value: h,
              items: List.generate(
                  maxH,
                  (i) => DropdownMenuItem(
                      value: i + 1, child: Text("${i + 1}. Hafta"))),
              onChanged: (v) => setState(() => h = v!)),
          Expanded(
              child: list.isEmpty
                  ? const Center(child: Text("Bugün ders yok."))
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (c, i) {
                        var g = list[i];
                        return CheckboxListTile(
                            title: Text(g.ders),
                            subtitle: Text(g.konu),
                            value: g.yapildi,
                            onChanged: (v) => setState(() => g.yapildi = v!));
                      }))
        ]));
  }
}

class OkulSinavlariEkrani extends StatefulWidget {
  const OkulSinavlariEkrani({super.key});
  @override
  State<OkulSinavlariEkrani> createState() => _OkulSinavlariEkraniState();
}

class _OkulSinavlariEkraniState extends State<OkulSinavlariEkrani> {
  void _ekle() {
    TextEditingController t = TextEditingController();
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
                title: const Text("Ekle"),
                content: TextField(controller: t),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        VeriDeposu.dersEkle(t.text);
                        setState(() {});
                        Navigator.pop(c);
                      },
                      child: const Text("OK"))
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Okul Notları"), backgroundColor: Colors.brown),
        body: ListView.builder(
            itemCount: VeriDeposu.okulNotlari.length,
            itemBuilder: (c, i) {
              var d = VeriDeposu.okulNotlari[i];
              return ListTile(
                  title: Text(d.ad),
                  trailing: Text(d.ortalama.toStringAsFixed(0)),
                  onTap: () {});
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: _ekle, child: const Icon(Icons.add)));
  }
}

class BasariGrafigiEkrani extends StatelessWidget {
  final String ogrenciId;
  const BasariGrafigiEkrani({super.key, required this.ogrenciId});
  @override
  Widget build(BuildContext context) {
    var l = VeriDeposu.denemeListesi
        .where((d) => d.ogrenciId == ogrenciId && d.tur == "TYT")
        .toList();
    if (l.length > 5) l = l.sublist(l.length - 5);
    return Scaffold(
        appBar: AppBar(
            title: const Text("Grafik (TYT)"), backgroundColor: Colors.purple),
        body: l.isEmpty
            ? const Center(child: Text("Veri Yok"))
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: l
                        .map((d) => Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(d.toplam.toStringAsFixed(1)),
                                  Container(
                                      width: 30,
                                      height: (d.toplam / 120) * 300,
                                      color: Colors.purple),
                                  Text("${d.tarih.day}/${d.tarih.month}")
                                ]))
                        .toList())));
  }
}

class DenemeListesiEkrani extends StatelessWidget {
  final String? ogrenciId;
  const DenemeListesiEkrani({super.key, this.ogrenciId});
  @override
  Widget build(BuildContext context) {
    var l = ogrenciId != null
        ? VeriDeposu.denemeListesi
            .where((d) => d.ogrenciId == ogrenciId)
            .toList()
        : VeriDeposu.denemeListesi;
    return Scaffold(
        appBar: AppBar(
            title: const Text("Denemeler"), backgroundColor: Colors.deepPurple),
        body: ListView.builder(
            itemCount: l.length,
            itemBuilder: (c, i) => Card(
                child: ListTile(
                    title: Text(l[i].tur),
                    subtitle: Text("Net: ${l[i].toplam}"),
                    trailing: Text("${l[i].tarih.day}/${l[i].tarih.month}")))));
  }
}

class SinavSayaciEkrani extends StatefulWidget {
  const SinavSayaciEkrani({super.key});
  @override
  State<SinavSayaciEkrani> createState() => _SinavSayaciEkraniState();
}

class _SinavSayaciEkraniState extends State<SinavSayaciEkrani> {
  Duration f = Duration.zero;
  @override
  void initState() {
    super.initState();
    Timer.periodic(
        const Duration(seconds: 1),
        (t) => setState(() => f = DateTime(
                DateTime.now().year + (DateTime.now().month > 6 ? 1 : 0), 6, 15)
            .difference(DateTime.now())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.redAccent,
        appBar: AppBar(
            title: const Text("Sayaç"),
            backgroundColor: Colors.redAccent,
            elevation: 0),
        body: Center(
            child: Text("${f.inDays} Gün",
                style: const TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));
  }
}

class YoneticiPaneli extends StatelessWidget {
  const YoneticiPaneli({super.key});
  void _excel(BuildContext c) async {
    String s = await VeriDeposu.excelDenemeYukle();
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(s)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                title: const Text("Yönetici"),
                backgroundColor: Colors.red,
                bottom: const TabBar(tabs: [
                  Tab(text: "İşlem"),
                  Tab(text: "Atama"),
                  Tab(text: "Liste")
                ])),
            body: TabBarView(children: [
              Column(children: [
                ElevatedButton(
                    onPressed: () => _excel(context),
                    child: const Text("Excel Yükle")),
                const Text("Excel Formatı: [0]No [1]Tür [2]Tr [3]Mat...")
              ]),
              ListView(
                  children: VeriDeposu.ogrenciler
                      .map((o) => ListTile(
                          title: Text(o.ad),
                          subtitle: Text("Atanan: ${o.atananOgretmenId}")))
                      .toList()),
              ListView(
                  children: VeriDeposu.ogrenciler
                      .map((o) => ListTile(
                          title: Text(o.ad), trailing: Text("${o.puan} P")))
                      .toList())
            ])));
  }
}

class OgretmenPaneli extends StatelessWidget {
  final String aktifOgretmenId;
  const OgretmenPaneli({super.key, required this.aktifOgretmenId});
  @override
  Widget build(BuildContext context) {
    var l = VeriDeposu.ogrenciler
        .where((o) => o.atananOgretmenId == aktifOgretmenId)
        .toList();
    return Scaffold(
        appBar: AppBar(
            title: const Text("Öğretmen Paneli"), backgroundColor: Colors.teal),
        body: ListView.builder(
            itemCount: l.length,
            itemBuilder: (c, i) => ListTile(
                title: Text(l[i].ad),
                subtitle: Text(l[i].sinif),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) =>
                            OgrenciAnaEkrani(ogrenciId: l[i].id))))));
  }
}
