import 'user_model.dart';

class ServiceModel {
  final String? id;
  final String? userId;
  final String title;
  final String category;
  final String price;
  final String location;
  final String description;
  bool isFavorite;
  final List imgUrls;
  final String status;
  final UserModel? user;
  final List? bookmarks;
  final int views;
  final String comments;

  ServiceModel(
      {this.id,
      this.userId,
      required this.title,
      required this.category,
      required this.price,
      required this.location,
      required this.description,
      required this.isFavorite,
      required this.imgUrls,
      required this.status,
      this.user,
      this.bookmarks,
      required this.views,
      required this.comments});

  toJson() {
    return {
      "id": id,
      "title": title,
      "userId": userId,
      "category": category,
      "price": price,
      "location": location,
      "description": description,
      "isFavorite": isFavorite,
      "imgUrls": imgUrls,
      "status": status,
      "user": user,
      "bookmarks": bookmarks,
      "views": views,
      "comments": comments
    };
  }
}

class UpdateModel {
  final String title;
  final String category;
  final String price;
  final String location;
  final String description;
  final List imgUrls;
  final String status;

  UpdateModel(
      {required this.title,
      required this.category,
      required this.price,
      required this.location,
      required this.description,
      required this.imgUrls,
      required this.status});

  toJson() {
    return {
      "title": title,
      "category": category,
      "price": price,
      "location": location,
      "description": description,
      "imgUrls": imgUrls,
      "status": status
    };
  }
}
