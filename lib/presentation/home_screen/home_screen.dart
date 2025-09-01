import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';

import '../../routes/app_routes.dart';
import '../../widgets/shared/glass_container.dart';
import '../../widgets/shared/neon_button.dart';
import '../../widgets/shared/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<Project> _projects = [];
  final List<String> _selectedProjects = [];

  // Mock data
  final List<Project> _mockProjects = List.generate(
    7,
    (index) => Project(
      id: 'proj_$index',
      title: 'Project Alpha ${index + 1}',
      lastModified: DateTime.now().subtract(Duration(days: index * 2)),
      duration: Duration(minutes: 5 + index, seconds: 30),
      thumbnailUrl: 'https://picsum.photos/seed/${index + 1}/400/300',
    ),
  );

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    setState(() => _isLoading = true);
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _projects = _mockProjects;
      // To test empty state, uncomment the line below
      // _projects = [];
      _isLoading = false;
    });
  }

  void _toggleSelection(String projectId) {
    setState(() {
      if (_selectedProjects.contains(projectId)) {
        _selectedProjects.remove(projectId);
      } else {
        _selectedProjects.add(projectId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14141D),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1E293B), // Darker surface color
      elevation: 0,
      title: Text('Workspace', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.apps_rounded, color: Color(0xFF5A67F8)),
      ),
      actions: _selectedProjects.isEmpty
          ? _buildDefaultActions()
          : _buildSelectionActions(),
    );
  }

  List<Widget> _buildDefaultActions() {
    return [
      IconButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.globalLibrary), icon: Icon(Icons.video_library_outlined)),
      IconButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications), icon: Icon(Icons.notifications_outlined)),
      IconButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.account), icon: Icon(Icons.account_circle_outlined)),
      SizedBox(width: 2.w),
    ];
  }

  List<Widget> _buildSelectionActions() {
    return [
      IconButton(onPressed: () {}, icon: Icon(Icons.archive_outlined, color: Colors.white)),
      IconButton(onPressed: () {}, icon: Icon(Icons.delete_outline, color: Colors.red.shade400)),
      IconButton(
        onPressed: () => setState(() => _selectedProjects.clear()),
        icon: Icon(Icons.close),
      ),
      SizedBox(width: 2.w),
    ];
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          NeonButton(
            text: '+ New Project',
            onPressed: () {},
            height: 50,
          ),
          SizedBox(height: 2.h),
          CustomTextField(
            controller: TextEditingController(),
            hintText: 'Search projects...',
            prefixIcon: Icon(Icons.search),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: _isLoading
                ? _buildLoadingGrid()
                : _projects.isEmpty
                    ? _buildEmptyState()
                    : _buildProjectGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      gridDelegate: _gridDelegate(),
      itemCount: 8,
      itemBuilder: (context, index) => const ProjectCardSkeleton(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.create_new_folder_outlined,
              size: 20.w, color: Colors.white.withAlpha((255 * 0.3).round())),
          SizedBox(height: 2.h),
          Text(
            'Your workspace is empty',
            style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 1.h),
          Text(
            'Create your first project to get started.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 14.sp, color: Colors.white.withAlpha((255 * 0.7).round())),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectGrid() {
    return GridView.builder(
      gridDelegate: _gridDelegate(),
      itemCount: _projects.length,
      itemBuilder: (context, index) {
        final project = _projects[index];
        final isSelected = _selectedProjects.contains(project.id);
        return ProjectCard(
          project: project,
          isSelected: isSelected,
          onTap: () {
            if (_selectedProjects.isNotEmpty) {
              _toggleSelection(project.id);
            } else {
              Navigator.pushNamed(context, AppRoutes.aiChat);
            }
          },
          onLongPress: () => _toggleSelection(project.id),
        );
      },
    );
  }

  SliverGridDelegate _gridDelegate() {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.8,
      crossAxisSpacing: 3.w,
      mainAxisSpacing: 3.w,
    );
  }
}

class Project {
  final String id;
  final String title;
  final DateTime lastModified;
  final Duration duration;
  final String thumbnailUrl;

  Project({
    required this.id,
    required this.title,
    required this.lastModified,
    required this.duration,
    required this.thumbnailUrl,
  });
}

class ProjectCard extends StatelessWidget {
  final Project project;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProjectCard({
    Key? key,
    required this.project,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: GlassContainer(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildThumbnail(),
                _buildInfo(),
              ],
            ),
            if (isSelected) _buildSelectionOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Expanded(
      flex: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        child: Image.network(
          project.thumbnailUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.image_not_supported, color: Colors.white38),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  color: Colors.white),
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Modified: ${project.lastModified.day}/${project.lastModified.month}',
              style: GoogleFonts.inter(
                  fontSize: 10.sp, color: Colors.white.withAlpha((255 * 0.6).round())),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.auto_awesome, size: 5.w, color: Color(0xFFC73EF1)),
                Icon(Icons.cut, size: 5.w, color: Color(0xFF5A67F8)),
                Icon(Icons.more_vert, size: 5.w, color: Colors.white70),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF5A67F8).withAlpha((255 * 0.4).round()),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF5A67F8), width: 2),
      ),
      child: Center(
        child: Icon(Icons.check_circle, color: Colors.white, size: 10.w),
      ),
    );
  }
}

class ProjectCardSkeleton extends StatelessWidget {
  const ProjectCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail skeleton
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
          ),
          // Info skeleton
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 2.h, width: 30.w, color: Colors.white.withAlpha((255 * 0.2).round())),
                  SizedBox(height: 1.h),
                  Container(
                      height: 1.5.h, width: 20.w, color: Colors.white.withAlpha((255 * 0.1).round())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
