class Photo{
  String id,Url,uid;

  Photo.fromMap(Map<String,dynamic> json){
    this.id=json['id'];
    this.Url=json['Url'];
    this.uid=json['uid'];
  }
}
