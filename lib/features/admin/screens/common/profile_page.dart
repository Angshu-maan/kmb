import 'package:flutter/material.dart';
import 'package:kmb_app/features/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:kmb_app/core/auth/user_role.dart';
import 'package:kmb_app/core/routes/role_router.dart';
import 'package:kmb_app/shared/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController mobileController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    final auth = context.read<AuthProvider>();
    final session = auth.session!;

    nameController = TextEditingController(text: session.activeRole);
    mobileController = TextEditingController(text: session.userType);
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  void toggleEdit() {
    setState(() => isEditing = !isEditing);
  }

  void saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() => isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated")),
      );

      // TODO: Call API
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final session = auth.session!;
    final UserRole role = auth.role!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final route = RoleRouter.goHome(role);
            context.goNamed(route);
          },
        ),
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: isEditing ? saveProfile : toggleEdit,
          ),
        ],
      ),
      body: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 16),

                /// NAME
                isEditing
                    ? TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "Enter name" : null,
                      )
                    : Text(
                        session.activeRole,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                const SizedBox(height: 6),

                Text(
                  role.name.toUpperCase(),
                  style:
                      TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),

                const SizedBox(height: 20),
                const Divider(),

                /// MOBILE
                isEditing
                    ? TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Mobile",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "Enter mobile" : null,
                      )
                    : ProfileWidget(
                        label: "Mobile",
                        value: session.userType,
                      ),

                ProfileWidget(
                  label: "Role",
                  value: role.name,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
