import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:notepro/features/admin/widgets/admin_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class CreateArticlePage extends StatefulWidget {
  const CreateArticlePage({super.key});

  @override
  State<CreateArticlePage> createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _linkController = TextEditingController();
  final _linkTextController = TextEditingController();
  bool _isPreview = false;
  bool _isLoading = false;
  String? _mainImageUrl;
  Uint8List? _mainImageBytes;
  String _loadingMessage = '';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _linkController.dispose();
    _linkTextController.dispose();
    super.dispose();
  }

  void _setLoading(bool loading, {String message = ''}) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
        _loadingMessage = message;
      });
    }
  }

  Future<void> _pickMainImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return;

      _setLoading(true, message: 'Chargement de l\'image...');

      // Lire les bytes de l'image
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() => _mainImageBytes = bytes);

      // Upload image to Firebase Storage
      final fileName = 'main_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('article_images')
          .child(fileName);

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedBy': FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
          'uploadedAt': DateTime.now().toIso8601String(),
          'type': 'main_image',
        },
      );

      _setLoading(true, message: 'Upload de l\'image...');

      // Upload les bytes directement
      final uploadTask = await storageRef.putData(bytes, metadata);

      if (uploadTask.state == TaskState.success) {
        final imageUrl = await storageRef.getDownloadURL();
        if (!mounted) return;
        setState(() {
          _mainImageUrl = imageUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image principale ajoutée avec succès')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout de l\'image: $e')),
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _insertImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return;

      _setLoading(true, message: 'Chargement de l\'image...');

      // Lire les bytes de l'image
      final bytes = await image.readAsBytes();

      final fileName = 'content_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('article_images')
          .child(fileName);

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedBy': FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
          'uploadedAt': DateTime.now().toIso8601String(),
          'type': 'content_image',
        },
      );

      _setLoading(true, message: 'Upload de l\'image...');

      // Upload les bytes directement
      final uploadTask = await storageRef.putData(bytes, metadata);

      if (uploadTask.state == TaskState.success) {
        final imageUrl = await storageRef.getDownloadURL();
        if (!mounted) return;
        final text = _contentController.text;
        final selection = _contentController.selection;
        final newText = text.replaceRange(
          selection.start,
          selection.end,
          '![${image.name}]($imageUrl)',
        );
        _contentController.text = newText;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image ajoutée avec succès')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout de l\'image: $e')),
      );
    } finally {
      _setLoading(false);
    }
  }

  void _showLinkDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Insérer un lien'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _linkTextController,
                  decoration: const InputDecoration(
                    labelText: 'Texte du lien',
                    hintText: 'Cliquez ici',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _linkController,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    hintText: 'https://example.com',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  final text = _contentController.text;
                  final selection = _contentController.selection;
                  final linkText =
                      _linkTextController.text.isNotEmpty
                          ? _linkTextController.text
                          : _linkController.text;
                  final newText = text.replaceRange(
                    selection.start,
                    selection.end,
                    '[$linkText](${_linkController.text})',
                  );
                  _contentController.text = newText;
                  _linkController.clear();
                  _linkTextController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Insérer'),
              ),
            ],
          ),
    );
  }

  Future<void> _publishArticle() async {
    final title = _titleController.text;
    final content = _contentController.text;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous devez être connecté pour publier un article'),
        ),
      );
      return;
    }

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Veuillez entrer un titre')));
      return;
    }

    if (_mainImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez ajouter une image principale')),
      );
      return;
    }

    _setLoading(true, message: 'Publication de l\'article...');

    try {
      // Extraire les URLs des images du contenu
      final imageUrls = <String>[];
      final RegExp imageRegex = RegExp(r'!\[.*?\]\((.*?)\)');
      final matches = imageRegex.allMatches(content);

      for (final match in matches) {
        if (match.groupCount >= 1) {
          imageUrls.add(match.group(1)!);
        }
      }

      // Save article to Firestore
      await FirebaseFirestore.instance.collection('articles').add({
        'title': title,
        'content': content,
        'mainImageUrl': _mainImageUrl,
        'contentImageUrls': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'status': 'published',
        'author': user.uid,
        'authorEmail': user.email,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article publié avec succès')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la publication: $e')),
      );
    } finally {
      _setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        onRefresh: () => setState(() {}),
        onCreateArticle: () {},
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title field
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre de l\'article',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Main image section
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:
                      _mainImageUrl != null
                          ? Stack(
                            children: [
                              Image.network(
                                _mainImageUrl!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Text(
                                      'Erreur de chargement de l\'image',
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onPressed: _isLoading ? null : _pickMainImage,
                                ),
                              ),
                            ],
                          )
                          : Center(
                            child: TextButton.icon(
                              onPressed: _isLoading ? null : _pickMainImage,
                              icon: const Icon(Icons.add_photo_alternate),
                              label: const Text('Ajouter une image principale'),
                            ),
                          ),
                ),
                const SizedBox(height: 16),

                // Editor toolbar
                Row(
                  children: [
                    TextButton.icon(
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                setState(() {
                                  _isPreview = !_isPreview;
                                });
                              },
                      icon: Icon(_isPreview ? Icons.edit : Icons.preview),
                      label: Text(_isPreview ? 'Éditer' : 'Aperçu'),
                    ),
                    if (!_isPreview) ...[
                      TextButton.icon(
                        onPressed:
                            _isLoading
                                ? null
                                : () {
                                  final text = _contentController.text;
                                  final selection =
                                      _contentController.selection;
                                  final newText = text.replaceRange(
                                    selection.start,
                                    selection.end,
                                    '**${text.substring(selection.start, selection.end)}**',
                                  );
                                  _contentController.text = newText;
                                },
                        icon: const Icon(Icons.format_bold),
                        label: const Text('Gras'),
                      ),
                      TextButton.icon(
                        onPressed:
                            _isLoading
                                ? null
                                : () {
                                  final text = _contentController.text;
                                  final selection =
                                      _contentController.selection;
                                  final newText = text.replaceRange(
                                    selection.start,
                                    selection.end,
                                    '*${text.substring(selection.start, selection.end)}*',
                                  );
                                  _contentController.text = newText;
                                },
                        icon: const Icon(Icons.format_italic),
                        label: const Text('Italique'),
                      ),
                      TextButton.icon(
                        onPressed:
                            _isLoading
                                ? null
                                : () {
                                  final text = _contentController.text;
                                  final selection =
                                      _contentController.selection;
                                  final newText = text.replaceRange(
                                    selection.start,
                                    selection.end,
                                    '# ${text.substring(selection.start, selection.end)}',
                                  );
                                  _contentController.text = newText;
                                },
                        icon: const Icon(Icons.title),
                        label: const Text('Titre'),
                      ),
                      TextButton.icon(
                        onPressed: _isLoading ? null : _showLinkDialog,
                        icon: const Icon(Icons.link),
                        label: const Text('Lien'),
                      ),
                      TextButton.icon(
                        onPressed: _isLoading ? null : _insertImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Image'),
                      ),
                    ],
                  ],
                ),

                // Content editor or preview
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:
                      _isPreview
                          ? Markdown(
                            data: _contentController.text,
                            selectable: true,
                          )
                          : TextField(
                            controller: _contentController,
                            maxLines: null,
                            expands: true,
                            enabled: !_isLoading,
                            decoration: const InputDecoration(
                              hintText: 'Contenu de l\'article (Markdown)',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                ),

                const SizedBox(height: 16),

                // Publish button
                ElevatedButton(
                  onPressed: _isLoading ? null : _publishArticle,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Publier l\'article',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      _loadingMessage,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
