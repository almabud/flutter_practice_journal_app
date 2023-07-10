import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_client/models/journal.dart';

import '../services/authentication_api.dart';
import '../services/db_firestore_api.dart';

class HomeBloc {
  final DbApi dbApi;
  final AuthenticationApi authenticationApi;

  final StreamController<List<Journal>> _journalController =
      StreamController<List<Journal>>.broadcast();
  Sink<List<Journal>> get _addListJournal => _journalController.sink;
  Stream<List<Journal>> get listJournal => _journalController.stream;
  final StreamController<Journal> _journalDeleteController =
  StreamController<Journal>.broadcast();
  Sink<Journal> get deleteJournal => _journalDeleteController.sink;


  HomeBloc(this.dbApi, this.authenticationApi){
    _startListeners();
  }

  void dispose(){
    _journalController.close();
    _journalDeleteController.close();
  }

  void _startListeners(){
    User user = authenticationApi.getFirebaseAuth().currentUser;
    dbApi.getJournalList(user.uid).listen((journalDocs){
      _addListJournal.add(journalDocs);
    });

    _journalDeleteController.stream.listen((journal) {
      dbApi.deleteJournal(journal);
    });

  }
}


