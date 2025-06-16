import 'package:flutter/material.dart';
import 'package:notezilla/HiveService.dart';
import 'package:intl/intl.dart';

class AddNote extends StatefulWidget {

  AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  var titlecontroller = TextEditingController();
  var contentcontroller = TextEditingController();

  final hiveservice = Hiveservice();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    inithive();
  }

  void inithive()async
  {
    await hiveservice.inithive();


  }



  // int? id;
  // String title;
  // String content;
  // String createdAt;
  // String updatedAt;
  // int color;
  // bool isPinned;

  void addDummyNotes() {
    for (int i = 1; i <= 20 ; i++) {
      String title = "Note Title $i";
      String content = "This is the content of note number $i.";
      addnote(title, content);
    }
  }


  void addnote(String title, String content)
  {
    final newTransactiondemo = {
      "title" : title,
      "content" : content,
      "createdAt" : formatDate(DateTime.now()),
      "updatedAt" : "",
      "color": null,
      "isPinned": false
    };

    hiveservice.addnotes(newTransactiondemo);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }


  @override
  Widget build(BuildContext context) {
    return  PopScope(
        canPop: true,
      onPopInvoked: (didPop) {

        if(titlecontroller.text.trim().isNotEmpty || contentcontroller.text.trim().isNotEmpty)
          {
            //addnote(titlecontroller.text, contentcontroller.text);
            addDummyNotes();

          }
        else
          {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Empty note discarded")));
          }



      },
      child: Scaffold(
        backgroundColor: Colors.teal[400],
        appBar: AppBar(backgroundColor: Colors.teal[400],
            leading:Padding(
              padding: const EdgeInsets.all(4.0), // Adds spacing around the circle
              child: InkWell(
                onTap: () => Navigator.pop(context), // Back action

                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.3),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black.withOpacity(0.6),
                    size: 18,
                  ),
                ),
              ),
            )),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Container(
              decoration: BoxDecoration( borderRadius: BorderRadius.circular(26)),
              child: Column(
                children: [
                  Container(

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(controller: titlecontroller,
                          maxLines: null, // Keep it single-line

                          decoration: InputDecoration(
                            hintText: "Enter Title",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none, // Remove underline
                          ),

                          style: TextStyle(color: Colors.white, fontFamily: 'Caveat',fontSize: 24,),),
                      )),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Transform.rotate(
                        angle:0.04,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Container(
                                width: MediaQuery.of(context).size.width ,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
                                child: TextFormField(controller: contentcontroller,
                                  expands: true,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    border: InputBorder.none, // Hides the underline
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: 'Write your note...',


                                  ),
                                  style: TextStyle(color: Colors.black,fontFamily: 'Caveat',fontSize: 24,),),
                              ),
                            ),

                            Positioned(
                              top: -3,
                              left: 30,
                              child: SizedBox(
                                width: 40,
                                height: 20,
                                child: Text("\ud83d\udccd", style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
