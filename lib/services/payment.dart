import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  Future<bool> makePayment(BuildContext context, String amount) async {
    try {
      final paymentIntent = await createPaymentIntent(amount, "usd");
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent["client_secret"],
          merchantDisplayName: "Your Merchant Name",
        ),
      );
      return await displayPaymentSheet(context, amount);
    } catch (e) {
      print("Error in makePayment: $e");
      return false;
    }
  }

  Future<bool> displayPaymentSheet(BuildContext context, String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Payment Successful"),
          content: Text("Amount: \$$amount"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        ),
      );

      return true;
    } catch (e) {
      print("Error displaying payment sheet: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${dotenv.env["SECRET_KEY"]}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to create payment intent: ${response.body}");
      }

      return json.decode(response.body);
    } catch (e) {
      throw Exception("Error in createPaymentIntent: $e");
    }
  }

  String calculateAmount(String amount) {
    try {
      final int parsedAmount = int.parse(amount);
      return (parsedAmount * 100).toString();
    } catch (e) {
      throw Exception("Invalid amount format: $amount");
    }
  }
}
