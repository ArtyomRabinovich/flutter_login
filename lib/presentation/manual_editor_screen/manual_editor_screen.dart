import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ManualEditorScreen extends StatelessWidget {
  const ManualEditorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14141D),
      appBar: _buildAppBar(context),
      body: _buildBody(),
      bottomNavigationBar: _buildToolbar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1E293B),
      elevation: 0,
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      title: Text('Manual Edit: v1', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.undo)),
        IconButton(onPressed: () {}, icon: Icon(Icons.redo)),
        IconButton(onPressed: () {}, icon: Icon(Icons.ios_share_outlined)),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildPreviewMonitor(),
        _buildTimeline(),
      ],
    );
  }

  Widget _buildPreviewMonitor() {
    return Expanded(
      flex: 5,
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_circle_fill, color: Colors.white.withAlpha((255 * 0.8).round()), size: 15.w),
              SizedBox(height: 2.h),
              Text('00:00:12:34', style: GoogleFonts.getFont('Source Code Pro', color: Colors.white, fontSize: 18.sp)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    return Expanded(
      flex: 4,
      child: Container(
        color: const Color(0xFF1E293B),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.layers, color: Colors.white.withAlpha((255 * 0.3).round()), size: 10.w),
              SizedBox(height: 1.h),
              Text('Timeline (V1, A1, A2)', style: GoogleFonts.inter(color: Colors.white.withAlpha((255 * 0.5).round()))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF10141D),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildToolbarButton(context, icon: Icons.select_all, label: 'Select'),
            _buildToolbarButton(context, icon: Icons.cut, label: 'Split'),
            _buildToolbarButton(context, icon: Icons.content_cut, label: 'Trim'),
            _buildToolbarButton(context, icon: Icons.add_to_photos, label: 'Add Media'),
            _buildToolbarButton(context, icon: Icons.text_fields, label: 'Text'),
            _buildToolbarButton(context, icon: Icons.movie_filter, label: 'FX'),
            _buildToolbarButton(context, icon: Icons.closed_caption, label: 'Captions'),
            _buildToolbarButton(context, icon: Icons.tune, label: 'Inspector', isInspector: true),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarButton(BuildContext context, {required IconData icon, required String label, bool isInspector = false}) {
    return InkWell(
      onTap: () {
        if (isInspector) {
          _showInspector(context);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70),
            SizedBox(height: 0.5.h),
            Text(label, style: GoogleFonts.inter(color: Colors.white70, fontSize: 10.sp)),
          ],
        ),
      ),
    );
  }

  void _showInspector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (_, controller) => GlassInspectorSheet(scrollController: controller),
      ),
    );
  }
}

class GlassInspectorSheet extends StatelessWidget {
  final ScrollController scrollController;
  const GlassInspectorSheet({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E293B).withAlpha((255 * 0.8).round()),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: Colors.white.withAlpha((255 * 0.2).round())),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.all(4.w),
            children: [
              Center(
                child: Container(
                  width: 10.w,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((255 * 0.4).round()),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              _buildSection('Transform', [
                _buildControl('Position'),
                _buildControl('Scale'),
                _buildControl('Rotation'),
                _buildControl('Opacity'),
              ]),
              _buildSection('Color', [
                _buildControl('Exposure'),
                _buildControl('Contrast'),
                _buildControl('Saturation'),
                _buildControl('LUT'),
              ]),
              _buildSection('Speed', [
                _buildControl('Speed Ramps'),
                _buildControl('Reverse'),
              ]),
              _buildSection('Audio', [
                _buildControl('Volume'),
                _buildControl('EQ'),
                _buildControl('Ducking'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 1.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildControl(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12.sp)),
          Icon(Icons.chevron_right, color: Colors.white70),
        ],
      ),
    );
  }
}
