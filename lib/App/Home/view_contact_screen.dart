import 'package:blinq/App/Home/edit_screen.dart';
import 'package:blinq/App/Home/your_card_screen.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class ViewContactScreen extends StatefulWidget {
  String contactCardId;

  ViewContactScreen({Key? key, required this.contactCardId}) : super(key: key);

  @override
  State<ViewContactScreen> createState() => _ViewContactScreenState();
}

class _ViewContactScreenState extends State<ViewContactScreen> {
  var contactCardDetails;

  RxBool isDocExist = false.obs;
  String loadingMsg = 'Loading...';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkIfDocExists(widget.contactCardId);
  }

  /// Check If Document Exists
  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');
      var doc = await collectionRef.doc(docId).get();

      isDocExist.value = doc.exists;

      if (!isDocExist.value) {
        loadingMsg = 'This card has been deleted by creator..!';
      }
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => commonStructure(
        context: context,
        appBar: commonAppBar(),
        child: isDocExist.value
            ? StreamBuilder<Object>(
                stream: FirebaseFirestore.instance.collection('users').doc(widget.contactCardId).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong, Please try again later...'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: (Text('Loading...')));
                  }
                  contactCardDetails = snapshot.requireData;
                  return SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.heightBox,
                        SizedBox(
                          height: getScreenHeight(context) * 0.30,
                          child: Stack(
                            children: [
                              Container(
                                height: getScreenHeight(context) * 0.25,
                                width: getScreenWidth(context),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), boxShadow: [
                                  BoxShadow(
                                      color: colorGrey.withOpacity(0.5), offset: const Offset(0.0, 3.0), blurRadius: 10)
                                ]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: contactCardDetails['profile_pic'] == null ||
                                          contactCardDetails['profile_pic'].toString().isEmpty
                                      ? Container(
                                          height: 55,
                                          width: 55,
                                          color: colorRed,
                                        )
                                      : CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: contactCardDetails['company_logo'],
                                          placeholder: (context, url) => Image(
                                            image: bgPlaceholder,
                                            fit: BoxFit.cover,
                                          ),
                                          errorWidget: (context, url, error) => Image(
                                            image: bgPlaceholder,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), boxShadow: const [
                                    BoxShadow(color: colorGrey, offset: Offset(0.0, 3.0), blurRadius: 10)
                                  ]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: contactCardDetails['profile_pic'] == null ||
                                            contactCardDetails['profile_pic'].toString().isEmpty
                                        ? Image(
                                            image: profilePlaceholder,
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                            imageUrl: contactCardDetails['profile_pic'],
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
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.heightBox,
                        Text(
                          '${contactCardDetails['first_name']} ${contactCardDetails['last_name']}',
                          style: FontStyleUtility.blackInter16W600.copyWith(fontSize: 24),
                        ),
                        10.heightBox,
                        Text(contactCardDetails['job_title'], style: FontStyleUtility.blackInter16W500),
                        10.heightBox,
                        Text(contactCardDetails['department'], style: FontStyleUtility.blackInter16W500),
                        10.heightBox,
                        Text(contactCardDetails['company_name'], style: FontStyleUtility.blackInter16W500),
                        contactCardDetails['headline'].isNotEmpty
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(contactCardDetails['headline'], style: FontStyleUtility.greyInter16W400))
                            : SizedBox.shrink(),
                        10.heightBox,
                        Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: contactCardDetails['fields'].length ?? 0,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async {
                                String type = getFieldType(fileTitle: contactCardDetails['fields'][index]['title']);

                                if (type == typeEmail) {
                                  openMail(emailAddress: contactCardDetails['fields'][index]['data']);
                                } else if (type == typePhone) {
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: contactCardDetails['fields'][index]['data'],
                                  );
                                  await launchUrl(launchUri);
                                } else if (type == typeLink) {
                                  const url = "https://flutter.io";
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  } else {
                                    // can't launch url, there is some error
                                    throw "Could not launch $url";
                                  }
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                height: 50,
                                width: 50,
                                padding: EdgeInsets.all(12),
                                decoration:
                                    BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(100)),
                                child: Image(
                                  image:
                                      getImage(index: index, fieldName: contactCardDetails['fields'][index]['title']),
                                  color: colorWhite,
                                ),
                              ),
                              title: Text(
                                contactCardDetails['fields'][index]['data'],
                                style: FontStyleUtility.blackInter16W500,
                              ),
                              subtitle: Text(
                                contactCardDetails['fields'][index]['label'],
                                style: FontStyleUtility.greyInter14W400,
                              ),
                            );
                          },
                        ),
                        50.heightBox,
                      ],
                    ),
                  );
                })
            : Container(
                child: Center(
                  child: Text(
                    loadingMsg,
                  ),
                ),
              ),
      ),
    );
  }
}
