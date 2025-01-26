import 'dart:io';
import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/models/user_model.dart';
import 'package:AgriGuide/providers/profile_provider.dart';
import 'package:AgriGuide/services/translator.dart';
import 'package:AgriGuide/utils/read_user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class EditProfileScreen extends StatefulWidget {
  final String id;
  const EditProfileScreen({required this.id, super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late ProfileProvider _profileProvider;

  File? _bannerImage;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final storage = const FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();

  String bio = '';

  void helper(final _bio) async {
    String fromLanguage = 'en';
    final toLanguage = await storage.read(key: 'ln');
    String content = await TranslationService()
        .translateText(_bio, fromLanguage, toLanguage);
    setState(() {
      bio = content;
    });
  }

  @override
  void initState() {
    super.initState();
    _profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    // Assuming the user data is already fetched and available
    final user = _profileProvider.user;
    helper(user?.bio);
    _nameController = TextEditingController(text: user?.name ?? '');
    _usernameController = TextEditingController(text: user?.username ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<String?> _uploadImageToFirebase(File image, bool isBanner) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final uploadTask = storageRef
          .child(isBanner
              ? 'banners/${path.basename(image.path)}'
              : 'profiles/${path.basename(image.path)}')
          .putFile(image);

      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _pickImage(ImageSource source, bool isBanner) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isBanner) {
          _bannerImage = File(pickedFile.path);
        } else {
          _profileImage = File(pickedFile.path);
        }
      });
    }
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      String? profileImageUrl;
      String? bannerImageUrl;

      if (_profileImage != null) {
        profileImageUrl = await _uploadImageToFirebase(_profileImage!, false);
      }

      if (_bannerImage != null) {
        bannerImageUrl = await _uploadImageToFirebase(_bannerImage!, true);
      }

      final updatedUser = User(
        name: _nameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        bio: _bioController.text,
        profileImage: profileImageUrl,
        bannerImage: bannerImageUrl,
        updatedAt: DateTime.now(),
        createdAt: _profileProvider.user!.createdAt,
      );

      await _profileProvider.updateUserProfile(context, updatedUser);
      if (_profileProvider.status == AuthStatus.success) {
        Navigator.pop(
            context); // Return to profile screen after successful update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_profileProvider.errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: readUserData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No user data available.'));
            }

            final userData = snapshot.data!;
            return Stack(
              children: [
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery, true),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      image: DecorationImage(
                        image: _bannerImage != null
                            ? FileImage(_bannerImage!)
                            : NetworkImage(userData['bannerImage'] ??
                                    'https://via.placeholder.com/500x200.png?text=Banner+Image')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        LocaleData.changeBanner.getString(context),
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: readUserData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No user data available.'));
            }

            final userData = snapshot.data!;
            // helper(userData['bio']);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _pickImage(ImageSource.gallery, false),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 58,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : NetworkImage(userData['profileImage'] ??
                                            'https://via.placeholder.com/150.png?text=Profile+Image')
                                        as ImageProvider,
                              ),
                            ),
                            Positioned(
                              right: 4,
                              bottom: 4,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4.0),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildTextField(
                        LocaleData.name.getString(context),
                        userData['name'],
                        _nameController,
                        required: false,
                      ),
                      _buildTextField(
                        LocaleData.username.getString(context),
                        userData['username'],
                        _usernameController,
                        required: false,
                      ),
                      _buildTextField(
                        LocaleData.bio.getString(context),
                        bio,
                        _bioController,
                        maxLines: 3,
                        required: false,
                      ),
                      _buildTextField(
                        LocaleData.phone.getString(context),
                        userData['phone'],
                        _phoneController,
                        required: false,
                      ),
                      _buildTextField(
                        LocaleData.email.getString(context),
                        userData['email'],
                        _emailController,
                        required: false,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(LocaleData.saveChanges.getString(context)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hintText, TextEditingController controller,
      {int maxLines = 1, bool required = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return '$label is required';
          }
          return null;
        },
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
