import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth_repo_bloc.dart';
import '../presentations/dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String? verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is OTPSent) {
              print("RECEIVED OTPSent state with ID: ${state.verificationId}");
              setState(() {
                verificationId = state.verificationId;
              });
              print("After setState, verificationId: $verificationId");
            }
            if (state is Authenticated) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  // Image.asset("assets/images/login_illustration.png", height: 180),
                  const SizedBox(height: 20),

                  const Text(
                    "Welcome Back!",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign in to continue",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 20),

                  if (state is AuthLoading) CircularProgressIndicator(),

                  // Email Field
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Password Field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon:
                          const Icon(Icons.lock, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Email Login Button
                  ElevatedButton(
                    onPressed: () {
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        context.read<AuthBloc>().add(
                              EmailLoginEvent(emailController.text,
                                  passwordController.text),
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Please enter both email and password."),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Sign in with Email",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Google Sign-In Button
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(GoogleSignInEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // FaIcon(Icons., color: Colors.white),
                        SizedBox(width: 8),
                        Text("Sign in with Google",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  Divider(thickness: 1.5, color: Colors.grey[300]),
                  SizedBox(height: 10),

                  // Phone Number Login
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: Icon(Icons.phone, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () {
                      if (phoneController.text.isNotEmpty &&
                          phoneController.text.length == 10) {
                        context
                            .read<AuthBloc>()
                            .add(PhoneLoginEvent(phoneController.text));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a phone number"),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.message, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Send OTP",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),

                  // OTP Field
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter OTP",
                      prefixIcon:
                          const Icon(Icons.lock, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () {
                      print("Verification ID received: $verificationId");
                      if (verificationId != null &&
                          otpController.text.isNotEmpty) {
                        context.read<AuthBloc>().add(VerifyOTPEvent(
                            verificationId!, otpController.text));
                        print(
                            "🛂 Verifying OTP: ${otpController.text} with ID: $verificationId");
                      } else {
                        print(
                            "❗ Error: verificationId is null or OTP is empty");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Verify OTP",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Anonymous Sign-In Button
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AnonymousSignInEvent());
                    },
                    child: Text("Sign in Anonymously",
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[700])),
                  ),

                  if (state is Unauthenticated && state.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        state.error!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
