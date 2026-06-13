import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

// Import das telas
import 'screens/login_page.dart';
import 'screens/cadastro_page.dart';
import 'screens/sindico/home_sindico.dart';
import 'screens/morador/documentos_morador.dart';
import 'screens/sindico/documentos_page.dart';
import 'screens/sindico/chat_page.dart';
import 'screens/sindico/agenda_page.dart';
import 'screens/sindico/livro_ocorrencias_page.dart';
import 'screens/sindico/mudancas_obras_page.dart';
import 'screens/sindico/contabilidade_page.dart';
import 'screens/sindico/assembleia_page.dart';
import 'screens/sindico/manutencao_page.dart';
import 'screens/sindico/fundos_page.dart';
import 'screens/sindico/seguro_page.dart';
import 'screens/sindico/axia_assistente_page.dart';
import 'screens/morador/home_morador.dart';
import 'screens/morador/assembleias_morador_page.dart';
import 'screens/morador/boletos_page.dart';
import 'screens/portaria/home_portaria.dart';
import 'screens/portaria/acessos_page.dart';
import 'screens/portaria/prestadores_page.dart' as prestadores;
import 'screens/portaria/visitantes_page.dart' as visitantes;
import 'screens/sindico/boletos_sindico.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);
  Intl.defaultLocale = 'pt_BR';

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XGON App',
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const WrapperPage(), // Página inicial que decide para onde ir
      routes: {
        '/login': (context) => const LoginPage(),
        '/home_sindico': (context) => const HomeSindico(),
        '/home_morador': (context) => const HomeMorador(),
        '/assembleias_morador': (context) => const AssembleiasMoradorPage(),
        '/documentos_morador': (context) => const DocumentosMorador(),
        '/documentos': (context) => const DocumentosSindico(),
        '/home_portaria': (context) => const HomePortaria(),
        '/acessosportaria': (_) => AcessosPage(),
        '/prestadoresportaria': (_) => prestadores.PrestadoresPage(),
        '/visitantesportaria': (_) => visitantes.VisitantesPage(),
        '/cadastro': (context) => const CadastroPage(),
        '/chat': (context) => const ChatPage(grupoId: 'chat_geral'),
        '/agenda': (context) => const AgendaPage(),
        '/ocorrencias': (context) => const LivroOcorrenciasPage(),
        '/mudancas_obras': (context) => const MudancasObrasPage(),
        '/contabilidade': (context) => const ContabilidadePage(),
        '/assembleia': (context) => const AssembleiasPage(),
        '/manutencao': (context) => const ManutencaoPage(),
        '/fundos': (context) => const FundosPage(),
        '/seguro': (context) => const SeguroPage(),
        '/assistente_axia': (context) => const AxiaAssistentePage(),
      },
    );
  }
}

class WrapperPage extends StatelessWidget {
  const WrapperPage({super.key});

  Future<String> _getUserPerfil() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'none';
    final doc = await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get();
    return doc.exists ? doc['perfil'] as String : 'none';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserPerfil(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final perfil = snapshot.data!;
        switch (perfil) {
          case 'sindico':
            return const HomeSindico();
          case 'morador':
            return const HomeMorador();
          case 'portaria':
            return const HomePortaria();
          default:
            return const LoginPage();
        }
      },
    );
  }
}