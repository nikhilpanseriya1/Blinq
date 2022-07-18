import 'package:blinq/App/Home/scan_qr_screen.dart';
import 'package:blinq/Utility/constants.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  TextEditingController searchController = TextEditingController();

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

                  // if (kHomeController.mainUserData['contacts'].isNotEmpty) {
                  //   kHomeController.userContacts.clear();
                  //   kHomeController.mainUserData['contacts'].forEach((element) {
                  //     kHomeController.userContacts.add(element);
                  //     kHomeController.userContacts.refresh();
                  //   });
                  //   showLog('~~~~~~~ ${kHomeController.userContacts}');
                  // }

                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                height: 55,
                                width: 55,
                                fit: BoxFit.cover,
                                imageUrl: userData['profile_pic'],
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
                            title: Text(userData['first_name'] + ' ' + userData['last_name']),
                            subtitle: Text(userData['job_title'] + ' - ' + userData['company_name']),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.more_vert),
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
