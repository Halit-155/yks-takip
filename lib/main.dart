import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// ============================================================
// 1. GLOBAL VERİ DEPOSU VE MODELLER
// ============================================================

class VeriDeposu {
  static List<Gorev> kayitliProgram = [];
  static List<DenemeSonucu> denemeListesi = [];

  // Örnek Öğrenci Verileri
  static List<Ogrenci> ogrenciler = [
    Ogrenci(
        id: "101",
        ad: "Ahmet Yılmaz",
        sinif: "12",
        puan: 1250,
        atananOgretmenId: "t1"),
    Ogrenci(
        id: "102",
        ad: "Ayşe Demir",
        sinif: "12",
        puan: 2400,
        atananOgretmenId: "t1"),
  ];

  static List<Ogretmen> ogretmenler = [
    Ogretmen(id: "t1", ad: "Mustafa Hoca", brans: "Matematik"),
  ];

  static List<Mesaj> mesajlar = [];
  static List<Rozet> tumRozetler = [];

  // Okul Dersleri (Varsayılan)
  static List<OkulDersi> okulNotlari = [
    OkulDersi(ad: "Kur'an-ı Kerim", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Arapça", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Matematik", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Türk Dili ve Edb.", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Tarih", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Coğrafya", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Felsefe", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Fizik", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Kimya", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "Biyoloji", yazili1: 0, yazili2: 0, performans: 0),
    OkulDersi(ad: "İngilizce", yazili1: 0, yazili2: 0, performans: 0),
  ];

  static Map<String, bool> tamamlananKonular = {};

  // --- BAŞLANGIÇTA ROZETLERİ OLUŞTUR ---
  static void baslat() {
    if (tumRozetler.isNotEmpty) return;
    for (int i = 5; i <= 100; i += 5) {
      tumRozetler.add(Rozet(
          id: "deneme_$i",
          ad: "$i. Deneme",
          aciklama: "$i deneme tamamladın!",
          kategori: "Deneme",
          puanDegeri: i * 2,
          ikon: Icons.edit,
          renk: Colors.blue,
          hedefSayi: i,
          mevcutSayi: 0));
    }
    tumRozetler.add(Rozet(
        id: "konu_10",
        ad: "Başlangıç",
        aciklama: "10 Konu bitti.",
        kategori: "Konu",
        puanDegeri: 50,
        ikon: Icons.book,
        renk: Colors.green,
        hedefSayi: 10,
        mevcutSayi: 0));
    tumRozetler.add(Rozet(
        id: "konu_50",
        ad: "Yarıladık",
        aciklama: "50 Konu bitti.",
        kategori: "Konu",
        puanDegeri: 200,
        ikon: Icons.library_books,
        renk: Colors.teal,
        hedefSayi: 50,
        mevcutSayi: 0));
    tumRozetler.add(Rozet(
        id: "puan_1000",
        ad: "Hırslı",
        aciklama: "1000 Puan.",
        kategori: "Seviye",
        puanDegeri: 0,
        ikon: Icons.star,
        renk: Colors.orange,
        hedefSayi: 1000,
        mevcutSayi: 0));
    tumRozetler.add(Rozet(
        id: "puan_5000",
        ad: "Efsane",
        aciklama: "5000 Puan.",
        kategori: "Seviye",
        puanDegeri: 0,
        ikon: Icons.diamond,
        renk: Colors.red,
        hedefSayi: 5000,
        mevcutSayi: 0));
  }

  static void puanEkle(String ogrId, int miktar) {
    var o = ogrenciler.firstWhere((e) => e.id == ogrId,
        orElse: () => ogrenciler[0]);
    o.puan += miktar;
    _rozetleriGuncelle();
  }

  static void _rozetleriGuncelle() {
    int denemeSayisi = denemeListesi.length;
    int bitenKonu = tamamlananKonular.values.where((e) => e).length;
    int puan = ogrenciler[0].puan;

    for (var r in tumRozetler) {
      if (r.kategori == "Deneme") r.mevcutSayi = denemeSayisi;
      if (r.kategori == "Konu") r.mevcutSayi = bitenKonu;
      if (r.kategori == "Seviye") r.mevcutSayi = puan;
      if (r.mevcutSayi >= r.hedefSayi && !r.kazanildi) {
        r.kazanildi = true;
        puanEkle("101", r.puanDegeri);
      }
    }
  }

