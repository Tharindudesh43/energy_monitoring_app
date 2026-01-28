import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    TextEditingController Accountnumber = TextEditingController();
    TextEditingController AccessKey = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 400,

                height: 400,
                padding: EdgeInsets.all(50),
                child: Image.asset('assets/signin_image.png'),
              ),
            ),
            Padding(
 padding:  EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Account Number: ",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  TextField(
                    maxLines: 1,
                    cursorColor: Colors.green,
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "CEB_xxxxxx_xxxxxx-xx",
                      hintStyle: const TextStyle(color: Colors.green),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Access Key: ",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  TextField(
                    maxLines: 1,
                    cursorColor: Colors.green,
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "* * * * * * ",
                      hintStyle: const TextStyle(color: Colors.green),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 200,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color.fromARGB(255, 103, 214, 106), Color.fromARGB(255, 67, 115, 11)],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
