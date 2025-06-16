import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notezilla/HiveService.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:notezilla/NoteList.dart';

class Notesdetail extends StatefulWidget {

  Color color;
  double tilt;
  var data;

   Notesdetail({super.key, required this.color, required this.tilt, required this.data });

  @override
  State<Notesdetail> createState() => _NotesdetailState();
}

class _NotesdetailState extends State<Notesdetail> {

  var titlecontroller = TextEditingController();
  var contentcontroller = TextEditingController();
  String? datee = "";

  final hiveservice = Hiveservice();
  bool isloading = true;
  bool isChanged = false;
  bool isupdated = false;
  bool isDeleting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    inithive();

  }

  void inithive()async
  {
    await hiveservice.inithive();
    setup();
  }

  void setup()
  {
    titlecontroller.text = widget.data["title"];
    contentcontroller.text = widget.data["content"] ;


    final updated = widget.data["updatedAt"];
    final created = widget.data["createdAt"];
   // datee = (updated != null && updated.toString().isNotEmpty) ? updated : created;

    if(updated != null && updated.toString().isNotEmpty)
      {
        datee = updated;
        isupdated = true;
      }
    else
      {
        datee = created;
        isupdated = false;
      }

    print("${widget.data["id"]}");

    isloading = false;
    setState(() {


    });



  }
  void addnote(String title, String content)
  {

    if (isChanged)
    {
      datee = formatDate(DateTime.now());
    }
    final newTransactiondemo = {
      "title" : title,
      "content" : content,
      "createdAt" :  widget.data["createdAt"],
      "updatedAt" : datee,
      "color": null,
      "isPinned": false
    };

    hiveservice.updateNote( widget.data["id"] ,newTransactiondemo);
  }

  Future<void> deleteNote() async
  {
    await  hiveservice.deleteTransaction(widget.data["id"]);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Notes Deleted")));
    Navigator.of(context).pop();
    Navigator.of(context).pop();

  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return  PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (isChanged && !isDeleting) {
          addnote(titlecontroller.text, contentcontroller.text);
        }
      },
      child: Scaffold(
        backgroundColor: widget.color,
        appBar: AppBar(backgroundColor: widget.color,
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
            ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {

                  showDialog(
                      context: context, builder: (context) => StatefulBuilder(builder: (context, setState) {

                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white,
                          title: Row(
                            children: const [
                              Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                              SizedBox(width: 8),
                              Text("Delete Note?", style: TextStyle(fontWeight: FontWeight.w500, fontFamily: "Quando", fontSize: 16)),
                            ],
                          ),
                          content: const Text(
                            "Are you sure you want to delete this note? ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Cancel
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async{
                                isDeleting = true;
                               await deleteNote();

                              },

                              icon: const Icon(Icons.delete_outline, size: 18),
                              label: const Text(
                                "Delete",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },),);
                },
                child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.delete_sweep_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),

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
                        child:  isloading ? SpinKitWave(color: Colors.white, size: 20,) :
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(controller: titlecontroller,
                              maxLines: null, // Keep it single-line

                              decoration: InputDecoration(
                                hintText: "Enter Title",
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none, // Remove underline
                              ),

                              onChanged: (value) {
                                isChanged = true;
                              },

                              style: TextStyle(color: Colors.white, fontFamily: 'Caveat',fontSize: 26,  letterSpacing: 1.5, fontWeight: FontWeight.w600),),

                            Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.white70, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  isupdated ? "Updated at: ${datee ?? 'Beyond time'}" : "Created at: ${datee ?? 'Beyond time'}",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontFamily: 'Caveat',
                                    fontSize: 14,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      )),



                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Transform.rotate(
                        angle: widget.tilt,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Container(
                                width: MediaQuery.of(context).size.width ,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
                                child: isloading ? SpinKitWave(color: widget.color,size: 20) : TextFormField(controller: contentcontroller,
                                  expands: true,
                                  maxLines: null,
                                  onChanged: (value) {
                                    isChanged = true;
                                  },
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    border: InputBorder.none, // Hides the underline
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: 'Write your note...',
                              
                              
                                  ),
                                  style: TextStyle(color: Colors.black87,fontFamily: 'Caveat',fontSize: 24,),),
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
