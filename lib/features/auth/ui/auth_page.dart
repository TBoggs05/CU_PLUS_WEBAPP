import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../api/auth_api.dart';
import '../../dashboard/home_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String? _error;
  String? _tokenPreview;

  late final AuthApi _authApi;

  @override
  void initState() {
    super.initState();
    _authApi = AuthApi(ApiClient());
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onVerify() async {
    setState(() {
      _error = null;
      _tokenPreview = null;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final res = await _authApi.login(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      //final verification_code - user?[""]
      final user = res["user"] as Map<String, dynamic>?;
      final email = (user?["email"] ?? _emailCtrl.text.trim()).toString();

      if (!mounted) return;

      // popup
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Login successful!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );

      // navigate
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(email: email)),
      );

      final token = (res["token"] ?? "").toString();
      setState(() {
        _tokenPreview = token.isEmpty
            ? "(no token returned)"
            : "${token.substring(0, token.length > 25 ? 25 : token.length)}...";
      });
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst("Exception: ", ""));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Plus Scholar Cameron",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: 
          Image.asset('assets/images/cameron_logo2.png'),
          // SvgPicture.asset('assets/images/cameron_logo2_embedded.svg'),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 0),
                  const Text(
                    "Two-factor authentication",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 60),
                  
                    Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "The 6-digit code sent to your email will expire in 15 minutes. Do not share this with anyone.",
                      style: TextStyle(fontSize: 16, color: Color(0xFF111928)),
                    ),
                    const SizedBox(height: 20),
                  ],
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Authentication code", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: true,
                        // validator: (v) {
                        //   if ((v ?? "").isEmpty) return "Password is required";
                        //   if ((v ?? "").length < 6) return "Min 6 characters";
                        //   return null;
                        // },

                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter 6-digit code",

                          filled: true,
                          fillColor: Color(0xFFF5F5F5),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),

                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),

                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (_error != null) ...[
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 12),
                  ],

                  const SizedBox(height: 10),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _loading ? null : _onVerify,
                          // ignore: sort_child_properties_last
                          child: Text(
                            _loading ? "Verifying..." : "Verify",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 24,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFC425),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3, // shadow
                            padding: const EdgeInsets.symmetric(
                              vertical: 22,
                              horizontal: 60,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        TextButton(
                          onPressed: () => null,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_tokenPreview != null) ...[
                    const SizedBox(height: 12),
                    Text("Token: $_tokenPreview"),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
