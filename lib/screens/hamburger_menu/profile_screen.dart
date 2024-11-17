import 'package:AgriGuide/models/user_model.dart';
import 'package:AgriGuide/providers/profile_provider.dart';
import 'package:AgriGuide/utils/appColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    // Fetch user profile data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchUserProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.user;

    if (user != null) {
      // Update controllers with user data when loaded
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
    }

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Profile', style: TextStyle(color: AppColors.iconColor)),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit,
                color: AppColors.iconColor),
            onPressed: () {
              if (_isEditing && user != null) {
                final updatedUser = User(
                  name: _nameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  profileImageUrl: user.profileImageUrl,
                );
                profileProvider.updateUserProfile(updatedUser);
              }
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: profileProvider.status == AuthStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: user == null
                  ? Center(
                      child: Text(
                        profileProvider.errorMessage.isNotEmpty
                            ? profileProvider.errorMessage
                            : 'User data not found',
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                user.profileImageUrl ??
                                    ''),
                            backgroundColor: AppColors.accentColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField('Name', _nameController, _isEditing),
                        _buildTextField('Email', _emailController, _isEditing),
                        _buildTextField('Phone', _phoneController, _isEditing),
                        const SizedBox(height: 20),
                        if (_isEditing)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                              });
                              // Update profile when 'Save Changes' is pressed
                              final updatedUser = User(
                                name: _nameController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                                profileImageUrl: user.profileImageUrl,
                              );
                              profileProvider.updateUserProfile(updatedUser);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: AppColors.iconColor,
                            ),
                            child: const Text('Save Changes'),
                          ),
                      ],
                    ),
            ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController? controller, bool isEditable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: isEditable,
        style: const TextStyle(fontSize: 18, color: AppColors.textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              color: AppColors.primaryColor, fontWeight: FontWeight.bold),
          filled: true,
          fillColor: isEditable ? Colors.white : AppColors.backgroundColor,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppColors.accentColor, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: isEditable
              ? const Icon(Icons.edit, color: AppColors.primaryColor)
              : null,
        ),
      ),
    );
  }
}
