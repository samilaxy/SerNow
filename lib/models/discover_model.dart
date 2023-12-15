class DiscoverModel {
  final String? id;
  final String title;
  final String price;
  final int views;
  final String img;
  final String status;
  final String comments;

  DiscoverModel(
      {this.id,
      required this.title,
      required this.price,
      required this.views,
      required this.img,
      required this.status,
      required this.comments});

  toJson() {
    return {
      "id": id,
      "name": title,
      "price": price,
      "views": views,
      "img": img,
      "status": status,
      "comments": comments
    };
  }
}
