class BlogPost {
  final String id; // Un identifiant unique (peut être utilisé pour les routes)
  final String title;
  final String description; // Petit résumé / description rapide
  final String content; // Le contenu complet de l'article
  final String image; // Image principale de l'article
  final String author; // Nom de l'auteur
  final DateTime date; // Date de publication
  final List<String> categories; // Ex : ['Technologie', 'Sécurité']
  final int views; // Nombre de vues
  final List<String> tags; // Ex : ['banque', 'sécurité', 'mobile']

  BlogPost({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.image,
    required this.author,
    required this.date,
    required this.categories,
    required this.views,
    required this.tags,
  });
}
