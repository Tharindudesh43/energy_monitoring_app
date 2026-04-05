import 'package:energy_monitoring_app/auth-pages/signup.dart';
import 'package:energy_monitoring_app/user-pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An unexpected error occurred"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Future<void> _signInWithGoogle() async {
  //   setState(() => _isGoogleLoading = true);

  //   try {
  //     final googleSignIn = GoogleSignIn.instance(
  //       serverClientId: 'YOUR_GOOGLE_WEB_CLIENT_ID', // from Google Cloud Console
  //     );

  //     final googleUser = await googleSignIn.signIn();
  //     if (googleUser == null) {
  //       // User cancelled
  //       setState(() => _isGoogleLoading = false);
  //       return;
  //     }

  //     final googleAuth = await googleUser.authentication;

  //     if (googleAuth.accessToken == null || googleAuth.idToken == null) {
  //       _showSnackBar("Failed to get Google credentials", isError: true);
  //       return;
  //     }

  //     await _supabase.auth.signInWithIdToken(
  //       provider: OAuthProvider.google,
  //       idToken: googleAuth.idToken!,
  //       accessToken: googleAuth.accessToken!,
  //     );

  //     if (mounted) {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => const HomePage()),
  //       );
  //     }
  //   } on AuthException catch (e) {
  //     _showSnackBar(e.message, isError: true);
  //   } catch (e) {
  //     _showSnackBar("Google sign-in failed. Please try again.", isError: true);
  //   } finally {
  //     if (mounted) setState(() => _isGoogleLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      height: 260,
                      child: Image.asset('assets/signin_image.png'),
                    ),
                  ),
                  const Text(
                    "Sign In to Your Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Email field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email Account: ",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 1,
                          cursorColor: Colors.green,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: "ccc@gmail.com",
                            hintStyle: TextStyle(color: Colors.green),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                                width: 2,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Access Key: ",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          maxLines: 1,
                          cursorColor: Colors.green,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: "* * * * * * ",
                            hintStyle: const TextStyle(color: Colors.green),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                                width: 2,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                                width: 2,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.green,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Navigate to Sign Up
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Signup()),
                    ),
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 103, 214, 106),
                            Color.fromARGB(255, 67, 115, 11),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signInWithEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                            : const Text(
                                "SIGN IN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // OR divider
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 40),
                  //   child: Row(
                  //     children: const [
                  //       Expanded(child: Divider(color: Colors.grey)),
                  //       Padding(

                  //         padding: EdgeInsets.symmetric(horizontal: 12),
                  //         child: Text(
                  //           "OR",
                  //           style: TextStyle(color: Colors.grey),
                  //         ),
                  //       ),
                  //       Expanded(child: Divider(color: Colors.grey)),
                  //     ],
                  //   ),
                  // ),

                  // const SizedBox(height: 12),

                  // Google Sign In button
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 40),
                  //   child: Container(
                  //     padding: const EdgeInsets.all(3),
                  //     decoration: BoxDecoration(
                  //       gradient: const LinearGradient(
                  //         colors: [
                  //           Color.fromARGB(255, 103, 214, 106),
                  //           Color.fromARGB(255, 67, 115, 11),
                  //         ],
                  //       ),
                  //       borderRadius: BorderRadius.circular(100),
                  //     ),
                  //     child: ElevatedButton(
                  //       onPressed: () => {},
                  //       // onPressed: _isGoogleLoading ? null : _signInWithGoogle,
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.transparent,
                  //         shadowColor: Colors.transparent,
                  //         minimumSize: const Size(double.infinity, 52),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(100),
                  //         ),
                  //       ),
                  //       child: _isGoogleLoading
                  //           ? const CircularProgressIndicator(
                  //               valueColor: AlwaysStoppedAnimation<Color>(
                  //                 Colors.white,
                  //               ),
                  //             )
                  //           : Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Container(
                  //                   width: 28,
                  //                   height: 28,
                  //                   padding: const EdgeInsets.all(4),
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(6),
                  //                   ),
                  //                   child: Image.network(
                  //                     "https://www.google.com/images/branding/googleg/1x/googleg_standard_color_128dp.png",
                  //                     fit: BoxFit.contain,
                  //                     errorBuilder:
                  //                         (context, error, stackTrace) =>
                  //                             const Icon(
                  //                               Icons.g_mobiledata,
                  //                               color: Colors.black,
                  //                               size: 20,
                  //                             ),
                  //                   ),
                  //                 ),
                  //                 const SizedBox(width: 12),
                  //                 const Text(
                  //                   "CONTINUE WITH GOOGLE",
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
