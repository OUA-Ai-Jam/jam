import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  final Function(String) onCategorySelected;
  final Set<String> selectedCategories;

  CategoriesScreen(
      {required this.onCategorySelected, required this.selectedCategories});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        for (var category in [
          'Fantasy',
          'Mystery',
          'Tragedy',
          'Science Fiction',
          'Thriller',
          'Education',
          'Climate'
        ])
          CategoryCard(
            category: category,
            onCategorySelected: onCategorySelected,
            isSelected: selectedCategories.contains(category),
          ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;
  final Function(String) onCategorySelected;
  final bool isSelected;

  CategoryCard(
      {required this.category,
        required this.onCategorySelected,
        required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCategorySelected(category),
      child: Card(
        color: isSelected ? Colors.blue : Colors.white,
        child: Center(
          child: Text(
            category,
            style: TextStyle(
                fontSize: 18, color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}