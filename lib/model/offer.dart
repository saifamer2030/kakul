class Offer{
  String id,title,text,new_price,old_price;
  String company_image,image,company_id,create_date;
  String IdSections,IdSubSection,Mobile;

  Offer.fromMap(Map<String,dynamic> json){
    this.id=json['id'];
    this.title=json['title'];
    this.text=json['text'];
    this.new_price=json['new_price'];
    this.old_price=json['old_price'];
    this.company_image=json['company_image'];
    this.image=json['image'];
    this.company_id=json['company_id'];
    this.create_date=json['create_date'];
    this.IdSections=json['IdSections'];
    this.IdSubSection=json['IdSubSection'];
    this.Mobile=json['Mobile'];
  }
}