import 'package:demoproject/ui/subscrption/subscription/cubit.dart';
import 'package:demoproject/ui/subscrption/subscription/state.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManualSubscriptionPage extends StatefulWidget {
  @override
  _ManualSubscriptionPageState createState() => _ManualSubscriptionPageState();
}

class _ManualSubscriptionPageState extends State<ManualSubscriptionPage> {
  final TextEditingController _subscriptionTypeController = TextEditingController();
  final TextEditingController _transactionIdController = TextEditingController();
  final TextEditingController _productIdController = TextEditingController();

  @override
  void dispose() {
    _subscriptionTypeController.dispose();
    _transactionIdController.dispose();
    _productIdController.dispose();
    super.dispose();
  }

  void _sendData() {
    final String subscriptionType = _subscriptionTypeController.text.trim();
    final String transactionId = _transactionIdController.text.trim();
    final String productId = _productIdController.text.trim();

    if (subscriptionType.isEmpty || transactionId.isEmpty || productId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required!")),
      );
      return;
    }
    // Access the Cubit and trigger the `sendPurchaseDetails` method.
    context.read<SubscriptionCubit>().sendPurchaseDetails(
      transactionId: transactionId,
      productId: productId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Purchase Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<SubscriptionCubit, SubscriptionState>(
          listener: (context, state) {
            if (state is SendPurchaseDetailsSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is SendPurchaseDetailsErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _subscriptionTypeController,
                  decoration: InputDecoration(
                    labelText: 'Subscription Type',
                    hintText: 'Enter subscription type (e.g., monthly)',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _transactionIdController,
                  decoration: InputDecoration(
                    labelText: 'Transaction ID',
                    hintText: 'Enter transaction ID',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _productIdController,
                  decoration: InputDecoration(
                    labelText: 'Product ID',
                    hintText: 'Enter product ID',
                  ),
                ),
                SizedBox(height: 24),
                state is SendPurchaseDetailsLoadingState
                    ? AppLoader()
                    : ElevatedButton(
                  onPressed: _sendData,
                  child: Text('Send Data'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
