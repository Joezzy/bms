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
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/business.dart';
import 'package:user/model/category.dart';
import 'package:user/model/product.dart';
import 'package:user/model/subCategory.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';
import 'package:http/http.dart' as http;
import 'package:user/widgets/myAppBar.dart';
import 'package:path/path.dart';
class NewProductScreen extends StatefulWidget {
  Product? product;

   NewProductScreen({Key? key,this.product}) : super(key: key);

  @override
  _NewProductScreenState createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  String country="";
  String business="";
  String category="";
  String subcategory="";

  TextEditingController productNameController=TextEditingController();
  TextEditingController costPriceController=TextEditingController();
  TextEditingController salesPriceController=TextEditingController();
  TextEditingController stockUnitController=TextEditingController();
  TextEditingController unitMeasureController=TextEditingController();
  TextEditingController unitIncrementController=TextEditingController(text: "1");
  TextEditingController option1Controller=TextEditingController(text: "");
  TextEditingController option2Controller=TextEditingController(text: "");
  TextEditingController option3Controller=TextEditingController(text: "");

  bool showPassword=true;

  String get productName =>productNameController.text;
  String get costPrice =>costPriceController.text;
  double get salesPrice =>double.parse(salesPriceController.text);
  String get stockUnit =>stockUnitController.text;
  String get unitMeasure =>unitMeasureController.text;
  String get unitIncrement =>unitIncrementController.text;
  String get option1 =>option1Controller.text;
  String get option2 =>option2Controller.text;
  String get option3 =>option3Controller.text;


  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  List<XFile>? _imageFileList;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBusinessMethod();
    getCategoryMethod();
    initMethod();

  }
