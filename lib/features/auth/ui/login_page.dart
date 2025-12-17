import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../data/auth_api.dart';
import '../../dashboard/home_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  Future<void> _onLogin() async {
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
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/cameron_logo2.png'),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      final s = (v ?? "").trim();
                      if (s.isEmpty) return "Email is required";
                      if (!s.contains("@")) return "Enter a valid email";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passCtrl,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (v) {
                      if ((v ?? "").isEmpty) return "Password is required";
                      if ((v ?? "").length < 6) return "Min 6 characters";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  if (_error != null) ...[
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 12),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _onLogin,
                      child: Text(
                        _loading ? "Logging in..." : "Login",
                        style: const TextStyle(
                          color: Colors.black,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFC425),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 3,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
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
