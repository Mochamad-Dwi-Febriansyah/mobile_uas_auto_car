import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Daftar URL gambar
final List<String> imageUrls = [
  "https://asset.kompas.com/crops/l8WD6LB1LaRO8PANAEcRhh24zs4=/0x39:700x389/780x390/data/photo/2020/06/26/5ef4dca93bee4.jpg",
  "https://asset.kompas.com/crops/duZ2HVTBZLpmtKdzZSTG1z1JJ_Q=/0x80:960x720/1200x800/data/photo/2024/03/05/65e65fd87ce47.png", 
  "https://astradigitaldigiroomuat.blob.core.windows.net/storage-uat-001/modifikasi_mobil_yaris.png",
  "https://micms.mediaindonesia.com/storage/app/media/0%20-%20FOTO%202025/SASTRO/10%20jan/Screen%20Shot%202025-01-10%20at%2000.27.07.png",
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar tetap di atas
      appBar: AppBar(
        title: const Text(
          'AutoCar',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
        ),
        backgroundColor: Colors.orangeAccent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // Logika untuk ikon search
              print("Search icon tapped");
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              // Logika untuk ikon cart
              print("Cart icon tapped");
            },
          ),
        ],
      ),
      body: Container(
        color: Colors
            .orangeAccent, // Memberikan warna latar belakang orangeAccent pada seluruh body
        child: CustomScrollView(
          slivers: [
            // SliverAppBar untuk gambar latar tanpa title
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: false,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.orangeAccent,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://cdn.pixabay.com/photo/2015/10/01/17/17/car-967387_1280.png',
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
            // SliverToBoxAdapter untuk body konten
            SliverToBoxAdapter(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: (MediaQuery.of(context).size.height) -
                        300, // Menjamin tinggi minimum setinggi layar
                  ),
                  child: Container(
                    color:
                        Colors.white, // Warna latar belakang untuk body konten
                    child: Column(
                      children: [
                        // Highlight Mobil
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                          child: Align(
                            alignment:
                                Alignment.centerLeft, // Menyusun teks ke kiri
                            child: Text(
                              'Highlight Mobil',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('products')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Terjadi kesalahan'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: Text('Tidak ada produk'));
                            } else {
                              final products = snapshot.data!.docs;
                              return SingleChildScrollView(
                                scrollDirection: Axis
                                    .horizontal, // Scroll horizontal untuk mobil
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start, // Rata kiri
                                  children:
                                      List.generate(products.length, (index) {
                                    final product = products[index].data()
                                        as Map<String, dynamic>;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Card(
                                        color: Colors.grey[100],
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Container(
                                          width: 250,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                child: Image.network(
                                                  product['image'] ??
                                                      'https://via.placeholder.com/150', // Gambar produk
                                                  fit: BoxFit.contain,
                                                  width: double.infinity,
                                                  height: 150,
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: Text(
                                                  product['name'] ??
                                                      'Nama produk tidak tersedia',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: Text(
                                                  'Harga: Rp. ${product['price'] ?? 'N/A'}',
                                                  style: TextStyle(
                                                      color: Colors.orange),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: Text(
                                                  product['description'] ??
                                                      'Deskripsi tidak tersedia',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            }
                          },
                        ),

                  // Promo & Event
const Padding(
  padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
  child: Align(
    alignment: Alignment.centerLeft, // Menyusun teks ke kiri
    child: Text(
      'Promo & Event',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  ),
),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Column(
    children: [
      Card(
        color: const Color.fromARGB(255, 255, 248, 239),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          leading: Icon(
            Icons.local_offer,
            color: Colors.orangeAccent,
            size: 36,
          ),
          title: Text('Diskon Akhir Tahun'),
          subtitle: Text('Nikmati diskon hingga 50% untuk semua produk!'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            // Tambahkan aksi jika diperlukan
          },
        ),
      ),
      SizedBox(height: 8),
      Card(
        color: const Color.fromARGB(255, 255, 248, 239),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          leading: Icon(
            Icons.event,
            color: Colors.orangeAccent,
            size: 36,
          ),
          title: Text('Workshop Gratis'),
          subtitle: Text('Ikuti workshop coding gratis pada 25 Januari 2025.'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            // Tambahkan aksi jika diperlukan
          },
        ),
      ),
      SizedBox(height: 8),
      Card(
        color: const Color.fromARGB(255, 255, 248, 239),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          leading: Icon(
            Icons.star,
            color: Colors.orangeAccent,
            size: 36,
          ),
          title: Text('Program Loyalitas'),
          subtitle: Text(
              'Dapatkan poin setiap pembelian dan tukarkan hadiah menarik!'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            // Tambahkan aksi jika diperlukan
          },
        ),
      ),
    ],
  ),
),

                     Column(
    children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Align(
          alignment: Alignment.centerLeft, // Menyusun teks ke kiri
          child: Text(
            'Inspirasi Desain',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Nonaktifkan scroll di grid
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Jumlah kolom grid
            crossAxisSpacing: 4, // Jarak antar kolom
            mainAxisSpacing: 4, // Jarak antar baris
          ),
          itemCount: imageUrls.length, // Menggunakan jumlah item dari daftar
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Tambahkan aksi saat item diklik
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5, // Menambahkan sedikit bayangan untuk kesan menarik
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    imageUrls[index], // Menggunakan URL dari daftar
                    width: double.infinity,
                    fit: BoxFit.cover, // Gambar akan mengisi area dengan proporsi
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi tombol tengah
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.orangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // Membuat bentuk lingkaran
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home,
                  color:
                      _selectedIndex == 0 ? Colors.orangeAccent : Colors.grey),
              onPressed: () {
                _onItemTapped(0);
                Navigator.pushNamed(context, '/home');
              },
            ),
            IconButton(
              icon: Icon(Icons.grid_view,
                  color:
                      _selectedIndex == 1 ? Colors.orangeAccent : Colors.grey),
              onPressed: () {
                _onItemTapped(1);
                Navigator.pushNamed(context, '/product');
              },
            ),
            SizedBox(width: 48), // Ruang untuk FloatingActionButton
            IconButton(
              icon: Icon(Icons.notifications,
                  color:
                      _selectedIndex == 2 ? Colors.orangeAccent : Colors.grey),
              onPressed: () {
                _onItemTapped(2);
                Navigator.pushNamed(context, '/notification');
              },
            ),
            IconButton(
              icon: Icon(Icons.person,
                  color:
                      _selectedIndex == 3 ? Colors.orangeAccent : Colors.grey),
              onPressed: () {
                _onItemTapped(3);
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }

// Widget untuk setiap kategori
  Widget _buildCategory({
    required Color? color,
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            width: 80,
            height: 80,
            child: Center(
              child: Icon(
                icon,
                size: 36,
                color: iconColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
