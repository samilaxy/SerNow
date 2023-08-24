class UserModel  {
  final String? id;
  final String fullName;
  final String? email;
  final String phone;
  final String? bio;
  final String? img;
  UserModel({
    this.id, 
    required this.fullName, 
    this.email, 
    required this.phone,
    this.bio,
    this.img
    });

    toJson() {
      return {
        "name" : fullName,
        "email" : email,
        "phone" : phone,
        "bio": bio,
        "img": img
      };
    }
}