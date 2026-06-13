import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final acessos = FirebaseFirestore.instance.collection('acessos');
  final prestadores = FirebaseFirestore.instance.collection('prestadores');
  final visitantes = FirebaseFirestore.instance.collection('visitantes');

  Future<void> addAcesso(Map<String, dynamic> data) => acessos.add(data);
  Future<void> updateAcesso(String id, Map<String, dynamic> data) =>
      acessos.doc(id).update(data);
  Future<void> deleteAcesso(String id) async =>
      await acessos.doc(id).delete(); // <-- adicionado

  Future<void> addPrestador(Map<String, dynamic> data) =>
      prestadores.add(data);
  Future<void> deletePrestador(String id) =>
      prestadores.doc(id).delete();

  Future<void> addVisitante(Map<String, dynamic> data) =>
      visitantes.add(data);
  Future<void> updateVisitante(String id, Map<String, dynamic> data) =>
      visitantes.doc(id).update(data);

  Future<void> updatePrestador(String id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('prestadores')
        .doc(id)
        .update(data);
  }

  Future<void> deleteVisitante(String id) async {
    await visitantes.doc(id).delete();
  }
}