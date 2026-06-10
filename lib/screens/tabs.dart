import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/main.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters_screen.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/drawer.dart';

import '../models/meal.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  //variable for managing the tab bar index
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];

  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    //which is better wrapping the entire thing in setstate or just the actual functions
    setState(() {
      if (isExisting) {
        _favoriteMeals.remove(meal);
        _showInfoMessage("Meal is no longer a favourite");
      } else {
        _favoriteMeals.add(meal);
        _showInfoMessage("Meal is marked as a favourite");
      }
    });
  }

  //function for switching the index of the selected page index
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop;
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(builder: (context) => FiltersScreen(currentFilters: _selectedFilters,)),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if  ( _selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree){
        return false;
      }
      if  ( _selectedFilters[Filter.lactoseFree]! && !meal.isGlutenFree){
        return false;
      }
      if  ( _selectedFilters[Filter.vegetarian]! && !meal.isGlutenFree){
        return false;
      }
      if  ( _selectedFilters[Filter.vegan]! && !meal.isGlutenFree){
        return false;
      }
      return true;
    }).toList();


    //variable stores the value of the active page. By default the active page is the categories screen.
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Favorites';
    }
    return Scaffold(
      //the appbar title is dynamically determined based on the current active page
      appBar: AppBar(title: Text(activePageTitle)),
      body: activePage,
      drawer: MainDrawer(onSelectScreen: _setScreen),
      bottomNavigationBar: BottomNavigationBar(
        //the current index of the tab bar items is zero by default, but changes based on the value of "selected page index"
        currentIndex: _selectedPageIndex,
        //this function runs when the tab bar is pressed, if the first tab bar item is tapped, index is 0, and so on
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourites"),
        ],
      ),
    );
  }
}
