import 'package:journal_client/models/journal.dart';

abstract class DbApi{
  Stream<List<Journal>> getJournalList(String uid);
  Future<Journal> getJournal(String uid, String docId);
  Future<bool> addJournal(Journal journal);
  void updateJournal(Journal journal);
  // void updateJournalWithTransaction(Journal journal);
  void deleteJournal(Journal journal);
}