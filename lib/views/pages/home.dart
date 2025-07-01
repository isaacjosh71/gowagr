import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gowagr/views/pages/tabs.dart';
import '../../core/constant/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    QallaTab(),
    _EmptyTab(title: 'Portfolio'),
    _EmptyTab(title: 'Activity'),
  ];

  @override
  Widget build(BuildContext context) {
    List tabs = ['Explore', 'Portfolio', 'Activity'];
    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 180,
            elevation: 0,
            pinned: true,
            centerTitle: false,
            scrolledUnderElevation: 0,
            primary: false,
            excludeHeaderSemantics: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Container(
                  width: double.infinity,
                  color: AppColors.background,
                  margin: EdgeInsets.fromLTRB(22, 16, 0, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset('assets/svg/qalla.svg'),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          tabs.length,
                              (index) {
                            return _buildNavItem(
                              label: tabs[index],
                              index: index,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          )
        ],
      )
    );
  }

  Widget _buildNavItem({
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Color(0xff355587) : Color(0xffDAE0EA),
            fontSize: 20,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _EmptyTab extends StatelessWidget {
  final String title;

  const _EmptyTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 64,
                color: AppColors.textSecondary,
              ),
              SizedBox(height: 16),
              Text(
                '$title Coming Soon',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'This feature is under development',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}