import 'package:flutter/material.dart';

import 'package:to_do_list_pct/app/notes_pct/ui/notes_page.dart';
import 'package:to_do_list_pct/app/app_colors.dart';

void main() async {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do Pct',
      theme: ThemeData(
        primaryTextTheme: Typography(platform: TargetPlatform.android).white,
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor:
                    WidgetStatePropertyAll(MyColors().titleColor))),
        iconTheme: const IconThemeData(color: Colors.white),
        primaryIconTheme: const IconThemeData(color: Colors.white),
        textTheme: Typography(platform: TargetPlatform.android).white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 80,
          backgroundColor: Color.fromARGB(255, 1, 4, 34),
        ),
        cardColor: MyColors().paletteColor1,
        cardTheme: const CardTheme(
          elevation: 15,
        ),
        focusColor: MyColors().titleColor,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.comfortable,
        colorScheme: ColorScheme.dark(surface: MyColors().paletteColor1),
        useMaterial3: true,
      ),
      home: const NotesPage(),
    );
  }
}
