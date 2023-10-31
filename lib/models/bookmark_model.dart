
class BookmarkModel  {
  final String? userId;
  final String? servId;
  
  BookmarkModel({
     this.userId,
     this.servId
    });

    toJson() {
      return {
        "userId": userId,
        "servId" : servId
      };
    }
}