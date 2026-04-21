import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/auth_controller.dart';
import '../api/auth_api.dart';
import "../models/session_user.dart";

class VerifyTwoFactorPage extends StatefulWidget {
  final String email;
  const VerifyTwoFactorPage({super.key, required this.email});

  @override
  State<VerifyTwoFactorPage> createState() => _VerifyTwoFactorPageState();
}

class _VerifyTwoFactorPageState extends State<VerifyTwoFactorPage> {
  final _codeCtrl = TextEditingController();
  bool _loading = false;
  bool _resending = false;
  String? _error;
  String? _message;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() {
      _loading = true;
      _error = null;
      _message = null;
    });

    try {
      final api = context.read<AuthApi>();
      final res = await api.verifyTwoFactor(
        email: widget.email,
        code: _codeCtrl.text.trim(),
      );

      final userMap = res["user"] as Map<String, dynamic>?;
      if (userMap == null) {
        throw Exception("Invalid user response");
      }

      final user = SessionUser(
        id: userMap["id"].toString(),
        email: userMap["email"].toString(),
        role: userMap["role"].toString(),
      );

      context.read<AuthController>().setUser(user);

      if (!mounted) return;
      context.go("/dashboard");
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      _resending = true;
      _error = null;
      _message = null;
    });

    try {
      final api = context.read<AuthApi>();
      final res = await api.resendTwoFactor(email: widget.email);

      setState(() {
        _message = res["message"]?.toString() ?? "Verification code resent";
      });
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Enter Verification Code",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text("We sent a 6-digit code to ${widget.email}"),
                const SizedBox(height: 16),
                TextField(
                  controller: _codeCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Verification Code",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loading ? null : _verify,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text("Verify"),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _resending ? null : _resend,
                  child: Text(_resending ? "Resending..." : "Resend Code"),
                ),
                if (_message != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _message!,
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}