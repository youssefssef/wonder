// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wonder/provider/theme.dart';

import 'sqldb.dart';

class NotePage extends StatefulWidget {
  final String title;
  final String note;
  final String date;
  final int id;
  const NotePage({Key? key, required this.title, required this.note, required this.date, required this.id});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  bool isEditing = false;
  bool isNoteOrTitleEdited = false;

  TextEditingController _noteController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  String editedNote = '';
  String editeTitle = '';
  String editedDate = '';

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.note;
    _titleController.text = widget.title;

    editedNote = widget.note;
    editeTitle = widget.title;
    editedDate = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkTheme ? const Color.fromARGB(255, 39, 39, 39) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'note',
          style: GoogleFonts.pacifico(
              // ignore: prefer_const_constructors
              textStyle:
                  TextStyle(color: themeProvider.isDarkTheme ? Colors.white : Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
        ),
        actions: [
          isEditing
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      editedNote = _noteController.text; // Update the edited note
                      editeTitle = _titleController.text; //update the edited title
                      isNoteOrTitleEdited ? editedDate = DateFormat('KK:mm, dd/MM').format(DateTime.now()) : null;

                      isEditing = false; // stop editing mode when tapped
                    });
                    isNoteOrTitleEdited ? updateNote() : null;
                  },
                  icon: Icon(Icons.check, color: themeProvider.isDarkTheme ? Colors.white : Colors.black))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isEditing = true; // Enter editing mode when tapped
                    });
                  },
                  icon: Icon(Icons.edit, color: themeProvider.isDarkTheme ? Colors.white : Colors.black))
        ],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 35.0, top: 35),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: isEditing
                        ? TextField(
                            controller: _titleController,
                            maxLines: null,
                            minLines: null,
                            onChanged: (value) {
                              setState(() {
                                isNoteOrTitleEdited = true; // Set the flag to true when the title is edited
                              });
                            },
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent), // Remove the underline
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent), // Remove the underline when focused
                              ),
                            ),
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                                height: 1.8),
                          )
                        : Text(editeTitle,
                            style: GoogleFonts.courgette(
                              textStyle: TextStyle(
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
                            )),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 35),
                  child: Text(editedDate,
                      style: GoogleFonts.courgette(
                        textStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkTheme ? Colors.white.withOpacity(0.3) : Colors.grey),
                      )),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 30, bottom: 10, right: 10),
              child: isEditing
                  ? TextField(
                      controller: _noteController,
                      maxLines: null,
                      minLines: null,
                      onChanged: (value) {
                        setState(() {
                          isNoteOrTitleEdited = true; // Set the flag to true when the title is edited
                        });
                      },
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                          height: 1.8),
                    )
                  : Text(
                      editedNote, // Use the edited note here
                      style: GoogleFonts.merienda(
                        textStyle: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                            height: 1.8),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void updateNote() async {
    final sqlDb = SqlDb();
    try {
      await sqlDb.updateNote(widget.id, editeTitle, editedNote, editedDate);
    } catch (e) {
      // Handle the error here. You can show an error message to the user, log the error, etc.
      print('Failed to update note: $e');
      return;
    }
    print('the note successfully updated');
  }
}
