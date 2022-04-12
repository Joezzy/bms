import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/backgroundWavy.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/business.dart';
import 'package:user/model/country.dart';
import 'package:user/model/role.dart';
import 'package:user/model/staff.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';
import 'package:http/http.dart' as http;
import 'package:user/widgets/myAppBar.dart';
import 'package:path/path.dart';
class NewStaffScreen extends StatefulWidget {
  Staff? staff;
   NewStaffScreen({Key? key,this.staff}) : super(key: key);

  @override
  _NewStaffScreenState createState() => _NewStaffScreenState();
}

class _NewStaffScreenState extends State<NewStaffScreen> {
  String country="";

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'enter a valid email address')    ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(passwordPattern, errorText: 'should contain at least one upper case '
        '\nshould contain at least one lower case '
        '\nshould contain at least one digit '
        '\nAt least one Special character( ! @ # \$ & * ~ )')
  ]);

  TextEditingController firstNameController=TextEditingController();
  TextEditingController lastNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController positionController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController deptController=TextEditingController();
  TextEditingController dobController=TextEditingController();

  bool showPassword=true;


  String get firstName =>firstNameController.text;
  String get lastName =>lastNameController.text;
  String get email =>emailController.text;
  String get phone =>phoneController.text;
  String get password =>passwordController.text;
  String get address =>addressController.text;
  // String get position =>positionController.text;
  String get dept =>deptController.text;
  //////
  List genderList=[
    "Male",
    "Female"
  ];

  // List<Map>  designationList=[
  //   {"caption":"Admin","value":"admin"},
  //   {"caption":"Sales Rep","value":"sales_rep"},
  //   // {"caption":"Operations","value":"operations"},
  //   {"caption":"Accountant","value":"accountant"},
  //   {"caption":"Front Desk","value":"front_desk"},
  //
  // ];
