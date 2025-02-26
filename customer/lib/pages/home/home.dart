import 'package:ecoearn/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  final List<Map<String, String>> products = const [
    {
      "name": "Eco-Friendly Bottle",
      "image": "assets/bottle.png",
      "price": "\$12.99"
    },
    {
      "name": "Recycled Notebook",
      "image": "assets/notebook.png",
      "price": "\$8.99"
    },
    {
      "name": "Bamboo Toothbrush",
      "image": "assets/toothbrush.png",
      "price": "\$5.49"
    },
    {
      "name": "Reusable Shopping Bag",
      "image": "assets/bag.png",
      "price": "\$6.99"
    },
  ];

  @override
  Widget build(BuildContext context) {
    print("🏠 Home screen is being built"); // Debugging print

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(57, 239, 83, 1),
        title: Text(
          'EcoEarn Catalog',
          style: GoogleFonts.raleway(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            key: const Key("logoutButton"), // Debugging key
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              print("🔴 Logout button pressed"); // Debugging print
              await AuthService().signout(context: context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, 👋',
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                FirebaseAuth.instance.currentUser?.email ?? "User",
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _buildCatalogItem(products[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCatalogItem(Map<String, String> product) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              product["image"]!,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product["name"]!,
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            product["price"]!,
            style: GoogleFonts.raleway(
              fontSize: 14,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
