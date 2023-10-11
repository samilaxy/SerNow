class UserModel  {
  final String? id;
  final String fullName;
  final String? email;
  final String phone;
  final String? bio;
  final String? img;
  final bool? isUser;
  
  UserModel({
    this.id, 
    required this.fullName, 
    this.email, 
    required this.phone,
    required this.bio,
    this.img,
    this.isUser
    });

    toJson() {
      return {
        "userId": id,
        "name" : fullName,
        "email" : email,
        "phone" : phone,
        "bio": bio,
        "img": img,
        "isUser": isUser
      };
    }
}