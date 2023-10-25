
class BookmarkModel  {
  final bool isFavorite;
  final bool userId;
  final bool servId;
  
  BookmarkModel({
    required this.isFavorite,
    required this.userId,
    required this.servId
    });

    toJson() {
      return {
        "isFavorite": isFavorite,
        "userId": userId,
        "servId" : servId
      };
    }
}