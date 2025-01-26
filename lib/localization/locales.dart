import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale('en', LocaleData.EN),
  MapLocale('hi', LocaleData.HI),
  MapLocale('mr', LocaleData.MR),
];

mixin LocaleData {
  static const String home = 'AgriGuide';
  static const String cropCare = 'Crop Care';
  static const String weather = 'Weather';
  static const String marketplace = 'Marketplace';
  static const String feed = 'AgriFeed';

  //home screen
  static const String mAgo = '%am ago';
  static const String hAgo = '%ah ago';
  static const String dAgo = '%ad ago';
  static const String justNow = 'just now';
  static const String comments = 'Comments';
  static const String noCommentsYet = 'No comments yet';
  static const String commentHere = 'Comment here...';
  static const String sharePost = 'Check out this post by @%a :\n %a';
  static const String postFrom = 'Post from %a';
  static const String like = 'Like';
  static const String share = 'share';
  static const String rePost = 'rePost';
  static const String newPost = 'New Post';
  static const String whatsHappening = "What's happening?";
  static const String post = "Post";
  static const String postEmpty = "Post cannot be empty!";
  static const String postChars = "Post exceeds 280 characters!";
  static const String postSuccess = "Post posted successfully!!";
  static const String follow = "Follow";

  //weather screen
  static const String kmPerHr = '%a km/h';
  static const String todayWeather = 'Today';
  static const String nextDays = 'Next Days';

  //noti screen
  static const String saveSettings = 'Save Settings';
  static const String notifications = 'Notifications';
  static const String noNotifications = 'No new notifications';
  static const String today = 'today';
  static const String yesterday = 'yesterday';
  static const String older = 'older';
  static const String clearAll = 'clearAll';

  //crop care
  static const String cropIden = 'Crop Recognition';
  static const String dieasesIden = 'Disease Recognition';
  static const String askAgbot = 'Ask AGbot...';

  // hamburger drawer
  static const String profile = 'Profile';
  static const String trackEx = 'Track Expense';
  static const String shareApp = 'Share AgriGuide';
  static const String help = 'Help';
  static const String logout = 'Logout';
  static const String version = 'version %a';
  static const String followers = 'followers';
  static const String following = 'following';

  //track expense
  static const String totalExpense = 'Total Expense %a';
  static const String expenseDesc = 'Expense Description';
  static const String amount = 'Amount';
  static const String addExpense = 'Add Expense';
  static const String fielsAreEmpty = 'Fields are empty';
  static const String areYouSure = 'Are you sure?';
  static const String cancel = 'Cancel';
  static const String yes = 'Yes';
  static const String updateExpense = 'Update Expense';
  static const String newDesc = 'New Description';
  static const String newAmt = 'New Amount';
  static const String update = 'Update';

  //share app
  static const String title = 'Check out this amazing app: %a';
  static const String subject = 'AgriGuide app';

  //setting screen
  static const String enableNoti = 'Enable Notifications';
  static const String language = 'Language';
  static const String selectLanguage = 'Select Language';
  static const String theme = 'Theme';
  static const String settings = 'Settings';
  static const String chooseThemeColor = 'Choose theme color';

  //help screen
  static const String q1 = 'How to use the app?';
  static const String q2 = 'How to track expenses?';
  static const String a1 = 'You can refer to the guide on the Home screen.';
  static const String a2 = 'Go to the "Track Expense" section from the menu.';
  static const String search = 'Search...';

  //agriFeed screen
  static const String news = 'News';
  static const String govSchemes = 'Gov. Schemes';
  static const String readMore = 'Read More';

  //profile screen
  static const String posts = 'Posts';
  static const String likes = 'Likes';
  static const String rePosts = 'Reposts';
  static const String changeBanner = 'Tap to change banner';
  static const String name = 'Name';
  static const String username = 'Username';
  static const String bio = 'Bio';
  static const String phone = 'Phone';
  static const String email = 'Email';
  static const String saveChanges = 'Save Changes';

  //cart screen
  static const String myCart = 'My Cart';
  static const String yourCartEmpty = 'Your cart is empty';
  static const String removedFromCart = 'Removed from cart!';
  static const String proceed = 'Proceed to checkout';
  static const String checkout = 'Checkout';
  static const String total = 'Total';

  //product screen
  static const String addToCart = 'Added to cart';
  static const String vendorDetails = 'Vendor Details';
  static const String vendorName = 'Vendor Name: %a';
  static const String contact = 'Contact: %a';
  static const String location = 'Location: %a, %a';
  static const String productGallery = 'Product Gallery';
  static const String reviews = 'Reviews & Ratings';
  static const String rating = 'Rating: %a';
  static const String recommedation = 'Recommended Products';
  static const String compare = 'Compare Similar Products';
  static const String price = 'Price';
  static const String ratings = 'Rating';

  //marketplace screen
  static const String searchProducts = 'Search products...';
  static const String all = 'All';
  static const String vegies = 'Vegetables';
  static const String fruits = 'Fruits';
  static const String dairy = 'Dairy';
  static const String recommendations = 'Recommendations:';
  static const String category = 'Category: %a';
  static const String stock = 'Stock: %a';
  static const String off = '%a OFF';

  static const Map<String, dynamic> EN = {
    home: 'AgriGuide',
    cropCare: 'Crop Care',
    weather: 'Weather',
    marketplace: 'Marketplace',
    feed: 'AgriFeed',

    //weather screen
    kmPerHr: '%a km/h',
    todayWeather: 'Today',
    nextDays: 'Next Days',

    //home screen
    mAgo: '%am ago',
    hAgo: '%ah ago',
    dAgo: '%ad ago',
    justNow: 'just now',
    comments: 'Comments',
    noCommentsYet: 'No comments yet',
    commentHere: 'Comment here...',
    sharePost: 'Check out this post by @%a :\n %a',
    postFrom: 'Post from %a',
    like: 'Like',
    rePost: 'rePost',
    share: 'share',
    post: 'Post',
    newPost: 'New Post',
    whatsHappening: "What's happening?",
    postChars: 'Post exceeds 280 characters!',
    postEmpty: 'Post cannot be empty!',
    postSuccess: 'Post posted successfully!',
    follow: 'Follow',

    //noti screen
    saveSettings: 'Save Settings',
    notifications: 'Notifications',
    noNotifications: 'No new notifications',
    today: 'today',
    yesterday: 'yesterday',
    older: 'older',
    clearAll: 'clearAll',

    //crop care
    cropIden: 'Crop Recognition',
    dieasesIden: 'Disease Recognition',
    askAgbot: 'Ask AGbot...',

    //hamburger drawer
    profile: 'Profile',
    trackEx: 'Track Expense',
    shareApp: 'Share AgriGuide',
    help: 'Help',
    logout: 'Logout',
    version: 'version %a',
    followers: 'followers',
    following: 'following',

    //track expense
    totalExpense: 'Total Expense %a',
    expenseDesc: 'Expense Description',
    amount: 'Amount',
    addExpense: 'Add Expense',
    fielsAreEmpty: 'Fields are empty',
    areYouSure: 'Are you sure?',
    cancel: 'Cancel',
    yes: 'Yes',
    updateExpense: 'Update Expense',
    newDesc: 'New Description',
    newAmt: 'New Amount',
    update: 'Update',

    //share app
    title: 'Check out this amazing app: %a',
    subject: 'AgriGuide app',

    //settings screen
    enableNoti: 'Enable Notifications',
    language: 'Language',
    selectLanguage: 'Select Language',
    theme: 'Theme',
    settings: 'Settings',
    chooseThemeColor: 'Choose theme color',

    //help screen
    q1: 'How to use the app?',
    a1: 'You can refer to the guide on the Home screen.',
    q2: 'How to track expenses?',
    a2: 'Go to the "Track Expense" section from the menu.',
    search: 'Search...',

    //agriFeed screen
    news: 'News',
    govSchemes: 'Gov. Schemes',
    readMore: 'Read More',

    //profile screen
    posts: 'Posts',
    likes: 'Likes',
    rePosts: 'Reposts',
    name: 'Name',
    username: "Username",
    bio: "Bio",
    phone: "Phone",
    email: "Email",
    saveChanges: "Save Changes",
    changeBanner: 'Tap to change banner',

    //cart screen
    myCart: 'My Cart',
    yourCartEmpty: 'Your cart is empty',
    removedFromCart: 'Removed from cart!',
    proceed: 'Proceed to checkout',
    checkout: 'Checkout',
    total: 'Total',

    //product screen
    addToCart: 'Added to cart',
    vendorDetails: 'Vendor Details',
    vendorName: 'Vendor Name: %a',
    contact: 'Contact: %a',
    location: 'Location: %a',
    productGallery: 'Product Gallery',
    reviews: 'Reviews & Ratings',
    rating: 'Rating: %a',
    recommedation: 'Recommended Products',
    compare: 'Compare Similar Products',
    price: 'Price',
    ratings: 'Rating',

    //marketplcae screen
    searchProducts: 'Search products...',
    all: 'All',
    vegies: 'Vegetables',
    fruits: 'Fruits',
    dairy: 'Dairy',
    recommendations: 'Recommendations',
    category: 'Category: %a',
    stock: 'Stock: %a',
    off: '%a OFF',
  };

  static const Map<String, dynamic> HI = {
    home: 'अॅग्रीगाईड',
    cropCare: 'फसल देखभाल',
    weather: 'हवामान',
    marketplace: 'बाजार',
    feed: 'कृषिफ़ीड',

    //home screen
    mAgo: '%am पहले',
    hAgo: '%ah पहले',
    dAgo: '%ad पहले',
    justNow: 'अभी अभी',
    comments: 'कमेंट्स',
    noCommentsYet: 'कोई कमेंट नहीं है।',
    commentHere: 'यहाँ कमेंट करें...',
    sharePost: 'इस पोस्ट को देखें @%a से:\n %a',
    postFrom: 'पोस्ट %a से',
    like: 'पसंद',
    rePost: 'पोस्ट करें',
    share: 'शेअर करें',
    newPost: 'नई पोस्ट',
    whatsHappening: 'क्या हो रहा है?',
    post: 'पोस्ट करें',
    postChars: 'पोस्ट 280 अक्षरों से अधिक है!',
    postEmpty: 'पोस्ट खाली नहीं हो सकती!',
    postSuccess: 'पोस्ट सफलतापूर्वक पोस्ट किया गया!',
    follow: 'फॉलो करें',

    //weather screen
    kmPerHr: '%a कि/घं',
    todayWeather: 'आज',
    nextDays: 'अगले दिन',

    //noti screen
    saveSettings: 'सेटिंग्स सेव करें',
    notifications: 'सूचनाएँ',
    noNotifications: 'कोई नई सूचनाएँ नहीं है',
    today: 'आज',
    yesterday: 'कल',
    older: 'पुराना',
    clearAll: 'साफ करें',

    //crop care
    cropIden: 'फसल पहचान',
    dieasesIden: 'रोग पहचान',
    askAgbot: 'AGbot से पूछें...',

    //hamburger drawer
    profile: 'प्रोफाइल',
    trackEx: 'खर्च ट्रैक करें',
    shareApp: 'शेअर अॅग्रीगाइड',
    help: 'मदत',
    logout: 'लॉगआउट करो',
    version: 'version %a',
    followers: 'फॉलोअर्स',
    following: 'फॉलोइंग',

    //track expense
    totalExpense: 'कुल खर्च %a',
    expenseDesc: 'खर्च का विवरण',
    amount: 'कुल धनराशि',
    addExpense: 'खर्च जोड़ें',
    fielsAreEmpty: 'इनपुट खाली हैं',
    areYouSure: 'सचमुच?',
    cancel: 'रद्द करें',
    yes: 'हाँ',
    updateExpense: 'खर्च अपडेट करें',
    newDesc: 'नया विवरण',
    newAmt: 'नई राशि',
    update: 'अपडेट',

    //share app
    title: 'इस शानदार ऐप को देखो: %a',
    subject: 'एग्रीगाइड ऐप',

    //settings screen
    enableNoti: 'नोटिफिकेशन चालू करो',
    language: 'भाषा',
    selectLanguage: 'भाषा चुनो',
    theme: 'थीम',
    settings: 'सेटिंग्स',
    chooseThemeColor: 'थीम का रंग चुनो',

    //help screen
    q1: 'ऐप का कैसे इस्तेमाल करें?',
    a1: 'आप होम स्क्रीन पर गाइड देख सकते हैं।',
    q2: 'खर्चों को कैसे ट्रैक करें?',
    a2: "मेनू से 'खर्च ट्रैक करें' सेक्शन पर जाएं।",
    search: 'खोजें...',

    //agriFeed screen
    news: 'समाचार',
    govSchemes: 'सरकारी योजनाएँ',
    readMore: 'आगे पढ़ें',

    //profile screen
    posts: 'पोस्ट्स',
    likes: 'पसंद',
    rePosts: 'पुनर्पोस्ट',
    name: 'नाम',
    username: "यूज़रनेम",
    bio: "बायो",
    phone: "फ़ोन",
    email: "ईमेल",
    saveChanges: "सेव करें",
    changeBanner: 'बैनर बदलने के लिए टैप करें',

    //cart screen
    myCart: 'मेरी कार्ट',
    yourCartEmpty: 'आपकी कार्ट खाली है।',
    removedFromCart: 'कार्ट से हटा दिया!',
    proceed: 'चेकआउट के लिए आगे बढ़ें',
    checkout: 'चेकआउट',
    total: 'कुल',

    //product screen
    addToCart: 'कार्ट में जोड़ा गया',
    vendorDetails: 'विक्रेता विवरण',
    vendorName: 'विक्रेता का नाम: %a',
    contact: 'संपर्क: %a',
    location: 'स्थान: %a',
    productGallery: 'प्रोडक्ट गैलरी',
    reviews: 'रिव्यू और रेटिंग्स',
    rating: 'रेटिंग्स: %a',
    recommedation: 'सिफारिश की गई चीजें',
    compare: 'समान उत्पादों की तुलना करें',
    price: 'कीमत',
    ratings: 'रेटिंग्स',

    //marketplcae screen
    searchProducts: 'उत्पादों को खोजें...',
    all: 'सब',
    vegies: 'सब्जियाँ',
    fruits: 'फल',
    dairy: 'डेयरी',
    recommendations: 'सिफारिशें',
    category: 'श्रेणी: %a',
    stock: 'भंडार: %a',
    off: '%a छूट',
  };

  static const Map<String, dynamic> MR = {
    home: 'अॅग्रीगाईड',
    cropCare: 'पिकांची काळजी',
    weather: 'हवामान',
    marketplace: 'बाजारपेठ',
    feed: 'कृषिफीड',

    //home screen
    mAgo: '%am पूर्वी',
    hAgo: '%ah पूर्वी',
    dAgo: '%ad पूर्वी',
    justNow: 'आत्ताच',
    comments: 'कमेंट्स',
    noCommentsYet: 'अजून काही कमेंट्स नाहीत',
    commentHere: 'इथे कमेंट करा...',
    sharePost: 'पाहा ही पोस्ट @%a कडून:\n %a',
    postFrom: 'पोस्ट कडून %a',
    like: 'पसंत',
    rePost: 'पोस्ट करा',
    share: 'शेअर करा',
    post: 'पोस्ट करा',
    newPost: 'नवीन पोस्ट',
    whatsHappening: 'काय चालू आहे?',
    postChars: 'पोस्ट 280 अक्षरांपेक्षा जास्त!',
    postEmpty: 'पोस्ट रिकामे होऊ शकत नाही!',
    postSuccess: 'पोस्ट यशस्वी पणे पोस्ट केली आहे!',
    follow: 'फॉलो करा',

    //weather screen
    kmPerHr: '%a कि/ता',
    todayWeather: 'आज',
    nextDays: 'पुढचे दिवस',

    //noti screen
    saveSettings: 'सेटिंग्ज जतन करा',
    notifications: 'सूचना',
    noNotifications: 'नवीन सूचना नाहीत',
    today: 'आज',
    yesterday: 'काल',
    older: 'जुना',
    clearAll: 'सर्व स्पष्ट करा',

    //crop care
    cropIden: 'पिकांची ओळख',
    dieasesIden: 'रोग ओळख',
    askAgbot: 'AGbot ला विचारा...',

    //hamburger drawer
    profile: 'प्रोफाइल',
    trackEx: 'खर्च ट्रॅक करा',
    shareApp: 'शेअर अॅग्रीगाइड',
    help: 'मदत',
    logout: 'लॉगआउट करा',
    version: 'version %a',
    followers: 'फॉलोअर्स',
    following: 'फॉलोइंग',

    //track expense
    totalExpense: 'एकूण खर्च %a',
    expenseDesc: 'खर्चाचे वर्णन',
    amount: 'रक्कम',
    addExpense: 'खर्च जोडा',
    fielsAreEmpty: 'इनपुट रिकामे आहेत',
    areYouSure: 'खरंच??',
    cancel: 'रद्द करा',
    yes: 'होय',
    updateExpense: 'खर्च अपडेट करा',
    newDesc: 'नवीन वर्णन',
    newAmt: 'नवीन रक्कम',
    update: 'अपडेट',

    //share app
    title: 'पाहा हे अप्रतिम अॅप: %a',
    subject: 'अॅग्रीगाईड अॅप',

    //settings screen
    enableNoti: 'सूचना चालू करा',
    language: 'भाषा',
    selectLanguage: 'भाषा निवडा',
    theme: 'थीम',
    settings: 'सेटिंग्स',
    chooseThemeColor: 'थीम रंग निवडा',

    //help screen
    q1: 'अॅप कसे वापरावे?',
    a1: 'आपण होम स्क्रीनवर गाइड पाहू शकता.',
    q2: 'खर्च कसे ट्रॅक करायचे?',
    a2: 'मेन्यूमधून "खर्च ट्रॅक करा" विभागात जा.',
    search: 'शोधा...',

    //agriFeed screen
    news: 'बातम्या',
    govSchemes: 'सरकारी योजना',
    readMore: 'पुढे वाचा',

    //profile screen
    posts: 'पोस्ट्स',
    likes: 'पसंत',
    rePosts: 'पुनर्पोस्ट',
    name: 'नाव',
    username: "युजरनेम",
    bio: "बायो",
    phone: "फोन",
    email: "ईमेल",
    saveChanges: "बदल जतन करा",
    changeBanner: 'बॅनर बदलण्यासाठी टॅप करा',

    //cart screen
    myCart: 'माझी कार्ट',
    yourCartEmpty: 'तुमची कार्ट रिकामी आहे.',
    removedFromCart: 'कार्टमधून काढले गेले!',
    proceed: 'चेकआउटसाठी पुढे जा',
    checkout: 'चेकआउट',
    total: 'एकूण',

    //product screen
    addToCart: 'कार्टमध्ये जोडले',
    vendorDetails: 'विक्रेत्याचा तपशील',
    vendorName: 'विक्रेत्याचे नाव: %a',
    contact: 'संपर्क: %a',
    location: 'ठिकाण: %a',
    productGallery: 'प्रोडक्ट गैलरी',
    reviews: 'रिव्यू आणि रेटिंग्स',
    rating: 'रेटिंग्स: %a',
    recommedation: 'शिफारस केलेली उत्पादने',
    compare: 'समान उत्पादनांची तुलना करा.',
    price: 'किंमत',
    ratings: 'रेटिंग्स',

    //marketplcae screen
    searchProducts: 'उत्पादने शोधा...',
    all: 'सर्व',
    vegies: 'भाज्या',
    fruits: 'फळे',
    dairy: 'डेयरी',
    recommendations: 'शिफारशी',
    category: 'प्रवर्ग: %a',
    stock: 'साठा: %a',
    off: '%a सूट',
  };
}
