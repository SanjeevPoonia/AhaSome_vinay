
class AppModel{

  static late String authKey;
  static bool isChatOpen=false;
  static bool newPost=false;
  static bool deleteNotification=false;
  static late int groupId;
  static int reportedID=10;


  static String setAuthKey(String token)
  {
    authKey=token;
    return authKey;
  }
  static int setGroupId(int id)
  {
    groupId=id;
    return groupId;
  }
  static int setReportedId(int rid)
  {
    reportedID=rid;
    return reportedID;
  }
  static bool setChatOpen(bool value)
  {
    isChatOpen=value;
    return isChatOpen;
  }
  static bool setNewPost(bool value)
  {
    newPost=value;
    return newPost;
  }
  static bool setNotificationDelete(bool value)
  {
    deleteNotification=value;
    return deleteNotification;
  }
}