  static void programiKaydet(List<List<Map<String, dynamic>>> tabloVerisi) {
    kayitliProgram.clear();
    for (int i = 0; i < tabloVerisi.length; i++) {
      var hafta = tabloVerisi[i];
      int hNo = i + 1;
      for (var gun in hafta) {
        String gAd = gun['gun'];
        List blk = gun['bloklar'];
        for (var b in blk) {
          kayitliProgram.add(Gorev(
              hafta: hNo,
              gun: gAd,
              saat: b['saat'],
              ders: b['ders'],
              konu: b['konu']));
        }
      }
    }
    puanEkle("101", 100);
  }

  static void dersEkle(String ad) {
    if (!okulNotlari.any((d) => d.ad == ad))
      okulNotlari.add(OkulDersi(ad: ad, yazili1: 0, yazili2: 0, performans: 0));
  }

  static void dersSil(int index) {
    okulNotlari.removeAt(index);
  }

  static void denemeEkle(DenemeSonucu d) {
    denemeListesi.add(d);
    puanEkle("101", 20);
    _rozetleriGuncelle();
  }

  static void konuDurumDegistir(String k, bool v) {
    tamamlananKonular[k] = v;
    if (v) puanEkle("101", 10);
    _rozetleriGuncelle();
  }

  static void mesajGonder(String g, String a, String i) {
    mesajlar
        .add(Mesaj(gonderen: g, aliciId: a, icerik: i, tarih: DateTime.now()));
  }
}

