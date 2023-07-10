import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_client/models/journal.dart';

class DbFirestoreService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionJournals = 'journals';

  DbFirestoreService() {
    _firestore.settings = Settings(persistenceEnabled: true);
  }

  Stream<List<Journal>> getJournalList(String uid) {
    return _firestore
        .collection(_collectionJournals)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Journal> _journalDocs =
          snapshot.docs.map((doc) => Journal.fromDoc(doc)).toList();
      _journalDocs.sort((comp1, comp2) => comp2.date!.compareTo(comp1.date!));

      return _journalDocs;
    });

    Future<bool> addJournal(Journal journal) async {}
    void updateJournal(Journal journal) async {}
    void updateJournalWithTransaction(Journal journal) async {}
    void deleteJournal(Journal journal) async {}
  }
}
