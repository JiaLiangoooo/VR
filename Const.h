#ifdef DEBUG
#define CLog(...) NSLog(__VA_ARGS__)
#else
#define CLog(...)
#endif

#define MTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define MTGlobalBg MTColor(230, 230, 230)
