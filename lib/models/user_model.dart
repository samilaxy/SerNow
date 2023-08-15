class UserModel  {
  final String? id;
  final String fullName;
  final String email;
  final String phone;
  final String? bio;

  UserModel({
    this.id, 
    required this.fullName, 
    required this.email, 
    required this.phone,
    this.bio,
    });

    toJson() {
      return {
        "name" : fullName,
        "email" : email,
        "phone" : phone,
        "bio": bio
      };
    }
}