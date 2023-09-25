class ServiceModel  {
  final String? id;
  final String? userId;
  final String title;
  final String category;
  final String price;
  final String location;
  final String description;
  final List? imgUrls;
  final String status;
  
  ServiceModel({
    this.id, 
    required this.userId,
    required this.title, 
    required this.category,
    required this.price,
    required this.location,    
    required this.description,
    required this.status,
    required this.imgUrls,
    });

    toJson() {
      return {
        "title" : title,
        "userId" : userId,
        "category" : category,
        "price" : price,
        "location": location,
        "description": description,
        "imgUrls": imgUrls,
        "status": status
      };
    }
}