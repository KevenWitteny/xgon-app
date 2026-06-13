import 'package:flutter/material.dart';
import 'package:xgon_app/screens/sindico/documentos_page.dart';
import 'package:xgon_app/screens/sindico/chat_page.dart';
import 'package:xgon_app/screens/sindico/agenda_page.dart';
import 'package:xgon_app/screens/sindico/livro_ocorrencias_page.dart';
import 'package:xgon_app/screens/sindico/mudancas_obras_page.dart';
import 'package:xgon_app/screens/sindico/contabilidade_page.dart';
import 'package:xgon_app/screens/sindico/assembleia_page.dart';
import 'package:xgon_app/screens/sindico/manutencao_page.dart';
import 'package:xgon_app/screens/sindico/seguro_page.dart';
import 'package:xgon_app/screens/sindico/fundos_page.dart';
import 'package:xgon_app/screens/sindico/boletos_sindico.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {
  final String title;
  final String tipoUsuario;

  const AppDrawer({
    super.key,
    required this.title,
    required this.tipoUsuario,
  });

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

          // VISÍVEL PARA TODOS
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Documentos'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DocumentosSindico()),
            ),
          ),

          if (tipoUsuario == 'Síndico' || tipoUsuario == 'Portaria') ...[
ListTile(
  leading: const Icon(Icons.chat),
  title: const Text("Chat"),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChatPage(grupoId: 'chat_geral'),
      ),
    );
  },
),

            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text('Livro de Ocorrências'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LivroOcorrenciasPage()),
              ),
            ),
          ],

          if (tipoUsuario == 'Síndico') ...[
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Agenda'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AgendaPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.construction),
              title: const Text('Mudanças e Obras'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MudancasObrasPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calculate_outlined),
              title: const Text('Contabilidade'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContabilidadePage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.how_to_vote),
              title: const Text('Assembleias'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AssembleiasPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.build_circle),
              title: const Text('Manutenções'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManutencaoPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Seguro'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SeguroPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.savings),
              title: const Text('Fundos'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FundosPage()),
              ),
            ),
            // 👇 Novo item: Boletos (Síndico)
            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Boletos'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BoletosSindicoPage()),
              ),
            ),
          ],

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