import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'sign_in_screen.dart';
import 'profile_details_screen.dart';
import 'faq_screen.dart';
import 'contact_us_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'User';
  String? profileImagePath; // Can be set to a local image path or network URL

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final displayName = await AuthService.getDisplayName();
    if (mounted) {
      setState(() {
        userName = displayName ?? 'User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            _buildProfilePicture(),
            const SizedBox(height: 16),
            // User Name
            _buildUserName(),
            const SizedBox(height: 40),
            // Menu Options
            _buildMenuOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Profile Picture Circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              color: Colors.grey[200],
            ),
            child: profileImagePath != null
                ? ClipOval(
                    child: Image.network(
                      profileImagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultProfileIcon();
                      },
                    ),
                  )
                : _buildDefaultProfileIcon(),
          ),
          // Edit Button positioned at bottom-right
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _handleEditProfilePicture,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF036B52),
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultProfileIcon() {
    return Icon(
      Icons.person,
      size: 60,
      color: Colors.grey[600],
    );
  }

  Widget _buildUserName() {
    return Text(
      userName,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _buildMenuOptions() {
    final menuItems = [
      _MenuItemData(
        icon: Icons.person_outline,
        title: 'Profile details',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProfileDetailsScreen(),
            ),
          );
        },
      ),
      _MenuItemData(
        icon: Icons.help_outline,
        title: 'FAQ',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FAQScreen(),
            ),
          );
        },
      ),
      _MenuItemData(
        icon: Icons.phone_outlined,
        title: 'Contact Us',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ContactUsScreen(),
            ),
          );
        },
      ),
      _MenuItemData(
        icon: Icons.logout_outlined,
        title: 'Log Out',
        onTap: () {
          _showLogoutDialog(context);
        },
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == menuItems.length - 1;

          return Column(
            children: [
              ListTile(
                leading: Icon(
                  item.icon,
                  color: Colors.black87,
                  size: 24,
                ),
                title: Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Colors.grey[600],
                ),
                onTap: item.onTap,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[200],
                  indent: 60,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }



  void _handleEditProfilePicture() {
    // Show options dialog for editing profile picture
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(
                  'Choose from Gallery',
                  style: GoogleFonts.poppins(),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(
                  'Take Photo',
                  style: GoogleFonts.poppins(),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              if (profileImagePath != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: Text(
                    'Remove Photo',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _removeProfilePicture();
                  },
                ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _pickImageFromGallery() {
    // TODO: Implement image picker from gallery
    // You can use image_picker package: https://pub.dev/packages/image_picker
    // Example:
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // if (image != null) {
    //   setState(() {
    //     profileImagePath = image.path;
    //   });
    // }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Gallery picker will be implemented here',
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }

  void _takePhoto() {
    // TODO: Implement camera functionality
    // You can use image_picker package: https://pub.dev/packages/image_picker
    // Example:
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.camera);
    // if (image != null) {
    //   setState(() {
    //     profileImagePath = image.path;
    //   });
    // }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Camera functionality will be implemented here',
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }

  void _removeProfilePicture() {
    setState(() {
      profileImagePath = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile picture removed',
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Log Out',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey[700],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await AuthService.signOut();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                    (route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Logged out successfully',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                'Log Out',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Helper class for menu items
class _MenuItemData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _MenuItemData({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

