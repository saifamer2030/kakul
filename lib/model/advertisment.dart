class Advertisment{
  String id,name,Link,aplace,image;

  Advertisment.fromMap(Map<String,dynamic> json){
    this.id=json['id'];
    this.name=json['Name'];
    this.Link=json['Link'];
    this.aplace=json['Aplace'];
    this.image=json['Image'];

  }
}