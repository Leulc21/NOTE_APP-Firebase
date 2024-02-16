// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudapp/service/firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Firestore firestoreservice = Firestore();
  final TextEditingController textController = TextEditingController();

  void openNoteBox(String? docID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firestoreservice.addNote(textController.text);
              } else {
                firestoreservice.updateNote(docID, textController.text);
              }
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor:  Color(0xFFE2DED0),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'አጀንዳ',
          style: TextStyle(
            fontFamily: 'Chiret',
             fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF4E4F50),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox,
        backgroundColor: Colors.black87,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreservice.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> notesList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notesList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = notesList[index];

              String docID = document.id;
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String noteText = data['note'];

              return Column(
                children: [
                  SizedBox(height: 20.0),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 8.0,
                        right: 16.0,
                        left: 16.0), // Adjust the bottom margin for spacing
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(noteText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => openNoteBox(docID),
                            icon: Icon(Icons.settings,color: Colors.black54,),
                          ),
                          IconButton(
                            onPressed: () => firestoreservice.deleteNote(docID),
                            icon: Icon(Icons.delete,color: Colors.black54,),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        DateFormat('yyyy-MM-dd HH:mm')
                            .format(data['timestamp'].toDate()),
                      ),
                    ),
                  ),
                  // Add a SizedBox for spacing between tiles
                  SizedBox(height: 8.0), // Adjust the height for spacing
                  // Repeat the structure for the second ListTile and so on...
                ],
              );
            },
          );
        },
      ),
    );
  }
}
