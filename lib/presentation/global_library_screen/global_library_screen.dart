import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/shared/glass_container.dart';

class GlobalLibraryScreen extends StatelessWidget {
  const GlobalLibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xFF14141D),
        appBar: _buildAppBar(context),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: const Color(0xFF5A67F8),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1E293B),
      elevation: 0,
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      title: Text('Global Library', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
      ],
      bottom: TabBar(
        isScrollable: true,
        indicatorColor: const Color(0xFF5A67F8),
        labelColor: const Color(0xFF5A67F8),
        unselectedLabelColor: Colors.white70,
        tabs: [
          Tab(text: 'All'),
          Tab(text: 'Video'),
          Tab(text: 'Audio'),
          Tab(text: 'Images'),
          Tab(text: 'Brand Kit'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      children: [
        _buildAssetGrid('all'),
        _buildAssetGrid('video'),
        _buildAssetGrid('audio'),
        _buildAssetGrid('image'),
        BrandKitView(),
      ],
    );
  }

  Widget _buildAssetGrid(String type) {
    // Mock data
    final int count = type == 'all' ? 20 : 8;
    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 3.w,
      ),
      itemCount: count,
      itemBuilder: (context, index) => AssetCard(seed: index),
    );
  }
}

class AssetCard extends StatelessWidget {
  final int seed;
  const AssetCard({Key? key, required this.seed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(12),
      hasBorder: false,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          'https://picsum.photos/seed/${seed + 10}/200/200',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.image_not_supported, color: Colors.white38),
        ),
      ),
    );
  }
}

class BrandKitView extends StatelessWidget {
  const BrandKitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(4.w),
      children: [
        _buildSectionTitle('Logos'),
        _buildLogoGrid(),
        SizedBox(height: 3.h),
        _buildSectionTitle('Color Palettes'),
        _buildColorGrid(),
        SizedBox(height: 3.h),
        _buildSectionTitle('Fonts'),
        _buildFontList(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildLogoGrid() {
    return SizedBox(
      height: 15.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) => GlassContainer(
          margin: EdgeInsets.only(right: 3.w),
          padding: EdgeInsets.all(2.w),
          child: Image.network('https://picsum.photos/seed/logo${index}/100/100'),
        ),
      ),
    );
  }

  Widget _buildColorGrid() {
    final List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple, Colors.orange];
    return SizedBox(
      height: 10.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          return Container(
            width: 10.h,
            margin: EdgeInsets.only(right: 3.w),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text('#${((color.r * 255).round()).toRadixString(16).padLeft(2, '0')}${((color.g * 255).round()).toRadixString(16).padLeft(2, '0')}${((color.b * 255).round()).toRadixString(16).padLeft(2, '0')}', style: GoogleFonts.getFont('Source Code Pro', color: Colors.white, shadows: [Shadow(blurRadius: 2)]))),
          );
        },
      ),
    );
  }

  Widget _buildFontList() {
    final List<String> fonts = ['Inter', 'Source Code Pro', 'Roboto Mono'];
    return Column(
      children: fonts.map((font) => GlassContainer(
        margin: EdgeInsets.only(bottom: 2.h),
        child: ListTile(
          title: Text(font, style: GoogleFonts.getFont(font, color: Colors.white, fontSize: 16.sp)),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
        ),
      )).toList(),
    );
  }
}