String designation="manager";
  List<Role> designationList = [
    Role(caption: "Manager",value: "manager"),
    Role(caption: "Sales Rep",value: "sales_rep"),
    Role(caption: "Accountant",value: "accountant"),
    Role(caption: "Front Desk",value: "front_desk"),

  ];

  String dob="01/02/2022";
  DateTime selectedDate=DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dob = DateFormat('yyyy-MM-dd').format(selectedDate);
        dobController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        print(dob);
      });
  }

  String gender="Female";

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }
  final _key = GlobalKey<FormState>(); 
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getBusinessMethod(context);
    initMethod();
  }
  
  initMethod(){
 if(widget.staff!=null){
   firstNameController.text=widget.staff!.firstName;
   lastNameController.text=widget.staff!.lastName;
   emailController.text=widget.staff!.email;
   phoneController.text=widget.staff!.phone;
   positionController.text=widget.staff!.designation;
   addressController.text=widget.staff!.address;
   // passwordController.text=widget.staff!.firstName;
   dobController.text=DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.staff!.dob.toString()));
  dob=DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.staff!.dob.toString()));

 }

 getBusinessMethod(context);
   }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.staff==null? "New Staff":"Edit Staff",),
      backgroundColor: Colors.white,
      body: isLoading? Center(child: CircularProgressIndicator()):
      Container(
        width: MySize.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: MySize.size20),

        child: SingleChildScrollView(
          child:
          Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(height: MySize.size10,),
                getImageWidget(),
                SizedBox(height: MySize.size10,),
                FillButton(
                  // fontColor: Colors.white,
                    height: 45,
                    width: MySize.size200,
                    text:"Upload Photo",
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize: MySize.size14,
                    enabledColor: AppTheme.primaryColor,
                    enabled: true,
                    onPressed: (){
                      pictureWidget(context);


                    }),

                SizedBox(height: MySize.size20,),

                InputWithTitle(
                  fieldLabel: "First Name",
                  inputWidget: Txt(
                      width: MySize.screenWidth,
                      controller: firstNameController,
                      validator:     MinLengthValidator(2, errorText: 'Field is require'),
                      onChanged: (txt){}),
                ),
                SizedBox(height: MySize.size10,),
                InputWithTitle(
                  fieldLabel: "Last Name",
                  inputWidget: Txt(
                      width: MySize.screenWidth,
                      controller: lastNameController,
                      validator:     MinLengthValidator(2, errorText: 'Field is require'),
                      onChanged: (txt){}),
                ),
                if( widget.staff==null )       SizedBox(height: MySize.size10,),
                if( widget.staff==null )   InputWithTitle(
                  fieldLabel: "Email",
                  inputWidget: Txt(
                      width: MySize.screenWidth,
                      controller: emailController,
                      validator: emailValidator,
                      onChanged: (txt){}),
                ),
                SizedBox(height: MySize.size10,),
                InputWithTitle(
                  fieldLabel: "Phone",
                  inputWidget: Txt(
                      width: MySize.screenWidth,
                      placeholderText: "+2348 0000 000",
                      keyboardType: TextInputType.number,
                      validator:     MinLengthValidator(10, errorText: 'At least 10 character'),
                      controller: phoneController,
                      onChanged: (txt){}),
                ),

                SizedBox(height: MySize.size10,),
                InputWithTitle(
                  fieldLabel: "Designation",
                  inputWidget:  MyDropDown(
                      hint: "Select designation",
                      width: MySize.screenWidth,
                      drop_value: designation,
                      itemFunction: designationList?.map((item) {
                        return DropdownMenuItem(
                          child: new Text("${item.caption}"),
                          value: item.value,
                        );
                      }).toList() ??
                          [],
                      onChanged: (newValue) async {
                        print(newValue);
                        designation=newValue.toString();
                      }
                  ),
                ),

                SizedBox(height: MySize.size10,),
                InputWithTitle(
                  fieldLabel: "Date of birth",
                  inputWidget: Txt(
                      width: MySize.screenWidth,
                      controller: dobController,
                      suffixIcon: Icon(Icons.calendar_today), 
                      onSuffixItemTapped: ()=>_selectDate(context),
                      validator:     MinLengthValidator(2, errorText: 'Field is require'),
                      onChanged: (txt){}),
                ),

                SizedBox(height: MySize.size10,),

                InputWithTitle(
                  fieldLabel: "Address",
                  inputWidget: Txt(
                      width: MySize.screenWidth,
                      controller: addressController,
                      validator:     MinLengthValidator(2, errorText: 'Field is require'),
                      onChanged: (txt){}),
                ),
                SizedBox(height: MySize.size10,),
                InputWithTitle(
                  fieldLabel: "Store",
                  inputWidget:  MyDropDown(
                      hint: "Select Store",
                      width: MySize.screenWidth,
                      drop_value: business,
                      itemFunction: businessList!.map((item) {
                        return DropdownMenuItem(
                          child: new Text("${item.storeName}"),
                          value: item.id,
                        );
                      }).toList() ??
                          [],
                      onChanged: (newValue) async {
                        print(newValue);
                        business=newValue.toString();
                      }
                  ),
                ),
                SizedBox(height: MySize.size10,),
                if( widget.staff==null )
                  InputWithTitle(
                  fieldLabel: "Password",

                  inputWidget:   Txt(
                      width: MySize.screenWidth,
                      controller: passwordController,
                      isPasswordField: showPassword,
                      validator: passwordValidator,
                      placeholderText: "Enter password",
                      suffixIcon: showPassword? Icon(MdiIcons.eyeOutline): Icon(MdiIcons.eyeOffOutline),
                      onSuffixItemTapped: (){
                        setState(() {
                          if(!showPassword)
                            showPassword=true;
                          else
                            showPassword=false;
                        });
                      },

                      onChanged: (txt){}),
                ),



                SizedBox(height: MySize.size20,),

                FillButton(
                    width: MySize.screenWidth,
                    height: 45,
                    text:widget.staff==null?"Add Staff":"Update Staff",
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize: MySize.size14,
                    enabledColor: AppTheme.primaryColor,
                    enabled: true,
                    onPressed: (){
                      // getCountryMethod();
                      if(_key.currentState!.validate()){
                        addStaffMethod(context);
                      }else
                        return;
                    }),

                SizedBox(height: MySize.size100,),


              ],
            ),
          )

        ),
      ),
    );
  }


  double imgH = MySize.size100 * 2;
  double imgW = MySize.size100 * 2;
    File? _selectedFile;
  bool _inProcess = false;
  Dio dio = Dio();
  var avatar;

  Widget getImageWidget() {
    if (_selectedFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(MySize.size20)),
        child: Image.file(
          _selectedFile!,
          width: imgW,
          height: imgH,
          fit: BoxFit.cover,
        ),
      );
    } else {
      if (avatar != null) {
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(MySize.size20)),
          child: CachedNetworkImage(
            width: imgW,
            height: imgH,
            fit: BoxFit.cover,
            imageUrl: avatar,
            placeholder: (context, avatar) => CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
            ),
            errorWidget: (context, avatar, error) => Icon(Icons.error),
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(MySize.size20)),
          child: Image.asset(
            "assets/avatar.jpg",
            width: imgW,
            height: imgH,
            fit: BoxFit.cover,
          ),
        );
      }
    }
  }

  bool isLoading = false;
  bool _isBusy = false;
  bool _allowEditing = false;
   File? _currentFile;

  Future<void> _pickFile(ImageSource source) async {
    String? result;
    try {
      setState(() {
        _isBusy = true;
        // _currentFile;
      });

      // result = await FlutterFileDialog.pickFile(params: params);

       XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 100,
      );
      setState(() {
        _imageFile = pickedFile;
      });
      File img = File(pickedFile!.path);
      if (img != null) {
        File? cropped = await ImageCropper().cropImage(
          sourcePath: img.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 150,
          maxWidth: 150,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.white,
            toolbarTitle: "Royal Hair",
            statusBarColor: Colors.black,
            // backgroundColor: Colors.white,
          ),
        );


        this.setState(() {
          _selectedFile = File(cropped!.path);
          print("PICTURE OUTPUT= $_selectedFile");
          // print(filePath);
          _inProcess = false;
        });
        if (img != null) {
          // await updateAvatarMethod();
        }
      }
    } on PlatformException catch (e) {
      print(e);
    } finally {
      setState(() {
        if (result != null) {
          _currentFile = File(result);
        } else {
          _currentFile = null;
        }
        _isBusy = false;
      });
    }
  }


  void addStaffMethod(context) async {
    String url="";
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var myData;
    String filePath="";
    String filename="";
    if(_selectedFile!=null){
       filePath=_selectedFile!.path;
       filename=basename(filePath);
    }

    print(filePath);

    var body = FormData.fromMap(
        {


        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "email": email,
        "password": password,
        "designation": designation,
        "address": address,
        "dob": dob,
        "business": business,
        'avatar': _selectedFile!=null? await MultipartFile.fromFile(
              filePath, filename: filename):avatar
        }
    );
print(body.fields);
    SharedPreferences crypt = await SharedPreferences.getInstance();
    var res;
    try{
      if(widget.staff==null){
      url=  baseUrl + '/staff/';
    res=  await RequestHelper.postRequestAuth(url, body);
    }else{
      url=  baseUrl + '/staff/${widget.staff!.id}/';
    res=  await RequestHelper.patchRequestAuth(url, body);

    }
      print("OKP");
      print(res);
      if (res[0]["status"] == "failed") {
        print(res[0]["data"]);


        MotionToast.error(
            height: MySize.size200,
            title:  Text("Unsuccessful!\n",style: TextStyle(fontWeight: FontWeight.bold),),
            description:  Text("${replaceString(res[0]["message"].toString())}")
        ).show(context);
      } else {
        myData = res[0]["data"]["data"];
        print("MyData");
        setState(() {
          firstNameController.clear();
          lastNameController.clear();
          emailController.clear();
          phoneController.clear();
          positionController.clear();
          addressController.clear();
          passwordController.clear();
          deptController.clear();
          dobController.clear();
          _selectedFile=null;
        });

        Navigator.pop(context,"success");
        MotionToast.success(
            title:  Text("Successful"),
            description:  Text(widget.staff==null? "Account Created":"Account updated")
        ).show(context);

      }
    }
    catch( e){
      print("CATCH");
      print(e.toString());
      MotionToast.error(
        title:  Text("Unsuccessful"),
        description:  Text("${e.toString()}"),
      ).show(context);
    }

    setState(() {
      isLoading = false;
    });
  }


  List<Country> countryList=[];
  void getCountryMethod() async {
    String url = baseUrl + '/countries/';
    if (mounted)
      setState(() {
        countryList.clear();
        isLoading = true;
      });

    var myData;
    var body = json.encode(
        {}
    );
    // List res;
    try{
      final  res=  await RequestHelper.getRequestAuth(url, body);
      print("OKP");
      print(res);
      if (res[0]["status"] == "failed") {
        print(res[0]["data"]);
        MotionToast.error(
            height: MySize.size200,
            title:  Text("Unsuccessful!\n",style: TextStyle(fontWeight: FontWeight.bold),),
            description:  Text("${replaceString(res[0]["message"].toString())}")
        );
      } else {
        myData = res[0]["message"];
        print("MyData");
        log(json.encode(myData));
        setState(() {
          countryList= countryFromJson(json.encode(myData));
          country= countryList[0].id.toString();
          isLoading=false;
        });
        log(countryList[0].name);


      }
    }
    catch( e){
      print("CATCH");
      print(e.toString());
      MotionToast.error(
        title:  Text("Unsuccessful"),
        description:  Text("${e.toString()}"),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  String business="";
  List<Business> businessList=[];
  void getBusinessMethod(context) async {
    String url = baseUrl + '/business/';
    if (mounted)
      setState(() {
        businessList.clear();
        isLoading = true;
      });

    var myData;
    var body = json.encode(
        {}
    );
    // List res;
    try{
      final  res=  await RequestHelper.getRequestAuth(url, body);
      print("OKP");
      print(res);
      if (res[0]["status"] == "failed") {
        print(res[0]["data"]);
        MotionToast.error(
            height: MySize.size200,
            title:  Text("Unsuccessful!\n",style: TextStyle(fontWeight: FontWeight.bold),),
            description:  Text("${replaceString(res[0]["message"].toString())}")
        ).show(context);
      } else {
        myData = res[0]["message"];
        print("MyData");
        log(json.encode(myData));
        setState(() {
          businessList= businessFromJson(json.encode(myData));
          business= businessList[0].id.toString();
          isLoading=false;
        });
        log(businessList[0].storeName);


      }
    }
    catch( e){
      print("CATCH");
      print(e.toString());
      MotionToast.error(
        title:  Text("Unsuccessful"),
        description:  Text("${e.toString()}"),
      ).show(context);
    }

    setState(() {
      isLoading = false;
    });
  }



  void pictureWidget(context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MySize.size230,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MySize.size20 ),
                          child: Text(
                            "Add Image",
                            style: TextStyle(
                                fontSize: MySize.size18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        ListTile(
                          leading: Icon(Icons.camera_outlined),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Camera"),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();

                            _pickFile(ImageSource.camera);


                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.photo_library_outlined),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Gallery "),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            _pickFile(ImageSource.gallery);




                          },
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }


}
