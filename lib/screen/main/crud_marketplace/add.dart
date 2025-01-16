import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatelessWidget {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _sellerContactController = TextEditingController();

  void _addProduct(BuildContext context) async {
    final name = _nameController.text.trim();
    final price = _priceController.text.trim();
    final image = _imageController.text.trim();
    final description = _descriptionController.text.trim();
    final location = _locationController.text.trim();
    final sellerContact = _sellerContactController.text.trim();

    if (name.isEmpty || price.isEmpty || image.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Harap isi semua bidang wajib!")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'price': price,
      'image': image,
      'description': description.isEmpty ? 'Deskripsi tidak tersedia.' : description,
      'location': location.isEmpty ? 'Lokasi tidak tersedia.' : location,
      'seller_contact': sellerContact.isEmpty ? 'Kontak tidak tersedia.' : sellerContact,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Produk berhasil ditambahkan!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah Produk",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Nama Produk
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nama Produk",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Harga Produk
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: "Harga Produk",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // URL Gambar
            TextField(
              controller: _imageController,
              decoration: InputDecoration(
                labelText: "URL Gambar",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Deskripsi Produk
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Deskripsi Produk",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Lokasi Penjual
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: "Lokasi Penjual",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Kontak Penjual
            TextField(
              controller: _sellerContactController,
              decoration: InputDecoration(
                labelText: "Kontak Penjual",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Tambah Produk
            ElevatedButton(
              onPressed: () => _addProduct(context),
              child: Text(
                "Tambah Produk",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
