import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawerPortaria extends StatelessWidget {
  const AppDrawerPortaria({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text('Visitantes'),
            onTap: () {
              Navigator.pushNamed(context, '/visitantesportaria');
            },
          ),
          ListTile(
            leading: const Icon(Icons.engineering),
            title: const Text('Prestadores'),
            onTap: () {
              Navigator.pushNamed(context, '/prestadoresportaria');
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Acessos'),
            onTap: () {
              Navigator.pushNamed(context, '/acessosportaria');
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
