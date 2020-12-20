class SubSection{
  String id;
  String name;

SubSection.fromMap(Map<String,dynamic> json){
this.id=json['id'];
this.name=json['Name'];
}  
}

