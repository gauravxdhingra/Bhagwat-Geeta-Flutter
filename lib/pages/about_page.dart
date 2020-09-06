import 'package:bhagwat_geeta/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);
  static const routeName = "about_page";
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool _isLoading = true;
  bool init = false;
  bool doubleBack = false;

  Box<Map> x;
  var lang;
  String language = "eng";

  @override
  void didChangeDependencies() async {
    if (!init) {
      doubleBack = ModalRoute.of(context).settings.arguments ?? false;
      x = await Hive.openBox<Map>("Geeta");
      lang = x.get("lang");
      if (lang == null || lang.toString() == "") {
        language = "eng";
        x.put("lang", {"lang": "eng"});
      }
      if (x.toMap()["lang"]["lang"] == "eng") {
        language = "eng";
      } else {
        language = "hi";
      }
      setState(() {
        init = true;
        _isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  changeLanguage() async {
    setState(() {
      _isLoading = true;
    });
    if (x.toMap()["lang"]["lang"] == "hi") {
      x.put("lang", {"lang": "eng"});
      language = "eng";
    } else {
      x.put("lang", {"lang": "hi"});
      language = "hi";
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        if (doubleBack) Navigator.pop(context);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: language == "hi"
                ? Text(
                    "श्रीमद्भगवद्गीता",
                    style: TextStyle(fontFamily: "KrutiDev"),
                  )
                : Text(
                    "About Bhagwat Geeta",
                    style: TextStyle(fontFamily: "Samarkan"),
                  ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                  if (doubleBack) Navigator.pop(context);
                }),
            actions: [
              IconButton(
                  icon: Icon(Icons.translate),
                  onPressed: () async {
                    await changeLanguage();
                  })
            ],
          ),
          body: Container(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Image.asset('assets/images/1.jpg'),
                  SizedBox(height: 20),
                  if (language == "hi")
                    Text(
                      "श्रीमद्भगवद्‌गीता",
                      style: TextStyle(
                          color: Themes.primaryColor,
                          fontSize: 25,
                          fontFamily: "KrutiDev",
                          fontWeight: FontWeight.bold),
                    ),
                  if (language == "eng")
                    Text(
                      "Bhagwat Geeta",
                      style: TextStyle(
                          color: Themes.primaryColor,
                          fontSize: 25,
                          fontFamily: "Samarkan",
                          fontWeight: FontWeight.bold),
                    ),
                  if (language == "hi")
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Text(
                        '''श्रीमद्भगवद्‌गीता हिन्दुओं के पवित्रतम ग्रन्थों में से एक है। महाभारत के अनुसार कुरुक्षेत्र युद्ध में भगवान श्री कृष्ण ने गीता का सन्देश अर्जुन को सुनाया था। यह महाभारत के भीष्मपर्व के अन्तर्गत दिया गया एक उपनिषद् है। भगवत गीता में एकेश्वरवाद, कर्म योग, ज्ञानयोग, भक्ति योग की बहुत सुन्दर ढंग से चर्चा हुई है।

श्रीमद्भगवद्‌गीता की पृष्ठभूमि महाभारत का युद्ध है। जिस प्रकार एक सामान्य मनुष्य अपने जीवन की समस्याओं में उलझकर किंकर्तव्यविमूढ़ हो जाता है और जीवन की समस्यायों से लड़ने की बजाय उससे भागने का मन बना लेता है उसी प्रकार अर्जुन जो महाभारत के महानायक थे, अपने सामने आने वाली समस्याओं से भयभीत होकर जीवन और क्षत्रिय धर्म से निराश हो गए थे, अर्जुन की तरह ही हम सभी कभी-कभी अनिश्चय की स्थिति में या तो हताश हो जाते हैं और या फिर अपनी समस्याओं से विचलित होकर भाग खड़े होते हैं।

भारत वर्ष के ऋषियों ने गहन विचार के पश्चात जिस ज्ञान को आत्मसात किया उसे उन्होंने वेदों का नाम दिया। इन्हीं वेदों का अंतिम भाग उपनिषद कहलाता है। मानव जीवन की विशेषता मानव को प्राप्त बौद्धिक शक्ति है और उपनिषदों में निहित ज्ञान मानव की बौद्धिकता की उच्चतम अवस्था तो है ही, अपितु बुद्धि की सीमाओं के परे मनुष्य क्या अनुभव कर सकता है उसकी एक झलक भी दिखा देता है।

श्रीमद्भगवद्गीता वर्तमान में धर्म से ज्यादा जीवन के प्रति अपने दार्शनिक दृष्टिकोण को लेकर भारत में ही नहीं विदेशों में भी लोगों का ध्यान अपनी और आकर्षित कर रही है। निष्काम कर्म का गीता का संदेश प्रबंधन गुरुओं को भी लुभा रहा है। विश्व के सभी धर्मों की सबसे प्रसिद्ध पुस्तकों में शामिल है। गीता प्रेस गोरखपुर जैसी धार्मिक साहित्य की पुस्तकों को काफी कम मूल्य पर उपलब्ध कराने वाले प्रकाशन ने भी कई आकार में अर्थ और भाष्य के साथ श्रीमद्भगवद्गीता के प्रकाशन द्वारा इसे आम जनता तक पहुंचाने में काफी योगदान दिया है।''',
                        style: TextStyle(fontFamily: "KrutiDev", fontSize: 16),
                      ),
                    ),
                  if (language == "eng")
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Text(
                        '''Bhagavad Gita, also known as the Gita - "The Song of The Lord" is a practical guide to one's life that guides one to re-organise their life, achieve inner peace and approach the Supreme Lord (the Ultimate Reality). It is a 700-verse text in Sanskrit which comprises chapters 23 through 40 in the Bhishma-Parva section of the Mahabharata.

The Bhagavad Gita is a dialogue between Arjuna, a supernaturally gifted warrior and his guide and charioteer Lord Krishna on the battlefield of Kurukshetra. As both armies stand ready for the battle, the mighty warrior Arjuna, on observing the warriors on both sides becomes overwhelmed with grief and compassion due to the fear of losing his relatives and friends and the consequent sins attributed to killing his own relatives. So, he surrenders to Lord Krishna, seeking a solution. Thus, follows the wisdom of the Bhagavad Gita. Over 18 chapters, Gita packs an intense analysis of life, emotions and ambitions, discussion of various types of yoga, including Jnana, Bhakti, Karma and Raja, the difference between Self and the material body as well as the revelation of the Ultimate Purpose of Life.''',
                        style: TextStyle(fontFamily: "Smarkan", fontSize: 16),
                      ),
                    ),
                  SizedBox(height: 20),
                  // if (language == "eng")
                  Image.asset('assets/images/loading.gif', height: 70),
                  SizedBox(height: 10),
                  if (language == "eng")
                    Text("।। Jai Shree Krishna ।।",
                        style: TextStyle(
                            fontFamily: "Samarkan",
                            fontSize: 22,
                            letterSpacing: 1.1)),
                  if (language == "hi")
                    Text("।। जय श्री कृष्णा ।।",
                        style: TextStyle(
                            fontFamily: "Samarkan",
                            fontSize: 22,
                            letterSpacing: 1.1)),
                  SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
