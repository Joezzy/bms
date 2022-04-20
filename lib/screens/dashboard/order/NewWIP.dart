import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/controller/businessProvider.dart';
import 'package:user/controller/cartProvider.dart';
import 'package:user/controller/cartProvider.dart';
import 'package:user/controller/cartProvider.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/order.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';


class NewWIPScreen extends StatefulWidget {
  wipList? order;
   NewWIPScreen({Key? key,

    this.order}) : super(key: key);


  @override
  _NewWIPScreenState createState() => _NewWIPScreenState();
}


class _NewWIPScreenState extends State<NewWIPScreen> {
  String selectedStage = "5b6b19a8-5cb4-4426-be36-14c017eacd13";
  TextEditingController remarkController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CartProvider>(context, listen: false).getServicesMethod();
  }

  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  List<XFile>? _imageFileList;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("New WIP",style: TextStyle(color: Colors.black),),
        backgroundColor: AppTheme.whiteBackground,
        iconTheme: IconThemeData(color: AppTheme.primaryColor,),
        elevation: 0,

      ),
      body: isLoading?Center(child: CircularProgressIndicator()): Container(
        // height: MySize.size400,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.only(top: MySize.size10),
              child: Text(
                "Select one stage to create a WIP stage",
                style: TextStyle(
                    fontSize: MySize.size12, fontWeight: FontWeight.bold),
              ),
            ),

            InputWithTitle(
              fieldLabel: "Stage",
              inputWidget: MyDropDown(
                  hint: "Select Stage",
                  drop_value: selectedStage,
                  itemFunction: cartProvider.serviceList.map((item) {
                    return DropdownMenuItem(
                      child: new Text("${item.name}"),
                      value: item.id.toString(),
                    );
                  }).toList() ??
                      [],
                  onChanged: (newValue) async {
                    print(newValue);
                    selectedStage = newValue.toString();
                  }
              ),
            ),
            SizedBox(height: MySize.size20),
            InputWithTitle(
              fieldLabel: "Remark(Optional)",
              inputWidget: Txt(
                  controller: remarkController,
                  // validator: RequiredValidator(errorText: 'this field is required'),
                  placeholderText: "",
                  contentPadding: EdgeInsets.all(10),
                  maxLine: 3,
                  onChanged: (txt) {}),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: MySize.size20),
              child: Text(
                " Tap to upload image sample",
                style: TextStyle(
                    fontSize: MySize.size12, fontWeight: FontWeight.bold),
              ),
            ),

            GestureDetector(
                onTap:()=> _pickFile(ImageSource.gallery),
                child: getImageWidget()),
            SizedBox(height: MySize.size40),

            FillButton(
              // fontColor: Colors.white,
                height: 45,
                width: MySize.size650,
                text: "Create WIP  Stage",
                fontColor: Colors.white,
                fontWeight: FontWeight.w100,
                fontSize: MySize.size14,
                enabledColor: AppTheme.primaryColor,
                enabled: true,
                onPressed: () {
createWIPMethod();

                }
            ),

          ],
        ),
      ),
    );
  }

  double imgH = MySize.size300;
  double imgW = MySize.screenWidth;
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
            "assets/upload.jpg",
            width: imgW,
            height: imgH,
            fit: BoxFit.cover,
          ),
        );
      }
    }
  }

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
      // if (img != null) {
      //   File? cropped = await ImageCropper().cropImage(
      //     sourcePath: img.path,
      //     aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      //     compressQuality: 100,
      //     maxHeight: 150,
      //     maxWidth: 150,
      //     compressFormat: ImageCompressFormat.jpg,
      //     androidUiSettings: AndroidUiSettings(
      //       toolbarColor: Colors.white,
      //       toolbarTitle: "Couriax",
      //       statusBarColor: Colors.black,
      //       // backgroundColor: Colors.white,
      //     ),
      //   );
      //
      //

        this.setState(() {
          _selectedFile = File(img.path);
          print("PICTURE OUTPUT= $_selectedFile");
          // print(filePath);
          _inProcess = false;
        });

      // }
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



  void createWIPMethod() async {
    String url= baseUrl + '/wip/';
    final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
    if (mounted)
      setState(() {
        isLoading = true;
      });

    // Business, stage(service), remark,order_id

    var myData;
    var body = json.encode(
        {
          "business": businessProvider.baseStore,
          "stage": selectedStage,
          "order": widget.order!.id,
          "remark":remarkController.text
        }
    );

    var res;
    // try{

    res=  await RequestHelper.postRequestAuth(url, body);
    print("OKP");
    print(res);
    if (res[0]["status"] == "failed") {
      print(res[0]["data"]);

      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        confirmBtnColor: AppTheme.primaryColor,
        backgroundColor: AppTheme.primaryColor,
        text: "${replaceString(res[0]["message"].toString())}",
      );

    } else {
      myData = res[0]["data"]["data"];
      print("MyData");

      // MotionToast.success(
      //     title:  Text("Successful"),
      //     description:  Text("Account Created")
      // ).show(context);

      Navigator.pop(context,"success");

      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        confirmBtnColor: AppTheme.primaryColor,
        backgroundColor: AppTheme.primaryColor,
        text:"WIP Stage Created!",
      );

      // Navigator.of(context, rootNavigator: true,).pop();

    }
    // }
    // catch( e){
    //   print("CATCH");
    //   print(e.toString());
    //   CoolAlert.show(
    //     context: context,
    //     type: CoolAlertType.error,
    //     confirmBtnColor: AppTheme.primaryColor,
    //     backgroundColor: AppTheme.primaryColor,
    //     text: "${replaceString(e.toString())}",
    //   );
    // }

    setState(() {
      isLoading = false;
    });
  }

}