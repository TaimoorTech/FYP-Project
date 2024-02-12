class Constants {

  //appTitle
  static const String appTitle = "SafeNav";
  static const String splashScreenTitle = "SafeNav";

  //Internet Connection Error
  static const String noInternetDetectedText = "No Internet Connection Detected!!!";
  static const String checkInternetConnectionText = "Please Check your Internet Connection";

  //Verification Code
  static const String confirmedVerificationCode = "Verification Code Confirmed...";
  static const String wrongVerificationCode = "Wrong Verification Code...";
  static const String userAlreadyExists = "User Already Exists...";
  static const String verificationCodeSent = "Verification Code Sent...";
  static const String verificationCodeError = "Error in Sending Verification Code...";

  //PostgresSQL credentials
  static const String dbHostForEmulator = "ep-icy-surf-a1ayxu0k.ap-southeast-1.aws.neon.tech";
  static const int port = 5432;
  static const String postgresDB = "UserSignUp";
  static const String dbUsername = "safenav24";
  static const String dbPassword = "3Jxd4LoPNrHa";

  //registerScreenAlertDialog
  static const String dialogTitle = "Are you sure?";
  static const String dialogContent = "Do you want to exit an App";
  static const String dialogTextNo = "No";
  static const String dialogTextYes = "Yes";

  //SnackBarTexts
  static const String emptyFieldErrorText = "Fill All The Fields...";
  static const String correctEmailErrorText = "Wrong Email Address Format...";
  static const String passwordLengthErrorText = "Password Length must be equal or greater than 8...";
  static const String passwordNotMatchText = "Password does not match...";
  static const String userSuccessfullyRegistrationText = "User Successfully Registered...";
  static const String userUnSuccessfullyRegistrationText = "User Registration Failed...";
  static const String userSigningInText = "Signing In...";
  static const String userSuccessfullyLoggingText = "User Successfully Logged In...";
  static const String userUnSuccessfullyLoggingText = "Login Failed. Wrong Email or Username...";
  static const String userLoginInText = "Logging In...";
  static const String userLogOutText = "Logging Out...";

  //screenTexts
  static const String createAccountText= "Create Account";
  static const String verifyEmailAddressText= "Verify Your Email Adress";
  static const String alreadyAccountText = "Already have an Account?";
  static const String doNotHaveAccountText = "Don't have a SafeNav Account?";
  static const String registerNowText = "Register Now";
  static const String loginText = "Login";
  static const String homeScreenText = "Home Screen";
  static const String homeDrawerOptionsText = "Options";

  //ButtonTexts
  static const String registerButtonText = "Register";
  static const String loginButtonText = "Login";
  static const String logOutButtonText = "Log Out";
  static const String getVerificationCodeButtonText = "Get Verification Code";
  static const String confirmVerificationCodeButtonText = "Confirm Verification Code";

  //textFields
  static const String usernameTextField = "Enter UserName";
  static const String emailTextField = "Enter Email";
  static const String passwordTextField = "Enter Password";
  static const String passwordHelperText = "Password Length must be equal or greater than 8";
  static const String confirmPasswordTextField = "Enter Confirm Password";
  static const String verificationCodeTextField = "Enter Verification Code";

  //Icons
  static const String appIcon = 'images/appIcon.png';
  static const String wifiDisconnectedIcon = 'images/wifi_Disconnected.png';

  //Screen Paths
  static const String defaultScreenPath ='/';
  static const String emailVerificationScreenPath ='/emailVerification';
  static const String registerScreenPath = '/register';
  static const String loginScreenPath = '/login';
  static const String homeScreenPath = '/home';
}