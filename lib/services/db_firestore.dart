import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_client/models/journal.dart';

import 'db_firestore_api.dart';

class DbFirestoreService implements DbApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionJournals = 'journals';

  Stream<List<Journal>> getJournalList(String uid) {
    return _firestore
        .collection(_collectionJournals)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Journal> _journalDocs =
      snapshot.docs.map((doc) => Journal.fromDoc(doc)).toList();

      return _journalDocs;
    });
  }

  Future<Journal> getJournal(String uid, String docId) async{
    QuerySnapshot<Map<String, dynamic>> snapshot =  await _firestore
        .collection(_collectionJournals)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: docId)
        .limit(1)
        .get();

    return Journal.fromDoc(snapshot.docs[0]);
  }

  Future<bool> addJournal(Journal journal) async {
    DocumentReference _documentReference =
    await _firestore.collection(_collectionJournals).add({
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
      'uid': journal.uid
    });

    return true;
  }

  void updateJournal(Journal journal) async {
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .update({
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note
    }).catchError((error) => print('Error updating: $error'));
  }

  void deleteJournal(Journal journal) async {
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .delete()
        .catchError((error) => print('Error deleting: $error'));
  }
}
