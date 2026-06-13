import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage>
    with SingleTickerProviderStateMixin {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool _loading = false;
  String tipoSelecionado = 'Morador'; // Valor padrão do dropdown

  late AnimationController _controller;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(reverse: true);

    _color1 = _controller.drive(
      TweenSequence<Color?>([
        TweenSequenceItem(
          tween: ColorTween(begin: const Color(0xFF00c6ff), end: const Color(0xFF7b4397)),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(begin: const Color(0xFF7b4397), end: const Color(0xFF43cea2)),
          weight: 1,
        ),
      ]),
    );

    _color2 = _controller.drive(
      TweenSequence<Color?>([
        TweenSequenceItem(
          tween: ColorTween(begin: const Color(0xFF185a9d), end: const Color(0xFF00c6ff)),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(begin: const Color(0xFF00c6ff), end: const Color(0xFF3f5efb)),
          weight: 1,
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

Future<void> _cadastrarUsuario() async {
  final nome = nomeController.text.trim();
  final email = emailController.text.trim();
  final senha = senhaController.text;
  final confirmarSenha = confirmarSenhaController.text;

  if (nome.isEmpty || email.isEmpty || senha.isEmpty || confirmarSenha.isEmpty) {
    if (!mounted) return;
    _mostrarMensagem("Preencha todos os campos.");
    return;
  }

  if (senha != confirmarSenha) {
    if (!mounted) return;
    _mostrarMensagem("As senhas não coincidem.");
    return;
  }

  try {
    if (!mounted) return;
    setState(() => _loading = true);

    UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );

    await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
      'nome': nome,
      'email': email,
      'tipo': tipoSelecionado,
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    _mostrarMensagem("Cadastro realizado com sucesso!");
    Navigator.pop(context); // Volta para tela de login
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;
    _mostrarMensagem("Erro de autenticação: ${e.message}");
  } catch (e) {
    if (!mounted) return;
    _mostrarMensagem("Erro ao cadastrar: $e");
  } finally {
    if (!mounted) return;
    setState(() => _loading = false);
  }
}


  void _mostrarMensagem(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.black87),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_color1.value!, _color2.value!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: buildCadastroCard(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCadastroCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 460),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Crie sua conta",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 28),
          buildTextField(controller: nomeController, label: "Nome", icon: Icons.person_outline),
          const SizedBox(height: 16),
          buildTextField(controller: emailController, label: "E-mail", icon: Icons.email_outlined, keyboard: TextInputType.emailAddress),
          const SizedBox(height: 16),
          buildTextField(controller: senhaController, label: "Senha", icon: Icons.lock_outline, obscure: true),
          const SizedBox(height: 16),
          buildTextField(controller: confirmarSenhaController, label: "Confirmar Senha", icon: Icons.lock_outline, obscure: true),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: tipoSelecionado,
            dropdownColor: Colors.grey[850],
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Entrar como',
              labelStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.group, color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
            items: ['Síndico', 'Morador', 'Portaria'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                tipoSelecionado = newValue!;
              });
            },
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _loading ? null : _cadastrarUsuario,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43A047),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 6,
              ),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Cadastrar",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Já possui conta? Faça login",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}