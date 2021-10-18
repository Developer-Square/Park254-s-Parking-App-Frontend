import 'package:flutter/material.dart';
import '../../BackArrow.dart';
import '../../../config/globals.dart' as globals;

class TermsAndConditions extends StatelessWidget {
  Widget singleBlock({@required String title, @required String content}) {
    return Column(
      children: [
        Text(
          title,
          style: globals.buildTextStyle(14.5, true, globals.textColor),
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
            'Terms And Conditions',
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
                Text(
                  'Terms & Conditions – For use of the ‘Park254’ App',
                  style: globals.buildTextStyle(14.0, false, globals.textColor),
                ),
                SizedBox(
                  height: 10.0,
                ),
                singleBlock(
                    title: '1.  Introduction',
                    content:
                        'In this document, ‘we’, ‘our’ and ‘us’ means Park254 Ltd (PVT-LRUEMVA) or any of its related bodies corporate (as that term is defined in the Companies Act 2015 ) and ‘you’ means any person who uses the Park254 application. In this agreement “Services” means the provision of the Park254 application and the services we provide to our customers using the Park254 application. This agreement outlines the terms and conditions that apply to your use of the Services. You must also comply with our Privacy Policy and our Acceptable Use Policy as referred to in this agreement.'),
                singleBlock(
                    title: '2.	Term of Agreement',
                    content:
                        'This agreement commences on the date you start using the Services and continues for such time as you continue to use the Services, provided that any provisions of this agreement intended to survive termination or expiry of this agreement will do so.'),
                singleBlock(
                    title: '3.	Service Availability',
                    content:
                        'We will use due care and skill in providing the Services in accordance with this agreement. We do not purport to exclude any statutory guarantees, conditions or warranties imposed by consumer- protection laws that apply to Services we supply. However we cannot promise that our Services will be continuous or fault-free. \n\nWe will attempt to perform all scheduled maintenance at times which will affect the fewest customers. If scheduled maintenance requires the Service to be offline for more than 30 minutes we will post details of the scheduled maintenance at least 24 hours in advance of the maintenance. If we need to perform unscheduled maintenance that requires the Service to be offline for more than 30 minutes, we will post details of the event after the maintenance has been completed. \n\nOur liability to you is governed by clause 6 of this agreement.'),
                singleBlock(
                    title: '4.	Passwords and content',
                    content:
                        'You will keep any passwords or log-in details used in connection with the Service secure and you are totally responsible for when and how your account with us is used and the actions of any people you give your password and log-in details to.\n\nYou are solely responsible for your data and any content you use or store in connection with your Service.\n\nYou grant us a license to use and reproduce all your data and content in order to fulfil our obligations under this agreement.\n\nYou must ensure that you comply with our Acceptable Use Policy terms in clause 19 in relation to any data or content you use or store in connection with your Service.\n\nYou agree that if, in our sole discretion, you are using the Services in a way which is not legitimate, is not in compliance with this agreement or any law that we may suspend, disable, limit or terminate the Services or deny you access to the Service without notice.'),
                singleBlock(
                    title:
                        '5.	Customer’s Warranties, Liabilities and Undertakings',
                    content:
                        'You indemnify us against, and must pay us for, any loss or damage we suffer relating to: \n\nThe provision of the Service to you; and  Your use, or attempted use, of the Service. \n\nYou indemnify us against (and must pay us for) any costs, including legal costs, relating to your breach of this agreement. However you are not liable to us for any loss to the extent it is caused by us (for example, through our breach of this agreement or our negligence). \n\nAt the time of entering into this agreement you are not relying on any representation made by us which has not been stated expressly in this agreement, or on any descriptions or specifications contained in any other document, including any catalogues, web site or publicity material which we have produced.'),
                singleBlock(
                    title: '6.	Our Warranties and Liabilities',
                    content:
                        'We accept liability for the supply of the Services to the extent provided in this agreement. \n\nWe do not warrant that the Services: \n\nWill be uninterrupted or error free; \n\nWill meet your requirements, other than as expressly set out in this agreement; \n\nWill be free from external intruders (hackers), virus or worm attack, denial of service attack, or other persons having unauthorized access to the Services or systems of ours. \n\nSubject to clause 6.4: \n\nWe exclude all liability for indirect, incidental, special and consequential loss or damage of any kind, loss or corruption of data, loss of use, loss of revenue, loss of profits, failure to realise expected profits or savings and any other commercial or economic loss of any kind, in contract, tort (including negligence), under any statute or otherwise arising from or relating in any way to this agreement and/or its subject matter; \n\nThe Services are provided on an ‘as is’ and ‘as available’ basis; \n\nWe make or give no express or implied warranties including, without limitation, the warranties of merchantability or fitness for a particular purpose, or arising from a course of dealing, usage or trade practice, with respect to any goods or services provided under or incidental to this agreement; \n\nNo oral or written information or advice given by us, our resellers, agents, representatives or employees shall create a warranty or in any way increase the scope of the express warranties hereby given, and you may not rely on any such information or advice; \n\nOur total aggregate liability to you for any claim in contract, tort, negligence or otherwise arising out of or in connection with the provision of the Services will be limited to the charges paid by you in the 12 months preceding the claim in respect of the Services which are the subject of any such claim. Any claim must be notified to us within 1 month of it arising. \n\nIn the event that this agreement constitutes a supply of goods or services to a consumer as defined in the Competition Act 2016 (CA) nothing contained in this agreement excludes, restricts or modifies any remedies or guarantees where to do so is unlawful. To the full extent permitted by law, where the benefit of any such remedy or guarantee is conferred upon you pursuant to the CA our sole liability for breach of any such remedy or guarantee shall be limited to the remedies available under the CA.'),
                singleBlock(
                    title: '7.	 Suspension and Termination of the Service',
                    content:
                        'We may suspend or terminate your account if: \n\nYou breach this agreement and fail to rectify any remediable breach within 6 days of us notifying you to do so; \n\nYou become insolvent; \n\nYou are declared bankrupt; or \n\nWe are ordered to do so by a court or pursuant to an arbitration award. \n\nIn addition to any other rights we may have under this agreement, you agree that we may, without notice to you and without any liability to us, amend, alter or take down your data or content if we: \n\nReceive an order from a court or other competent body requiring us to do so; \n\nAre directed to do so by the Communications Authority of Kenya or any other regulatory body or authority or industry association; \n\nConsider in our sole discretion that you are breaching this agreement including without limitation, by infringing third party intellectual property rights, or because your data or content is defamatory, illegal, obscene or breaches a person’s privacy. \n\nFrom time to time we may have to suspend or disconnect the Service without notice or deny your access to the Service during any technical failure, modification or maintenance involved in the Service. We will use reasonable endeavors to procure the resumption of the Services as soon as reasonably practicable. In these circumstances you will remain liable for all charges due throughout the period of suspension. \n\nIf your account has been suspended or terminated due to your breach, reactivation of your account will be at our discretion. If we agree to reactivate your account, we will require payment in full of any outstanding amounts owing to us and we may charge a reactivation fee. \n\nIn the event this agreement constitutes a supply of goods or services to a consumer as defined in the Competition Act, and you cancel your Service because we have failed to meet one or more of the consumer guarantees under the Competition Act, we will refund to you any unused portion of your Service fee and any other amount you have prepaid, as well as any Service fee where the Services provided did not meet the consumer guarantees. \n\nYou may terminate your account or any individual Service with us for any reason at any time by contacting our Park254 Support Service by: \n\nTelephone on 0729558499/0726527543; and / or sending an email to park42963@gmail.com \n\nAny fees you have paid us prior to your termination of your account are non-refundable except as set out in clause 7.5 above. \n\nIf we wish to terminate your Service for reasons other than a breach of these conditions, we may do so by giving you 6 days written notice. In this circumstance, we will refund any remaining unused credit on your account. \n\nIf your account is closed for whatever reason you must pay all outstanding charges immediately.'),
                singleBlock(
                    title: '8.	Fees, Charges and Payments',
                    content:
                        'The Service facilitates the payment of fees to third parties such as car park operators. We are not responsible for and have no control over the services provided by those third parties or the fees they charge. We disclaim any liability for the services provided to you by third parties in connection with the Services to the maximum extent permitted by law. \n\nIf you fail to pay for the services provided by third parties such as car park operators in full on or before the due date, we may charge you a late fee (the greater of Ksh.500 or other amount agreed with you). \n\nWe will only provide the Services to you where you have paid for the services provided by third parties such as car park operators in full. Without prejudice to our other rights and remedies under this agreement, if any sum payable is not paid on or before the due date, we reserve the right, at our discretion, to suspend the provision of Services to you until we receive the required payment (including any late payment fees, interest, debt recovery charges and reactivation fees) in full. \n\n If you fail to make payment in accordance with the terms of this agreement, you will become liable for any reasonable costs incurred by us in recovering the debt (including any legal fees, collection agency charges or any other reasonable costs) and interest on the outstanding amount, calculated at the daily rate of 10% per annum, from the due date of the payment. \n\n Upon registration of a credit card account, you give us authorisation to debit your credit card for all charges. \n\nYou consent to us obtaining a report from a credit reporting agency on your credit worthiness if you choose to pay by credit card. \n\nIf we receive notice of a chargeback, declined or reversed payment from a credit card company in connection with payments made by you for the Services, we reserve the right to suspend the provision of Services to you until we receive the required payment (including any bank charges we incur, late payment fees, interest, debt recovery charges and reactivation fees) in full. \n\nThere is no extra charge / additional premium applied on top of the prices / fees charged by third parties (such as car park operators) to the user. For example, rates for car parking are at the rates as advertised / displayed or charged by the car park operator.'),
                singleBlock(
                    title: '9.	The use of Spam and Virus Filters',
                    content:
                        'We can use spam and virus filters and, to the maximum extent permitted by law, this may require us to use third party equipment or services to monitor and filter email traffic between our equipment and the Internet. To the maximum extent permitted by law, we will not be liable for any loss or damage resulting from the use of spam or virus filters.'),
                singleBlock(
                    title: '10.	Ownership of Equipment',
                    content:
                        'You obtain no rights to the hardware and other infrastructure and facilities used by us to deliver the Services. \n\nIf we supply you with any equipment as part of our provision of the Services to you, unless the law otherwise requires, we do so on the following terms: \n\nYou acknowledge that we are only acting as a reseller of the equipment which was manufactured by a third party; \n\nYou will not resell, export or otherwise transfer the equipment; \n\nWe are not obliged to keep the equipment current, up-to-date, in good working order or to alter or modify the equipment in any way;\n\nAny malfunction or manufacturer’s defect in the equipment must be remedied by you directly with the manufacturer and we are not liable for any such malfunction or defect or any consequences arising from them.'),
                singleBlock(
                    title: '11.	Intellectual Property',
                    content:
                        'All right, title and interest in any technology, techniques, software or trade mark that is used in, or provided by us, as part of the Services is owned by us or will vest in us on creation, or is licensed to us. You may use the technologies, techniques, software and trade marks as permitted by this agreement. We otherwise reserve all rights in relation to them.'),
                singleBlock(
                    title: '12.	Severability',
                    content:
                        'If any clause of these terms and conditions is held to be invalid or unenforceable in whole or in part, the invalid or unenforceable wording may be severed from this agreement and the remaining terms of this agreement continue in force.'),
                singleBlock(
                    title: '13.	Assignment',
                    content:
                        'You must not assign or otherwise transfer your rights or obligations under this agreement without our prior written consent, which may be withheld in our absolute discretion. \n\nWe may assign or otherwise novate or transfer our rights and obligations under this agreement to: \n\nA related body corporate, including without limitation as part of a change in how we provide the Services or as part of a partial or full restructuring of our business; and \n\nAnother person as part of the sale, or restructuring, of all or part of our business, and you agree that, if we do this, we may transfer all necessary information (including, without limitation, personal information and credit card details) to the related body corporate or other person, and they may use that information, in order for them to be able to continue providing the Services to you. If you do not agree to the assignment, novation or transfer, you may terminate this agreement and we will refund any remaining unused credit on your account.'),
                singleBlock(
                    title: '14.	Changes to Terms',
                    content:
                        'We may change the terms and conditions of this agreement (including our Acceptable Use Policy and Privacy Policy) at any time. Details of our current terms will always be available on our website. Changes to this agreement will become effective upon their publication on our website and your use of the Services following publication of any amended version of this agreement will constitute acceptance of the amended terms. If you do not wish to accept the amended terms and conditions, you may terminate this agreement by contacting our Park254 Support Service by:0729558499/0726527543; and / or sending an email to park42963@gmail.com'),
                singleBlock(
                    title: '15.	Entire Agreement',
                    content:
                        'These terms and conditions constitute the entire agreement between us and you. It supersedes all prior agreements, understandings and representations whether oral or written.'),
                singleBlock(
                    title: '16.	Governing Law',
                    content:
                        'These terms and conditions are governed by the laws in Kenya. Both parties agree to submit to the non-exclusive jurisdiction of the Courts of Republic of Kenya.'),
                singleBlock(
                    title: '17.	Notifications & Communications',
                    content:
                        'All notifications under this agreement will be by email to your nominated internet address or via in-app messaging. This includes critical service notifications, renewal, billing and account notifications, scheduled downtime notifications or any other communications deemed to be an essential part of our Service to you.'),
                singleBlock(
                    title: '18.	Privacy Policy',
                    content:
                        'We collect and use personal information in accordance with our privacy policy (available on our website at https://park254.com/privacy).'),
                singleBlock(
                    title: '19.	Acceptable Use Policy',
                    content:
                        'Our Acceptable Use Policy (set out in this clause 19) outlines what we deem to be unacceptable use of the Services. \n\nYou must comply with our Acceptable Use Policy whilst using our Services and you must ensure that any person who you allow to use our Services also complies with this Acceptable Use Policy. \n\nWe may change the terms and conditions of this Acceptable Use Policy at any time. Details of our current Acceptable Use Policy will always be available on our website. Changes to this Acceptable Use Policy will become effective upon their publication on our website and your use of the Services following publication of any amended version of this agreement will constitute \n\nAcceptance of the amended terms. If you do not wish to accept the amended terms and conditions, you may terminate this agreement by contacting our Park254 Support Service by: \n\nTelephone 0729558499/0726527543; and / or \n\nSending an email to park42963@gmail.com \n\nWe will take reasonable measures to ensure that the owners and operators of our Services will comply with this Acceptable Use Policy. \n\nWe reserve the right to monitor your compliance by any lawful means and to take action if we (in our sole discretion) deem it necessary. We will also investigate and, if appropriate, act on any complaint from a complainant. We will cooperate fully with law enforcement agencies if required by law. \n\nYou must comply with all applicable Commonwealth, State and Territory laws. You must not act or fail to act in a way that would place us in breach of any applicable law, including those that regulate the provision of internet and telecommunications-related services. \n\nWe impose additional restrictions on the use of our Services to ensure that our Services operate fairly for all customers and to safeguard our name, goodwill and reputation. \n\nYou must not use our Services, attempt to use a Service, or allow a Service to be used in any way that: \n\nResults in the customer or us breaching, or being involved in a breach of law, order, code, instrument or regulation; \n\nStores, sends or distributes any content or material which is restricted, prohibited, or is otherwise unlawful under any applicable Commonwealth, State or Territory law; \n\nIs obscene, defamatory, offensive, abusive, sends, displays, accesses, makes available, publishes, or distributes or otherwise is involved in making material available that a reasonable person would consider obscene, defamatory, threatening, abusive, inciting of violence or hatred, or offensive; \n\nViolates a person’s privacy; \n\nInfringes on any person’s rights (including intellectual property rights and moral rights);\ /\n\nConstitutes a misuse of any person’s confidential information; or \n\nResults in a breach by a customer of any obligation that the customer owes to any person; \n\nManipulates or bypasses our usage limits; \n\nImpedes or interferes with our ability to provide our Services; \n\nDamages our commercial well being, reputation or brand; \n\nWould result in an excessive load being generated on our servers, network, or other resources; and would create any undue burden on other our customers or the Service in general. \n\nExceptions and exclusions may be granted at our discretion. \n\nTo the extent permitted by law, we reserve the right to decide whether any action or omission constitutes unacceptable use and our decision will be final. \n\nYou agree to use your best endeavors to secure any device or network within your control against being used in breach of this Acceptable Use Policy by third parties, including where appropriate by: \n\nThe installation and maintenance of up-to-date antivirus software; \n\nThe installation and maintenance of firewall software; and \n\nThe application of operating system and application software patches and updates. \n\nYou agree that you will cooperate and comply with any corrective or preventative action that we deem necessary to ensure compliance with our Acceptable Use Policy. \n\nAt our absolute discretion, we reserve the right to suspend or terminate your access to any or all Services if we form the view that you have has breached this Acceptable Use Policy. \n\nOur right to suspend or terminate your account applies regardless of whether the breach is committed intentionally, through misconfiguration, or by any other means. \n\nWe will generally operate on the basis that an allegation of unacceptable use against a customer is not proven until we assess the facts or a law enforcement agency or other relevant government authority requires us to act immediately. Nevertheless, we reserve the right to suspend or terminate a customer’s account without notice to that customer if the circumstances dictate (in our sole discretion) that immediate action is required. \n\nWe may comply or cooperate with law enforcement and security agencies through any means we consider lawful, including in relation to court orders for the interception or monitoring of our Services. \n\nTo the maximum extent permitted by law, we will not be liable for any loss a customer may suffer or incur if we suspend or terminate a customer account under the terms of this Acceptable Use Policy where: \n\nA customer has breached the terms of this Acceptable Use Policy; \n\nWe are required to do so by law; \n\nWe are directed to do so by the police or any governmental authority; \n\nWe are entitled to suspend or terminate the customer account in accordance with our terms and conditions or Acceptable Use Policy; or \n\nWe acted reasonably in the circumstances. \n\nEach customer agrees to indemnify us against any claim a complainant might make for any loss or damages the complainant incurs as a result of a breach of this Acceptable Use Policy by that customer. \n\nEach complainant agrees to indemnify us against any claim a customer might make for any loss or damages the customer incurs as a result of a complaint made by the complainant and the action we take as a consequence of that complaint, except to the extent that the acts or omissions of the customer contributed to the customer’s loss or damages.'),
                singleBlock(
                    title: '20.	Complaints process',
                    content:
                        'Subject to clause 20.2, complaints about a customer of ours should be sent to  park42963@gmail.com \n\nIf you have a complaint about content accessible using our Service, you may contact the Communication Authority of Kenya in accordance with the complaints process detailed on their website: www.cak.go.ke. \n\nIf we receive a complaint about a customer, we may refer it to the appropriate government agency or authority for action (which may include the Kenya Police, the Office of the Data Protection Commissioner (Data Commissioner), Competition Authority of Kenya, or  Communications Authority of Kenya. \n\nWhere we receive a complaint, the complaint will be acknowledged within 1 business day. The acknowledgement may be verbal (via telephone) or in writing (via email or letter) at our discretion. \n\nWhere we receive notice of a complaint from a government agency or authority, we will, where appropriate and lawful, follow the procedures or take the actions we are required to take in that notice, including suspending or terminating your account, removing or disabling access to content or material, or providing the information requested by the agency or authority. \n\nIf the complaint is about Service interference created by another customer: \n\nWe will investigate the allegations and attempt to resolve the matter. If our Service is seriously compromised we may choose to suspend a customer’s Service immediately pending an investigation. \n\nOur decision regarding Service interference will be final. It may include suspension or termination of a customer’s Service. \n\nWe aim to resolve all complaints within 9 business days from the date of our acknowledgement of receipt of the complaint. However, it is not always possible to resolve complaints within this timeframe and timeframes will vary depending on the nature of the complaint. We will keep complainants and relevant customers advised of progress in resolving any complaint raised with us and we will advise both parties either verbally or in writing of the outcome of the complaint. \n\n© 2021 Park254 Ltd.'),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
