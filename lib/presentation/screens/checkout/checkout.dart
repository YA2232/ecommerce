import 'package:ecommerce/presentation/screens/checkout/widgets/check_button.dart';
import 'package:ecommerce/presentation/screens/checkout/widgets/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/add_to_cart.dart';
import 'package:ecommerce/data/model/order_model.dart';
import 'package:ecommerce/presentation/screens/checkout/success.dart';
import 'package:ecommerce/services/payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';

class CheckoutScreen extends StatefulWidget {
  final List<AddToCart> cartItems;
  final int totalPrice;

  const CheckoutScreen(
      {super.key, required this.cartItems, required this.totalPrice});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final int _deliveryFee = 50;
  final PaymentService _paymentService = PaymentService();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  late FirebaseCubit _firebaseCubit;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firebaseCubit = BlocProvider.of<FirebaseCubit>(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final isPaymentSuccessful = await _paymentService.makePayment(
        context,
        (widget.totalPrice + _deliveryFee).toString(),
      );

      if (isPaymentSuccessful) {
        final orderId = randomAlphaNumeric(10);

        await _firebaseCubit.addOrder(OrderModel(
          orderId: orderId,
          userId: _firebaseAuth.currentUser!.uid,
          name: _nameController.text,
          address: _addressController.text,
          phone: _phoneController.text,
          totalPrice: (widget.totalPrice + _deliveryFee).toDouble(),
          list: widget.cartItems.map((e) => e.toJson()).toList(),
          status: "new order",
          createdAt: DateTime.now(),
        ));

        await _firebaseCubit.clearCart(_firebaseAuth.currentUser!.uid);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Success()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment failed. Please try again.")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(_nameController, 'Full Name',
                            Icons.person, 'Enter your name'),
                        _buildTextField(_phoneController, 'Phone Number',
                            Icons.phone, 'Enter your phone number',
                            keyboardType: TextInputType.phone),
                        _buildTextField(_addressController, 'Address',
                            Icons.location_on, 'Enter your address',
                            maxLines: 2),
                        const SizedBox(height: 20),
                        OrderSummary(
                            subtotal: widget.totalPrice,
                            deliveryFee: _deliveryFee),
                      ],
                    ),
                  ),
                ),
              ),
              CheckoutButton(isLoading: _isLoading, onPressed: _submitOrder),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, String hint,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) =>
            value == null || value.isEmpty ? 'Required field' : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
