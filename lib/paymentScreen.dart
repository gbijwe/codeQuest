import 'package:flutter/material.dart';
import 'package:supa/customScaffold.dart';

class PaymentGateway extends StatefulWidget {
  const PaymentGateway({super.key});

  @override
  State<PaymentGateway> createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Center(child: Text("Pay with STRIPE"),)
    );
  }
}