import 'package:country_code_picker/country_code_picker.dart';
import 'package:dicegram/ui/screens/otp_screen.dart';
import 'package:dicegram/utils/Color.dart';
import 'package:dicegram/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String countryPhoneCode = "+91";
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment(-0.5.sp, 0.5.sp),
            colors: const [Color(0xffFCEE21), Color(0xFFFF0000)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(40.sp),
              child: Image(
                  fit: BoxFit.fill,
                  width: width.w,
                  image: AssetImage('assets/images/logo2.png')),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 1.r,
                        blurRadius: 8.r,
                        offset:
                            Offset(4.sp, 8.sp), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10.r))),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.h),
                  child: TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name',
                        hintStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    controller: _usernameController,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Container(
                width: width,
                margin: EdgeInsets.symmetric(vertical: 16.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 1.r,
                        blurRadius: 8.r,
                        offset:
                            Offset(4.sp, 8.sp), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10.r))),
                child: SizedBox(
                  width: 500.w,
                  child: Row(
                    children: [
                      CountryCodePicker(
                        onChanged: _onCountryCodeSelected,
                        showFlagDialog: true,
                        showFlagMain: true,
                        backgroundColor: Colors1.red,
                        showDropDownButton: true,
                        barrierColor: Colors1.red,
                        initialSelection: 'IN',
                        favorite: const ['IN'],
                        countryFilter: AppConstants.list,
                        showFlag: false,
                        flagDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          obscureText: false,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.phone,
                          controller: _mobileController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Phone',
                              hintStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
                onTap: () {
                  if (_usernameController.text.characters.length < 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add valid User name')));
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtpScreen(
                              countryPhoneCode + _mobileController.text,
                              _usernameController.text)),
                    );
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFFF1803), Color(0xffFF4A0B)]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(4, 8), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.w, horizontal: 32.h),
                    child: Text(
                      'Get OTP',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ))
          ],
        ),
      ),
    ));
  }

  void _onCountryCodeSelected(countryCode) {
    countryPhoneCode = countryCode;
  }
}
