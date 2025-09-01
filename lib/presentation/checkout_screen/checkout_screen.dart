import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/shared/glass_container.dart';
import '../../widgets/shared/neon_button.dart';
import '../../widgets/shared/custom_text_field.dart';

class CheckoutScreen extends StatelessWidget {
  // In a real app, you'd pass the selected plan here
  final String selectedPlanName;

  const CheckoutScreen({Key? key, this.selectedPlanName = 'Pro Plan'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14141D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: Text('Checkout • $selectedPlanName',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: EdgeInsets.all(4.w),
        children: [
          _buildBillingDetails(),
          SizedBox(height: 3.h),
          _buildPaymentMethod(),
          SizedBox(height: 3.h),
          _buildSummary(),
          SizedBox(height: 4.h),
          NeonButton(
            text: 'Subscribe & Pay',
            onPressed: () {
              // Mock success
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Subscription Successful!')));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBillingDetails() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Billing Details', style: _sectionTitleStyle()),
          SizedBox(height: 2.h),
          CustomTextField(
            controller: TextEditingController(text: 'Jules Verne'),
            hintText: 'Full Name',
            prefixIcon: Icon(Icons.person),
          ),
          SizedBox(height: 2.h),
          CustomTextField(
            controller: TextEditingController(text: 'jules.verne@example.com'),
            hintText: 'Email Address',
            prefixIcon: Icon(Icons.email),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Method', style: _sectionTitleStyle()),
          SizedBox(height: 2.h),
          // In a real app, this would be a proper card field widget (e.g., from Stripe)
          CustomTextField(
            controller: TextEditingController(),
            hintText: 'Card Number',
            prefixIcon: Icon(Icons.credit_card),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: TextEditingController(),
                  hintText: 'MM/YY',
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: CustomTextField(
                  controller: TextEditingController(),
                  hintText: 'CVC',
                ),
              ),
            ],
          ),
           SizedBox(height: 2.h),
          CustomTextField(
            controller: TextEditingController(),
            hintText: 'Coupon Code (Optional)',
            prefixIcon: Icon(Icons.local_offer),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: _sectionTitleStyle()),
          SizedBox(height: 2.h),
          _buildSummaryRow('Plan:', selectedPlanName),
          _buildSummaryRow('Billing Cycle:', 'Annually'),
          _buildSummaryRow('Subtotal:', '\$191.90'),
          _buildSummaryRow('Taxes:', '\$9.60'),
          Divider(color: Colors.white.withAlpha((255 * 0.2).round()), height: 4.h),
          _buildSummaryRow('Total:', '\$201.50', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.white70)),
          Text(value, style: GoogleFonts.inter(fontSize: isTotal ? 14.sp : 12.sp, color: Colors.white, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  TextStyle _sectionTitleStyle() {
    return GoogleFonts.inter(
        fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white);
  }
}
