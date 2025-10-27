// ignore_for_file: non_constant_identifier_names

enum ApiStates { loading, normal, success, error, initial }

class UrlEndpoints {
  //////////////////////WEBMOBRIL///////////////////////////

  // static String baseUrl = "http://192.168.11.190:10061/api/v1/";

  ////////////////////////AWS///////////////////////////////

  // static String baseUrl = "https://www.lempiredating.com/api/v1/";

  ///////////////////KRISHAN/////////////////////////

  // static String baseUrl = "http://172.16.3.32:10061/api/v1/";

  ///////////////////shubham yadav/////////////////////////

  static String baseUrl = "http://172.16.100.230:10061/api/v1/";


  static String login = "user/login-phone";
  static String verifyOtpWithPhone = "user/verification";
  static String createaccount = "user/set-profile";
  static String addphoto = "user/upload-media";
  static String basicinformation = "user/set-basic-info";
  static String moreabout = "user/set-more-about";
  static String updatedata = "user/set-profile";
  static String getquestion = "user/get-all-question";
  static String answers = "user/create-answer";
  static String filterApi = "user/create-filter";
  static String likedYouApi = "user/get-liked-you";
  static String youliked = "user/get-likes";
  static String likeDislike = "user/create-like-dislike";
  static String addIntro = "user/create-intro";
  static String exploreApi = "user/all-groups";
  static String uploadProfile = "user/upload-profile-picture";
  static String getFirebaseId = "user/get-user-firebase/";
  static String itsmatch = "user/getallMatches";
  static String getuser = "user/get-single-profile/";
  static String Liveuser = "user/get-online-users";
  static String DeleteMedia = "user/delete-media";
  static String allNotification = "user/getall-notification";
  static String deleteNoitByid = "user/delete-notification/";
  static String deleteNoitall = "user/delete-all-notification";
  static String verificationprofile = "user/verify-profile-picture";
  static String vediocall = "user/get-channel-token";
  static String referral = "user/create-referral";
  static String BLOCK = "user/report-user";
  static String Logout = "user/logout-user";
  static String RemaningQuestion = "user/get-unanswered-question";
  static String gglLogin = "user/google-login";
  static String appleLogin = "user/apple-login";
  static String agreedisagree = "user/get-match-percentage/";
  static String reelsUpload = "user/upload-reel";
  static String myReelsData = "user/get-reels";
  static String allReelsData = "user/get-all-reels";
  static String userReelsData = "user/get-userprofile/";
  static String getComment = "user/getall-comment/";
  static String sendComment = "user/add-comment/";
  static String sendLike = "user/like-reel";
  static String getSub = "user/get-user-subscription";
  static String sendSub = "user/in-app-purchase-subscription";
  
}
