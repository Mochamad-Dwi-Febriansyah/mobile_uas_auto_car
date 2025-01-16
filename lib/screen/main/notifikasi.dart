import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Daftar untuk menyimpan notifikasi
  List<Map<String, String>> notifications = [
    {
      'title': 'Promo Akhir Tahun!',
      'message': 'Diskon hingga 50% untuk pembelian mobil.',
      'time': '1 jam yang lalu'
    },
    {
      'title': 'Servis Gratis',
      'message': 'Dapatkan layanan servis gratis setelah 5 pembelian.',
      'time': '3 jam yang lalu'
    },
    {
      'title': 'Test Drive',
      'message': 'Jadwal test drive Anda telah dikonfirmasi.',
      'time': 'Kemarin'
    },
  ];

  // Ambil pembelian dari Firestore
  Future<List<Map<String, dynamic>>> _getPurchases() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('purchases').get();
      List<Map<String, dynamic>> purchases = [];
      for (var doc in snapshot.docs) {
        purchases.add(doc.data() as Map<String, dynamic>);
      }
      return purchases;
    } catch (e) {
      // Handle error
      print("Error fetching purchases: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
        iconTheme: IconThemeData(color: Colors.white), // Panah kembali putih
        automaticallyImplyLeading: false, 
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getPurchases(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada pembelian terbaru.'));
            }

            final purchases = snapshot.data!;

            return ListView.builder(
              itemCount: purchases.length,
              itemBuilder: (context, index) {
                final purchase = purchases[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container( 
                      color: const Color.fromARGB(255, 255, 248, 239),
                      child: ListTile(
                        title: Text(
                          'Produk: ${purchase['productName']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text('Harga: Rp${purchase['price']}'),
                            Text('Pajak: ${purchase['tax']}%'),
                            Text('Biaya Pengiriman: Rp${purchase['shippingFee']}'),
                            SizedBox(height: 4),
                            Text(
                              'Total Pembayaran: Rp${purchase['totalAmount']}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Waktu Pembelian: ${purchase['purchaseDate'].toDate().toString()}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.orangeAccent,
                          child: Icon(Icons.notifications, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
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
}
