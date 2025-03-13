import 'package:dio/dio.dart';
import 'package:ecommerce/constants/strings.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsHelper {
  // creat instance of fbm
  final _firebaseMessaging = FirebaseMessaging.instance;
  String? deviceToken;

  // initialize notifications for this app or device
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    deviceToken = (await _firebaseMessaging.getToken())!;
    print(
        "===================Device FirebaseMessaging Token====================");
    print(deviceToken);
    print(
        "===================Device FirebaseMessaging Token====================");
  }

  // handle notifications when received
  void handleMessages(RemoteMessage? message) {
    if (message == null) return;

    print("Notification Data: ${message.data}");
    print("Notification Title: ${message.notification?.title}");
    print("Notification Body: ${message.notification?.body}");
  }

  // handel notifications in case app is terminated
  void handleBackgroundNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then((handleMessages));
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
  }

  Future<String?> getAccessToken() async {
    final Map<String, dynamic> serviceAccountJson = {
      "type": dotenv.env['SERVICE_ACCOUNT_TYPE'],
      "project_id": dotenv.env['SERVICE_ACCOUNT_PROJECT_ID'],
      "private_key_id": dotenv.env['SERVICE_ACCOUNT_PROJECT_KEY_ID'],
      "private_key": dotenv.env['SERVICE_ACCOUNT_PROJECT_KEY'],
      "client_email": dotenv.env['SERVICE_ACCOUNT_CLIENT_EMAIL'],
      "client_id": dotenv.env['SERVICE_ACCOUNT_CLIENT_ID'],
      "auth_uri": dotenv.env['SERVICE_ACCOUNT_AUTH_URI'],
      "token_uri": dotenv.env['SERVICE_ACCOUNT_TOKEN_URI'],
      "auth_provider_x509_cert_url":
          dotenv.env['SERVICE_ACCOUNT_AUTH_PROVIDER_X509_CERT_URL'],
      "client_x509_cert_url":
          dotenv.env['SERVICE_ACCOUNT_CLIENT_X509_CERT_URL'],
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
              scopes,
              client);

      client.close();
      print(
          "Access Token: ${credentials.accessToken.data}"); // Print Access Token
      return credentials.accessToken.data;
    } catch (e) {
      print("Error getting access token: $e");
      return null;
    }
  }

  Map<String, dynamic> getBody({
    required String fcmToken,
    required String title,
    required String body,
    required String userId,
    String? type,
  }) {
    return {
      "message": {
        "token": fcmToken,
        "notification": {"title": title, "body": body},
        "android": {
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "default"
          }
        },
        "apns": {
          "payload": {
            "aps": {"content_available": true}
          }
        },
        "data": {
          "type": type,
          "id": userId,
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        }
      }
    };
  }

  Future<void> sendNotification({
    required String userId,
    required String fcmToken,
    required String title,
    required String body,
    String? type,
  }) async {
    try {
      var serverKeyAuthorization = await getAccessToken();
      const String urlEndPoint =
          "https://fcm.googleapis.com/v1/projects/ecommerce-591d4/messages:send";

      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';

      // Define the body data for the notification
      var requestBody = {
        "message": {
          "token": fcmToken,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {
            "userId": userId,
            "type": type ?? "message",
          },
        }
      };

      var response = await dio.post(urlEndPoint, data: requestBody);

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
    } catch (e) {
      print("Error sending notification: $e");
      if (e is DioException) {
        print("Error Response: ${e.response?.data}");
      }
    }
  }
}
