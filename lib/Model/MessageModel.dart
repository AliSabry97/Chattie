
class MessageModel{

  String loggedUserID;
  String loggedUserName;
  String receiverID;
  String receiverName;
  String messageBody;
  String sentAt;

  MessageModel({

     required this.loggedUserID,
    required this.loggedUserName,
    required this.receiverID,
    required this.receiverName,
    required this.messageBody,
    required this.sentAt,

  });
toJson()
{
  return
  {
    "senderid":loggedUserID,
    "sendername":loggedUserName,
    "reciverid":receiverID,
    "receivername":receiverName,
    "messagebody":messageBody,
    "sentat":sentAt,
  };


  


}

}