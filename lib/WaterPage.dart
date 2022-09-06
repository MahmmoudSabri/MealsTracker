
import 'package:flutter/material.dart';
import 'APPLIC.dart';
import 'AppTheme.dart';
import 'sql_helper.dart';


class WaterPage extends StatefulWidget {
  WaterPage({Key? key}) : super(key: key);

  @override
  _WaterPageState createState() => _WaterPageState( );
}


class _WaterPageState extends State<WaterPage> {
  List<Map<String, dynamic>> _myWaterCup = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshWaterCup() async {
    final data = await SQLHelper.getWaters(APPLIC.now,DateTime(APPLIC.now.year, APPLIC.now.month , APPLIC.now.day+ 1));
    setState(() {
      _myWaterCup = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    /// print(APPLIC.now.toString());
    super.initState();
    _refreshWaterCup(); // Loading the diary when the app starts
  }
  @override
  void didUpdateWidget(WaterPage oldWidget) {
    _refreshWaterCup();
    print(APPLIC.now.toString());
    super.didUpdateWidget(oldWidget);
// Loading the diary when the app starts
  }

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an Meal


// Insert a new WaterCup to the database
  Future<void> _addWaterCup() async {
    await SQLHelper.createWater(1);
    _refreshWaterCup();
  }
  

  // Delete an Meal
  void _deleteWaterCup(int id) async {
    await SQLHelper.deleteWater(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a Water Cup!'),
    ));
    _refreshWaterCup();
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //print(APPLIC.now.toString());
    return Scaffold(

      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _myWaterCup.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blue[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Row(
                children: [
                  Icon(Icons.local_drink_outlined),
                  Text(_myWaterCup[index]['createdAt'].toString()),
                ],
              ),

              trailing: SizedBox(
                width: 50,
                child: Row(
                  children: [

                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteWaterCup(_myWaterCup[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton:
      APPLIC.now.day==DateTime.now().day&&APPLIC.now.month==DateTime.now().month  ?
      Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: FloatingActionButton(backgroundColor: AppTheme.nearlyGreen,
          child: const Icon(Icons.add,),
          onPressed: () =>  _addWaterCup()
      ,
        ),
      ):null,
    );
  }
}

