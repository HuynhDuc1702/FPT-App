import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fptapp/blocs/auth_bloc/auth-state.dart';
import 'package:fptapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:fptapp/blocs/auth_bloc/auth_event.dart';
import 'package:fptapp/blocs/musics/musics_bloc.dart';
import 'package:fptapp/blocs/musics/musics_event.dart';
import 'package:fptapp/blocs/musics/musics_state.dart';
import 'package:fptapp/models/musics_model.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController filenameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MusicBloc>().add(LoadMusic());
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  void openMusicBox({String? docID, Musics? existingMusic}) {
    if (existingMusic != null) {
      titleController.text = existingMusic.tiles;
      filenameController.text = existingMusic.filename ;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(docID == null ? "Add Music" : "Edit Music"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: filenameController,
                  decoration: const InputDecoration(labelText: "File full name"),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final filename = filenameController.text.trim();

                  if (docID == null) {
                    context.read<MusicBloc>().add(AddMusic(title, filename));
                  } else {
                    context.read<MusicBloc>().add(
                      UpdateMusic(docID, title, filename),
                    );
                  }

                  titleController.clear();
                  filenameController.clear();

                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  void openMusicPlayerDialog(String title, String filename) {
    showDialog(
      context: context,
      builder: (context) {
        // Start playing the music when opening the dialog
        _audioPlayer.play(AssetSource('music/$filename'));

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.music_note, size: 60),
              const SizedBox(height: 20),
              Text(
                filename,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _audioPlayer.stop(); // Stop playing when closing
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void deleteMusic(String docID) {
    context.read<MusicBloc>().add(DeleteMusic(docID));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBlocLogout, Authstate>(
      listener: (context, state) {
        if (state is AuthStateLogoutDone) {
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
          title: const Text('Musics'),
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
          onPressed: () => openMusicBox(),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<MusicBloc, MusicState>(
          builder: (context, state) {
            if (state is MusicLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MusicLoaded) {
              final musicList = state.musicList;
              if (musicList.isEmpty) {
                return const Center(child: Text("No musics yet..."));
              }

              return ListView.builder(
                itemCount: musicList.length,
                itemBuilder: (context, index) {
                  final music = musicList[index];
                  return ListTile(
                    title: Text(music.tiles),
                    leading: const Icon(Icons.music_note),
                    onTap:
                        () => openMusicPlayerDialog(
                          music.tiles,
                          music.filename ,
                        ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed:
                              () => openMusicBox(
                                docID: music.id,
                                existingMusic: music,
                              ),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => deleteMusic(music.id),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is MusicError) {
              return Center(child: Text("Error: ${state.error}"));
            } else {
              return const Center(child: Text("Unexpected state"));
            }
          },
        ),
      ),
    );
  }
}
