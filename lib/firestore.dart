import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  // ✅ ADD NOTE
  Future<void> addNote(String text) async {
    if (text.trim().isEmpty) return;

    await notes.add({
      'note': text.trim(),
      'timestamp': Timestamp.now(),
    });
  }

  // ✅ DELETE NOTE
  Future<void> deletenote(String docID) async {
    await notes.doc(docID).delete();
  }

  // ✅ GET NOTES STREAM (SAFE)
  Stream<QuerySnapshot> getnotesstream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  // ✅ UPDATE NOTE
  Future<void> updatenote(String newtext, String docID) async {
    if (newtext.trim().isEmpty) return;

    await notes.doc(docID).update({
      'note': newtext.trim(),
      'timestamp': Timestamp.now(),
    });
  }
}