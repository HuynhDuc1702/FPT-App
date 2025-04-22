import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fptapp/blocs/auth_bloc/auth-state.dart';
import 'package:fptapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:fptapp/blocs/auth_bloc/auth_event.dart';
import 'package:fptapp/blocs/notes/notes_bloc.dart';
import 'package:fptapp/blocs/notes/notes_event.dart';
import 'package:fptapp/blocs/notes/notes_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Load notes when the widget is created
    context.read<NotesBloc>().add(LoadNotes());
  }

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
                      context.read<NotesBloc>().add(
                        AddNote(textController.text),
                      );
                    } else {
                      //Updatenew note
                      context.read<NotesBloc>().add(
                        UpdateNote(docID, textController.text),
                      );
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
      context.read<NotesBloc>().add(DeleteNote(docID));
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
          title: const Text('Your Notes'),
         backgroundColor: Colors.blue,
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
        body: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            if (state is NotesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            //Print all data if have note
            else if (state is NotesLoaded) {
              final notesList = state.notes;
              if (notesList.isEmpty) {
                return const Center(child: Text("No notes..."));
              }

              //display as a list
              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  //get each note
                  final note = notesList[index];
                  final String noteText = note['note'];
                  final String docID = note['id'];

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
              return const Center(
                child: Text("Something went wrong or unknown state"),
              );
            }
          },
        ),
      ),
    );
  }
}
