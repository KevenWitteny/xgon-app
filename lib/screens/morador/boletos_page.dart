import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class BoletosPage extends StatelessWidget {
  const BoletosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Boletos"),
        backgroundColor: Colors.green[800],
      ),
      body: uid == null
          ? const Center(child: Text("Usuário não autenticado"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("boletos")
                  .where("userId", isEqualTo: uid)
                  .orderBy("vencimento", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Nenhum boleto disponível"));
                }

                final boletos = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: boletos.length,
                  itemBuilder: (context, index) {
                    final data = boletos[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Icon(
                          data['status'] == 'pago'
                              ? Icons.check_circle
                              : Icons.pending,
                          color: data['status'] == 'pago'
                              ? Colors.green
                              : Colors.orange,
                        ),
                        title: Text("Mês: ${data['mes']}"),
                        subtitle: Text(
                          "Valor: R\$ ${data['valor']}\n"
                          "Vencimento: ${data['vencimento']}\n"
                          "Status: ${data['status']}",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.picture_as_pdf),
                          onPressed: () {
                            final url = data['arquivoUrl'];
                            if (url != null) {
                              // abrir PDF com url_launcher
                            }
                          },
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