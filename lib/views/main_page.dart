import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fptapp/blocs/auth_bloc/auth-state.dart';
import 'package:fptapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:fptapp/blocs/auth_bloc/auth_event.dart';
import 'package:fptapp/services/firestore.dart';

class MainPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();
  MainPage({super.key});

  final String imageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Cat_August_2010-4.jpg/960px-Cat_August_2010-4.jpg';

  @override
  Widget build(BuildContext context) {
    void openNoteBox(String? docID) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              content: TextField(controller: textController),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (docID == null) {
                      //Add new note
                      firestoreService.addNote(textController.text);
                    } else {
                      //Updatenew note
                      firestoreService.updateNote(docID, textController.text);
                    }

                    //Clear the text controller
                    textController.clear();

                    //close the box
                    Navigator.pop(context);
                  },
                  child: Text("Save"),
                ),
              ],
            ),
      );
    }

    void deleteNote(String docID) {
      firestoreService.deleteNote(docID);
    }

    return BlocListener<AuthBlocLogout, Authstate>(
      listener: (context, state) {
        if (state is AuthStateLogoutDone) {
          print(FirebaseAuth.instance.currentUser);
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login/', (_) => false);
        } else if (state is AuthStateError && state.error != null) {
          final snackBar = SnackBar(content: Text(state.error!));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Main Page'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBlocLogout>().add(AuthEventLogout());
              },
              tooltip: 'Logout',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => openNoteBox(null),
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            //Print all data if have note
            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;

              //display as a list
              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  //get each noteb
                  DocumentSnapshot document = notesList[index];
                  String docID = document.id;

                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String noteText = data['notes'];
                  return ListTile(
                    title: Text(noteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => openNoteBox(docID),
                          icon: const Icon(Icons.settings),
                        ),
                        IconButton(
                          onPressed: () => deleteNote(docID),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                      
                    ),
                  );
                },
              );
            } else {
              return const Text("No notes...");
            }
          },
        ),
      ),
    );
  }
}
