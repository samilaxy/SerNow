
class DiscoverModel  {
  final String? id;
  final String title;
  final String price;
  final String img;
  final bool status;
  
  DiscoverModel({
    this.id, 
    required this.title, 
    required this.price,
    required this.img,
    required this.status,
    });

    toJson() {
      return {
        "id": id,
        "name" : title,
        "price" : price,
        "img": img,
        "status": status
      };
    }
}