// --- MODELLER ---
class Ogrenci {
  String id, ad, sinif;
  int puan;
  String? atananOgretmenId;
  Ogrenci(
      {required this.id,
      required this.ad,
      required this.sinif,
      required this.puan,
      this.atananOgretmenId});
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
  String tur;
  DateTime tarih;
  double t, m, f, s, toplam;
  DenemeSonucu(
      {required this.tur,
      required this.tarih,
      required this.t,
      required this.m,
      required this.f,
      required this.s})
      : toplam = t + m + f + s;
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

// AĞIRLIKLI KONULAR VE DERSLER
final Map<String, List<KonuDetay>> dersKonuAgirliklari = {
  "TYT Matematik": [
    KonuDetay("Temel Kavramlar", 3),
    KonuDetay("Sayı Basamakları", 1),
    KonuDetay("Bölme-Bölünebilme", 1),
    KonuDetay("EBOB-EKOK", 2),
    KonuDetay("Rasyonel Sayılar", 1),
    KonuDetay("Üslü Sayılar", 2),
    KonuDetay("Köklü Sayılar", 2),
    KonuDetay("Problemler", 10),
    KonuDetay("Kümeler", 1),
    KonuDetay("Fonksiyonlar", 3),
    KonuDetay("Polinomlar", 2),
    KonuDetay("PKOB", 2)
  ],
  "TYT Türkçe": [
    KonuDetay("Sözcükte Anlam", 2),
    KonuDetay("Cümlede Anlam", 2),
    KonuDetay("Paragraf", 15),
    KonuDetay("Ses Bilgisi", 1),
    KonuDetay("Yazım Kuralları", 2),
    KonuDetay("Noktalama", 2),
    KonuDetay("Dil Bilgisi", 3)
  ],
  "TYT Fen": [
    KonuDetay("Fizik Bilimine Giriş", 1),
    KonuDetay("Madde ve Özellikleri", 1),
    KonuDetay("Hareket ve Kuvvet", 3),
    KonuDetay("İş Güç Enerji", 3),
    KonuDetay("Isı ve Sıcaklık", 3),
    KonuDetay("Optik", 5),
    KonuDetay("Atom", 2),
    KonuDetay("Kimyasal Türler", 2),
    KonuDetay("Hücre", 2),
    KonuDetay("Canlılar", 2)
  ],
  "TYT Sosyal": [
    KonuDetay("Tarih Bilimi", 1),
    KonuDetay("İlk Çağ", 1),
    KonuDetay("Türk Tarihi", 2),
    KonuDetay("Osmanlı", 3),
    KonuDetay("Milli Mücadele", 3),
    KonuDetay("Coğrafi Konum", 2),
    KonuDetay("İklim", 2),
    KonuDetay("Felsefe", 2),
    KonuDetay("Din", 2)
  ],
  "AYT Matematik": [
    KonuDetay("Trigonometri", 5),
    KonuDetay("Logaritma", 3),
    KonuDetay("Diziler", 2),
    KonuDetay("Limit", 3),
    KonuDetay("Türev", 8),
    KonuDetay("İntegral", 8)
  ],
  "AYT Fen": [
    KonuDetay("Vektörler", 2),
    KonuDetay("Elektrik", 5),
    KonuDetay("Modern Fizik", 3),
    KonuDetay("Gazlar", 3),
    KonuDetay("Organik Kimya", 6),
    KonuDetay("Sistemler", 6),
    KonuDetay("Bitki Biyolojisi", 3)
  ],
  "AYT Edebiyat-Sosyal": [
    KonuDetay("Şiir Bilgisi", 3),
    KonuDetay("Divan Edebiyatı", 5),
    KonuDetay("Tanzimat", 3),
    KonuDetay("Cumhuriyet", 6),
    KonuDetay("Tarih", 4),
    KonuDetay("Coğrafya", 4)
  ]
};

final Map<String, Map<String, dynamic>> tumDerslerGlobal = {
  "TYT Türkçe": {
    "katsayi": 40,
    "konular": ["Sözcükte Anlam", "Paragraf", "Dil Bilgisi", "Yazım-Noktalama"]
  },
  "TYT Matematik": {
    "katsayi": 40,
    "konular": [
      "Temel Kavramlar",
      "Problemler",
      "Fonksiyonlar",
      "PKOB",
      "Üslü-Köklü"
    ]
  },
  "TYT Fen": {
    "katsayi": 20,
    "konular": ["Fizik Bilimi", "Hareket", "Atom", "Hücre", "Canlılar"]
  },
  "TYT Sosyal": {
    "katsayi": 20,
    "konular": [
      "Tarih Bilimi",
      "Milli Mücadele",
      "Coğrafi Konum",
      "Felsefe",
      "Din"
    ]
  },
  "AYT Matematik": {
    "katsayi": 40,
    "konular": ["Trigonometri", "Logaritma", "Limit", "Türev", "İntegral"]
  },
  "AYT Fen": {
    "katsayi": 40,
    "konular": ["Elektrik", "Organik Kimya", "Sistemler", "Bitki Biyolojisi"]
  },
  "AYT Edebiyat-Sosyal": {
    "katsayi": 40,
    "konular": ["Divan Edebiyatı", "Cumhuriyet Dönemi", "Tarih", "Coğrafya"]
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
    // Yönetici
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
    // Öğretmen
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
    // Öğrenci
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => const OgrenciAnaEkrani(ogrenciId: "101")));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: SizedBox(
              height: size.height,
              child: Stack(children: [
                Container(
                    height: size.height * 0.4,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xFF1A237E), Color(0xFF3949AB)]),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(60)))),
                SingleChildScrollView(
                    child: Column(children: [
                  const SizedBox(height: 60),
                  const Icon(Icons.school, size: 80, color: Colors.white),
                  const SizedBox(height: 10),
                  const Text("BAYBURT ANADOLU\nİMAM HATİP LİSESİ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1)),
                  const Text("YKS Takip Platformu",
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 30),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 20,
                                    offset: const Offset(0, 10))
                              ]),
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: TabBar(
                                        controller: _tc,
                                        indicator: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: Colors.indigo),
                                        labelColor: Colors.white,
                                        unselectedLabelColor: Colors.grey,
                                        labelStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        tabs: const [
                                          Tab(text: 'Öğrenci'),
                                          Tab(text: 'Öğretmen'),
                                          Tab(text: 'Yönetici')
                                        ]))),
                            Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(children: [
                                  TextField(
                                      controller: _k,
                                      decoration: const InputDecoration(
                                          labelText: "Kullanıcı Adı / ID",
                                          prefixIcon: Icon(Icons.person),
                                          border: OutlineInputBorder())),
                                  const SizedBox(height: 20),
                                  TextField(
                                      controller: _s,
                                      obscureText: _g,
                                      decoration: InputDecoration(
                                          labelText: "Şifre",
                                          prefixIcon: Icon(Icons.lock),
                                          suffixIcon: IconButton(
                                              icon: Icon(_g
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                              onPressed: () =>
                                                  setState(() => _g = !_g)),
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
                                ]))
                          ]))),
                ]))
              ]))),
    );
  }
}

