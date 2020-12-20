class New{
  String id,name,topic,imgURL,date;

  New.fromMap(Map<String,dynamic> json){
    this.id=json['id'];
    this.name=json['Name'];
    this.topic=json['Topic'];
    this.imgURL=json['Image'];
    this.date=json['DateAt'];
  }
}