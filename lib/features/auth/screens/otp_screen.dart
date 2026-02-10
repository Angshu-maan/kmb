import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kmb_app/core/storage/secure_storage.dart';
import 'package:kmb_app/core/auth/session_manager.dart';
import 'package:kmb_app/core/routes/role_router.dart';
import 'package:kmb_app/features/provider/auth_provider.dart';
import 'package:kmb_app/shared/back_button_handler.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../../../core/utils/otp_validator.dart';
import '../../../shared/primary_button.dart';




class OTPScreen extends StatefulWidget {


  final String phoneNumber;
  final String otpToken;

  const OTPScreen({
    super.key,
    required this.phoneNumber,
    required this.otpToken,
  });

  static OTPScreen fromGoRouter(BuildContext context, GoRouterState state) {
    final data = state.extra as Map<String, dynamic>?;

    if (data == null || data['phone'] == null || data['otpToken'] == null) {
      throw Exception('OTP route called without required data');
    }

    return OTPScreen(phoneNumber: data['phone'], otpToken: data['otpToken']);
  }

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  Timer? _resendTimer;
  int _timer = 60;

  bool _isLoading = false;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  String _getOtp() =>
      _otpControllers.map((controller) => controller.text).join();

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _startResendTimer() {
    _resendTimer?.cancel();

    setState(() {
      _timer = 60;
      _canResend = false;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _timer--);
      }
    });
  }

  String _formatTimer() {
    final minutes = (_timer ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timer % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<void> _verifyOtp() async {
    final otp = _getOtp();
    final error = OTPValidator.validateOTP(otp);

    if (error != null) {
      _showSnack(error);
      return;
    }

    setState(() => _isLoading = true);
    // debugPrint("Verify Otp Phone => ${widget.phoneNumber}");
    // debugPrint("Verify Otp Token => ${widget.otpToken}");
    // debugPrint("Otp => $otp");

    try {
      final authProofToken = await AuthService.verifyOtp(
        phone: widget.phoneNumber,
        otp: otp,
        otpToken: widget.otpToken,
      );
      final session = await AuthService.login(
        phone: widget.phoneNumber,
        authProofToken: authProofToken,
      );


        final expiryDate = DateTime.now().add(
    Duration(seconds: 20),
  );

  // Start global session tracking
  // AuthState.login(expiry: expiryDate);
      // final activeRole = Session['active_role'];
      
      // await SecureStorage.saveSession(session);
      // debugPrint("JWT SAVED TO SESSION => ${session.jwt}");

      // SessionManager.setSession(session);

      // debugPrint('ACTIVE ROLE => ${SessionManager.session!.activeRole}');
      // debugPrint('USER TYPE  => ${SessionManager.session!.userType}');

      final authProvider = context.read<AuthProvider>();
      await authProvider.login(session);



      if (!mounted) return;
      final route = RoleRouter.homeRouteForRole(session.activeRole);
      context.goNamed(route);
    } catch (e) {
      _showSnack(e.toString().replaceAll('Exception:', '').trim());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    try {
      final newOtpToken = await AuthService.sendOtp(widget.phoneNumber);

      if (!mounted) return;

      _showSnack("OTP sent successfully");

      context.goNamed(
        'otp',
        extra: {'phone': widget.phoneNumber, 'otpToken': newOtpToken},
      );
    } catch (e) {
      _showSnack(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  @override
  Widget build(BuildContext context) {


    return BackButtonHandler(
    
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 2,
            children: [

              SizedBox(
                height: 150,
                width: 200,
               child: Image.asset('assets/images/otp_image.png'),   
              ),
              const SizedBox(height:10 ,),
               
              const Text("Enter the 6-digit OTP "),
              const SizedBox(height: 6),
              Text(
                widget.phoneNumber.replaceRange(
                  0,
                  widget.phoneNumber.length - 4,
                  '****',
                ),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 48,
                    height: 55,
                    child: TextField(
                      controller: _otpControllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      decoration:  InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 163, 105, 240),
                              width: 3
                            )
  
                        ),
                        enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                        color: const Color.fromARGB(115, 0, 16, 246),
                        width: 3.0,
                        ),
                        
                       ),

                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 163, 105, 240),
                          width: 3.0,
                        ),
                      ),
                                            
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              AppButton(
                text: _isLoading ? "Verifying..." : "Verify OTP",
                onPressed: _isLoading ? null : _verifyOtp,
              
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: _canResend ? _resendOtp : null,
                child: Text(
                  _canResend ? "Send again" : "Resend OTP in ${_formatTimer()} s",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
