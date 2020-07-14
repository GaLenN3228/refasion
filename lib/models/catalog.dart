class Catalog {
  final String model;
  final String id;
  final String name;

  Catalog(
      this.name,
      this.id,
      this.model
      );

  @override
  String toString() {
    return 'Catalog{model: $model, id: $id, name: $name}';
  }
}

List<Catalog> loadCatalogItems() {
  var items = <Catalog>[
    Catalog('Elisabetta franchi', '838909f8-35cd-4047-be15-704421da5059', 'Блузки и рубашки'),
    Catalog('Nike', '838909f8-35cd-4047-be15-704421da5059', 'Спорт'),
    Catalog('Stussy', '838909f8-35cd-4047-be15-704421da5059', 'Свитшоты'),
    Catalog('Rara avis tyora', '838909f8-35cd-4047-be15-704421da5059', 'Свадебные платья'),
    Catalog('La Sposa', '838909f8-35cd-4047-be15-704421da5059', 'Свадебные платья'),
  ];

  return items;
}