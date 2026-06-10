import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/widgets/category_grid_item.dart';

import '../models/meal.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.onToggleFavorite, required this.availableMeals});

  //function used as a third party link to the meals screen
  final void Function(Meal meal) onToggleFavorite;
  final List<Meal> availableMeals;

  void _selectCategory(BuildContext context, Category category) {
    //check the list of meals for items that have a matching ID with the selected category,
    // convert them to a list and assign the list to the filteredMeals variable
    final filteredMeals = availableMeals.where((meal) => meal.categories.contains(category.id)).toList();


    Navigator.of(context).push(
      MaterialPageRoute(
        //navigate to the meals screen and use the filtered meals as a parameter
        //ofc if no filters have been applied the list will be empty
        builder: (context) => MealsScreen(title: category.title, meals: filteredMeals, onToggleFavorite: onToggleFavorite,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
        padding: EdgeInsets.all(24),
        //gridview shenanigans
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          //for every category in the category list, create a grid item.
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            ),

          // - alternative to the code above
          // availableCategories.map((category) => CategoryGridItem(category: category)).toList()
        ],
      );
  }
}
