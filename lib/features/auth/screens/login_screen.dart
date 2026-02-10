import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/primary_button.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  // final String phoneNumber;
  // final String refreshToken;

  const LoginPage({super.key});
  // const LoginPage({super.key, required this.phoneNumber, required this.refreshToken});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  bool canSendOTP = true;

  String _phone = '';

  /* ---------------- SEND OTP ---------------- */
  Future<void> validateAndSendOTP() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      final otpToken = await AuthService.sendOtp(_phone);
      



      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP sent successfully"),
          backgroundColor: Colors.green,
        ),
      );
      context.pushNamed('otp', extra: {'phone': _phone, 'otpToken': otpToken});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception:', '').trim()),
          backgroundColor: Colors.red,
        ),
      );

      setState(() => canSendOTP = true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // Re Login

  // Future<void> reLogging() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   _formKey.currentState!.save();

  //   try {
  //     final reLogin = await AuthService.reLoggedIn(phone: widget.phoneNumber, refreshtoken: widget.refreshToken);
      

  //     if (!mounted) return;

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("RefeTo sent successfully"),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //     context.pushNamed('otp', extra: {'phone': widget.phoneNumber, 'otpToken': widget.refreshToken});
  //   } catch (e) {
  //     if (!mounted) return;

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(e.toString().replaceAll('Exception:', '').trim()),
  //         backgroundColor: Colors.red,
  //       ),
  //     );

  //     setState(() => canSendOTP = true);
  //   } finally {
  //     if (mounted) setState(() => isLoading = false);
  //   }
  // }



  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = (screenWidth * 0.6).clamp(90.0, 160.0);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 112, 140, 214).withOpacity(0.6),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo_black.png',
                    width: imageSize,
                    height: imageSize,
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Welcome Back",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Enter your mobile number to login",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 32),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                final phone = value?.trim() ?? '';
                                if (phone.isEmpty) {
                                  return "Phone number is required";
                                }
                                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
                                  return "Please enter a valid phone number";
                                }
                                return null;
                              },
                              onSaved: (value) => _phone = value!.trim(),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                hintText: "Mobile Number",
                                counterText: "",
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          AppButton(
                            text: isLoading ? "Sending..." : "Send OTP",
                            onPressed: validateAndSendOTP,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
