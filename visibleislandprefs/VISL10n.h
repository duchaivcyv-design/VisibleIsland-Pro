#import <Foundation/Foundation.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

// Ngôn ngữ giao diện cài đặt: English (mặc định) / Tiếng Việt, đổi qua lại trong mục "Thêm"
@interface VISL10n : NSObject
+ (NSString *)languageCode;          // "en" hoặc "vi"
+ (BOOL)isVietnamese;
+ (NSString *)tr:(NSString *)english; // trả về bản dịch, không có thì giữ nguyên tiếng Anh
+ (void)localizeSpecifiers:(NSArray *)specifiers forController:(PSListController *)controller title:(NSString *)englishTitle;
+ (void)refreshController:(PSListController *)controller; // gọi trong viewWillAppear: tự nạp lại nếu đã đổi ngôn ngữ
@end

@interface PSListController (VISExtra)
- (PSSpecifier *)specifierAtIndexPath:(NSIndexPath *)indexPath;
@end