// ============================================================
// 3. ÖĞRENCİ PANELİ
// ============================================================

class OgrenciAnaEkrani extends StatelessWidget {
  final String ogrenciId;
  const OgrenciAnaEkrani({super.key, required this.ogrenciId});
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
                  const CircleAvatar(child: Icon(Icons.person))),
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
                      const DenemeEkleEkrani()),
                  _btn(context, Icons.bar_chart, "GRAFİK", Colors.purple,
                      const BasariGrafigiEkrani()),
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
    VeriDeposu._rozetleriGuncelle();
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

class DenemeEkleEkrani extends StatefulWidget {
  const DenemeEkleEkrani({super.key});
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
  List<DersGiris> tyt = [
    DersGiris("Türkçe", 40),
    DersGiris("Sosyal", 20),
    DersGiris("Matematik", 40),
    DersGiris("Fen", 20)
  ];
  List<DersGiris> ayt = [
    DersGiris("Matematik", 40),
    DersGiris("Fen", 40),
    DersGiris("Edb-Sos1", 40),
    DersGiris("Sos-2", 40)
  ];

  void _hesapla(DersGiris d) {
    double dog = double.tryParse(d.d.text.replaceAll(',', '.')) ?? 0;
    double yan = double.tryParse(d.y.text.replaceAll(',', '.')) ?? 0;
    setState(() => d.r = dog - (yan / 4));
  }

