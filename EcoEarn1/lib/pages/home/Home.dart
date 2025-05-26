import 'package:ecoearn/repository/widgets/uihelper.dart';
import 'package:ecoearn/services/auth_service.dart';
import 'package:flutter/material.dart';

// Edit Profile Page
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color.fromARGB(255, 247, 248, 247),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UiHelper.CustomText(
              text: "Update Your Profile",
              fontsize: 24,
              fontweight: FontWeight.bold,
              color: Colors.black,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: "John Doe"),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: "john.doe@example.com"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile Updated")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: UiHelper.CustomText(
                text: "Save Changes",
                fontsize: 16,
                fontweight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Order History Page
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orders = [
      {"id": "ORD001", "date": "2025-03-20", "total": 599.98, "status": "Delivered"},
      {"id": "ORD002", "date": "2025-03-15", "total": 199.99, "status": "Delivered"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: const Color.fromARGB(255, 247, 248, 247),
      ),
      body: orders.isEmpty
          ? Center(
              child: UiHelper.CustomText(
                text: "No orders yet",
                fontsize: 18,
                fontweight: FontWeight.w500,
                color: Colors.grey,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  child: ListTile(
                    title: UiHelper.CustomText(
                      text: "Order ${order["id"]}",
                      fontsize: 16,
                      fontweight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    subtitle: UiHelper.CustomText(
                      text: "Date: ${order["date"]}",
                      fontsize: 14,
                      fontweight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        UiHelper.CustomText(
                          text: "₹${order["total"].toStringAsFixed(2)}",
                          fontsize: 16,
                          fontweight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        UiHelper.CustomText(
                          text: order["status"],
                          fontsize: 12,
                          fontweight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Saved Addresses Page
class SavedAddressesPage extends StatelessWidget {
  const SavedAddressesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> addresses = [
      {"type": "Home", "address": "123 Green Street, Eco City"},
      {"type": "Work", "address": "456 Business Ave, Eco Town"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Addresses"),
        backgroundColor: const Color.fromARGB(255, 247, 248, 247),
      ),
      body: Column(
        children: [
          Expanded(
            child: addresses.isEmpty
                ? Center(
                    child: UiHelper.CustomText(
                      text: "No saved addresses",
                      fontsize: 18,
                      fontweight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return Card(
                        child: ListTile(
                          title: UiHelper.CustomText(
                            text: address["type"]!,
                            fontsize: 16,
                            fontweight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          subtitle: UiHelper.CustomText(
                            text: address["address"]!,
                            fontsize: 14,
                            fontweight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: UiHelper.CustomText(
                text: "Add New Address",
                fontsize: 16,
                fontweight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Payment Methods Page
class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> paymentMethods = [
      {"type": "Credit Card", "details": "Visa ending in 1234"},
      {"type": "UPI", "details": "john@upi"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Methods"),
        backgroundColor: const Color.fromARGB(255, 247, 248, 247),
      ),
      body: Column(
        children: [
          Expanded(
            child: paymentMethods.isEmpty
                ? Center(
                    child: UiHelper.CustomText(
                      text: "No payment methods added",
                      fontsize: 18,
                      fontweight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: paymentMethods.length,
                    itemBuilder: (context, index) {
                      final method = paymentMethods[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            method["type"] == "Credit Card"
                                ? Icons.credit_card
                                : Icons.payment,
                            color: Colors.green,
                          ),
                          title: UiHelper.CustomText(
                            text: method["type"]!,
                            fontsize: 16,
                            fontweight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          subtitle: UiHelper.CustomText(
                            text: method["details"]!,
                            fontsize: 14,
                            fontweight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: UiHelper.CustomText(
                text: "Add Payment Method",
                fontsize: 16,
                fontweight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Wishlist Page
class WishlistPage extends StatelessWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> wishlistItems = [
      {"name": "Golden Candle", "price": 299.99, "image": "image 54.png"},
      {"name": "Diwali Gift Set", "price": 499.99, "image": "image 51.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wishlist"),
        backgroundColor: const Color.fromARGB(255, 247, 248, 247),
      ),
      body: wishlistItems.isEmpty
          ? Center(
              child: UiHelper.CustomText(
                text: "Your wishlist is empty",
                fontsize: 18,
                fontweight: FontWeight.w500,
                color: Colors.grey,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final item = wishlistItems[index];
                return Card(
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: UiHelper.CustomImage(img: item["image"]),
                    ),
                    title: UiHelper.CustomText(
                      text: item["name"],
                      fontsize: 16,
                      fontweight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    subtitle: UiHelper.CustomText(
                      text: "₹${item["price"].toStringAsFixed(2)}",
                      fontsize: 14,
                      fontweight: FontWeight.w500,
                      color: Colors.green,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Help & Support Page
class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: const Color.fromARGB(255, 247, 248, 247),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UiHelper.CustomText(
              text: "How can we help you?",
              fontsize: 24,
              fontweight: FontWeight.bold,
              color: Colors.black,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.green),
              title: UiHelper.CustomText(
                text: "Contact Us",
                fontsize: 16,
                fontweight: FontWeight.w500,
                color: Colors.black,
              ),
              subtitle: UiHelper.CustomText(
                text: "support@ecoearn.com",
                fontsize: 14,
                fontweight: FontWeight.normal,
                color: Colors.grey,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: UiHelper.CustomText(
                text: "Call Support",
                fontsize: 16,
                fontweight: FontWeight.w500,
                color: Colors.black,
              ),
              subtitle: UiHelper.CustomText(
                text: "+91-123-456-7890",
                fontsize: 14,
                fontweight: FontWeight.normal,
                color: Colors.grey,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.green),
              title: UiHelper.CustomText(
                text: "FAQ",
                fontsize: 16,
                fontweight: FontWeight.w500,
                color: Colors.black,
              ),
              onTap: () {},
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: UiHelper.CustomText(
                text: "Submit a Ticket",
                fontsize: 16,
                fontweight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController searchController = TextEditingController();
  int _currentIndex = 0;

  final data = [
    {"img": "image 50.png", "text": "Lights, Diyas & Candles"},
    {"img": "image 51.png", "text": "Diwali Gifts"},
    {"img": "image 52.png", "text": "Appliances & Gadgets"},
    {"img": "image 53.png", "text": "Home & Living"}
  ];

  final category = [
    {"img": "image 54.png", "text": "Golden Glass Wooden Lid Candle (Oudh)"},
    {"img": "image 57.png", "text": "Royal Gulab Jamun By Bikano"},
    {"img": "image 63.png", "text": "Golden Glass Wooden Lid Candle (Oudh)"}
  ];

  final groceryKitchen = [
    {"img": "image 41.png", "text": "Vegetables & Fruits"},
    {"img": "image 42.png", "text": "Atta, Dal & Rice"},
    {"img": "image 43.png", "text": "Oil, Ghee & Masala"},
    {"img": "image 44 (1).png", "text": "Dairy, Bread & Milk"},
    {"img": "image 45 (1).png", "text": "Biscuits & Bakery"}
  ];

  final List<Map<String, dynamic>> cartItems = [
    {"name": "Golden Candle", "price": 299.99, "quantity": 2, "image": "image 54.png"},
    {"name": "Gulab Jamun", "price": 199.99, "quantity": 1, "image": "image 57.png"},
  ];

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      _buildHomePage(),
      _buildAccountPage(),
      _buildCartPage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 247, 248, 247),
      ),
      body: Container(
        color: const Color.fromARGB(255, 245, 248, 245),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: UiHelper.CustomTextField(controller: searchController),
          ),
          const SizedBox(height: 20),
          _buildSection("Diwali Offers", data),
          _buildSection("Top Categories", category),
          _buildSection("Grocery & Kitchen", groceryKitchen),
        ],
      ),
    );
  }

  Widget _buildAccountPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiHelper.CustomText(
                      text: "John Doe",
                      fontsize: 20,
                      fontweight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    UiHelper.CustomText(
                      text: "john.doe@example.com",
                      fontsize: 14,
                      fontweight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildAccountOption(
              icon: Icons.person_outline,
              title: "Edit Profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
                );
              },
            ),
            _buildAccountOption(
              icon: Icons.history,
              title: "Order History",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderHistoryPage()),
                );
              },
            ),
            _buildAccountOption(
              icon: Icons.location_on_outlined,
              title: "Saved Addresses",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SavedAddressesPage()),
                );
              },
            ),
            _buildAccountOption(
              icon: Icons.payment_outlined,
              title: "Payment Methods",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentMethodsPage()),
                );
              },
            ),
            _buildAccountOption(
              icon: Icons.favorite_border,
              title: "Wishlist",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WishlistPage()),
                );
              },
            ),
            _buildAccountOption(
              icon: Icons.help_outline,
              title: "Help & Support",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpSupportPage()),
                );
              },
            ),
            _buildAccountOption(
              icon: Icons.logout,
              title: "Logout",
              onTap: () {
                _handleLogout(context);
              },
              textColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    try {
      await AuthService().signout(context: context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }

  Widget _buildAccountOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? Colors.black54),
            const SizedBox(width: 15),
            UiHelper.CustomText(
              text: title,
              fontsize: 16,
              color: textColor ?? Colors.black,
              fontweight: FontWeight.w500,
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildCartPage() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UiHelper.CustomText(
                text: "Your Cart",
                fontsize: 24,
                fontweight: FontWeight.bold,
                color: Colors.black,
              ),
              UiHelper.CustomText(
                text: "${cartItems.length} Items",
                fontsize: 16,
                fontweight: FontWeight.w500,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        Expanded(
          child: cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      UiHelper.CustomText(
                        text: "Your cart is empty",
                        fontsize: 18,
                        fontweight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[200],
                              ),
                              child: UiHelper.CustomImage(img: item["image"]),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UiHelper.CustomText(
                                    text: item["name"],
                                    fontsize: 16,
                                    fontweight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 4),
                                  UiHelper.CustomText(
                                    text: "₹${item["price"].toStringAsFixed(2)}",
                                    fontsize: 14,
                                    fontweight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      if (item["quantity"] > 1) {
                                        item["quantity"]--;
                                      } else {
                                        cartItems.removeAt(index);
                                      }
                                    });
                                  },
                                ),
                                UiHelper.CustomText(
                                  text: "${item["quantity"]}",
                                  fontsize: 16,
                                  fontweight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      item["quantity"]++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        if (cartItems.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UiHelper.CustomText(
                      text: "Total",
                      fontsize: 18,
                      fontweight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    UiHelper.CustomText(
                      text: "₹${_calculateTotal().toStringAsFixed(2)}",
                      fontsize: 18,
                      fontweight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Proceeding to checkout...")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: UiHelper.CustomText(
                    text: "Checkout",
                    fontsize: 18,
                    fontweight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  double _calculateTotal() {
    return cartItems.fold(0, (sum, item) => sum + (item["price"] * item["quantity"]));
  }

  Widget _buildSection(String title, List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 10),
          child: UiHelper.CustomText(
            text: title,
            color: Colors.black,
            fontweight: FontWeight.bold,
            fontsize: 18,
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: UiHelper.CustomImage(img: items[index]["img"]!),
                    ),
                    const SizedBox(height: 5),
                    UiHelper.CustomText(
                      text: items[index]["text"]!,
                      color: Colors.black,
                      fontweight: FontWeight.normal,
                      fontsize: 10,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}