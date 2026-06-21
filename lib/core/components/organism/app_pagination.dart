import 'package:flutter/material.dart';

class AppPagination extends StatelessWidget {
  const AppPagination({
    super.key,
    required this.page,
    required this.totalPage,
    required this.onChanged,
  });

  final int page;
  final int totalPage;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: page > 1 ? () => onChanged(page - 1) : null,
          icon: const Icon(Icons.chevron_left),
        ),

        Text("$page / $totalPage"),

        IconButton(
          onPressed: page < totalPage ? () => onChanged(page + 1) : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
