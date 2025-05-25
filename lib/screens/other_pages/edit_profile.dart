import 'package:companion/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController educationController = TextEditingController();

  final UserService userService = UserService();
  Map<String, dynamic>? userProfile;
  final box = GetStorage();

  Future<void> loadUserProfile() async {
    final userId = box.read('userid');
    try {
      final details = await userService.fetchUserDetails(userId);
      setState(() {
        userProfile = details;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    loadUserProfile();
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    educationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child:
              userProfile == null
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Edit Profile",
                            style: GoogleFonts.workSans(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        buildtextfield(
                          firstNameController,
                          hintText: userProfile!['firstname'],
                          labelText: "First Name",
                        ),
                        SizedBox(height: 20),
                        buildtextfield(
                          lastNameController,
                          hintText: userProfile!['lastname'],
                          labelText: "Last Name",
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  Widget buildtextfield(
    TextEditingController controller, {
    required String hintText,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
