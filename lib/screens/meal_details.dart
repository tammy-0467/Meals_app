import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import '../models/meal.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({super.key, required this.meal,});

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);

    //checks if the current meal is part of the favourite's list
    final isFavorite = favoriteMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(title: Text(meal.title),
      actions: [
        //simple page showing the details of an individual meal.
        //passes the functionality of the favourite function to the meals screen
        IconButton(onPressed: (){
          final wasAdded =
          ref.read(favoriteMealsProvider.notifier).toggleMealFavoriteStatus(meal);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(wasAdded ? "Meal removed" : "Meal added as a favorite")));
        },
          //icon requires a widget, animated switcher works
          //unlike explicit animations, you don't have to worry about initializing or starting
          // the animation. you just choose what animation you want and flutter handles the rest
          icon: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child, animation){
            return RotationTransition(
                turns: Tween(begin: 0.9, end: 1.0).animate(animation), child: child,);
          },
          child: Icon(isFavorite ? Icons.star: Icons.star_border, key: ValueKey(isFavorite),),
        ),
        )
      ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: meal.id,
              child: Image.network(
                meal.imageUrl,
                height: 300,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 14),
            Text(
              "Ingredients",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 14,),
            
            for (final ingredients in meal.ingredients)
              Text(
                ingredients,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            SizedBox(height: 20,),
            Text("Steps", style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface
            ),),
            for (final steps in meal.steps)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12.0),
                child: Text(
                  steps,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
