import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  int _selectedIndex = 3;
  String userEmail = ''; // Variabel untuk menyimpan email pengguna
  String userName = 'Jane Doe'; // Nama pengguna default

  // Ambil email dari SharedPreferences saat halaman pertama kali dibuka
  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  Future<void> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail') ?? ''; // Jika tidak ada email, set kosong
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _editProfile() {
    TextEditingController nameController = TextEditingController(text: userName);
    TextEditingController emailController = TextEditingController(text: userEmail);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Lengkap'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                // Menyimpan data yang baru
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('userEmail', emailController.text.trim());
                setState(() {
                  userEmail = emailController.text.trim();
                });

                Navigator.of(context).pop(); // Menutup dialog setelah menyimpan
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orangeAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Profil
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.orangeAccent,
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // Foto Profil
                  ClipOval(
                    child: Image.asset(
                      'assets/images/avatar-ladies.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Nama Pengguna
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // Email Pengguna
                  Text(
                    userEmail, // Menampilkan email yang login
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Opsi Menu
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.edit, color: Colors.orangeAccent),
                        title: Text('Edit Profile'),
                        onTap: _editProfile, // Menampilkan popup untuk edit profile
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.settings, color: Colors.orangeAccent),
                        title: Text('Settings'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.logout, color: Colors.redAccent),
                        title: Text('Logout'), 
                        onTap: () {  Navigator.pushNamed(context, '/login');},
                      ),
                    ],
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
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
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
            SizedBox(width: 48),
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
