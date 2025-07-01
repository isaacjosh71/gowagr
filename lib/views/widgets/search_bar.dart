import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constant/app_colors.dart';
import '../cubit/event_cubit.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String? initialValue;
  final VoidCallback? onClear;


  const CustomSearchBar({
    super.key,
    required this.onSearch,
    this.initialValue,
    this.onClear,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onSubmitted: widget.onSearch,
        decoration: InputDecoration(
          hintText: 'Search for a market',
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 20,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
            onPressed: () {
              setState(() {
                _controller.clear();
              });
              widget.onSearch('');
              context.read<EventsCubit>().searchEvents('');
              widget.onClear?.call();
            },
            icon: Icon(
              Icons.clear,
              color: AppColors.textSecondary,
              size: 20,
            ),
          )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }
}
