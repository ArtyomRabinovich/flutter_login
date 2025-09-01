import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/shared/glass_container.dart';

class ExportedVideo {
  final String filename;
  final DateTime date;
  final String resolution;
  final String size;
  final String thumbnailUrl;

  ExportedVideo({
    required this.filename,
    required this.date,
    required this.resolution,
    required this.size,
    required this.thumbnailUrl,
  });
}

class OutputsScreen extends StatelessWidget {
  const OutputsScreen({Key? key}) : super(key: key);

  // Mock data
  final List<ExportedVideo> _exports = const [
    // Empty by default to show empty state
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
        title: Text('Outputs / Exports',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: _exports.isEmpty ? _buildEmptyState() : _buildOutputGrid(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_outlined, size: 20.w, color: Colors.white.withOpacity(0.3)),
          SizedBox(height: 2.h),
          Text(
            'No Exports Yet',
            style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your rendered videos will appear here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 14.sp, color: Colors.white.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 3.w,
      ),
      itemCount: _exports.length,
      itemBuilder: (context, index) {
        final video = _exports[index];
        return ExportCard(video: video);
      },
    );
  }
}

class ExportCard extends StatelessWidget {
  final ExportedVideo video;
  const ExportCard({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                video.thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.filename,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13.sp, color: Colors.white),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${video.date.day}/${video.date.month} • ${video.resolution} • ${video.size}',
                    style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.white.withOpacity(0.6)),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.share, color: Colors.white70, size: 5.w)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.save_alt, color: Colors.white70, size: 5.w)),
                       IconButton(onPressed: (){}, icon: Icon(Icons.more_vert, color: Colors.white70, size: 5.w)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
