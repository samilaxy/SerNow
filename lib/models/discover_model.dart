
class DiscoverModel  {
  final String? id;
  final String title;
  final String price;
  final String img;
  
  DiscoverModel({
    this.id, 
    required this.title, 
    required this.price,
    required this.img
    });

    toJson() {
      return {
        "userId": id,
        "name" : title,
        "price" : price,
        "img": img
      };
    }
}