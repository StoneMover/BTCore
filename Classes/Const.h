
// 全局工具类宏定义

#ifndef define_h
#define define_h

// 导航高度获取
#define NAV_HEIGHT (NAVCONTENT_HEIGHT + STATUSBAR_HEIGHT)
#define NAVCONTENT_HEIGHT 44
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define HOME_INDICATOR_HEIGHT (UI_IS_IPHONEX ? 34.f : 0.f)
#define HOME_INDICATOR_HEIGHT_SMALL (UI_IS_IPHONEX ? 14.f : 0.f)
#define TAB_HEIGHT (UI_IS_IPHONEX ? (49.f+34.f) : 49.f)
#define  UI_IS_IPHONEX ((KScreenWidth == 375.f && KScreenHeight == 812.f ? YES : NO) || (KScreenWidth == 414.f && KScreenHeight == 896.f ? YES : NO))


//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        ((AppDelegate*)([UIApplication sharedApplication].delegate))
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kNotificationCenter [NSNotificationCenter defaultCenter]

// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]


//获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds

#define Iphone6ScaleWidth KScreenWidth/375.0
#define Iphone6ScaleHeight KScreenHeight/667.0
//根据ip6的屏幕来拉伸
#define kRealValue(with) ((with)*(KScreenWidth/375.0f))




#define SystemFont(Size,Weight)\
[UIFont systemFontOfSize:Size weight:Weight]


//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//颜色
#define KClearColor [UIColor clearColor]
#define KWhiteColor [UIColor whiteColor]
#define KBlackColor [UIColor blackColor]
#define KGrayColor [UIColor grayColor]
#define KLightGray [UIColor lightGrayColor]
#define KBlueColor [UIColor blueColor]
#define KRedColor [UIColor redColor]
#define KGroupTabColor [UIColor groupTableViewBackgroundColor]
#define KRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define KRGBAColor(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kRandomColor    KRGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))        //随机色生成
#define MainColor [UIColor redColor]


#define IMAGE(name) [UIImage imageNamed:name]
#define SafeStr(str) (str!=nil ? str:@"")


#define PLACE_HOLDER IMAGE(@"default_bg")


#define URL(url) (url!=nil ? [NSURL URLWithString:url]:[NSURL URLWithString:@"http://www.baidu.com/default.png"])

#define MAIN_COLOR KRedColor


#define isEmptyStr(str) [BTUtils isEmpty:str]

#endif /* define_h */