  void _kaydet(String tur, List<DersGiris> l) {
    double t = 0, m = 0, f = 0, s = 0;
    if (tur == "TYT") {
      t = l[0].r;
      s = l[1].r;
      m = l[2].r;
      f = l[3].r;
    } else {
      m = l[0].r;
      f = l[1].r;
      t = l[2].r;
      s = l[3].r;
    }
    VeriDeposu.denemeEkle(
        DenemeSonucu(tur: tur, tarih: DateTime.now(), t: t, m: m, f: f, s: s));
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Kaydedildi")));
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
                body: TabBarView(
                    children: [_form("TYT", tyt), _form("AYT", ayt)]))));
  }

  Widget _form(String t, List<DersGiris> l) {
    return Column(children: [
      Expanded(
          child: ListView(
              children: l
                  .map((d) => Card(
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(children: [
                            Expanded(flex: 3, child: Text("${d.n} (${d.s})")),
                            Expanded(
                                child: TextField(
                                    controller: d.d,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration:
                                        const InputDecoration(labelText: "D"),
                                    onChanged: (v) => _hesapla(d))),
                            const SizedBox(width: 5),
                            Expanded(
                                child: TextField(
                                    controller: d.y,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration:
                                        const InputDecoration(labelText: "Y"),
                                    onChanged: (v) => _hesapla(d))),
                            Expanded(
                                child:
                                    Center(child: Text(d.r.toStringAsFixed(2))))
                          ]))))
                  .toList())),
      ElevatedButton(
          onPressed: () => _kaydet(t, l), child: const Text("KAYDET"))
    ]);
  }
}

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
    int y = DateTime.now().year + (DateTime.now().month > 6 ? 1 : 0);
    return (DateTime(y, 6, 15).difference(DateTime.now()).inDays / 7)
        .ceil()
        .clamp(1, 40);
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
    int dersSayisi = ((bitisSaati.hour * 60 + bitisSaati.minute) -
            (baslangicSaati.hour * 60 + baslangicSaati.minute)) ~/
        50;
    if (dersSayisi < 1) dersSayisi = 1;
    int konuSayaci = 0, toplamHafta = _hesaplaKalanHaftalar();

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
          int dk =
              (baslangicSaati.hour * 60 + baslangicSaati.minute) + (i * 50);
          gunlukBloklar.add({
            'saat': "${dk ~/ 60}:${(dk % 60).toString().padLeft(2, '0')}",
            'ders': secilen['ders'],
            'konu': secilen['konu']
          });
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
                title: const Text("Değiştir"),
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
                            [blokIndex]['konu'] = "Manuel";
                      });
                      Navigator.pop(context);
                    }),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("İptal"))
                ]));
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
                  tabs: List.generate(
                      _tabController.length, (i) => Tab(text: "${i + 1}.H")))),
          body: TabBarView(
              controller: _tabController,
              children: akilliProgramTablosu
                  .asMap()
                  .entries
                  .map((entry) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          columns: const [
                            DataColumn(label: Text("GÜN")),
                            DataColumn(label: Text("DERS 1")),
                            DataColumn(label: Text("DERS 2")),
                            DataColumn(label: Text("DERS 3")),
                            DataColumn(label: Text("DERS 4"))
                          ],
                          rows: entry.value.map((gun) {
                            List blk = gun['bloklar'];
                            return DataRow(cells: [
                              DataCell(Text(gun['gun'])),
                              ...List.generate(
                                  4,
                                  (i) => i < blk.length
                                      ? DataCell(InkWell(
                                          onTap: () => _hucreyiDuzenle(
                                              entry.key,
                                              entry.value.indexOf(gun),
                                              i),
                                          child: Text(
                                              "${blk[i]['ders']}\n${blk[i]['konu']}",
                                              style: const TextStyle(
                                                  fontSize: 10))))
                                      : const DataCell(Text("-")))
                            ]);
                          }).toList())))
                  .toList()),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                VeriDeposu.programiKaydet(akilliProgramTablosu);
                Navigator.pop(context);
              },
              child: const Icon(Icons.save)));
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
            steps: [
              Step(
                  title: const Text("Sınıf"),
                  content: DropdownButtonFormField(
                      value: secilenSinif,
                      items: ["9", "10", "11", "12", "Mezun"]
                          .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)))
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
                          .map(
                              (a) => DropdownMenuItem(value: a, child: Text(a)))
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
                    const Text("Tatil"),
                    Wrap(
                        children: gunler
                            .map((g) => ChoiceChip(
                                label: Text(g),
                                selected: tatilGunu == g,
                                onSelected: (v) =>
                                    setState(() => tatilGunu = g)))
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
            ]));
  }
}

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
  String tatil = "Pazar";
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
              title: const Text("Manuel"),
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
                                        children: (g['bloklar'] as List)
                                            .map((b) => Text(
                                                "${b['saat']} ${b['ders']}-${b['konu']}"))
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
            title: const Text("Manuel Program"),
            backgroundColor: Colors.orange),
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
                    Text("${sure.toInt()} Hafta")
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
                                  onChanged: (v) =>
                                      setState(() => sec[k] = v!)))
                              .toList()))),
              Step(title: const Text("Bitti"), content: const Text("Hazırla."))
            ]));
  }
}

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
  const BasariGrafigiEkrani({super.key});
  @override
  Widget build(BuildContext context) {
    var l = VeriDeposu.denemeListesi.where((d) => d.tur == "TYT").toList();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text("Yönetici"), backgroundColor: Colors.red),
        body: ListView(
            children: VeriDeposu.ogrenciler
                .map((o) => ListTile(
                    title: Text(o.ad), subtitle: Text("Puan: ${o.puan}")))
                .toList()));
  }
}

class OgretmenPaneli extends StatelessWidget {
  final String aktifOgretmenId;
  const OgretmenPaneli({super.key, required this.aktifOgretmenId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Öğretmen Paneli")),
        body: const Center(child: Text("Öğrenci Listesi")));
  }
}
