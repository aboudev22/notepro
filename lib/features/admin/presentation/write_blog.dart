import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class WriteBlogPage extends StatefulWidget {
  @override
  _WriteBlogPageState createState() => _WriteBlogPageState();
}

class _WriteBlogPageState extends State<WriteBlogPage> {
  final quill.QuillController _controller = quill.QuillController.basic();
  final TextEditingController _titleController = TextEditingController();

  void _publishBlog() {
    final title = _titleController.text.trim();
    final content = _controller.document.toPlainText().trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir le titre et le contenu.')),
      );
      return;
    }

    // Logique pour publier l'article (API ou base de données)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Article publié avec succès !')),
    );

    // Réinitialiser les champs
    _titleController.clear();
    _controller.replaceText(0, _controller.document.length - 1, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Écrire un article de blog'),
        actions: [
          IconButton(
            icon: Icon(Icons.publish),
            onPressed: _publishBlog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre de l\'article',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: quill.QuillEditor.basic(
                  controller: _controller,
                  readOnly: false, // false pour permettre l'édition
                ),
              ),
            ),
            const SizedBox(height: 16),
            quill.QuillToolbar.basic(controller: _controller),
          ],
        ),
      ),
    );
  }
}