// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wonder/note.dart';
import 'package:wonder/sqldb.dart';

import 'provider/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String date = '';
  bool deleteBoxVisible = false;
  bool checkDeleteBox = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  List<Map<String, dynamic>> notesData = [];

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  //to get the data from database
  Future<List<Map<String, dynamic>>> getNotes() async {
    SqlDb sqldb = SqlDb();
    List<Map<String, dynamic>> notes = await sqldb.getNote();
    setState(() {
      notesData = notes;
    });
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // ignore: prefer_const_constructors
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: themeProvider.isDarkTheme ? const Color.fromARGB(255, 39, 39, 39) : Colors.white,
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          title: Text(
            'Wonder',
            style: GoogleFonts.pacifico(
                // ignore: prefer_const_constructors
                textStyle:
                    TextStyle(color: themeProvider.isDarkTheme ? Colors.white : Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          actions: [
            Switch(
              value: themeProvider.isDarkTheme,
              activeColor: Colors.white,
              activeTrackColor: const Color.fromARGB(255, 85, 3, 143),
              inactiveThumbColor: Colors.black,
              onChanged: (value) {
                themeProvider.toggleTheme(); // Toggle the theme state when the Switch is changed
              },
            ),
            themeProvider.isDarkTheme ? const Icon(Icons.nightlight, size: 20) : const Icon(Icons.sunny, color: Colors.black, size: 20),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
          bottom: TabBar(
            indicatorColor: Colors.deepPurple,
            indicatorPadding: const EdgeInsets.only(right: 20, left: 20),
            tabs: [
              Text(
                'Note',
                style: TextStyle(fontSize: 15, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
              ),
              Text(
                'reminder',
                style: TextStyle(fontSize: 15, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          //for note page
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                notesData.isEmpty
                    ? Center(
                        child: Text(
                          "What's on your mind",
                          style: GoogleFonts.pacifico(
                              textStyle: TextStyle(color: themeProvider.isDarkTheme ? Colors.grey : const Color.fromARGB(255, 59, 58, 58))),
                        ),
                      )
                    : FutureBuilder<List<Map<String, dynamic>>>(
                        future: getNotes(),
                        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: GridView.builder(
                                itemCount: snapshot.data!.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2 / 1, // Set the aspect ratio based on your preference
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  String title = snapshot.data![index]['title'];
                                  String date = snapshot.data![index]['date'];
                                  String note = snapshot.data![index]['note'];
                                  int id = snapshot.data![index]['id'];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NotePage(
                                                  title: title,
                                                  note: note,
                                                  date: date,
                                                  id: id,
                                                )),
                                      );
                                    },
                                    onLongPress: () {
                                      deleteBoxVisible = true;
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      height: title.length * 10.0,
                                      decoration: BoxDecoration(
                                        color: themeProvider.isDarkTheme
                                            ? const Color.fromARGB(248, 82, 81, 81)
                                            : const Color.fromARGB(255, 93, 92, 92),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: SizedBox(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 15.0, top: 15),
                                                  child: Text(
                                                    title,
                                                    style: GoogleFonts.courgette(
                                                      textStyle: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: deleteBoxVisible,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 2),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          checkDeleteBox = !checkDeleteBox;
                                                        },
                                                        icon: checkDeleteBox
                                                            ? const Icon(
                                                                Icons.check_box_outlined,
                                                                color: Colors.white,
                                                              )
                                                            : const Icon(
                                                                Icons.check_box_outline_blank,
                                                                color: Colors.white,
                                                              )),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment: const Alignment(1, 1),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 5.0, bottom: 2.5),
                                                  child: Text(
                                                    date,
                                                    style: GoogleFonts.courgette(
                                                      textStyle: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                Positioned(
                  bottom: 5,
                  right: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0, bottom: 20),
                    child: FloatingActionButton(
                      backgroundColor: Colors.deepPurple,
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              backgroundColor: themeProvider.isDarkTheme ? const Color.fromARGB(255, 49, 48, 48) : Colors.grey,
                              title: TextField(
                                controller: titleController,
                                maxLines: null,
                                minLines: 1,
                                style: GoogleFonts.courgette(fontSize: 25),
                                decoration: const InputDecoration(
                                    border: InputBorder.none, hintText: 'Title', hintStyle: TextStyle(color: Colors.black, fontSize: 30)),
                              ),
                              content: Container(
                                height: MediaQuery.of(context).size.height / 2.6,
                                width: MediaQuery.of(context).size.width,
                                child: TextField(
                                  controller: noteController,
                                  maxLines: null,
                                  minLines: 1,
                                  style: GoogleFonts.dancingScript(
                                      textStyle: const TextStyle(
                                    fontSize: 25,
                                  )),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Your note',
                                      hintStyle: TextStyle(color: Colors.black, fontSize: 25)),
                                ),
                              ),
                              actions: [
                                //for addbutton
                                Row(
                                  children: [
                                    StatefulBuilder(
                                      builder: (context, setState) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Text(date),
                                        );
                                      },
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        if (titleController.text.isNotEmpty) {
                                          saveNote();
                                          Navigator.pop(context);
                                        } else {}
                                      },
                                      child: Container(
                                        height: 40,
                                        width: MediaQuery.of(context).size.width / 8,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.deepPurple),
                                        child: const Center(
                                          child: Text(
                                            'add',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),

                                    //for cancel button
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        titleController.clear();
                                        noteController.clear();
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );

                        setState(() {
                          date = DateFormat('KK:mm, dd/MM').format(DateTime.now());
                        });
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //for reminder page
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    "let's keep you on track",
                    style: GoogleFonts.pacifico(
                        textStyle: TextStyle(color: themeProvider.isDarkTheme ? Colors.grey : const Color.fromARGB(255, 59, 58, 58))),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0, bottom: 20),
                    child: FloatingActionButton(
                      backgroundColor: Colors.deepPurple,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              backgroundColor: themeProvider.isDarkTheme ? const Color.fromARGB(255, 49, 48, 48) : Colors.grey,
                              title: TextField(
                                controller: titleController,
                                maxLines: null,
                                minLines: 1,
                                style: GoogleFonts.courgette(fontSize: 18),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Your note',
                                    hintStyle: TextStyle(color: Colors.black, fontSize: 18)),
                              ),
                              content: Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 70,
                                    decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: Center(child: const Text('date')),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  //for save not into sqlite
  void saveNote() async {
    final sqlDb = SqlDb();
    try {
      await sqlDb.addNote(titleController.text, noteController.text, date);
    } catch (e) {
      // Handle the error here. You can show an error message to the user, log the error, etc.
      print('Failed to save note: $e');
      return;
    }
    // Clear the input fields if the note is successfully saved
    titleController.clear();
    noteController.clear();
    getNotes();
  }
}
