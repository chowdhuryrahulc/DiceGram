import 'package:country_code_picker/country_localizations.dart';
import 'package:dicegram/ContactsBox.dart';
import 'package:dicegram/StreamBuilderPage.dart';
import 'package:dicegram/providers/profile_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dicegram/utils/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'providers/group_provider.dart';

late Box contactsBox;
Future<void> main() async {
  await Hive.initFlutter();
  // contactsBox = await Hive.openBox('contactsBox');
  // Hive.registerAdapter(ContactsBoxAdapter());
  // // Put in DB. In ListViewBuilder
  // contactsBox.put('contactsBox', ContactsBox(number: 1, contactsName: 'KKK'));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ProfileProvider>(
              create: (context) => ProfileProvider()),
          ChangeNotifierProvider<GroupProvider>(
              create: (context) => GroupProvider()),
        ],
        child: Sizer(builder: (context, orientation, deviceType) {
          return ScreenUtilInit(
            builder: () {
              return MaterialApp(
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
            },
          );
        }));
  }
}
