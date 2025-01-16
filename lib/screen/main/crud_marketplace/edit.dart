import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductPage extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> productData;

  const EditProductPage({
    Key? key,
    required this.productId,
    required this.productData,
  }) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _imageController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _sellerContactController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current product data
    _nameController = TextEditingController(text: widget.productData['name']);
    _priceController = TextEditingController(text: widget.productData['price']);
    _imageController = TextEditingController(text: widget.productData['image']);
    _descriptionController =
        TextEditingController(text: widget.productData['description']);
    _locationController =
        TextEditingController(text: widget.productData['location']);
    _sellerContactController =
        TextEditingController(text: widget.productData['seller_contact']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _sellerContactController.dispose();
    super.dispose();
  }

  void _updateProduct(BuildContext context) async {
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

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .update({
        'name': name,
        'price': price,
        'image': image,
        'description': description.isEmpty ? 'Deskripsi tidak tersedia.' : description,
        'location': location.isEmpty ? 'Lokasi tidak tersedia.' : location,
        'seller_contact': sellerContact.isEmpty ? 'Kontak tidak tersedia.' : sellerContact,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Produk berhasil diperbarui!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Produk",
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

            // Tombol Perbarui Produk
            ElevatedButton(
              onPressed: () => _updateProduct(context),
              child: Text(
                "Perbarui Produk",
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
