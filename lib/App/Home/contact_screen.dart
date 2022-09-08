import 'package:blinq/App/Home/scan_qr_screen.dart';
import 'package:blinq/Utility/constants.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'home_screen.dart';
import 'view_contact_screen.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}

class _ContactScreenState extends State<ContactScreen> {
  TextEditingController searchController = TextEditingController();
  RxBool searching = false.obs;
  RxList<Map<String, dynamic>> searchedUserContacts = <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    showLog('Call Contact Screen......');
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding, top: Constants.avatarRadius + Constants.padding, right: Constants.padding, bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration:
              BoxDecoration(shape: BoxShape.rectangle, color: Colors.white, borderRadius: BorderRadius.circular(Constants.padding), boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), offset: Offset(0, 5), blurRadius: 10),
          ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                appName,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'When you share your $appName card with people, they\'ll be able to send you their details, which will appear here!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Got it!',
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  "assets/icons/app_icon.jpg",
                  fit: BoxFit.cover,
                  height: 90,
                  width: 90,
                )),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return commonStructure(
        context: context,
        appBar: commonAppBar(
            leadingIcon:
                SizedBox() /*IconButton(
              icon: Icon(
                Icons.menu,
                color: colorPrimary,
              ),
              onPressed: () {
                kHomeController.openDrawer.currentState!.openDrawer();
              },
            )*/
            ,
            title: 'Contacts',
            actionWidgets: [
              IconButton(
                  onPressed: () {
                    disableFocusScopeNode(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Constants.padding),
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: contentBox(context),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.error_outline,
                    color: colorPrimary,
                    size: 22,
                  )),
            ]),
        child: Column(
          children: [
            commonTextField(
                hintText: 'Search',
                onChangedFunction: (value) {
                  if (value == null || value.toString().isEmpty) {
                    searching.value = false;
                  } else {
                    searching.value = true;
                  }
                  searchContacts(val: value);
                },
                onFieldSubmit: () {
                  disableFocusScopeNode(context);
                },
                onEditingComplete: (){
                  disableFocusScopeNode(context);
                },
                textEditingController: searchController,
                preFixWidget: Icon(Icons.search),
                outlineInputBorder: textFieldBorderStyle,
                filledColor: colorGrey.withOpacity(0.05)),
            Expanded(
              child: StreamBuilder(
                  stream: kHomeController.userRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: (Text('Loading...')));
                    }

                    // userData = snapshot.requireData;
                    kHomeController.mainUserData = snapshot.requireData;
                    if (kHomeController.getContacts) {
                      if (kHomeController.mainUserData['contacts'].isNotEmpty) {
                        kHomeController.userContacts.clear();
                        kHomeController.mainUserData['contacts'].forEach((element) {
                          kHomeController.userContacts.add({
                            'id': element['id'],
                            'profile_pic': element['profile_pic'],
                            'first_name': element['first_name'],
                            'last_name': element['last_name'],
                            'job_title': element['job_title'],
                            'company_name': element['company_name']
                          });
                        });
                        // List<Map<String, dynamic>> tempArray = kHomeController.userContacts.reversed.toList();
                        // kHomeController.userContacts.value = tempArray;
                        kHomeController.userContacts.refresh();
                        showLog('~~~~~~~-- ${kHomeController.userContacts}');
                        kHomeController.getContacts = false;
                      }
                    }

                    return kHomeController.mainUserData['contacts'].isNotEmpty
                        ? searching.value
                            ? searchContactListView()
                            : contactListView()
                        : Center(
                            child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'No contacts found..!, Please scan $appName QR code to add your contacts.',
                              textAlign: TextAlign.center,
                              style: FontStyleUtility.blackInter16W500.copyWith(height: 1.5),
                            ),
                          ));
                  }),
            ),
          ],
        ),
        floatingButton: FloatingActionButton.extended(
          backgroundColor: colorPrimary,
          onPressed: () {
            disableFocusScopeNode(context);
            Get.to(() => ScanQrScreen());
          },
          label: Text(
            'Add',
            style: FontStyleUtility.blackInter16W500.copyWith(color: colorWhite),
          ),
          icon: const Icon(Icons.qr_code_scanner),
        ));
  }

  void deleteContact(int index) {
    if (kHomeController.mainUserData['contacts'].isNotEmpty) {
      kHomeController.userContacts.clear();
      kHomeController.mainUserData['contacts'].forEach((element) {
        kHomeController.userContacts.add({
          'id': element['id'],
          'profile_pic': element['profile_pic'],
          'first_name': element['first_name'],
          'last_name': element['last_name'],
          'job_title': element['job_title'],
          'company_name': element['company_name']
        });
      });
      kHomeController.getContacts = true;
    }

    kHomeController.userContacts.remove(kHomeController.userContacts[index]);
    showLog('~~~~~~~-- ${kHomeController.userContacts}');
    kHomeController.userContacts.refresh();

    kHomeController.userRef.update({'contacts': kHomeController.userContacts}).whenComplete(() async {
      showLog('Delete successfully...');
    });
  }

  void searchContacts({required String val}) {
    var suggestions = kHomeController.mainUserData['contacts'].where((data) {
      final title = data['first_name'].toString().toLowerCase() + data['last_name'].toString().toLowerCase();
      final input = val.toLowerCase();
      return title.contains(input);
    }).toList();

    searchedUserContacts.clear();
    suggestions.forEach((element) {
      searchedUserContacts.add(element);
    });

    // searchedUserContacts = suggestions;
    setState(() {
      searchedUserContacts.refresh();
    });
    print('====>> ${searchedUserContacts}');
  }

  Widget contactListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: kHomeController.userContacts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: InkWell(
            highlightColor: colorWhite,
            splashColor: colorWhite,
            onTap: () {
              if (kHomeController.userContacts[index]['id'] != null && kHomeController.userContacts[index]['id'].toString().isNotEmpty) {
                disableFocusScopeNode(context);
                Get.to(() => ViewContactScreen(contactCardId: kHomeController.userContacts[index]['id']));
              }
            },
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: kHomeController.userContacts[index]['profile_pic'] == null ||
                        kHomeController.userContacts[index]['profile_pic'].toString().isEmpty
                    ? Image(
                        image: profilePlaceholder,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        height: 55,
                        width: 55,
                        fit: BoxFit.cover,
                        imageUrl: kHomeController.userContacts[index]['profile_pic'],
                        placeholder: (context, url) => Image(
                          image: profilePlaceholder,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image(
                          image: profilePlaceholder,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              title: Text(kHomeController.userContacts[index]['first_name'] + ' ' + kHomeController.userContacts[index]['last_name']),
              subtitle: Text(kHomeController.userContacts[index]['job_title'] + ' - ' + kHomeController.userContacts[index]['company_name']),
              trailing: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.remove_red_eye),
                          10.widthBox,
                          Text(
                            'View card',
                            style: FontStyleUtility.blackInter14W400,
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          10.widthBox,
                          Text(
                            'Delete contact',
                            style: FontStyleUtility.blackInter14W400,
                          )
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 1) {
                    if (kHomeController.userContacts[index]['id'] != null && kHomeController.userContacts[index]['id'].toString().isNotEmpty) {
                      Get.to(() => ViewContactScreen(contactCardId: kHomeController.userContacts[index]['id']));
                    }
                  } else if (value == 2) {
                    showAlertDialog(
                        title: 'Delete contact?',
                        msg: 'Are you sure you want to delete this contact?, after delete this contact you can\'t access this contacts details!',
                        context: context,
                        callback: () {
                          deleteContact(index);
                        });
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget searchContactListView() {
    return GestureDetector(
      onTap: () {
        disableFocusScopeNode(context);
      },
      child: searchedUserContacts.isEmpty
          ? Center(
              child: Text(
                'No contact found!',
                style: FontStyleUtility.blackInter16W500,
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: searchedUserContacts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    highlightColor: colorWhite,
                    splashColor: colorWhite,
                    onTap: () {
                      if (searchedUserContacts[index]['id'] != null && searchedUserContacts[index]['id'].toString().isNotEmpty) {
                        disableFocusScopeNode(context);
                        Get.to(() => ViewContactScreen(contactCardId: searchedUserContacts[index]['id']));
                      }
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: searchedUserContacts[index]['profile_pic'] == null || searchedUserContacts[index]['profile_pic'].toString().isEmpty
                            ? Image(
                                image: profilePlaceholder,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                height: 55,
                                width: 55,
                                fit: BoxFit.cover,
                                imageUrl: searchedUserContacts[index]['profile_pic'],
                                placeholder: (context, url) => Image(
                                  image: profilePlaceholder,
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) => Image(
                                  image: profilePlaceholder,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      title: Text(searchedUserContacts[index]['first_name'] + ' ' + searchedUserContacts[index]['last_name']),
                      subtitle: Text(searchedUserContacts[index]['job_title'] + ' - ' + searchedUserContacts[index]['company_name']),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.remove_red_eye),
                                  10.widthBox,
                                  Text(
                                    'View card',
                                    style: FontStyleUtility.blackInter14W400,
                                  )
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  10.widthBox,
                                  Text(
                                    'Delete contact',
                                    style: FontStyleUtility.blackInter14W400,
                                  )
                                ],
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          if (value == 1) {
                            if (searchedUserContacts[index]['id'] != null && searchedUserContacts[index]['id'].toString().isNotEmpty) {
                              Get.to(() => ViewContactScreen(contactCardId: searchedUserContacts[index]['id']));
                            }
                          } else if (value == 2) {
                            showAlertDialog(
                                title: 'Delete contact?',
                                msg:
                                    'Are you sure you want to delete this contact?, after delete this contact you can\'t access this contacts details!',
                                context: context,
                                callback: () {
                                  deleteContact(index);
                                });
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
