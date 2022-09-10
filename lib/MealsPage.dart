
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'APPLIC.dart';
import 'AppTheme.dart';
import 'sql_helper.dart';


class MealsPage extends StatefulWidget {
  MealsPage({Key? key}) : super(key: key);

  @override
  _MealsPageState createState() => _MealsPageState( );
}


class _MealsPageState extends State<MealsPage> {
  List<Map<String, dynamic>> _myMeal = [];
  CollectionReference mealsFS = FirebaseFirestore.instance.collection('meals');

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshMeals() async {
    final data = await SQLHelper.getMeals(APPLIC.now,DateTime(APPLIC.now.year, APPLIC.now.month , APPLIC.now.day+ 1));
   //print(data);
    setState(() {
      _myMeal = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
   /// print(APPLIC.now.toString());
    super.initState();
    _refreshMeals(); // Loading the diary when the app starts
  }
  @override
  void didUpdateWidget(MealsPage oldWidget) {
    _refreshMeals();
    print(APPLIC.now.toString());
     super.didUpdateWidget(oldWidget);
// Loading the diary when the app starts
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an Meal
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new Meal
      // id != null -> update an existing Meal
      final existingMeals =
      _myMeal.firstWhere((element) => element['id'] == id);
      _nameController.text = existingMeals['name'];
      _caloriesController.text = existingMeals['calories'].toString();
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // this will prevent the soft keyboard from covering the text fields
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'name'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _caloriesController,keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'calories'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Save new Meals
                  if (id == null) {
                    await _addMeal();
                  }

                  if (id != null) {
                    await _updateMeal(id);
                  }

                  // Clear the text fields
                  _nameController.text = '';
                  _caloriesController.text = '';

                  // Close the bottom sheet
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Create New' : 'Update'),
              )
            ],
          ),
        ));
  }

// Insert a new Meals to the database
  Future<void> _addMeal() async {

    bool _addToFirestore=false;
    if(APPLIC.user!=null)
    try {
      final result = await InternetAddress.lookup('google.com');
      // print(result);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
      await mealsFS.add({
        'name': _nameController.text,
        'calories': _caloriesController.text,
        'id': '1' ,
        'createdAt':Timestamp.now(),
        'user_id':APPLIC.user?.email
      })  .then((value) => _addToFirestore=true)//print("Meal Added"))
          .catchError((error) => print("Failed to add Meal: $error"));
    } catch (_) {
    print("throwing new error");
    //throw Exception("Error on server");
    }
    await SQLHelper.createMeal(
        _nameController.text, int.parse(_caloriesController.text),_addToFirestore?'Y':'N');

    _refreshMeals();
  }

  // Update an existing Meals
  Future<void> _updateMeal(int id) async {
    await SQLHelper.updateMeal(
        id, _nameController.text, int.parse(_caloriesController.text),'Y');
    _refreshMeals();
  }

  // Delete an Meal
  void _deleteMeal(int id) async {
    await SQLHelper.deleteMeal(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a Meal!'),
    ));
    _refreshMeals();
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print(APPLIC.now.toString());
    return Scaffold(

      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _myMeal.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_myMeal[index]['name']),
              subtitle: Text(_myMeal[index]['calories'].toString()),

              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_myMeal[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteMeal(_myMeal[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton:
      APPLIC.now.day==DateTime.now().day&&APPLIC.now.month==DateTime.now().month?
        Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: FloatingActionButton(backgroundColor: AppTheme.nearlyGreen,
          child: const Icon(Icons.add,),
          onPressed: () => _showForm(null),
        ),
      ):null,
    );
  }
}

