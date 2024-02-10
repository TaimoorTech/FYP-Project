import 'dart:math';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:fyp_project/utils/util.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailVerificationService {

  // Replace these values with your own email configuration
  static const String _username = 'safenav24@gmail.com';
  static const String _password = 'vfuj jtml zblw ugtg';
  static const String _host = 'localhost';
  static const int _port = 44418;

  static Future<void> sendVerificationCode(BuildContext context, String recipientEmail, String verificationCode) async {
    final smtpServer = gmail(_username, _password);

    final message = Message()
      ..from = Address(_username, 'SafeNav')
      ..recipients.add(recipientEmail.trim())
      ..subject = 'Email Verification Code'
      ..text = 'Your verification code is: $verificationCode';

    try {
      final sendReport = await send(message, smtpServer);
      Util.submittedSnackBar(context, 'Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      Util.errorSnackBar(context, 'Message not sent. Error: $e');
    }
  }

}
