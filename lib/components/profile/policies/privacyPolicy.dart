import 'package:flutter/material.dart';
import '../../BackArrow.dart';
import '../../../config/globals.dart' as globals;

class PrivacyPolicy extends StatelessWidget {
  Widget singleBlock({@required String title, @required String content}) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: globals.buildTextStyle(14.5, true, globals.textColor),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          content,
          style: globals.buildTextStyle(14.0, false, globals.textColor),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Privacy Policy',
            style: globals.buildTextStyle(16.0, true, globals.textColor),
          ),
          centerTitle: true,
          leading: BackArrow(),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
              child: Column(children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                singleBlock(
                    title: '1.	Policy statement',
                    content:
                        'Park254 is committed to protecting the privacy of the personal  information which it collects and holds \n\nPark254 must comply with the Kenya Privacy Principles under the Data Protection Act 2019 (DPA), and other privacy laws which govern the way in which organizations such as Park254 hold, use and disclose personal information. \n\nThe purpose of this Privacy Policy is to explain: \n\nThe kinds of information that Park254 may collect about you and how that information is held; \n\nHow Park254 collects and holds personal information; \n\nThe purposes for which Park254 collects, holds, uses and discloses personal information; \n\nHow you can access the personal information Park254 holds about you and seek to correct such information; and \n\nThe way in which you can complain about a breach of your privacy and how Park254 will handle that complaint. \n\nTerms used in this Privacy Policy are defined in Clause 9.'),
                singleBlock(
                    title: '2.	Collection and use of personal information',
                    content:
                        '2.1 Types of personal information collected by Park254 \n\n(a)	Customers \n\nPark254 collects information from you which is necessary to provide you with our products and services. This includes collecting personal information such as your name, address, telephone number, email address, bank account details and any other information which may be necessary to enable us to effectively and efficiently provide our products and services to you. \n\n(b)	Contractors and service providers \n\nPark254 collects information from you which is necessary to properly manage and operate our business. This includes collecting personal information such as your name, address, telephone number, email address, bank account details and any other information which we consider reasonably necessary in connection with our engagement of you or our ongoing relationship with you. \n\n© Job applicants and employees \n\nPark254 collects information from you which is necessary to properly manage and operate our business. This includes collecting personal information such as your name, address, telephone number, email address, bank account details and any other information which we consider reasonably necessary in determining the merits of your application or for the purposes of managing your ongoing employment with us. \n\n2.2 How we collect personal information \n\nWe will usually collect your personal information directly from you, however sometimes we may need to collect information about you from third parties, such as: \n\nOther service providers; \n\nSources of publicly available information, such as databases lawfully maintained by government departments or private companies; \n\nOur related entities. \n\nWe will only collect information from third parties where: \n\nYou have consented to such collection; \n\nSuch collection is necessary to enable us to provide you with our products or services; \n\nSuch collection is reasonably necessary to enable us to appropriately manage and conduct our business; or \n\nIn other circumstances where it is legally permissible for us to do. \n\nPark254 will only collect information which is necessary to provide you with our products and services or appropriately manage and conduct our business. \n\n2.3 How Park254 uses your personal information \n\nPark254 only uses your personal information for the purpose for which it was collected by Park254 (primary purpose), unless: \n\nThere is another purpose (secondary purpose) and that secondary purpose is directly related to the primary purpose, and you would reasonably expect, or Park254 has informed you, that your information will be used for that secondary purpose; \n\nYou have given your consent for your personal information to be used for a secondary purpose; or \n\nPark254 is required or authorized by law to use your personal information for a secondary purpose (including for research and quality improvements within Park254). \n\nFor example, Park254 may use your personal information to: \n\nVerify your identity; \n\nEnable speedy contact with your next of kin, should the need arise in an emergency; \n\nGain an understanding of your needs in order for us to provide you with better products and services; \n\nProvide you with the products and services you require; \n\nAdminister and manage our services, including charging, billing and collecting debts; \n\nInform you of ways the products and services provided to you could be improved; \n\nAppropriately manage our business, such as assessing insurance requirements and conducting audits; \n\nAssist us in running our business, including quality assurance programs, improving our services, implementing appropriate security measures and training personnel; and \n\nEffectively communicate with third parties. \n\n2.4 Complete and accurate details \n\nWhere possible and practicable, you will have the option to deal with Park254 on an anonymous basis or by using a pseudonym. However, if the personal information you provide us is incomplete or inaccurate, or you withhold personal information, we may not be able to provide the products and services or support you are seeking, or deal with you effectively. \n\n2.5 CCTV \n\nPark254 uses camera surveillance systems (commonly referred to as CCTV) on its premises for the purposes of maintaining safety and security of its customers, personnel, visitors and other attendees. Those CCTV systems may also collect and store personal information and Park254 will comply with all privacy legislation in respect of any such information.'),
                singleBlock(
                    title: '3.	Disclosure of  your personal information',
                    content:
                        'Park254 will confine its disclosure of your personal information to the primary purpose for which that information has been collected, or for a related secondary purpose. This includes when disclosure is necessary to provide products or services to you, assist us in running our organisation, or for security reasons. \n\nWe may provide your personal information to: \n\nYour authorised representatives or your legal advisers; \n\nCredit-reporting and fraud-checking agencies; \n\nCredit providers (for credit related purposes such as credit-worthiness, credit rating, credit provision and financing); \n\nOur professional advisers, including our accountants, auditors and lawyers; \n\nGovernment and regulatory authorities and other organisations, as required or authorised by law; \n\nThird parties involved in the provision of products and services to you, such as our suppliers and contractors; \n\nAny of Park254’s related entities; \n\nTo our insurers in connection with any insurance claim or potential insurance claim; \n\nTo travel agencies, airlines, hotels, accommodation providers and other similar service providers in connection with any travel arrangements relating to your employment (if applicable); \n\nAnyone authorised by you to receive your personal information (your consent may be express or implied); or \n\nAnyone to whom Park254 is required by law to disclose your personal information.'),
                singleBlock(
                    title: '4.	Data storage, quality and security',
                    content:
                        '4.1 Data quality \n\nPark254 will take reasonable steps to ensure that your personal information which is collected, used or disclosed is accurate, complete and up to date. \n\n4.2 Storage \n\nAll your personal information is stored by Park254 securely in either hard copy or electronic form. \n\n4.3 Data security \n\nPark254 strives to ensure the security, integrity and privacy of personal information, and will take reasonable steps to protect your personal information from misuse, interference, loss, unauthorised access, modification or disclosure. Park254 reviews and updates (where necessary) its security measures in light of current technologies. \n\nPark254 follows all PCI-DSS requirements and implement additional generally accepted industry standards \n\nSystem scan, penetration testing as well as annual onsite PCI audits are performed by independent Qualified Security Assessor (QSA) certified by the PCI Security Standards Council to assess compliance with PCI DSS \n\nA copy of our PCI certificate is available upon request \n\n4.4 Storage location \n\nYour personal information may be stored by Park254 or third parties to whom we are permitted to disclose your personal information in accordance with this Data Protection Act in Kenya. We take steps to ensure that our service providers are obliged to protect the privacy and security of your personal information and use it only for the purpose for which it is disclosed. \n\n4.5 Online transfer of information \n\nWhile Park254 does all it can to protect the privacy of your personal information, no data transfer over the internet is 100% secure. When you share your personal information with Park254 via an online process, it is at your own risk. \n\nThere are ways you can help maintain the privacy of your personal information, including: \n\nAlways closing your browser when you have finished your user session; \n\nAlways ensuring others cannot access your personal information and emails if you use a public computer; and \n\nNever disclosing your user name and password to third parties.'),
                singleBlock(
                    title: '5.	Use of cookies',
                    content:
                        'A ‘cookie’ is a small data file placed on your machine or device which lets Park254 identify and interact more effectively with your computer. Cookies do not identify individual users, but they do identify your ISP and browser type. \n\nCookies which are industry standard and are used by most web sites, including those operated by Park254, can facilitate a user’s ongoing access to and use of a site. They allow Park254 to customize our website to the needs of our users. If you do not want information collected through the use of cookies, there is a simple procedure in most browsers that allows you to deny or accept the cookie feature. However, cookies may be necessary to provide you with some features of our on- line services via the Park254 website.'),
                singleBlock(
                    title: '6.	Links to other sites',
                    content:
                        'Park254 may provide links to third party websites. These linked sites may not be under our control and Park254 is not responsible for the content or privacy practices employed by those websites. \n\nBefore disclosing your personal information on any other website, you should carefully read the terms and conditions of use and privacy statement of the relevant website.'),
                singleBlock(
                    title:
                        '7.	Accessing and amending your personal information',
                    content:
                        'You have a right to access your personal information which Park254 holds about you. \n\nIf you make a request to access your personal information, we will ask you to verify your identity and specify the information you require. \n\nYou can also request an amendment to any of your personal information if you consider that it contains inaccurate information. \n\nYou can contact Park254 about any privacy issues as follows:  \n\nPrivacy Officer \n\n0729558499 \n\nBOGANI EAST ROAD, \n\nKAREN, \n\nNAIROBI, KENYA \n\nWhile Park254 aims to meet all requests to access and amendments to personal information, there may be some instances where Park254 is unable to do this where it may adversely affect your health and safety or the safety of others.'),
                singleBlock(
                    title: '8.	Complaints',
                    content:
                        'If you have a complaint about Park254’s information handling practices or consider we have breached your privacy, you can lodge a complaint with us. Park254 deals with all complaints in a fair and efficient manner.'),
                singleBlock(
                    title: '9.	Definitions',
                    content:
                        'In this Privacy Policy the following terms have the following meanings:  \n\nPersonal information means information or an opinion about an identified individual, or an individual who is reasonably identifiable: \n\nWhether the information or opinion is true or not; and \n\nWhether the information or opinion is recorded in a material form or not; \n\nRelated entities has the meaning given to that term under the Companies Act 2015. \n\nPark254 means Park254 Limited and its related entities from time to time'),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
