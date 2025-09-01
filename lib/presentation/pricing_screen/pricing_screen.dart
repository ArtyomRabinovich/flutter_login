import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../routes/app_routes.dart';
import '../../widgets/shared/glass_container.dart';
import '../../widgets/shared/neon_button.dart';

enum BillingCycle { monthly, annually }

class Plan {
  final String name;
  final String tagline;
  final double monthlyPrice;
  final List<String> features;
  final bool isRecommended;

  Plan({
    required this.name,
    required this.tagline,
    required this.monthlyPrice,
    required this.features,
    this.isRecommended = false,
  });
}

class PricingScreen extends StatefulWidget {
  const PricingScreen({Key? key}) : super(key: key);

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  BillingCycle _selectedCycle = BillingCycle.annually;

  final List<Plan> _plans = [
    Plan(
      name: 'Free',
      tagline: 'For getting started',
      monthlyPrice: 0,
      features: ['2 projects', '1 GB storage', '720p exports'],
    ),
    Plan(
      name: 'Pro',
      tagline: 'For serious creators',
      monthlyPrice: 19.99,
      features: [
        'Unlimited projects',
        '100 GB storage',
        '4K exports',
        'AI assistance',
        'Brand Kits'
      ],
      isRecommended: true,
    ),
    Plan(
      name: 'Super Premium',
      tagline: 'For professional teams',
      monthlyPrice: 49.99,
      features: [
        'All Pro features',
        '1 TB storage',
        'Team collaboration',
        'Dedicated support'
      ],
    ),
  ];

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
        title: Text('Plans & Pricing',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: EdgeInsets.all(4.w),
        children: [
          _buildBillingToggle(),
          SizedBox(height: 3.h),
          ..._plans.map((plan) => PlanCard(
                plan: plan,
                cycle: _selectedCycle,
              )),
          SizedBox(height: 2.h),
          TextButton(onPressed: () {}, child: Text('Restore Purchases', style: GoogleFonts.inter(color: Colors.white70)))
        ],
      ),
    );
  }

  Widget _buildBillingToggle() {
    return GlassContainer(
      padding: EdgeInsets.all(1.w),
      child: Row(
        children: [
          Expanded(
            child: NeonButton(
              text: 'Monthly',
              onPressed: () => setState(() => _selectedCycle = BillingCycle.monthly),
              isPrimary: _selectedCycle == BillingCycle.monthly,
              height: 45,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: NeonButton(
              text: 'Annually (-20%)',
              onPressed: () => setState(() => _selectedCycle = BillingCycle.annually),
              isPrimary: _selectedCycle == BillingCycle.annually,
              height: 45,
            ),
          ),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final Plan plan;
  final BillingCycle cycle;
  const PlanCard({Key? key, required this.plan, required this.cycle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final price = cycle == BillingCycle.monthly
        ? plan.monthlyPrice
        : plan.monthlyPrice * 12 * 0.8;

    return GlassContainer(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(plan.name,
              style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text(plan.tagline,
              style: GoogleFonts.inter(
                  fontSize: 12.sp, color: Colors.white.withOpacity(0.7))),
          SizedBox(height: 2.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('\$${price.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(width: 2.w),
              Text(
                price == 0 ? '' : (cycle == BillingCycle.monthly ? '/month' : '/year'),
                style: GoogleFonts.inter(
                    fontSize: 14.sp, color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Divider(color: Colors.white.withOpacity(0.2)),
          SizedBox(height: 2.h),
          ...plan.features.map((feature) => _buildFeatureRow(feature)),
           SizedBox(height: 3.h),
          NeonButton(
            text: 'Select Plan',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.checkout);
            },
            isPrimary: plan.isRecommended,
          )
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Icon(Icons.check, color: const Color(0xFF5A67F8), size: 5.w),
          SizedBox(width: 3.w),
          Text(feature, style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.white)),
        ],
      ),
    );
  }
}
