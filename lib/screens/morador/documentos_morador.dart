import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentosMorador extends StatefulWidget {
  const DocumentosMorador({super.key});

  @override
  State<DocumentosMorador> createState() => _DocumentosMoradorState();
}

class _DocumentosMoradorState extends State<DocumentosMorador> {
  final user = FirebaseAuth.instance.currentUser!;
  String search = "";

  /// Abrir documento em outro app
  void abrirDocumento(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Não foi possível abrir o documento.")),
      );
    }
  }

  /// Marcar documento como lido
  Future<void> marcarComoLido(String docId, List<dynamic> lidoPor) async {
    if (!lidoPor.contains(user.uid)) {
      await FirebaseFirestore.instance.collection("documentos").doc(docId).update({
        "lido_por": FieldValue.arrayUnion([user.uid]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Documentos"),
        backgroundColor: Colors.green[800],
      ),
      body: Column(
        children: [
          // 🔎 Campo de pesquisa fora da AppBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Pesquisar documento...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => search = value.toLowerCase());
              },
            ),
          ),
          // Lista de documentos
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("documentos")
                  .orderBy("created_at", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final nome = (data["nome"] ?? "").toString().toLowerCase();
                  final visibilidade = (data["visibilidade"] ?? "todos").toString();
                  final usuarioId = data["userId"] ?? "";

                  final podeVer = visibilidade == "todos" || usuarioId == user.uid;

                  return podeVer && (search.isEmpty || nome.contains(search));
                }).toList();

                if (docs.isEmpty) {
                  return const Center(child: Text("Nenhum documento encontrado"));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final timestamp = (data["created_at"] as Timestamp?)?.toDate();
                    final dataFormatada = timestamp != null
                        ? DateFormat("dd/MM/yyyy HH:mm").format(timestamp)
                        : "Data não disponível";
                    final lidoPor = List<String>.from(data["lido_por"] ?? []);

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(
                          lidoPor.contains(user.uid)
                              ? Icons.check_circle
                              : Icons.description,
                          color: lidoPor.contains(user.uid)
                              ? Colors.green
                              : Colors.blue,
                          size: 32,
                        ),
                        title: Text(data["nome"] ?? "Sem nome"),
                        subtitle: Text(
                          "${data["categoria"]} • ${data["mes"]}/${data["ano"]}\n$dataFormatada",
                        ),
                        isThreeLine: true,
                        onTap: () {
                          abrirDocumento(data["url"]);
                          marcarComoLido(doc.id, lidoPor);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}