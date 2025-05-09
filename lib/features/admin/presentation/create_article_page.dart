import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:notepro/features/admin/widgets/admin_appbar.dart';

class CreateArticlePage extends StatefulWidget {
  const CreateArticlePage({super.key});

  @override
  State<CreateArticlePage> createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isPreview = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _publishArticle() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Veuillez entrer un titre')));
      return;
    }

    // Here you would typically save the article to your backend
    print('Publishing article: $title');
    print('Content: $content');

    // Navigate back after publishing
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        onRefresh: () => setState(() {}),
        onCreateArticle: () {}, // Empty callback instead of null
      ),
      body: Padding(
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Editor toolbar
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isPreview = !_isPreview;
                    });
                  },
                  icon: Icon(_isPreview ? Icons.edit : Icons.preview),
                  label: Text(_isPreview ? 'Éditer' : 'Aperçu'),
                ),
                if (!_isPreview) ...[
                  TextButton.icon(
                    onPressed: () {
                      final text = _contentController.text;
                      final selection = _contentController.selection;
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
                    onPressed: () {
                      final text = _contentController.text;
                      final selection = _contentController.selection;
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
                    onPressed: () {
                      final text = _contentController.text;
                      final selection = _contentController.selection;
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
                ],
              ],
            ),

            // Content editor or preview
            Expanded(
              child: Container(
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
                          decoration: const InputDecoration(
                            hintText: 'Contenu de l\'article (Markdown)',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
              ),
            ),

            const SizedBox(height: 16),

            // Publish button
            ElevatedButton(
              onPressed: _publishArticle,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Publier l\'article',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
