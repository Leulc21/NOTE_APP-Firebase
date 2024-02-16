// ignore_for_file: unused_import

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Firestore {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");
  Future<void> addNote(String note) {
    return notes.add({'note': note, 'timestamp': DateTime.now()});
  }

  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updateNote(String documentID, String newText) {
    return notes.doc(documentID).update({
      'note': newText,
      'timestamp': Timestamp.now()
      });
  }
  Future<void> deleteNote(String docID){
    return notes.doc(docID).delete();
  }
}
