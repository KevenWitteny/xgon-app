import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xgon_app/screens/morador/documentos_morador.dart';

class AppDrawerMorador extends StatelessWidget {
  const AppDrawerMorador({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text(
              'Menu Morador',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Documentos'),
            onTap: () {
              Navigator.pushNamed(context, '/documentos_morador');
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            onTap: () {
              Navigator.pushNamed(context, '/chat');
            },
          ),
          ListTile(
            leading: const Icon(Icons.how_to_vote),
            title: const Text('Assembleias'),
            onTap: () {
              Navigator.pushNamed(context, '/assembleias');
            },
          ),
          ListTile(
            leading: const Icon(Icons.construction),
            title: const Text('Obras/Mudanças'),
            onTap: () {
              Navigator.pushNamed(context, '/obras');
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_page),
            title: const Text('Boletos'),
            onTap: () {
              Navigator.pushNamed(context, '/boletos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.savings),
            title: const Text('Fundos'),
            onTap: () {
              Navigator.pushNamed(context, '/fundos');
            },
          ),
ListTile(
  leading: const Icon(Icons.logout),
  title: const Text('Sair'),
  onTap: () async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}