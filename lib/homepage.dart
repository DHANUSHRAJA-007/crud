import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/firestore.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textcontroller = TextEditingController();

  void openNotebox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textcontroller),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firestoreService.addNote(textcontroller.text);
              } else {
                firestoreService.updatenote(textcontroller.text, docID);
              }

              textcontroller.clear();
              Navigator.pop(context);
            },
            child: Text("Add note"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text("Notes")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNotebox,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getnotesstream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];
                return ListTile(
                  title: Text(noteText),
                  trailing: IconButton(
                    onPressed: () => openNotebox(docID: docID),
                    icon: Icon(Icons.settings),
                  ),
                );
              },
            );
          } else {
            return Text("no notes");
          }
        },
      ),
    );
  }
}
