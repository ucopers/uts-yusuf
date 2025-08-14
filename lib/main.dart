// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

// ==================================
// MODEL DATA (Tidak ada perubahan)
// ==================================
class Menu {
  final String gambar;
  final String nama;
  final double harga;
  Menu({required this.gambar, required this.nama, required this.harga});
}

class Pesanan {
  final Menu menu;
  int jumlah;
  Pesanan({required this.menu, this.jumlah = 1});
}

// ==================================
// FUNGSI main() (Tidak ada perubahan)
// ==================================
void main() {
  runApp(const MyApp());
}

// ==================================
// WIDGET UTAMA APLIKASI
// ==================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pemesanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF57F17),
          primary: const Color(0xFFF57F17),
          secondary: const Color(0xFFFFB300),
          surface: const Color(0xFFFFF8E1),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: MenuScreen(),
    );
  }
}

// ==================================
// LAYAR MENU
// ==================================
class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<Menu> daftarMenu = [
    Menu(gambar: "sate_padang.png", nama: "Sate Padang", harga: 25000),
    Menu(gambar: "nasi_goreng.png", nama: "Nasi Goreng Spesial", harga: 22000),
    Menu(gambar: "mie_ayam.png", nama: "Mie Ayam Bakso", harga: 18000),
    Menu(gambar: "jus_jeruk.png", nama: "Jus Jeruk", harga: 10000),
  ];

  final List<Pesanan> daftarPesanan = [];

  void tambahKePesanan(Menu menu) {
    setState(() {
      final index =
          daftarPesanan.indexWhere((pesanan) => pesanan.menu.nama == menu.nama);
      if (index != -1) {
        daftarPesanan[index].jumlah++;
      } else {
        daftarPesanan.add(Pesanan(menu: menu));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${menu.nama} ditambahkan ke pesanan.'),
          duration: const Duration(seconds: 1),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatRupiah =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Pilih Menu',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
        itemCount: daftarMenu.length,
        itemBuilder: (context, index) {
          final menu = daftarMenu[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4,
            shadowColor: Theme.of(context).colorScheme.primary.withAlpha(50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12.0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/${menu.gambar}',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(menu.nama,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  formatRupiah.format(menu.harga),
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              onTap: () => tambahKePesanan(menu),
            ),
          )
              .animate()
              .fade(duration: 500.ms, delay: (100 * index).ms)
              .slideY(begin: 0.5, curve: Curves.easeInOut);
        },
      ),
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PesananScreen(daftarPesanan: daftarPesanan),
                ),
              );
            },
            label: const Text('Lihat Pesanan'),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
          if (daftarPesanan.isNotEmpty)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text(
                  '${daftarPesanan.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ==================================================
// LAYAR RINCIAN PESANAN
// ==================================================
class PesananScreen extends StatelessWidget {
  final List<Pesanan> daftarPesanan;

  const PesananScreen({super.key, required this.daftarPesanan});

  @override
  Widget build(BuildContext context) {
    double hitungTotalHarga() => daftarPesanan.fold(
        0, (sum, item) => sum + (item.menu.harga * item.jumlah));
    int hitungTotalItem() =>
        daftarPesanan.fold(0, (sum, item) => sum + item.jumlah);
    final formatRupiah =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    if (daftarPesanan.isEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text('Rincian Pesanan'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove_shopping_cart_outlined,
                  size: 100, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text('Keranjang Anda kosong',
                  style: TextStyle(fontSize: 22, color: Colors.grey[600])),
              const SizedBox(height: 8),
              Text('Silakan kembali dan pilih menu favorit Anda.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[500])),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Rincian Pesanan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: daftarPesanan.length,
              itemBuilder: (context, index) {
                final pesanan = daftarPesanan[index];
                final totalHargaItem = pesanan.menu.harga * pesanan.jumlah;
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset('assets/images/${pesanan.menu.gambar}',
                          width: 70, height: 70, fit: BoxFit.cover),
                    ),
                    title: Text(pesanan.menu.nama,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        'Jumlah: ${pesanan.jumlah} x ${formatRupiah.format(pesanan.menu.harga)}'),
                    trailing: Text(
                      formatRupiah.format(totalHargaItem),
                      // --- [PERBAIKAN FINAL] --- Menghapus 'const' dari TextStyle ini
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Item',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                    Text('${hitungTotalItem()}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Harga',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(
                      formatRupiah.format(hitungTotalHarga()),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