initMethod()async{
if(widget.product!=null){
  setState(() {
    productNameController.text=widget.product!.name;
    costPriceController.text=widget.product!.costPrice;
    salesPriceController.text=widget.product!.salesPrice;
    stockUnitController.text=widget.product!.stockUnit.toString();
    unitMeasureController.text=widget.product!.unitMeasurement;
    unitIncrementController.text=widget.product!.unitIncrement;
    category=widget.product!.category;
    subCategory=widget.product!.subCategory;
  });
}

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.product==null?"New Product":"Edit Product",),
      backgroundColor: Colors.white,
      body: isLoading? Center(child: CircularProgressIndicator()):Container(
        padding: EdgeInsets.symmetric(horizontal: MySize.size20),
        width: MySize.screenWidth,

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
                        _pickFile(ImageSource.gallery);

                      }),

                  SizedBox(height: MySize.size20,),

                  InputWithTitle(
                    fieldLabel: "Product Name",
                    inputWidget: Txt(
                        width: MySize.screenWidth,
                        controller: productNameController,
                        validator:     MinLengthValidator(2, errorText: 'Field is require'),
                        onChanged: (txt){}),
                  ),
                  SizedBox(height: MySize.size10,),
                  InputWithTitle(
                    fieldLabel: "Cost price",
                    inputWidget: Txt(
                        width: MySize.screenWidth,
                        controller: costPriceController,
                        keyboardType: TextInputType.number,
                        validator:     MinLengthValidator(1, errorText: 'Field is require'),
                        onChanged: (txt){}),
                  ),
                  SizedBox(height: MySize.size10,),
                  InputWithTitle(
                    fieldLabel: "Sales price",
                    inputWidget: Txt(
                        width: MySize.screenWidth,
                        controller: salesPriceController,
                        keyboardType: TextInputType.number,
                        validator:     MinLengthValidator(1, errorText: 'Field is require'),
                        onChanged: (txt){}),
                  ),
                  SizedBox(height: MySize.size10,),
                  InputWithTitle(
                    fieldLabel: "Stock Unit",
                    inputWidget: Txt(
                        width: MySize.screenWidth,
                        controller: stockUnitController,
                        keyboardType: TextInputType.number,
                        validator:     MinLengthValidator(1, errorText: 'Field is require'),
                        onChanged: (txt){}),
                  ),
                  SizedBox(height: MySize.size10,),
                  InputWithTitle(
                    fieldLabel: "Unit Measurement",
                    inputWidget: Txt(
                        width: MySize.screenWidth,
                        placeholderText: "Kg, mm, litre, etc",
                        validator:     MinLengthValidator(1, errorText: 'Field is required'),
                        controller: unitMeasureController,
                        onChanged: (txt){}),
                  ),
                  SizedBox(height: MySize.size10,),
                  InputWithTitle(
                    fieldLabel: "Unit Increment",
                    inputWidget: Txt(
                        width: MySize.screenWidth,
                        controller: unitIncrementController,
                        keyboardType: TextInputType.number,
                        validator:     MinLengthValidator(1, errorText: 'Field is require'),
                        onChanged: (txt){}),
                  ),
                  SizedBox(height: MySize.size10,),
                  InputWithTitle(
                    fieldLabel: "Color",
                    inputWidget: Txt(
                        width: MySize.screenWidth,
                        controller: option1Controller,
                        // keyboardType: TextInputType.number,
                        validator:     MinLengthValidator(1, errorText: 'Field is require'),
                        onChanged: (txt){}),
                  ),
                  SizedBox(height: MySize.size10,),
                  InputWithTitle(
                    fieldLabel: "Styling",
                    inputWidget: Txt(
                        width: MySize.screenWidth,
                        controller: option2Controller,
                        // keyboardType: TextInputType.number,
                        validator:     MinLengthValidator(1, errorText: 'Field is require'),
                        onChanged: (txt){}),
                  ),
                  SizedBox(height: MySize.size10,),

                  InputWithTitle(
                    fieldLabel: "Category",
                    inputWidget:  MyDropDown(
                        hint: "Select Category",
                        drop_value: category,
                        width: MySize.screenWidth,
                        itemFunction: categoryList.map((item) {
                          return DropdownMenuItem(
                            child: new Text("${item.name}"),
                            value: item.id.toString(),
                          );
                        }).toList() ??
                            [],
                        onChanged: (newValue) async {
                          print(newValue);
                          category=newValue.toString();
                          getSubCategoryMethod(category);
                        }
                    ),
                  ),
                  SizedBox(height: MySize.size10,),

                  isLoadingSubCategory?CircularProgressIndicator():
                  InputWithTitle(
                    fieldLabel: "Sub-category",
                    inputWidget:  MyDropDown(
                        hint: "Select Sub Category",
                        drop_value: subCategory,
                        width: MySize.screenWidth,
                        itemFunction: subCategoryList.map((item) {
                          return DropdownMenuItem(
                            child: new Text("${item.name}"),
                            value: item.id.toString(),
                          );
                        }).toList() ??
                            [],
                        onChanged: (newValue) async {
                          print(newValue);
                          subCategory=newValue.toString();
                        }
                    ),
                  ),

                  SizedBox(height: MySize.size20,),


                  FillButton(
                      width: MySize.screenWidth,
                      height: 45,
                      text:widget.product==null?"Add Product":"Update Product",
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w100,
                      fontSize: MySize.size14,
                      enabledColor: AppTheme.primaryColor,
                      enabled: true,
                      onPressed: (){

                        if(_key.currentState!.validate()){
                          addProductMethod(context);

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


  double imgH = MySize.size350;
  double imgW = MySize.size350;
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
        // maxWidth: 300,
        // maxHeight: 300,
        imageQuality: 100,
      );
      setState(() {
        _imageFile = pickedFile;
      });
      File img = File(pickedFile!.path);
      if (img != null) {
        this.setState(() {
          _selectedFile = File(img.path);
          print("PICTURE OUTPUT= $_selectedFile");
          // print(filePath);
          _inProcess = false;
        });

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


  void addProductMethod(context) async {
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

    var options=json.encode({"Color":option1,"style":option2});

    var body = FormData.fromMap(
        {
          "name": productName,
          "cost_price": costPrice,
          "sales_price": salesPrice,
          "stock_unit": stockUnit,
          "unit_measurement": unitMeasure,
          "unit_increment": unitIncrement,
          "category": category,
          "sub_category": subCategory,
          "business_id": business,
          "selectable_options":options,
          'image':_selectedFile!=null? await MultipartFile.fromFile(
              filePath, filename: filename):null
        }
    );

    SharedPreferences crypt = await SharedPreferences.getInstance();

    // print(body);
    var res;
    try{
      if(widget.product==null){
         url = baseUrl + '/product/';
        res=  await RequestHelper.postRequestAuth(url, body);

      }else{
         url = baseUrl + '/product/${widget.product!.id}/';

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
          productNameController.clear();
          costPriceController.clear();
          salesPriceController.clear();
          stockUnitController.clear();
          unitIncrementController.clear();
          unitMeasureController.clear();
          _selectedFile=null;
        });

        Navigator.pop(context,"success");

        MotionToast.success(
            title:  Text("Successful"),
            description:  Text(widget.product==null?"Product added Successfully!":"Product Updated!")
        ).show(context);

        if(widget.product!=null){
          Navigator.pop(context);
          Navigator.pop(context);
        }
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


  List<Business> businessList=[];
  void getBusinessMethod() async {
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
        setState(() {
          isLoading=false;
        });
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

    }

    setState(() {
      isLoading = false;
    });
  }

  List<Category> categoryList=[];

  void getCategoryMethod() async {
    String url = baseUrl + '/category/';
    if (mounted)
      setState(() {
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
      setState(() {
        isLoading=false;
      });
      } else {
        myData = res[0]["message"];
        print("MyData");
        log(json.encode(myData));
        setState(() {
          categoryList= categoryFromJson(json.encode(myData));
          category= categoryList[0].id.toString();
          isLoading=false;
        });
        log(categoryList[0].name);
        getSubCategoryMethod(category);


      }
    }
    catch( e){
      print("CATCH");
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }
bool   isLoadingSubCategory = false;

  String subCategory="";
  List<SubCategory> subCategoryList=[];
  void getSubCategoryMethod(categoryId) async {
    // String url = baseUrl + '/subcategory/get/$categoryId';
    String url = baseUrl + '/sub_category/?category_id=$categoryId';

    if (mounted)
      setState(() {
        // categoryList.clear();
        isLoadingSubCategory = true;
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
        setState(() {
          isLoadingSubCategory=false;
        });
      } else {
        myData = res[0]["message"];
        print("MyData2");
        log(json.encode(myData));
        setState(() {

          subCategoryList= subCategoryFromJson(json.encode(myData));
          subCategory= subCategoryList[0].id.toString();
          isLoadingSubCategory=false;
        });
        log(subCategoryList[0].name);



      }
    }
    catch( e){
      print("CATCH");
      print(e.toString());
      setState(() {
        isLoadingSubCategory = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

}
