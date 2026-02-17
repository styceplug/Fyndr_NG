class AppConstants {
  static const String APP_NAME = "Fyndr NG";
  static const String VERSION = "1.0.0";
  
  static const String BASE_URL = 'https://api.fyndr.ng';

  //TOKEN
  static const authToken = 'authToken';
  static const header = 'header';
  static const String lastVersionCheck = 'lastVersionCheck';



  static const String REGISTER_NEW_BUSINESS = '/api/v1/user/register/new-vendor';
  static const String REGISTER_EXISTING_BUSINESS = '/api/v1/user/register/vendor';



  static const String PUT_DEVICE_TOKEN = '/api/v1/user/device-tokens';
  static const String POST_LOGIN = '/api/v1/auth/login';
  static const String POST_VERIFY_OTP = '/api/v1/auth/otp/verify';
  static const String POST_RESEND_OTP = '/api/v1/auth/otp/send';
  static const String POST_REGISTER_CUSTOMER = '/api/v1/user/register/customer';
  static const String POST_REGISTER_VENDOR = '/api/v1/user/register/vendor';
  static const String GET_USER_PROFILE = '/api/v1/user/me';
  static const String PUT_UPDATE_PROFILE = '/api/v1/user/me';
  static const String POST_NEW_JOB = '/api/v1/job';
  static const String GET_USER_JOBS = '/api/v1/job/user';

  static String GET_JOB_DETAILS(String jobId) => '/api/v1/job/$jobId';
  static String GET_JOB_QUOTES(String jobId) => '/api/v1/job/$jobId/quotes';

  static String MARK_JOB_AS_COMPLETED(String jobId) => '/api/v1/job/$jobId/complete';


  static const String SWITCH_ROLE_URI = '/api/v1/user/role/switch';
  static const String UPDATE_AVAILABILITY = '/api/v1/user/availability';

  static const String GET_MERCHANT_LEADS = '/api/v1/job/merchant';

  static const String POST_JOB_QUOTE = '/api/v1/quote';
  static  String GET_QUOTE_DETAILS (String quoteId) => '/api/v1/quote/$quoteId';


  static  String ACCEPT_QUOTE (String quoteId) => '/api/v1/quote/$quoteId/accept';
  static  String COUNTER_QUOTE (String quoteId) => '/api/v1/quote/$quoteId/counter';
  static  String DECLINE_QUOTE (String quoteId) => '/api/v1/quote/$quoteId/reject';



  static  String CREATE_CHAT (String jobId) => '/api/v1/job/$jobId/chat';


  static const String CREATE_PRODUCT  = '/api/v1/product';
  static const String GET_PRODUCT  = '/api/v1/product';

  static const String GET_CUSTOMER_CHAT  = '/api/v1/chat/customer';
  static const String GET_VENDOR_CHAT  = '/api/v1/chat/vendor';







  static String getPngAsset(String image) {
    return 'assets/images/$image.png';
  }
  static String getGifAsset(String image) {
    return 'assets/gifs/$image.gif';
  }
}
