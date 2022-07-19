import 'package:blinq/App/Home/scan_qr_screen.dart';
import 'package:blinq/Utility/constants.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

class _ContactScreenState extends State<ContactScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    showLog('Call Contact Screen......');
  }

  @override
  Widget build(BuildContext context) {
    return commonStructure(
        context: context,
        appBar: commonAppBar(leadingIcon: SizedBox(), title: 'Contacts', actionWidgets: [
          IconButton(
              onPressed: () {},
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
                textEditingController: searchController,
                preFixWidget: Icon(Icons.search),
                outlineInputBorder: textFieldBorderStyle,
                filledColor: colorGrey.withOpacity(0.05)),
            StreamBuilder(
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
                      kHomeController.userContacts.refresh();
                      showLog('~~~~~~~-- ${kHomeController.userContacts}');
                      kHomeController.getContacts = false;
                    }
                  }

                  return Expanded(
                    child: ListView.builder(
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
                              if (kHomeController.userContacts[index]['id'] != null &&
                                  kHomeController.userContacts[index]['id'].toString().isNotEmpty) {
                                Get.to(
                                    () => ViewContactScreen(contactCardId: kHomeController.userContacts[index]['id']));
                              }
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
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
                              title: Text(kHomeController.userContacts[index]['first_name'] +
                                  ' ' +
                                  kHomeController.userContacts[index]['last_name']),
                              subtitle: Text(kHomeController.userContacts[index]['job_title'] +
                                  ' - ' +
                                  kHomeController.userContacts[index]['company_name']),
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
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
        floatingButton: FloatingActionButton.extended(
          backgroundColor: colorPrimary,
          onPressed: () {
            Get.to(() => ScanQrScreen());
          },
          label: Text(
            'Add',
            style: FontStyleUtility.blackInter16W500.copyWith(color: colorWhite),
          ),
          icon: const Icon(Icons.qr_code_scanner),
        ));
  }
}
