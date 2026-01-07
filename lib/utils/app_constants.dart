class AppConstants {
  static const String APP_NAME = "Fyndr NG";
  static const String VERSION = "1.0.0";
  
  static const String BASE_URL = 'https://api.fyndr.ng';

  //TOKEN
  static const authToken = 'authToken';
  static const header = 'header';
  static const String lastVersionCheck = 'lastVersionCheck';


  static const String POST_LOGIN = '/api/v1/auth/login';
  static const String POST_VERIFY_OTP = '/api/v1/auth/otp/verify';
  static const String POST_RESEND_OTP = '/api/v1/auth/otp/send';
  static const String POST_REGISTER_CUSTOMER = '/api/v1/user/register/customer';
  static const String POST_REGISTER_VENDOR = '/api/v1/user/register/vendor';
  static const String GET_USER_PROFILE = '/api/v1/user/me';
  static const String PUT_UPDATE_PROFILE = '/api/v1/user/me';



    static String getPngAsset(String image) {
    return 'assets/images/$image.png';
  }
  static String getGifAsset(String image) {
    return 'assets/gifs/$image.gif';
  }
}
