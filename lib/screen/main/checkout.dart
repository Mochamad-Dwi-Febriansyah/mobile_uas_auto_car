import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const CheckoutPage({Key? key, required this.product}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  double tax = 0.1; // 10% tax
  double shippingFee = 50.0; // Fixed shipping fee

  double getTotalAmount(double price) {
    double taxAmount = price * tax;
    return price + taxAmount + shippingFee;
  }

  // Fungsi untuk menyimpan riwayat pembelian ke Firebase
  Future<void> _savePurchaseToFirebase(double totalAmount) async {
    try {
      await FirebaseFirestore.instance.collection('purchases').add({
        'productName': widget.product['name'],
        'price': widget.product['price'],
        'tax': tax * 100, // Convert tax to percentage for better readability
        'shippingFee': shippingFee,
        'totalAmount': totalAmount,
        'purchaseDate': FieldValue.serverTimestamp(),
      });

      // Memberikan feedback kepada pengguna bahwa transaksi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pembelian berhasil!")),
      );

      // Setelah berhasil, arahkan ke halaman notifikasi
      Navigator.pushNamed(context, '/notification');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double price = double.parse(widget.product['price']);
    double totalAmount = getTotalAmount(price);

    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Checkout',
        style: TextStyle(color: Colors.white), 
      ),
       backgroundColor: Colors.orange,
        iconTheme:const IconThemeData(
          color: Colors.white,
        ),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying product details
            Text('Nama Produk: ${widget.product['name']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Harga: Rp${widget.product['price']}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),

            // Showing tax and shipping details
            Text('Pajak (10%): Rp${(price * tax).toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Biaya Pengiriman: Rp${shippingFee.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),

            // Displaying total amount
            Text('Total Pembayaran: Rp${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 30),

            // Button to confirm purchase
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePurchaseToFirebase(totalAmount);
                },
                child: Text('Bayar Sekarang', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
