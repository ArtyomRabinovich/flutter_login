import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/shared/glass_container.dart';

class Invoice {
  final String id;
  final DateTime date;
  final double amount;

  Invoice({required this.id, required this.date, required this.amount});
}

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({Key? key}) : super(key: key);

  // Mock data
  final List<Invoice> _invoices = const [
    // In a real app, this would come from a view model or repository
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
        title: Text('Invoices',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: _invoices.isEmpty ? _buildEmptyState() : _buildInvoiceList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 20.w, color: Colors.white.withOpacity(0.3)),
          SizedBox(height: 2.h),
          Text(
            'No Invoices Found',
            style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your billing history will appear here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 14.sp, color: Colors.white.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceList() {
    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: _invoices.length,
      itemBuilder: (context, index) {
        final invoice = _invoices[index];
        return GlassContainer(
          margin: EdgeInsets.only(bottom: 2.h),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            title: Text('Invoice #${invoice.id}', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
            subtitle: Text('${invoice.date.year}-${invoice.date.month}-${invoice.date.day}', style: GoogleFonts.inter(color: Colors.white70)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${invoice.amount.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 0.5.h),
                Icon(Icons.download_for_offline_outlined, color: Color(0xFF5A67F8)),
              ],
            ),
          ),
        );
      },
    );
  }
}
