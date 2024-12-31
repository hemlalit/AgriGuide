import 'package:flutter/material.dart';

class ManageInventoryScreen extends StatelessWidget {
  const ManageInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Inventory'),
      ),
      body: const Center(
        child: Text('Inventory management UI goes here'),
      ),
    );
  }
}
