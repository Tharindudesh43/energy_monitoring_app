import 'package:energy_monitoring_app/auth-pages/signin.dart';
import 'package:energy_monitoring_app/user-pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isLoading = false;
  final _supabase = Supabase.instance.client;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _accessKeyController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _accountNumberController.dispose();
    _accessKeyController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_usernameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _mobileController.text.trim().isEmpty ||
        _accountNumberController.text.trim().isEmpty ||
        _accessKeyController.text.trim().isEmpty) {
      _showSnackBar("Please fill in all fields", isError: true);
      return;
    }

    if (_accessKeyController.text.trim().length < 6) {
      _showSnackBar("Password must be at least 6 characters", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authResponse = await _supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _accessKeyController.text.trim(),
      );

      final user = authResponse.user;
      if (user == null) {
        _showSnackBar("Signup failed. Please try again.", isError: true);
        return;
      }

      await _supabase.from('users').insert({
        'id': user.id,
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'account_number': _accountNumberController.text.trim(),
      });

      if (mounted) {
        _showSnackBar("Account created successfully! ✅");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Signin()),
        );
      }
    } on AuthException catch (e) {
      // Supabase auth-specific errors
      String message = e.message;
      if (message.contains('already registered')) {
        message = "Email already in use. Please sign in.";
      } else if (message.contains('weak')) {
        message = "Password is too weak. Use at least 6 characters.";
      }
      _showSnackBar(message, isError: true);
    } on PostgrestException catch (e) {
      // Database insert errors
      _showSnackBar("Failed to save profile: ${e.message}", isError: true);
    } catch (e) {
      _showSnackBar("Something went wrong. Please try again.", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
          TextField(
            controller: controller,
            obscureText: isPassword ? _obscurePassword : false,
            keyboardType: type,
            cursorColor: Colors.green,
            style: const TextStyle(color: Colors.green, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.green, fontSize: 14),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
              // Show toggle only on password field
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.green,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                // Logo
                Container(
                  width: 200,
                  height: 200,
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/signin_image.png',
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.person_add,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),
                ),

                const Text(
                  "Create Your Account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  "Username:",
                  "Enter your name",
                  _usernameController,
                ),
                _buildInputField(
                  "Email Address:",
                  "example@mail.com",
                  _emailController,
                  type: TextInputType.emailAddress,
                ),
                _buildInputField(
                  "Mobile Number:",
                  "07xxxxxxxx",
                  _mobileController,
                  type: TextInputType.phone,
                ),
                _buildInputField(
                  "Existing Bill Account Number:",
                  "CEB_xxxxxx_xxxxxx",
                  _accountNumberController,
                ),
                _buildInputField(
                  "Access Key:",
                  "* * * * * *",
                  _accessKeyController,
                  isPassword: true,
                ),

                const SizedBox(height: 30),

                // Create Account button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF67D66A), Color(0xFF43730B)],
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          : const Text(
                              "CREATE ACCOUNT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Signin()),
                  ),
                  child: const Text(
                    "Already have an account? Sign In",
                    style: TextStyle(color: Colors.green),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
