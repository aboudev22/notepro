class Blog {
  final String? date, title, description, image;

  Blog({this.date, this.title, this.description, this.image});
}

List<Blog> blogPosts = [
  Blog(
    date: "15 Avril 2024",
    image: "assets/images/0.png",
    title:
        "Enquête sur les services bancaires mobiles au Cameroun : Fiabilité et Sécurité",
    description:
        "Le secteur bancaire mobile au Cameroun a connu une croissance exponentielle. Notepro a mené une enquête approfondie pour évaluer la fiabilité et la sécurité des principales applications bancaires. Découvrez nos conclusions et conseils pour une expérience bancaire mobile sécurisée.",
  ),
  Blog(
    date: "01 Mars 2024",
    image: "assets/images/1.png",
    title:
        "Analyse des services internet à domicile : Quel fournisseur offre la meilleure performance ?",
    description:
        "Notepro a testé les services internet à domicile de plusieurs fournisseurs au Cameroun. Nous avons analysé la vitesse, la stabilité et le rapport qualité-prix pour vous aider à choisir le meilleur fournisseur pour vos besoins.",
  ),
  Blog(
    date: "20 Février 2024",
    image: "assets/images/2.png",
    title:
        "Les restaurants les mieux notés à Yaoundé : Notre sélection Notepro",
    description:
        "Vous cherchez un endroit agréable pour dîner à Yaoundé ? Notepro a visité et évalué plusieurs restaurants en tenant compte de la qualité de la nourriture, du service et de l'ambiance. Découvrez notre sélection des meilleurs restaurants à Yaoundé.",
  ),
];
