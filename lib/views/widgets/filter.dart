import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';

class CategoryFilter extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;
  final VoidCallback onTrendingTap;
  final bool isShowingTrending;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onTrendingTap,
    required this.isShowingTrending,
  });

  static const List<String> categories = [
    'Sports',
    'Technology',
    'Entertainment',
    'Politics',
    'Business',
    'Science',
  ];

  static const List<IconData> icons = [
    Icons.sports_basketball,
    Icons.computer,
    Icons.music_note,
    Icons.policy,
    Icons.business,
    Icons.science,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildChip(
            label: 'Trending',
            isSelected: isShowingTrending,
            onTap: onTrendingTap,
            icon: Icons.trending_up,
          ),
          SizedBox(width: 8),
          ...List.generate(categories.length, (index) {
            return Padding(
              padding: EdgeInsets.only(right: 8),
              child: _buildChip(
                label: categories[index],
                isSelected: selectedCategory == categories[index],
                onTap: () => onCategorySelected(categories[index]),
                icon: icons[index],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.chip,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.text),
              SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.text,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        )
      ),
    );
  }
}