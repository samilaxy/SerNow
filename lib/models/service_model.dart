
import 'package:serv_now/models/user_model.dart';

class ServiceModel  {
  final String? id;
  final String userId;
  final String title;
  final String category;
  final String price;
  final String location;
  final String description;
  final bool isFavorite;
  final String status;
  final List imgUrls;
  final UserModel? user;
  
  ServiceModel( {
    this.id, 
    required this.userId,
    required this.title, 
    required this.category,
    required this.price,
    required this.location,    
    required this.description,
    required this.isFavorite,
    required this.status,
    required this.imgUrls,
    this.user,
    });

    toJson() {
      return {
        "id" : id,
        "title" : title,
        "userId" : userId,
        "category" : category,
        "price" : price,
        "location": location,
        "description": description,
        "isFavorite": isFavorite,
        "imgUrls": imgUrls,
        "status": status,
        "user": user
      };
    }
}