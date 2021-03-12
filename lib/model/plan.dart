class Plan{
  String id,name,text,price,image,duration;

  Plan.fromMap(Map<String,dynamic> json){
    this.id=json['id'];
    this.name=json['name'];
    this.text=json['text'];
    this.price=json['price'];
    this.image=json['image'];
    this.duration=json['duration'];

  }
}