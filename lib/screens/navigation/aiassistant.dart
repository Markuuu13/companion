import 'package:companion/components/ai_txtfield.dart';
import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiAssistant extends StatefulWidget {
  const AiAssistant({super.key});

  @override
  State<AiAssistant> createState() => _AiAssistantState();
}

class _AiAssistantState extends State<AiAssistant> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/companion_logo.png", width: 100),
                SizedBox(height: 20),
                Center(
                  // Ensures the text is fully centered
                  child: Text(
                    "Welcome To AI Assistant",
                    style: GoogleFonts.workSans(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      offset: Offset(0, -2),
                      spreadRadius: 0,
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: mainColor, width: 3),
                          ),
                          child: AiTxtfield(
                            hintText: "What do you want to know?",
                            controller: textController,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.send),
                        color: mainColor,
                      ),

                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.mic),
                        color: mainColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
