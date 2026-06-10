import 'package:flutter/material.dart';

import '../models/meal.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key, required this.meal, required this.onToggleFavorite});

  final Meal meal;
  final void Function(Meal meal) onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meal.title),
      actions: [
        IconButton(onPressed: (){
          onToggleFavorite(meal);
        }, icon: Icon(Icons.star))
      ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              meal.imageUrl,
              height: 300,
              fit: BoxFit.cover,
              width: double.infinity,
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
