import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/generated/app_localizations.dart';
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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          l10n.profile,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.titleLarge?.color,
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
    final theme = Theme.of(context);
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
                color: theme.dividerColor,
                width: 2,
              ),
              color: theme.canvasColor,
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
                    color: theme.cardColor,
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
    final theme = Theme.of(context);
    return Icon(
      Icons.person,
      size: 60,
      color: theme.iconTheme.color?.withOpacity(0.5),
    );
  }

  Widget _buildUserName() {
    final theme = Theme.of(context);
    return Text(
      userName,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: theme.textTheme.titleLarge?.color,
      ),
    );
  }

  Widget _buildMenuOptions() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    final menuItems = [
      _MenuItemData(
        icon: Icons.person_outline,
        title: l10n.profileDetails,
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
        title: l10n.faq,
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
        title: l10n.contactUs,
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
        title: l10n.logOut,
        onTap: () {
          _showLogoutDialog(context);
        },
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
                  color: theme.iconTheme.color,
                  size: 24,
                ),
                title: Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: theme.iconTheme.color?.withOpacity(0.5),
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
                  color: theme.dividerColor.withOpacity(0.1),
                  indent: 60,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _handleEditProfilePicture() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    // Show options dialog for editing profile picture
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.canvasColor,
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
                leading: Icon(Icons.photo_library_outlined, color: theme.iconTheme.color),
                title: Text(
                  l10n.chooseFromGallery,
                  style: GoogleFonts.poppins(color: theme.textTheme.bodyLarge?.color),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined, color: theme.iconTheme.color),
                title: Text(
                  l10n.takePhoto,
                  style: GoogleFonts.poppins(color: theme.textTheme.bodyLarge?.color),
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
                    l10n.removePhoto,
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
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.galleryPickerNotImplemented,
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }

  void _takePhoto() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.cameraNotImplemented,
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }

  void _removeProfilePicture() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      profileImagePath = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.profilePictureRemoved,
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.canvasColor,
          title: Text(
            l10n.logOut,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          content: Text(
            l10n.areYouSureLogOut,
            style: GoogleFonts.poppins(color: theme.textTheme.bodyLarge?.color),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.cancel,
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
                        l10n.loggedOutSuccessfully,
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                l10n.logOut,
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

