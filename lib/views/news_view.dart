import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fptapp/blocs/auth_bloc/auth-state.dart';
import 'package:fptapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:fptapp/blocs/auth_bloc/auth_event.dart';
import 'package:fptapp/blocs/news/news_bloc.dart';
import 'package:fptapp/blocs/news/news_event.dart';
import 'package:fptapp/blocs/news/news_state.dart';
import 'package:fptapp/models/news_model.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController imgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(LoadNews());
  }

  void openNewsBox({String? docID, News? existingNews}) {
    if (existingNews != null) {
      titleController.text = existingNews.tiles;
      contentController.text = existingNews.content;
      imgController.text = existingNews.img;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(docID == null ? "Add News" : "Edit News"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: "Content"),
                ),
                TextField(
                  controller: imgController,
                  decoration: const InputDecoration(labelText: "Image URL"),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final content = contentController.text.trim();
                  final img = imgController.text.trim();

                  if (docID == null) {
                    context.read<NewsBloc>().add(AddNew(title, content, img));
                  } else {
                    context.read<NewsBloc>().add(
                      UpdateNew(docID, title, content, img),
                    );
                  }

                  titleController.clear();
                  contentController.clear();
                  imgController.clear();

                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  void deleteNews(String docID) {
    context.read<NewsBloc>().add(DeleteNew(docID));
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
          title: const Text('News'),
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
          onPressed: () => openNewsBox(),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NewsLoaded) {
              final newsList = state.newsList;
              if (newsList.isEmpty) {
                return const Center(child: Text("No news yet..."));
              }

              return ListView.builder(
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index];
                  return ListTile(
                    title: Text(news.tiles),
                    leading:
                        news.img.isNotEmpty
                            ? Image.network(
                              news.img,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                            : const Icon(Icons.article),
                    onTap:
                        () => showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                content: ListTile(
                                  subtitle: Text(news.content),
                                  title: Text(news.tiles),
                                ),

                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Close"),
                                  ),
                                ],
                              ),
                        ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed:
                              () => openNewsBox(
                                docID: news.id,
                                existingNews: news,
                              ),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => deleteNews(news.id),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is NewsError) {
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
