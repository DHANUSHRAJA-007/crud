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

  void openNotebox({String? docID, String? existingText}) {
    textcontroller.text = existingText ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Enter your note 👇",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: textcontroller,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Notes...",
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              if (docID == null) {
                firestoreService.addNote(textcontroller.text);
              } else {
                firestoreService.updatenote(textcontroller.text, docID);
              }

              textcontroller.clear();
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notes, color: Colors.white),
            Text("Notes", style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Tap to Add notes",
        backgroundColor: Colors.blue,
        onPressed: () => openNotebox(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getnotesstream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("No notes"));
          }

          final notesList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notesList.length,
            itemBuilder: (context, index) {
              final document = notesList[index];
              final docID = document.id;
              final data = document.data() as Map<String, dynamic>;
              final noteText = data['note'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(noteText),

                    trailing: Wrap(
                      children: [
                        IconButton(
                          tooltip: "Edit",
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            openNotebox();
                          },
                        ),
                        IconButton(
                          tooltip: "Delete",
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            firestoreService.deletenote(docID);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
