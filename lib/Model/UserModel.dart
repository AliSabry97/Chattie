
class UserModel
{

  String userid,email,name,phone,photourl;
  
  UserModel(
    {

      required this.userid,
      required this.email,
      required this.name,
     required this.phone,
     required this.photourl,
    }


  );

  toJson()
  {

    return{

      'user_id': userid,
      'email':email,
      'name':name,
      'phone':"",
      'Photourl':"",
    };

  }
  
}