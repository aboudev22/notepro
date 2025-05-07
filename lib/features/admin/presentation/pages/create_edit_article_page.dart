import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notepro/features/articles/data/repositories/article_repository.dart';
import 'package:notepro/features/articles/domain/models/article.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class CreateEditArticlePage extends StatefulWidget {
  final Article? article;

  const CreateEditArticlePage({super.key, this.article});

  @override
  State<CreateEditArticlePage> createState() => _CreateEditArticlePageState();
}

class _CreateEditArticlePageState extends State<CreateEditArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _contentController = TextEditingController();
  final _articleRepository = ArticleRepository();
  File? _imageFile;
  bool _isPublished = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      _titleController.text = widget.article!.title;
      _summaryController.text = widget.article!.summary;
      _contentController.text = widget.article!.content;
      _isPublished = widget.article!.isPublished;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('article_images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      final uploadTask = await storageRef.putFile(_imageFile!);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du téléchargement de l\'image: $e'),
        ),
      );
      return null;
    }
  }

  Future<void> _saveArticle() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage();
      } else if (widget.article != null) {
        imageUrl = widget.article!.imageUrl;
      }

      final article = Article(
        id: widget.article?.id ?? '',
        title: _titleController.text,
        content: _contentController.text,
        summary: _summaryController.text,
        imageUrl: imageUrl ?? '',
        publishedAt: widget.article?.publishedAt ?? DateTime.now(),
        authorId:
            'current_user_id', // TODO: Remplacer par l'ID de l'utilisateur connecté
        authorName:
            'Admin', // TODO: Remplacer par le nom de l'utilisateur connecté
        likes: widget.article?.likes ?? 0,
        likedBy: widget.article?.likedBy ?? [],
        isPublished: _isPublished,
      );

      if (widget.article == null) {
        await _articleRepository.createArticle(article);
      } else {
        await _articleRepository.updateArticle(widget.article!.id, article);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sauvegarde: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.article == null ? 'Nouvel article' : 'Modifier l\'article',
        ),
        actions: [
          if (widget.article != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Supprimer l\'article'),
                        content: const Text(
                          'Êtes-vous sûr de vouloir supprimer cet article ?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Supprimer'),
                          ),
                        ],
                      ),
                );

                if (confirmed == true) {
                  await _articleRepository.deleteArticle(widget.article!.id);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Titre',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un titre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _summaryController,
                        decoration: const InputDecoration(
                          labelText: 'Résumé',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un résumé';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contentController,
                        decoration: const InputDecoration(
                          labelText: 'Contenu',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le contenu';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.image),
                            label: const Text('Choisir une image'),
                          ),
                          if (_imageFile != null ||
                              widget.article?.imageUrl.isNotEmpty == true)
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                _imageFile != null
                                    ? 'Image sélectionnée'
                                    : 'Image existante',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Publier l\'article'),
                        value: _isPublished,
                        onChanged: (value) {
                          setState(() {
                            _isPublished = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveArticle,
                          child: Text(
                            widget.article == null
                                ? 'Créer l\'article'
                                : 'Mettre à jour l\'article',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
