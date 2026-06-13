import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xgon_app/screens/login_page.dart';
import 'package:xgon_app/widgets/app_drawer_morador.dart';
import 'package:diacritic/diacritic.dart';

class HomeMorador extends StatelessWidget {
  const HomeMorador({super.key});

  Future<bool> _isMorador() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users') // ✅ Corrigido para a coleção certa
        .doc(user.uid)
        .get();

    if (!doc.exists) return false;

    final role = doc.data()?['tipo']?.toString() ?? '';
    final roleNormalized = removeDiacritics(role).toLowerCase();

    return roleNormalized == 'morador';
  }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return FutureBuilder<bool>(
      future: _isMorador(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.data!) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          });
          return const SizedBox.shrink();
        }

        final List<Map<String, dynamic>> funcoes = [
          {'titulo': 'Documentos', 'icone': Icons.folder, 'rota': '/documentos_morador'},
          {'titulo': 'Chat', 'icone': Icons.chat, 'rota': '/chat'},
          {'titulo': 'Assembleias', 'icone': Icons.how_to_vote, 'rota': '/assembleias_morador'},
          {'titulo': 'Obras/Mudanças', 'icone': Icons.construction, 'rota': '/obras'},
          {'titulo': 'Boletos', 'icone': Icons.request_page, 'rota': '/boletos'},
          {'titulo': 'Fundos', 'icone': Icons.savings, 'rota': '/fundos'},
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home - Morador'),
            backgroundColor: Colors.green[800],
          ),
          drawer: AppDrawerMorador(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: funcoes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) {
                final item = funcoes[index];

                return InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    item['rota'],
                    arguments: uid,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  splashColor: Colors.green.withOpacity(0.2),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.green.shade100, width: 1.5),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(item['icone'], size: 32, color: Colors.green[700]),
                          const SizedBox(height: 8),
                          Text(
                            item['titulo'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}