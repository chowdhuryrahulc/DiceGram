import 'dart:developer';

import 'package:country_code_picker/country_localizations.dart';
import 'package:dicegram/StreamBuilderPage.dart';
import 'package:dicegram/gameIdProblem.dart';
import 'package:dicegram/providers/profile_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dicegram/utils/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'models/user_model.dart';
import 'providers/group_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<circularProgressIndicatorController>(
              create: (context) => circularProgressIndicatorController()),
          ChangeNotifierProvider<updateGroup>(
              create: (context) => updateGroup()),
          ChangeNotifierProvider<ProfileProvider>(
              create: (context) => ProfileProvider()),
          ChangeNotifierProvider<GroupProvider>(
              create: (context) => GroupProvider()),
        ],
        child: ScreenUtilInit(
//             Height: 745.0
// [log] Width: 360.0
// [log] GameName: tikTackToe
            designSize: Size(360, 745),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: () {
              return MaterialApp(
                  builder: (context, widget) {
                    ScreenUtil.setContext(context);
                    return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: widget!);
                  },
                  supportedLocales: const [
                    Locale("af"),
                    Locale("am"),
                    Locale("ar"),
                    Locale("az"),
                    Locale("be"),
                    Locale("bg"),
                    Locale("bn"),
                    Locale("bs"),
                    Locale("ca"),
                    Locale("cs"),
                    Locale("da"),
                    Locale("de"),
                    Locale("el"),
                    Locale("en"),
                    Locale("es"),
                    Locale("et"),
                    Locale("fa"),
                    Locale("fi"),
                    Locale("fr"),
                    Locale("gl"),
                    Locale("ha"),
                    Locale("he"),
                    Locale("hi"),
                    Locale("hr"),
                    Locale("hu"),
                    Locale("hy"),
                    Locale("id"),
                    Locale("is"),
                    Locale("it"),
                    Locale("ja"),
                    Locale("ka"),
                    Locale("kk"),
                    Locale("km"),
                    Locale("ko"),
                    Locale("ku"),
                    Locale("ky"),
                    Locale("lt"),
                    Locale("lv"),
                    Locale("mk"),
                    Locale("ml"),
                    Locale("mn"),
                    Locale("ms"),
                    Locale("nb"),
                    Locale("nl"),
                    Locale("nn"),
                    Locale("no"),
                    Locale("pl"),
                    Locale("ps"),
                    Locale("pt"),
                    Locale("ro"),
                    Locale("ru"),
                    Locale("sd"),
                    Locale("sk"),
                    Locale("sl"),
                    Locale("so"),
                    Locale("sq"),
                    Locale("sr"),
                    Locale("sv"),
                    Locale("ta"),
                    Locale("tg"),
                    Locale("th"),
                    Locale("tk"),
                    Locale("tr"),
                    Locale("tt"),
                    Locale("uk"),
                    Locale("ug"),
                    Locale("ur"),
                    Locale("uz"),
                    Locale("vi"),
                    Locale("zh")
                  ],
                  localizationsDelegates: const [
                    CountryLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  title: 'DiceGram',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                      fontFamily: 'poppins',
                      primarySwatch: Colors1.primaryApp,
                      primaryColor: Colors1.primaryApp),
                  home: StreamBuilderPage());
            }));
  }
}

ifDoesntContainsAddAndReturnListOfUserModel(
    List<UserModel> peopleList, UserModel name) {
  bool isPresent = false;
  for (var k = 0; k < peopleList.length; k++) {
    if (name.username == peopleList[k].username) {
      isPresent = true;
    }
  }
  if (isPresent == false) {
    peopleList.add(name);
    log("Length: ${peopleList.length}");
  }
  return peopleList;
}
