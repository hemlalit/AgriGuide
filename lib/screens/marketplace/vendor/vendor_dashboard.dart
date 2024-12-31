import 'package:flutter/material.dart';

class VendorDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text('Add New Product'),
            onTap: () {
              Navigator.pushNamed(context, '/addProduct');
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Manage Inventory'),
            onTap: () {
              Navigator.pushNamed(context, '/manageInventory');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('View Sales'),
            onTap: () {
              Navigator.pushNamed(context, '/vendorSales');
            },
          ),
        ],
      ),
    );
  }
}
