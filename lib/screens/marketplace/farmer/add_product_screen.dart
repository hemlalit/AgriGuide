import 'dart:io';

import 'package:AgriGuide/screens/crop_care/img_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:AgriGuide/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:AgriGuide/models/product.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  double price = 0.0;
  List<String> imageUrls = [];
  String category = '';
  int stock = 0;
  bool _isLoading = false;

  void _saveProduct(ProductProvider productProvider) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      final newProduct = Product(
        name: name,
        description: description,
        price: price,
        imageUrls: imageUrls,
        category: category,
        stock: stock,
        vendorId: 'v1', // Assuming a static vendorId for now
        likes: [], // Assuming new products start with zero likes
        reviews: [],
      );

      try {
        await productProvider.addProduct(newProduct);
      } catch (error) {
        // Handle errors if necessary
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product: $error')),
        );
      }

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop(); // Navigate back or show a success message
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => ImagePickerDialog(onImagePicked: _onImagePicked),
    );
  }

  void _onImagePicked(XFile image) {
    setState(() {
      imageUrls.add(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          labelStyle: TextStyle(color: Colors.grey[600]),
                          prefixIcon:
                              Icon(Icons.shopping_bag, color: Colors.grey[600]),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: InputBorder.none,
                        ),
                        onSaved: (value) => name = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a name' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.grey[600]),
                          prefixIcon:
                              Icon(Icons.description, color: Colors.grey[600]),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: InputBorder.none,
                        ),
                        onSaved: (value) => description = value!,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter a description'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Price',
                          labelStyle: TextStyle(color: Colors.grey[600]),
                          prefixIcon:
                              Icon(Icons.attach_money, color: Colors.grey[600]),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => price = double.parse(value!),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a price' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Stock',
                          labelStyle: TextStyle(color: Colors.grey[600]),
                          prefixIcon:
                              Icon(Icons.storage, color: Colors.grey[600]),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => stock = int.parse(value!),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter the stock amount'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _showImagePickerDialog,
                        child: const Text('Pick Image'),
                      ),
                      const SizedBox(height: 10),
                      if (imageUrls.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageUrls.length,
                            itemBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Image.file(
                                File(imageUrls[index]),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          labelStyle: TextStyle(color: Colors.grey[600]),
                          prefixIcon:
                              Icon(Icons.category, color: Colors.grey[600]),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        value: category.isEmpty ? null : category,
                        items: const [
                          DropdownMenuItem(
                            value: 'Equipment',
                            child: Text('Equipment'),
                          ),
                          DropdownMenuItem(
                            value: 'Fertilizers',
                            child: Text('Fertilizers'),
                          ),
                          DropdownMenuItem(
                            value: 'Pesticides',
                            child: Text('Pesticides'),
                          ),
                          DropdownMenuItem(
                            value: 'Seeds',
                            child: Text('Seeds'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            category = value!;
                          });
                        },
                        onSaved: (value) => category = value!,
                        validator: (value) =>
                            value == null ? 'Please select a category' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _saveProduct(productProvider),
                        child: const Text('Save Product'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// import 'package:AgriGuide/widgets/custom_widgets/custom_snackbar.dart';
// import 'package:provider/provider.dart';
// import 'package:AgriGuide/providers/product_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:AgriGuide/models/product.dart';

// class AddProductScreen extends StatefulWidget {
//   @override
//   _AddProductScreenState createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String name = '';
//   String description = '';
//   double price = 0.0;
//   List<String> imageUrls = [];
//   String category = '';
//   int stock = 0;

//   void _saveProduct(ProductProvider productProvider) async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       final newProduct = Product(
//         name: name,
//         description: description,
//         price: price,
//         imageUrls: imageUrls,
//         category: category,
//         stock: stock,
//         vendorId: 'v1', // Assuming a static vendorId for now
//       );

//       try {
//         await productProvider.addProduct(newProduct);
//         if (productProvider.state == ProductState.success) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             CustomSnackbar.show(context, 'Product added successfully'),
//           );
//           // Navigator.of(context).pop(); // Navigate back or show a success message
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(productProvider.errorMessage)),
//           );
//         }
//       } catch (error) {
//         // Handle errors if necessary
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   'Failed to add product: ${productProvider.errorMessage}')),
//         );
//       }
//     }
//   }

//   void _addTestImageUrl() {
//     setState(() {
//       imageUrls.add('https://picsum.photos/200'); // Add a test image URL
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productProvider = Provider.of<ProductProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Product'),
//         backgroundColor: const Color(0xFF6441A5),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.lightGreen, Color.fromARGB(255, 1, 128, 5)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: productProvider.state == ProductState.loading
//             ? const Center(child: CircularProgressIndicator())
//             : Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Product Name',
//                           labelStyle: TextStyle(color: Colors.grey[600]),
//                           prefixIcon:
//                               Icon(Icons.shopping_bag, color: Colors.grey[600]),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                           border: const OutlineInputBorder(
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         onSaved: (value) => name = value!,
//                         validator: (value) =>
//                             value!.isEmpty ? 'Please enter a name' : null,
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Description',
//                           labelStyle: TextStyle(color: Colors.grey[600]),
//                           prefixIcon:
//                               Icon(Icons.description, color: Colors.grey[600]),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                           border: const OutlineInputBorder(
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         onSaved: (value) => description = value!,
//                         validator: (value) => value!.isEmpty
//                             ? 'Please enter a description'
//                             : null,
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Price',
//                           labelStyle: TextStyle(color: Colors.grey[600]),
//                           prefixIcon:
//                               Icon(Icons.attach_money, color: Colors.grey[600]),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                           border: const OutlineInputBorder(
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         keyboardType: TextInputType.number,
//                         onSaved: (value) => price = double.parse(value!),
//                         validator: (value) =>
//                             value!.isEmpty ? 'Please enter a price' : null,
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Stock',
//                           labelStyle: TextStyle(color: Colors.grey[600]),
//                           prefixIcon:
//                               Icon(Icons.storage, color: Colors.grey[600]),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                           border: const OutlineInputBorder(
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         keyboardType: TextInputType.number,
//                         onSaved: (value) => stock = int.parse(value!),
//                         validator: (value) => value!.isEmpty
//                             ? 'Please enter the stock amount'
//                             : null,
//                       ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: _addTestImageUrl,
//                         child: const Text('Add Test Image URL'),
//                       ),
//                       const SizedBox(height: 10),
//                       if (imageUrls.isNotEmpty)
//                         Container(
//                           height: 100,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: imageUrls.length,
//                             itemBuilder: (context, index) => Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 5),
//                               child: Image.network(
//                                 imageUrls[index],
//                                 height: 100,
//                                 width: 100,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 10),
//                       DropdownButtonFormField<String>(
//                         decoration: InputDecoration(
//                           labelText: 'Category',
//                           labelStyle: TextStyle(color: Colors.grey[600]),
//                           prefixIcon:
//                               Icon(Icons.category, color: Colors.grey[600]),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                           border: const OutlineInputBorder(
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         value: category.isEmpty ? null : category,
//                         items: const [
//                           DropdownMenuItem(
//                             value: 'Equipment',
//                             child: Text('Equipment'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'Fertilizers',
//                             child: Text('Fertilizers'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'Pesticides',
//                             child: Text('Pesticides'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'Seeds',
//                             child: Text('Seeds'),
//                           ),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             category = value!;
//                           });
//                         },
//                         onSaved: (value) => category = value!,
//                         validator: (value) =>
//                             value == null ? 'Please select a category' : null,
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () => _saveProduct(productProvider),
//                         child: const Text('Save Product'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
