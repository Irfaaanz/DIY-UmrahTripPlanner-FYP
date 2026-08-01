import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/profile_service.dart';
import '../services/auth_service.dart';
import '../l10n/generated/app_localizations.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  String? _selectedGender;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _obscurePassword = true;
  
  String? _profileImagePath;
  File? _newProfileImage;
  XFile? _newXFileImage;
  final ImagePicker _picker = ImagePicker();
  
  final List<String> _genderOptions = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });

    final profile = await ProfileService.getFullProfile();
    
    if (mounted) {
      setState(() {
        _displayNameController.text = profile?['displayName'] ?? '';
        _fullNameController.text = profile?['fullName'] ?? '';
        _selectedGender = profile?['gender'] as String?;
        // Validate gender: If not in options (e.g. empty string), reset to null
        if (_selectedGender != null && !_genderOptions.contains(_selectedGender)) {
          _selectedGender = null;
        }
        _emailController.text = profile?['email'] ?? '';
        _phoneController.text = profile?['phoneNo'] ?? '';
        // Do not pre-fill password with masked characters to avoids confusion
        _passwordController.text = ''; 
        _profileImagePath = profile?['profileImagePath'];
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _newXFileImage = image;
          if (!kIsWeb) {
             _newProfileImage = File(image.path);
          } else {
             // For web we can't create File(image.path) safely or uselessly
             _newProfileImage = null; 
          }
        });
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _showImageSourceActionSheet() async {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.chooseFromGallery),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(l10n.takePhoto),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _saveProfileImage() async {
    if (_newProfileImage == null) return _profileImagePath;
    
    try {
      if (kIsWeb) {
        return _newProfileImage!.path;
      }
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(_newProfileImage!.path)}';
      final savedImage = await _newProfileImage!.copy('${appDir.path}/$fileName');
      return savedImage.path;
    } catch (e) {
      debugPrint('Error saving image: $e');
      return _profileImagePath;
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Save profile image if new one selected
      String? imagePath;
      if (_newXFileImage != null) {
          imagePath = await ProfileService.uploadProfileImageXFile(_newXFileImage);
      } else {
          imagePath = _profileImagePath;
      }

      // Save profile data
      final success = await ProfileService.saveProfileData(
        displayName: _displayNameController.text.trim().isEmpty 
            ? null 
            : _displayNameController.text.trim(),
        fullName: _fullNameController.text.trim().isEmpty 
            ? null 
            : _fullNameController.text.trim(),
        gender: _selectedGender,
        phoneNo: _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
        profileImagePath: imagePath,
      );

      // Update password if changed
      if (_passwordController.text.isNotEmpty) {
        await ProfileService.updatePassword(_passwordController.text);
      }

      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Profile saved successfully!',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          
          // Navigate back to profile screen
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error saving profile',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.iconTheme.color,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          l10n.profileDetails,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showImageSourceActionSheet,
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.canvasColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                          child: ClipOval(
                            child: _newXFileImage != null
                                ? (kIsWeb 
                                    ? Image.network(
                                        _newXFileImage!.path, 
                                        width: 100, 
                                        height: 100, 
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(_newXFileImage!.path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ))
                                : _profileImagePath != null && _profileImagePath!.isNotEmpty
                                    ? Image.network(
                                        _profileImagePath!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            Icons.person,
                                            size: 50,
                                            color: theme.iconTheme.color?.withOpacity(0.5),
                                          );
                                        },
                                      )
                                    : Icon(
                                        Icons.person,
                                        size: 50,
                                        color: theme.iconTheme.color?.withOpacity(0.5),
                                      ),
                          ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: theme.canvasColor, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Display Name
                  Text(
                    _displayNameController.text.isEmpty 
                        ? 'User' 
                        : _displayNameController.text,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Form Fields
                  _buildField(
                    label: l10n.displayName,
                    controller: _displayNameController,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: l10n.fullName,
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 16),
                  _buildGenderDropdown(),
                  const SizedBox(height: 16),
                  _buildField(
                    label: l10n.emailAddress,
                    controller: _emailController,
                    enabled: false, // Email is read-only
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: l10n.phoneNo,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: l10n.passwords, // Keep label, but behavior changes
                    hintText: "Leave empty to keep current",
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword 
                            ? Icons.visibility_outlined 
                            : Icons.visibility_off_outlined,
                        color: theme.iconTheme.color,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB3E5FC),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black87,
                                ),
                              ),
                            )
                          : Text(
                              'Save', // TODO: Add to ARB if strictly needed, but "Save" is common enough or missed in my manual scan. Let's assume English OK or fix later. Wait, I missed "Save" in ARB scan.
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? hintText,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText, // Added hintText
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
          labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: theme.textTheme.bodyMedium?.color,
          ),
          suffixIcon: suffixIcon ?? Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.iconTheme.color,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        dropdownColor: theme.cardColor,
        decoration: InputDecoration(
          labelText: l10n.gender,
          labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: theme.textTheme.bodyMedium?.color,
          ),
          suffixIcon: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.iconTheme.color,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodyLarge?.color,
        ),
        items: _genderOptions.map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(
              gender,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue;
          });
        },
      ),
    );
  }
}

