import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/widgets/category_grid_item.dart';

import '../models/meal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initializing the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    //keyword for starting the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    //check the list of meals for items that have a matching ID with the selected category,
    // convert them to a list and assign the list to the filteredMeals variable
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        //navigate to the meals screen and use the filtered meals as a parameter
        //ofc if no filters have been applied the list will be empty
        builder: (context) =>
            MealsScreen(title: category.title, meals: filteredMeals),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      //the widget set as the child parameter is not animated (gridview),
      // only the widget being returned is animated (SlideTransition)
      animation: _animationController,
      builder: (context, child) => SlideTransition(
        //g
        position: _animationController.drive(
          Tween(
              begin: Offset(0, 0.3),
              end: Offset(0, 0)
          ).chain(CurveTween(curve: Curves.easeInOut)),
        ),
        child: child,
      ),
      child: GridView(
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
      ),
    );
  }
}
