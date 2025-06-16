import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:notezilla/AddNote.dart';
import 'package:notezilla/HiveService.dart';
import 'package:notezilla/NotesDetail.dart';

class Notelist extends StatefulWidget {
  const Notelist({super.key});

  @override
  State<Notelist> createState() => _NotelistState();
}

class _NotelistState extends State<Notelist> {
  Random random = Random();
  List<int> randheight = [];
  List<double> tiltValues = [];
  List<Color> bg_colour = [];
  final hiveservice = Hiveservice();
  List<Map<dynamic, dynamic>> noteslist = [];
  List<Map<dynamic, dynamic>> filternoteslist = [];
  bool isloading = true;
  final searchcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    inithive();
  }

  void inithive() async {
    await hiveservice.inithive();
   // hiveservice.clearAll();
    getdata();
    setcolour();
  }

  DateTime parseDate(String? dateStr) {
    try {
      return DateFormat('dd MMM yyyy, hh:mm a').parse(dateStr!);
    } catch (e) {
      return DateTime(1970); // fallback in case of parsing error
    }
  }

  void getdata() {

    noteslist = hiveservice.getnotes();

    // Sort by updatedAt if available, else createdAt
    // noteslist.sort((a, b) {
    //   DateTime dateA = parseDate(a["updatedAt"]?.toString().trim().isNotEmpty == true
    //       ? a["updatedAt"]
    //       : a["createdAt"]);
    //   DateTime dateB = parseDate(b["updatedAt"]?.toString().trim().isNotEmpty == true
    //       ? b["updatedAt"]
    //       : b["createdAt"]);
    //
    //   // For latest note first, compare in reverse
    //   return dateB.compareTo(dateA);
    // });


    filternoteslist = noteslist;




    setState(() {});

    print("get data called");
  }

  void setcolour(){

    setState(() {

      isloading = true;
    });

    randheight.clear();
    tiltValues.clear();
    bg_colour.clear();
    for (int i = 0; i < filternoteslist.length; i++) {
      randheight.add(100 + random.nextInt(100));
      tiltValues.add((random.nextDouble() * 0.18) - 0.09);
      bg_colour.add(getRandomShade());
    }

    setState(() {

      isloading = false;
    });



    print("set colour called");
  }

  void addSearch(String query)
  {
    var result = noteslist.where((element) => element["title"].toLowerCase().toString().contains(query.toLowerCase())
                                              || element["content"].toString().toLowerCase().contains(query.toLowerCase())
                                                ,).toList();

    filternoteslist = result;

    setState(() {

    });
  }

  Color getRandomShade() {
    const shades = [100, 200, 300, 400];
    const baseColors = [
      Colors.red,
      Colors.blue,
      Colors.green,

      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];
    final color = baseColors[random.nextInt(baseColors.length)];
    final shade = shades[random.nextInt(shades.length)];
    return color[shade]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Colors.white,),
        label: Text(
          "Add New Notes",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor:  Colors.teal[400],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNote()),
          ).then((value) {
            getdata();
            setcolour();
          },);
        },
      ),
      appBar: AppBar(leading: null, backgroundColor: Colors.white,
        elevation: 0,


        title:   Text(
      "NoteZilla",
      style: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
      fontFamily: 'Caveat',
      ),
    ),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child:  TextField(
                  controller:searchcontroller ,
                  onChanged: (value) => addSearch(value),
                  decoration: InputDecoration(
                    hintText: "Search notes...",
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "My Notes",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),

              isloading ? Expanded(child: SpinKitPulse(color: Colors.teal[400], size: 40,)) :
              filternoteslist.isEmpty ? Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/no_data.png",
                        width: 250,
                        height: 200,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "No Notes Yet!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Tap the + button to add your first note.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
                  :
              Expanded(
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 8,
                  padding: EdgeInsets.only(bottom: 100),
                  itemCount: filternoteslist.length,
                  itemBuilder: (context, index) {

                    var notedata = filternoteslist[index];
                    return Transform.rotate(
                      angle: tiltValues[index],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                searchcontroller.clear();
                                print("unfoc");

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Notesdetail(
                                      color: bg_colour[index],
                                      tilt: 0.05,
                                      data: notedata,
                                    ),
                                  ),
                                ).then((value) {
                                  getdata();
                                },);
                              },
                              child:Container(
                                height: randheight[index].toDouble(),
                                width: MediaQuery.of(context).size.width * 0.5,
                                padding: const EdgeInsets.all(16),

                                decoration: BoxDecoration(
                                  color: bg_colour[index],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(3, 3),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notedata["title"] ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Caveat',
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      notedata["content"] ?? "",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black54, // Softer than black
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Caveat',
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              )

                            ),
                            Positioned(
                              top: -8,
                              left: 90,
                              child: SizedBox(
                                width: 40,
                                height: 20,
                                child: Text("\ud83d\udccd", style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
