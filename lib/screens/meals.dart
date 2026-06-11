import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meal_details.dart';
import 'package:meals_app/widgets/meal_item.dart';

//page for showing the meals within a selected category

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, this.title, required this.meals,});

  final String? title;
  //page requires a meals list, if you're navigating through the categories screen it gives a filtered meals list
  //if you're navigating through the tab bar, you get a favourite meals list
  final List<Meal> meals;


  void selectMeal (BuildContext context, Meal meal){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MealDetailsScreen(meal: meal,)));
  }


  @override
  Widget build(BuildContext context) {

    // using a variable to store widgets so we can use an if statement to create alternate screens
    // depending on the data available
    Widget content = ListView.builder(
      itemCount: meals.length,
      //create a list view where each item is signified by the meal name
      itemBuilder: (context, index) => MealItem(meal: meals[index], onSelectMeal: (meal){
        selectMeal(context, meal);
      },),
    );

    //if there are no meals for this category, display the below. If not, display the list view
    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Uh oh ... nothing here!",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Try Selecting a different category",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    // if title is null return the content as is because the tab bar provides a scaffold and app bar
    if(title == null){
      return content;
    }
    //else return the content with a scaffold and appbar
    return Scaffold(
      //the title is nullable because this screen is used for the list of meals when clicking a category
      // and the favorites screen. This screen has it's title provided by the tab bar page, hence the nullable effect
      appBar: AppBar(title: Text(title!)),
      body: content,
    );
  }
}
