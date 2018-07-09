class ListEntity {
  String title;
  String titleImage;
  int slug;
  AuthorEntity authorEntity;

  ListEntity(this.title, this.titleImage, this.slug, this.authorEntity);

//  static List<ListEntity> fromJson(List covariant) {
////    List<ListEntity> children = new List();
////    covariant.forEach((string){
////      ListEntity entity = new ListEntity(string['title'], string['titleImage'],
////          string['slug'], new AuthorEntity.fromJson(string['author']));
////      children.add(entity);
////    });
//
//    return covariant.map((string) => new ListEntity(title: string['title'],
//        titleImage: string['titleImage'],
//        slug: string['slug'],
//        author: new AuthorEntity.fromJson(string['author'])))
//        .toList();
//
////    return children;
//  }
  static List<ListEntity> fromJson(List json) {
    return json
        .map((string) => new ListEntity(string['title'], string['titleImage'],
            string['slug'], new AuthorEntity.fromJson(string['author'])))
        .toList();
  }

  @override
  String toString() {
    return 'ListEntity{title: $title, titleImage: $titleImage, slug: $slug, authorEntity: $authorEntity}';
  }
}

class AuthorEntity {
  String profileUrl;
  String bio;
  String name;

  AuthorEntity(this.profileUrl, this.bio, this.name);

  factory AuthorEntity.fromJson(Map<String, dynamic> json) {
    return new AuthorEntity(
      json['profileUrl'],
      json['bio'],
      json['name'],
    );
  }
}

class DetailEntity {
  final String titleImage;
  final String title;
  final String content;
  AuthorEntity author;

  DetailEntity(this.titleImage, this.title, this.content, this.author);

  static DetailEntity fromJson(Map<String, dynamic> json) {
    return new DetailEntity(json['titleImage'], json['title'], json['content'],
        new AuthorEntity.fromJson(json['author']));
  }
}
