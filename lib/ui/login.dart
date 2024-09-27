import 'package:flutter/material.dart';
import 'package:marketplace/repositories/user.dart';

class LoginPage extends StatefulWidget {
  final UserRepository userRepository;

  const LoginPage({super.key, required this.userRepository});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(
    text: "john.doe@example.com",
  );
  final _passwordController = TextEditingController(
    text: "hashedpassword123",
  );
  bool _obscurePassword = true;
  String? _errorMessage;

  void _login() async {
    final user = await widget.userRepository.authenticate(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (user != null) {
      Navigator.pushReplacementNamed(
        context,
        '/products',
        arguments: user.name,
      );
    } else {
      setState(() {
        _errorMessage = "Usuário ou senha incorretos.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Hero(
              tag: 'market',
              child: Icon(
                Icons.store,
                size: 100,
                color: Colors.blueAccent,
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "E-mail"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Senha",
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
