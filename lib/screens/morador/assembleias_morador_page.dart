import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssembleiasMoradorPage extends StatelessWidget {
  const AssembleiasMoradorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Usuário não autenticado.'));
    }

    final uid = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assembleias'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('assembleias')
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('Nenhuma assembleia disponível.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final titulo = data['titulo'] ?? '';
              final descricao = data['descricao'] ?? '';
              final opcoes = data['opcoes'] != null
                  ? List<String>.from(data['opcoes'])
                  : <String>[];
              final votos = data.containsKey('votos')
                  ? Map<String, dynamic>.from(data['votos'])
                  : <String, dynamic>{};
              final votoDoUsuario = votos[uid];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(descricao),
                      const SizedBox(height: 16),
                      if (votoDoUsuario == null) ...[
                        const Text('Escolha uma opção:'),
                        ...opcoes.map(
                          (opcao) => ListTile(
                            title: Text(opcao),
                            leading: const Icon(Icons.how_to_vote),
                            onTap: () async {
                              final confirmar = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmação de voto'),
                                  content: Text(
                                      'Você tem certeza que deseja votar em "$opcao"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Confirmar'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmar == true) {
                                await FirebaseFirestore.instance
                                    .collection('assembleias')
                                    .doc(doc.id)
                                    .update({
                                  'votos.$uid': opcao,
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Voto registrado!')),
                                );
                              }
                            },
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Você votou: $votoDoUsuario',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}