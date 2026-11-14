#import "VISL10n.h"
#import <objc/runtime.h>

static NSString *const kVISDomain = @"com.ethxnn88.visibleislandprefs";
static char kVISLangKey;

@implementation VISL10n

+ (NSDictionary<NSString *, NSString *> *)vietnamese {
    static NSDictionary *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        table = @{
            // Root
            @"Enable Dynamic Island": @"Bật Dynamic Island",
            @"If your device isn't supported yet, use the custom positioning instead.": @"Nếu thiết bị của bạn chưa được hỗ trợ, hãy dùng vị trí tùy chỉnh.",
            @"Fix Island Position": @"Sửa vị trí Island",
            @"Custom Island Positioning": @"Vị trí Island tùy chỉnh",
            @"Use Custom Position": @"Dùng vị trí tùy chỉnh",
            @"X Position:": @"Vị trí X:",
            @"Y Position:": @"Vị trí Y:",
            @"Enter X Position": @"Nhập vị trí X",
            @"Enter Y Position": @"Nhập vị trí Y",
            @"Save": @"Lưu",
            @"Misc": @"Khác",
            @"Lock Icon on Island": @"Biểu tượng ổ khóa trên Island",
            @"Face ID Animation": @"Hoạt ảnh Face ID",
            @"Face ID Animation needs a respring after changing.": @"Hoạt ảnh Face ID cần respring sau khi thay đổi.",
            @"App Lock Face ID on Island": @"Face ID khóa ứng dụng trên Island",
            @"Hide When Not in Use": @"Ẩn khi không sử dụng",
            @"Disable Island Outline": @"Tắt viền Island",
            @"Notifications": @"Thông báo",
            @"Color and Opacity": @"Màu sắc và độ mờ",
            @"Scale": @"Tỷ lệ",
            @"Source Code": @"Mã nguồn",
            @"More": @"Thêm",
            // Color
            @"Custom Opacity": @"Độ mờ tùy chỉnh",
            @"Use Custom Opacity": @"Dùng độ mờ tùy chỉnh",
            @"Opacity": @"Độ mờ",
            @"Custom Color": @"Màu tùy chỉnh",
            @"Use Custom Color": @"Dùng màu tùy chỉnh",
            @"Red": @"Đỏ",
            @"Green": @"Xanh lá",
            @"Blue": @"Xanh dương",
            // Scale
            @"Custom Island Scale": @"Tỷ lệ Island tùy chỉnh",
            @"If you choose to use a custom scale, setting a custom position is recommended for best results.": @"Nếu dùng tỷ lệ tùy chỉnh, nên đặt cả vị trí tùy chỉnh để có kết quả tốt nhất.",
            @"Use Custom Scale": @"Dùng tỷ lệ tùy chỉnh",
            @"Scale:": @"Tỷ lệ:",
            @"Enter Scale": @"Nhập tỷ lệ",
            // Notifications
            @"Moves all incoming notification banners to below the Dynamic Island for better visibility.": @"Dời mọi biểu ngữ thông báo xuống dưới Dynamic Island để dễ nhìn hơn.",
            @"Fix Notification Positioning": @"Sửa vị trí thông báo",
            @"Custom Notification Positioning": @"Vị trí thông báo tùy chỉnh",
            @"Use custom positioning if you use a custom island position.": @"Dùng vị trí tùy chỉnh nếu bạn dùng vị trí Island tùy chỉnh.",
            @"Use Custom Notification Position": @"Dùng vị trí thông báo tùy chỉnh",
            // Thêm
            @"Language": @"Ngôn ngữ",
            @"About": @"Thông tin",
            @"Author": @"Tác giả",
            @"Edited by": @"Chỉnh sửa lại",
            @"Contribute ideas": @"Đóng góp ý tưởng",
            // Hộp thoại
            @"Respring": @"Respring",
            @"You are about to respring.": @"Bạn sắp respring máy.",
            @"Cancel": @"Hủy",
            @"Device not supported": @"Thiết bị chưa được hỗ trợ",
            @"This device is not officially supported by VisibleIsland, meaning there are no 'perfect' offsets found for your device as of now. You can enable this option and use the built-in estimated offsets, or disable it and use custom offsets. Support for this device will be added in a future build.": @"Thiết bị này chưa được VisibleIsland hỗ trợ chính thức, nghĩa là hiện chưa có độ lệch 'hoàn hảo' cho máy của bạn. Bạn có thể bật tùy chọn này để dùng độ lệch ước tính có sẵn, hoặc tắt đi và dùng vị trí tùy chỉnh. Máy này sẽ được hỗ trợ ở bản sau.",
            @"OK": @"OK",
        };
    });
    return table;
}

+ (NSString *)languageCode {
    CFPreferencesAppSynchronize((__bridge CFStringRef)kVISDomain);
    id value = CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("language"), (__bridge CFStringRef)kVISDomain));
    return ([value isKindOfClass:[NSString class]] && [value isEqualToString:@"vi"]) ? @"vi" : @"en";
}

+ (BOOL)isVietnamese {
    return [[self languageCode] isEqualToString:@"vi"];
}

+ (NSString *)tr:(NSString *)english {
    if (!english.length || ![self isVietnamese]) return english;
    return [self vietnamese][english] ?: english;
}

+ (void)localizeSpecifiers:(NSArray *)specifiers forController:(PSListController *)controller title:(NSString *)englishTitle {
    if (![self isVietnamese]) {
        if (englishTitle) controller.title = englishTitle;
        return;
    }
    for (PSSpecifier *specifier in specifiers) {
        NSString *name = specifier.name;
        if (name.length) specifier.name = [self tr:name];
        for (NSString *key in @[@"footerText", @"prompt"]) {
            NSString *text = [specifier propertyForKey:key];
            if ([text isKindOfClass:[NSString class]] && text.length) [specifier setProperty:[self tr:text] forKey:key];
        }
    }
    if (englishTitle) controller.title = [self tr:englishTitle];
}

+ (void)refreshController:(PSListController *)controller {
    NSString *code = [self languageCode];
    NSString *last = objc_getAssociatedObject(controller, &kVISLangKey);
    objc_setAssociatedObject(controller, &kVISLangKey, code, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (last && ![last isEqualToString:code]) {
        [controller reloadSpecifiers];
    }
}

@end
