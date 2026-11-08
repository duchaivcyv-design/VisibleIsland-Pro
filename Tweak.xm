#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sys/sysctl.h>
#import <notify.h>

// ============================================================================
// CẤU HÌNH BIẾN TOÀN CỤC CỦA VISIBLEISLAND
// ============================================================================
CGFloat red = 0.0;
CGFloat green = 0.0;
CGFloat blue = 0.0;
CGFloat alpha = 1.0;

CGFloat scale = 1.0;

CGFloat xPos = 0;
CGFloat yPos = 20.5;
CGFloat xNot = 0.0;
CGFloat yNot = 40;

static BOOL fixEnabled;
static BOOL islandEnabled;
static BOOL posEnabled;
static BOOL hideEnabled;
static BOOL notificationFix;
static BOOL notEnabled;
static BOOL colorEnabled;
static BOOL transEnabled;
static BOOL scaleEnabled;
static BOOL lineDisabled;

// ============================================================================
// INTERFACES NATIVE PHÁT HIỆN TỪ CACHE CRYPTEX (ĐÃ BỔ SUNG ĐẦY ĐỦ)
// ============================================================================
@interface FBSystemService : NSObject
+ (id)sharedInstance;
- (void)exitAndRelaunch:(BOOL)arg1;
@end

@interface SBSystemApertureWindow : UIView
@end

@interface _SBSystemApertureMagiciansCurtainView : UIView
@end

@interface SBBannerWindow : UIView
@end

@interface _SBGainMapView : UIView
@end

@interface _SBSystemApertureContainerViewContentView : UIView
@end

@interface SBFTouchPassThroughView : UIView
@end

@interface LAUIPearlGlyphStaticConfiguration : NSObject
+ (id)createSystemApertureConfiguration;
+ (id)createDefaultConfiguration;
@end

@interface LAUIPearlGlyphView : UIView
- (id)initWithConfiguration:(id)arg1;
- (void)setState:(NSInteger)state animated:(BOOL)animated withCompletion:(id)completion;
- (void)setFaceVisibility:(BOOL)arg1 animated:(BOOL)arg2;
- (void)setFeedbackEnabled:(BOOL)arg1;
- (void)setPaused:(BOOL)arg1;
- (BOOL)isPaused;
@end

@interface SBUIBiometricResource : NSObject
+ (id)sharedInstance;
- (BOOL)hasPearlSupport;
- (BOOL)isPearlDetectEnabled;
- (BOOL)isPearlAvailableForSystemAperture;
- (void)_notifyObserversOfEvent:(unsigned long long)event;
@end

@interface SBLockScreenManager : NSObject
+ (id)sharedInstance;
- (BOOL)isUILocked;
- (void)_finishUIUnlockFromSource:(int)source withOptions:(id)options;
- (BOOL)unlockUIFromSource:(int)source withOptions:(id)options;
- (void)lockUIFromSource:(int)source withOptions:(id)options;
@end

@interface SBUIProudLockIconView : UIView
- (LAUIPearlGlyphView *)_pearlGlyphView;
- (void)setState:(NSInteger)state animated:(BOOL)animated;
@end

// KHAI BÁO BỔ SUNG: Bắt sự kiện trong App (Ảnh ẩn/xoá, Keychain, App Store, Apple Pay)
@interface SBBiometricMonitorPearlDataSource : NSObject
- (void)_setMatching:(BOOL)arg1;
- (void)device:(id)arg1 pearlEventOccurred:(long long)arg2;
@end

// KHAI BÁO BỔ SUNG: Bắt sự kiện vuốt lên nhập mã PIN / Passcode
@interface SBUIPasscodeBiometricAuthenticationView : UIView
- (void)setBiometricAuthenticationState:(NSInteger)state animated:(BOOL)animated;
@end

@interface SBLockScreenBiometricAuthenticationCoordinator : NSObject
- (void)biometricResource:(id)resource observeEvent:(unsigned long long)event;
@end

// KHAI BÁO BỔ SUNG: Cờ nhận diện phần cứng Pearl
@interface SBFMobileKeyBag : NSObject
- (BOOL)hasPearl;
@end

@interface BSPlatform : NSObject
- (NSInteger)homeButtonType;
@end

@interface Model : NSObject
+ (NSString *)deviceModel;
+ (CGFloat)defaultIslandYOffset;
@end

@implementation Model

+ (NSString *)deviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    if (machine == NULL) {
        return nil;
    }
    if (sysctlbyname("hw.machine", machine, &size, NULL, 0) == -1) {
        free(machine);
        return nil;
    }
    NSString *deviceModel = [NSString stringWithUTF8String:machine];
    free(machine);
    return deviceModel;
}

+ (CGFloat)defaultIslandYOffset {
    NSString *m = [self deviceModel];
    // Các dòng Touch ID (iPhone 8, 8 Plus, SE)
    if ([m hasPrefix:@"iPhone10,1"] || [m hasPrefix:@"iPhone10,4"] ||
        [m hasPrefix:@"iPhone10,2"] || [m hasPrefix:@"iPhone10,5"] ||
        [m hasPrefix:@"iPhone12,8"] || [m hasPrefix:@"iPhone14,6"]) {
        return 11.0;
    }
    if ([m isEqualToString:@"iPhone10,3"] || [m isEqualToString:@"iPhone10,6"] ||
        [m isEqualToString:@"iPhone11,2"] || [m isEqualToString:@"iPhone12,3"]) {
        return 20.5;
    }
    if ([m isEqualToString:@"iPhone11,6"] || [m isEqualToString:@"iPhone12,5"] ||
        [m isEqualToString:@"iPhone11,8"] || [m isEqualToString:@"iPhone12,1"] ||
        [m isEqualToString:@"iPhone14,4"]) {
        return 22.5;
    }
    if ([m isEqualToString:@"iPhone13,1"]) return 19.5;
    if ([m isEqualToString:@"iPhone13,2"] || [m isEqualToString:@"iPhone13,3"]) return 21.5;
    if ([m isEqualToString:@"iPhone13,4"]) return 22.3;
    if ([m isEqualToString:@"iPhone14,5"] || [m isEqualToString:@"iPhone14,2"] ||
        [m isEqualToString:@"iPhone14,7"] || [m isEqualToString:@"iPhone14,8"]) {
        return 24.0;
    }
    if ([m isEqualToString:@"iPhone14,3"]) return 26.0;
    return 20.5;
}

@end

// ============================================================================
// BỘ QUẢN LÝ GLYPH FACE ID NATIVE DÀNH CHO SYSTEM APERTURE
// ============================================================================
@interface NativeIslandGlyphController : NSObject
@property (nonatomic, strong) UIWindow *glyphWindow;
@property (nonatomic, strong) UIView *pillContainer;
@property (nonatomic, strong) LAUIPearlGlyphView *glyphView;
@property (nonatomic, strong) NSTimer *dismissTimer;
+ (instancetype)sharedInstance;
- (void)showScanning;
- (void)showSuccess;
- (void)showFailure;
- (void)collapse;
@end

@implementation NativeIslandGlyphController

+ (instancetype)sharedInstance {
    static NativeIslandGlyphController *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[NativeIslandGlyphController alloc] init];
    });
    return inst;
}

- (void)setupNativeGlyphIfNeeded {
    if (self.glyphWindow) return;

    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.glyphWindow = [[UIWindow alloc] initWithFrame:screenBounds];
    self.glyphWindow.windowLevel = UIWindowLevelStatusBar + 600.0;
    self.glyphWindow.backgroundColor = [UIColor clearColor];
    self.glyphWindow.userInteractionEnabled = NO;
    self.glyphWindow.hidden = NO;

    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            self.glyphWindow.windowScene = (UIWindowScene *)scene;
            break;
        }
    }

    CGFloat topY = posEnabled ? yPos : 20.5;
    CGFloat baseW = 126.0;
    CGFloat baseH = 37.0;

    self.pillContainer = [[UIView alloc] initWithFrame:CGRectMake((screenBounds.size.width - baseW) / 2.0, topY, baseW, baseH)];
    self.pillContainer.backgroundColor = [UIColor blackColor];
    self.pillContainer.layer.cornerRadius = baseH / 2.0;
    self.pillContainer.layer.cornerCurve = kCACornerCurveContinuous;
    self.pillContainer.clipsToBounds = YES;
    self.pillContainer.alpha = 0.0;
    [self.glyphWindow addSubview:self.pillContainer];

    // Khởi tạo LAUIPearlGlyphView bằng cấu hình SystemAperture từ cache
    Class configClass = %c(LAUIPearlGlyphStaticConfiguration);
    id saConfig = nil;
    if ([configClass respondsToSelector:@selector(createSystemApertureConfiguration)]) {
        saConfig = [configClass createSystemApertureConfiguration];
    } else if ([configClass respondsToSelector:@selector(createDefaultConfiguration)]) {
        saConfig = [configClass createDefaultConfiguration];
    }

    Class glyphClass = %c(LAUIPearlGlyphView);
    if (saConfig && [glyphClass instancesRespondToSelector:@selector(initWithConfiguration:)]) {
        self.glyphView = [[glyphClass alloc] initWithConfiguration:saConfig];
    } else {
        self.glyphView = [[glyphClass alloc] initWithFrame:CGRectMake(0, 0, 76, 76)];
    }

    self.glyphView.frame = CGRectMake(0, 0, 76, 76);
    self.glyphView.center = CGPointMake(baseW / 2.0, baseH / 2.0);
    self.glyphView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    [self.glyphView setFeedbackEnabled:YES];
    [self.pillContainer addSubview:self.glyphView];
}

@implementation NativeIslandGlyphController

+ (instancetype)sharedInstance {
    static NativeIslandGlyphController *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[NativeIslandGlyphController alloc] init];
    });
    return inst;
}

- (void)setupNativeGlyphIfNeeded {
    if (self.glyphWindow) return;

    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.glyphWindow = [[UIWindow alloc] initWithFrame:screenBounds];
    self.glyphWindow.windowLevel = UIWindowLevelStatusBar + 600.0;
    self.glyphWindow.backgroundColor = [UIColor clearColor];
    self.glyphWindow.userInteractionEnabled = NO;
    self.glyphWindow.hidden = NO;

    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            self.glyphWindow.windowScene = (UIWindowScene *)scene;
            break;
        }
    }

    CGFloat topY = posEnabled ? yPos : [Model defaultIslandYOffset];
    CGFloat baseW = 126.0;
    CGFloat baseH = 37.0;

    self.pillContainer = [[UIView alloc] initWithFrame:CGRectMake((screenBounds.size.width - baseW) / 2.0, topY, baseW, baseH)];
    self.pillContainer.backgroundColor = [UIColor blackColor];
    self.pillContainer.layer.cornerRadius = baseH / 2.0;
    self.pillContainer.layer.cornerCurve = kCACornerCurveContinuous;
    self.pillContainer.clipsToBounds = YES;
    self.pillContainer.alpha = 0.0;
    [self.glyphWindow addSubview:self.pillContainer];

    Class configClass = %c(LAUIPearlGlyphStaticConfiguration);
    id saConfig = nil;
    if ([configClass respondsToSelector:@selector(createSystemApertureConfiguration)]) {
        saConfig = [configClass createSystemApertureConfiguration];
    } else if ([configClass respondsToSelector:@selector(createDefaultConfiguration)]) {
        saConfig = [configClass createDefaultConfiguration];
    }

    Class glyphClass = %c(LAUIPearlGlyphView);
    if (saConfig && [glyphClass instancesRespondToSelector:@selector(initWithConfiguration:)]) {
        self.glyphView = [[glyphClass alloc] initWithConfiguration:saConfig];
    } else {
        self.glyphView = [[glyphClass alloc] initWithFrame:CGRectMake(0, 0, 76, 76)];
    }

    self.glyphView.frame = CGRectMake(0, 0, 76, 76);
    self.glyphView.center = CGPointMake(baseW / 2.0, baseH / 2.0);
    self.glyphView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    [self.glyphView setFeedbackEnabled:YES];
    [self.pillContainer addSubview:self.glyphView];
}

- (void)showScanning {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupNativeGlyphIfNeeded];
        [self.dismissTimer invalidate];

        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGFloat topY = posEnabled ? yPos : [Model defaultIslandYOffset];
        CGFloat expandedW = 126.0;
        CGFloat expandedH = 80.0;

        [self.glyphView setFaceVisibility:YES animated:YES];
        if ([self.glyphView respondsToSelector:@selector(setPaused:)]) {
            [(id)self.glyphView setPaused:NO];
        }
        [self.glyphView setState:1 animated:YES withCompletion:nil];

        [UIView animateWithDuration:0.32 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.8 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.pillContainer.alpha = 1.0;
            self.pillContainer.frame = CGRectMake((screenBounds.size.width - expandedW) / 2.0, topY, expandedW, expandedH);
            self.pillContainer.layer.cornerRadius = 38.0;
            self.glyphView.center = CGPointMake(expandedW / 2.0, expandedH / 2.0);
            self.glyphView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        } completion:nil];

        self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(collapse) userInfo:nil repeats:NO];
    });
}

- (void)showSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupNativeGlyphIfNeeded];
        [self.dismissTimer invalidate];

        if ([self.glyphView respondsToSelector:@selector(setPaused:)]) {
            [(id)self.glyphView setPaused:NO];
        }
        [self.glyphView setState:2 animated:YES withCompletion:nil];

        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.glyphView.transform = CGAffineTransformMakeScale(1.15, 1.15);
        } completion:nil];

        self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(collapse) userInfo:nil repeats:NO];
    });
}

- (void)showFailure {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupNativeGlyphIfNeeded];
        [self.dismissTimer invalidate];

        [self.glyphView setState:3 animated:YES withCompletion:nil];

        CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        shake.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        shake.duration = 0.45;
        shake.values = @[@(-10), @(10), @(-8), @(8), @(-4), @(4), @(0)];
        [self.pillContainer.layer addAnimation:shake forKey:@"shake"];

        self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(collapse) userInfo:nil repeats:NO];
    });
}

- (void)collapse {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGFloat topY = posEnabled ? yPos : [Model defaultIslandYOffset];
        CGFloat baseW = 126.0;
        CGFloat baseH = 37.0;

        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.glyphView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            self.pillContainer.frame = CGRectMake((screenBounds.size.width - baseW) / 2.0, topY, baseW, baseH);
            self.pillContainer.layer.cornerRadius = baseH / 2.0;
            self.glyphView.center = CGPointMake(baseW / 2.0, baseH / 2.0);
            self.pillContainer.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.glyphView setState:0 animated:NO withCompletion:nil];
            }
        }];
    });
}

@end
====================================
// HOOK HỆ THỐNG GỐC KÍCH HOẠT HIỆU ỨNG (MÀN HÌNH KHÓA + IN-APP + PASSCODE)
// ============================================================================

%hook SBFMobileKeyBag
- (BOOL)hasPearl {
    return YES;
}
%end

%hook SBUIBiometricResource
- (BOOL)hasPearlSupport {
    return YES;
}
- (BOOL)isPearlDetectEnabled {
    return YES;
}
- (void)_notifyObserversOfEvent:(unsigned long long)event {
    %orig;
    // Chạm vân tay / quét camera -> Kích hoạt quét trên đảo
    if (event == 1 || event == 2 || event == 12 || event == 13) {
        [[NativeIslandGlyphController sharedInstance] showScanning];
    } 
    // Khớp khuôn mặt / Khớp vân tay (Touch ID) / Tweak mở khoá / Thanh toán thành công
    else if (event == 3 || event == 4 || event == 14 || event == 15) {
        [[NativeIslandGlyphController sharedInstance] showSuccess];
    } 
    // Thất bại
    else if (event == 9 || event == 10 || event == 11) {
        [[NativeIslandGlyphController sharedInstance] showFailure];
    }
}
%end

// 1. Mở khóa màn hình khóa
%hook SBLockScreenManager
- (void)_finishUIUnlockFromSource:(int)source withOptions:(id)options {
    [[NativeIslandGlyphController sharedInstance] showSuccess];
    %orig;
}

- (BOOL)unlockUIFromSource:(int)source withOptions:(id)options {
    BOOL res = %orig;
    if (res) {
        [[NativeIslandGlyphController sharedInstance] showSuccess];
    }
    return res;
}

- (void)lockUIFromSource:(int)source withOptions:(id)options {
    %orig;
    [[NativeIslandGlyphController sharedInstance] showScanning];
}
%end

// 2. Đồng bộ icon khóa trên màn hình khóa (Visage / Camera tweaks)
%hook SBUIProudLockIconView
- (void)setState:(NSInteger)state animated:(BOOL)animated {
    %orig;
    if (state == 1) {
        [[NativeIslandGlyphController sharedInstance] showScanning];
    } else if (state == 2) {
        [[NativeIslandGlyphController sharedInstance] showSuccess];
    }
}
%end

// 3. SỬA LỖI IN-APP: Bắt xác thực trong App (Ảnh ẩn/xóa, App Store, Apple Pay, Mật khẩu Keychain)
%hook SBBiometricMonitorPearlDataSource
- (void)_setMatching:(BOOL)matching {
    %orig;
    if (matching) {
        [[NativeIslandGlyphController sharedInstance] showScanning];
    }
}

- (void)device:(id)device pearlEventOccurred:(long long)event {
    %orig;
    if (event == 1) {
        // App bắt đầu gọi quét Face ID / Vân tay
        [[NativeIslandGlyphController sharedInstance] showScanning];
    } else if (event == 4) {
        // App xác thực thành công (Mở mục ẩn, mua hàng thành công)
        [[NativeIslandGlyphController sharedInstance] showSuccess];
    } else if (event == 8 || event == 9) {
        // Thất bại trong app
        [[NativeIslandGlyphController sharedInstance] showFailure];
    }
}
%end

// 4. SỬA LỖI VUỐT LÊN NHẬP MẬT MÃ: Face ID xoay ngay khi bàn phím số hiện ra
%hook SBUIPasscodeBiometricAuthenticationView
- (void)setBiometricAuthenticationState:(NSInteger)state animated:(BOOL)animated {
    %orig;
    if (state != 0) {
        [[NativeIslandGlyphController sharedInstance] showScanning];
    }
}
%end

%hook SBLockScreenBiometricAuthenticationCoordinator
- (void)biometricResource:(id)resource observeEvent:(unsigned long long)event {
    %orig;
    if (event == 4 || event == 3) {
        [[NativeIslandGlyphController sharedInstance] showSuccess];
    } else if (event == 1 || event == 2 || event == 13) {
        [[NativeIslandGlyphController sharedInstance] showScanning];
    }
}
%end

// ============================================================================
// GIỮ NGUYÊN HOÀN TOÀN TẤT CẢ CÁC HOOK CỦA VISIBLEISLAND
// ============================================================================
%hook SBSystemApertureWindow

- (void)layoutSubviews {
    %orig;
    if (scaleEnabled && fixEnabled) {
        self.transform = CGAffineTransformMakeScale(scale, scale);
        NSString *deviceModel = [Model deviceModel];
        if ([deviceModel isEqualToString:@"iPhone10,3"]) { //X
            %orig;
            CGFloat SyPos = 20.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone10,6"]) { //X
            %orig;
            CGFloat SyPos = 20.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone11,2"]) { //XS
            %orig;
            CGFloat SyPos = 20.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone12,3"]) { //11 Pro
            %orig;
            CGFloat SyPos = 20.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone11,6"]) { //XS Max FAKE OFFSETS??
            %orig;
            CGFloat SyPos = 22.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone12,5"]) { //11 Pro Max FAKE OFFSTES??
            %orig;
            CGFloat SyPos = 22.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone11,8"]) { //XR FIND OFFSETS - USING ESTIMATED
            %orig;
            CGFloat SyPos = 22.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone12,1"]) { //11 FIND OFFSETS - USING ESTIMATED
            %orig;
            CGFloat SyPos = 22.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,2"]) { //12 FIND OFFSETS - USING ESTIMATED
            %orig;
            CGFloat SyPos = 21.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,3"]) { //12 Pro FIND OFFSETS - USING ESTIMATED
            %orig;
            CGFloat SyPos = 21.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,1"]) { //12 Mini FIND OFFSETS - USING ESTIMATED
            %orig;
            CGFloat SyPos = 19.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,4"]) { //12 Pro Max FIND OFFSETS - USING ESTIMATED
            %orig;
            CGFloat SyPos = 22.3 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,5"]) { //13
            %orig;
            CGFloat SyPos = 24 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,2"]) { //13 Pro
            %orig;
            CGFloat SyPos = 24 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,7"]) { //14
            %orig;
            CGFloat SyPos = 24 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,4"]) { //13 Mini FAKE OFFSETS??
            %orig;
            CGFloat SyPos = 22.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,3"]) { //13 Pro Max FAKE OFFSETS??
            %orig;
            CGFloat SyPos = 26 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        }
    } else if (scaleEnabled && posEnabled) {
        self.transform = CGAffineTransformMakeScale(scale, scale);
        %orig;
        CGFloat SyPos = yPos / scale;
        CGRect frame = self.frame;
        frame.origin.y = SyPos;
        if (xPos > 0) {
            CGFloat SxPos = xPos / scale;
            frame.origin.x = SxPos;
        }
        self.frame = frame;
    } else if (fixEnabled && !scaleEnabled) {
        NSString *deviceModel = [Model deviceModel];
        if ([deviceModel isEqualToString:@"iPhone10,3"]) { //X
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 20.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone10,6"]) { //X
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 20.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone11,2"]) { //XS
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 20.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone12,3"]) { //11 Pro
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 20.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone11,6"]) { //XS Max FAKE OFFSETS??
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 22.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone12,5"]) { //11 Pro Max FAKE OFFSTES??
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 22.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone11,8"]) { //XR FIND OFFSETS - USING ESTIMATED
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 22.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone12,1"]) { //11 FIND OFFSETS - USING ESTIMATED
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 22.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,2"]) { //12 FIND OFFSETS - USING ESTIMATED
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 21.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,3"]) { //12 Pro FIND OFFSETS - USING ESTIMATED
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 21.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,1"]) { //12 Mini FIND OFFSETS - USING ESTIMATED
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 19.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,4"]) { //12 Pro Max FIND OFFSETS - USING ESTIMATED
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 22.3;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,5"]) { //13
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 24;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,2"]) { //13 Pro
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 24;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,7"]) { //14
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 24;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,4"]) { //13 Mini FAKE OFFSETS??
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 22.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,3"]) { //13 Pro Max FAKE OFFSETS??
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 26;
            self.frame = frame;
        }
    } else if (posEnabled && !scaleEnabled) {
        %orig;
        CGRect frame = self.frame;
        frame.origin.y = yPos;
        frame.origin.x = xPos;
        self.frame = frame;
    } else if (scaleEnabled && !posEnabled | scaleEnabled && !fixEnabled) {
        self.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

%end

%hook _SBSystemApertureMagiciansCurtainView

-(void)didMoveToWindow {
    if (fixEnabled) {
        self.hidden = YES;
    } else if (posEnabled) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}

%end

%hook _SBGainMapView

- (void)didMoveToWindow {
    if (hideEnabled) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }
}

%end

%hook _SBSystemApertureContainerViewContentView

- (void)layoutSubviews {
    UIColor *backgroundColor = [self backgroundColor];
    if (colorEnabled) {
        if (!backgroundColor) {
            UIColor *customColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:alpha];
            [self setBackgroundColor:customColor];
        }
    }
    %orig;
}

%end

%hook SBFTouchPassThroughView

- (void)layoutSubviews {
    %orig;
    if (transEnabled) {
        if (self.subviews.count == 4) {
            UIView *targetSubview = self.subviews[2];
            if (targetSubview.alpha == 1.0 && targetSubview.userInteractionEnabled == 0) {
                targetSubview.alpha = alpha;
            }
        }
    } if (lineDisabled) {
        if (self.subviews.count == 4) {
            UIView *lineView = self.subviews[1];
            if (lineView.alpha == 1.0 && lineView.userInteractionEnabled == 0) {
                lineView.hidden = YES;
            }
        }
    }
}

%end

%hook SBBannerWindow

- (CGRect)frame {
    if (notificationFix) {
        NSString *deviceModel = [Model deviceModel];
        if ([deviceModel isEqualToString:@"iPhone10,3"]) { //X
            %orig;
            return CGRectMake(0, 35, 375, 812);
        } else if ([deviceModel isEqualToString:@"iPhone10,6"]) { //X
            %orig;
            return CGRectMake(0, 35, 375, 812);
        } else if ([deviceModel isEqualToString:@"iPhone11,2"]) { //XS
            %orig;
            return CGRectMake(0, 35, 375, 812);
        } else if ([deviceModel isEqualToString:@"iPhone12,3"]) { //11 Pro
            %orig;
            return CGRectMake(0, 35, 375, 812);
        } else if ([deviceModel isEqualToString:@"iPhone11,6"]) { //XS Max
            %orig;
            return CGRectMake(0, 37, 414, 896);
        } else if ([deviceModel isEqualToString:@"iPhone12,5"]) { //11 Pro Max
            %orig;
            return CGRectMake(0, 37, 414, 896);
        } else if ([deviceModel isEqualToString:@"iPhone11,8"]) { //XR
            %orig;
            return CGRectMake(0, 37, 414, 896);
        } else if ([deviceModel isEqualToString:@"iPhone12,1"]) { //11
            %orig;
            return CGRectMake(0, 37, 414, 896);
        } else if ([deviceModel isEqualToString:@"iPhone13,2"]) { //12
            %orig;
            return CGRectMake(0, 35, 390, 844);
        } else if ([deviceModel isEqualToString:@"iPhone13,3"]) { //12 Pro
            %orig;
            return CGRectMake(0, 35, 390, 844);
        } else if ([deviceModel isEqualToString:@"iPhone13,1"]) { //12 Mini
            %orig;
            return CGRectMake(0, 33, 360, 780);
        } else if ([deviceModel isEqualToString:@"iPhone13,4"]) { //12 Pro Max
            %orig;
            return CGRectMake(0, 38, 428, 926);
        } else if ([deviceModel isEqualToString:@"iPhone14,5"]) { //13
            %orig;
            return CGRectMake(0, 40, 390, 844);
        } else if ([deviceModel isEqualToString:@"iPhone14,2"]) { //13 Pro
            %orig;
            return CGRectMake(0, 40, 390, 844);
        } else if ([deviceModel isEqualToString:@"iPhone14,7"]) { //14
            %orig;
            return CGRectMake(0, 40, 390, 844);
        } else if ([deviceModel isEqualToString:@"iPhone14,4"]) { //13 Mini
            %orig;
            return CGRectMake(0, 38, 360, 780);
        } else if ([deviceModel isEqualToString:@"iPhone14,3"]) { //13 Pro Max
            %orig;
            return CGRectMake(0, 42, 428, 926);
        }
    } else if (notEnabled) {
        NSString *deviceModel = [Model deviceModel];
        if ([deviceModel isEqualToString:@"iPhone10,3"]) { //X
            %orig;
            return CGRectMake(xNot, yNot, 375, 812);
        } else if ([deviceModel isEqualToString:@"iPhone10,6"]) { //X
            %orig;
            return CGRectMake(xNot, yNot, 375, 812);
        } else if ([deviceModel isEqualToString:@"iPhone11,2"]) { //XS
            %orig;
            return CGRectMake(xNot, yNot, 375, 812);
        } else if ([deviceModel isEqualToString:@"iPhone12,3"]) { //11 Pro
            %orig;
            return CGRectMake(xNot, yNot, 375, 812);
        } else if ([deviceModel isEqualToString:@"iPhone11,6"]) { //XS Max
            %orig;
            return CGRectMake(xNot, yNot, 414, 896);
        } else if ([deviceModel isEqualToString:@"iPhone12,5"]) { //11
            %orig;
            return CGRectMake(xNot, yNot, 414, 896);
        } else if ([deviceModel isEqualToString:@"iPhone11,8"]) { //XR
            %orig;
            return CGRectMake(xNot, yNot, 414, 896);
        } else if ([deviceModel isEqualToString:@"iPhone12,1"]) { //11
            %orig;
            return CGRectMake(xNot, yNot, 414, 896);
        } else if ([deviceModel isEqualToString:@"iPhone13,2"]) { //12
            %orig;
            return CGRectMake(xNot, yNot, 390, 844);
        } else if ([deviceModel isEqualToString:@"iPhone13,3"]) { //12 Pro
            %orig;
            return CGRectMake(xNot, yNot, 390, 844);
        } else if ([deviceModel isEqualToString:@"iPhone13,1"]) { //12 Mini
            %orig;
            return CGRectMake(xNot, yNot, 360, 780);
        } else if ([deviceModel isEqualToString:@"iPhone13,4"]) { //12 Pro Max
            %orig;
            return CGRectMake(xNot, yNot, 428, 926);
        } else if ([deviceModel isEqualToString:@"iPhone14,5"]) { //13
            %orig;
            return CGRectMake(xNot, yNot, 390, 844);
        } else if ([deviceModel isEqualToString:@"iPhone14,2"]) { //13 Pro
            %orig;
            return CGRectMake(xNot, yNot, 390, 844);
        } else if ([deviceModel isEqualToString:@"iPhone14,7"]) { //14
            %orig;
            return CGRectMake(xNot, yNot, 390, 844);
        } else if ([deviceModel isEqualToString:@"iPhone14,4"]) { //13 Mini
            %orig;
            return CGRectMake(xNot, yNot, 360, 780);
        } else if ([deviceModel isEqualToString:@"iPhone14,3"]) { //13 Pro Max
            %orig;
            return CGRectMake(xNot, yNot, 428, 926);
        }
    }
    return %orig;
}

- (void)setFrame:(CGRect)frame {
    if (notificationFix) {
        NSString *deviceModel = [Model deviceModel];
        if ([deviceModel isEqualToString:@"iPhone10,3"]) { //X
            %orig(CGRectMake(0, 35, 375, 812));
        } else if ([deviceModel isEqualToString:@"iPhone10,6"]) { //X
            %orig(CGRectMake(0, 35, 375, 812));
        } else if ([deviceModel isEqualToString:@"iPhone11,2"]) { //XS
            %orig(CGRectMake(0, 35, 375, 812));
        } else if ([deviceModel isEqualToString:@"iPhone12,3"]) { //11 Pro
            %orig(CGRectMake(0, 35, 375, 812));
        } else if ([deviceModel isEqualToString:@"iPhone11,6"]) { //XS Max
            %orig(CGRectMake(0, 37, 414, 896));
        } else if ([deviceModel isEqualToString:@"iPhone12,5"]) { //11 Pro Max
            %orig(CGRectMake(0, 37, 414, 896));
        } else if ([deviceModel isEqualToString:@"iPhone11,8"]) { //XR
            %orig(CGRectMake(0, 37, 414, 896));
        } else if ([deviceModel isEqualToString:@"iPhone12,1"]) { //11
            %orig(CGRectMake(0, 37, 414, 896));
        } else if ([deviceModel isEqualToString:@"iPhone13,2"]) { //12
            %orig(CGRectMake(0, 35, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone13,3"]) { //12 Pro
            %orig(CGRectMake(0, 35, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone13,1"]) { //12 Mini
            %orig(CGRectMake(0, 33, 360, 780));
        } else if ([deviceModel isEqualToString:@"iPhone13,4"]) { //12 Pro Max
            %orig(CGRectMake(0, 38, 428, 926));
        } else if ([deviceModel isEqualToString:@"iPhone14,5"]) { //13
            %orig(CGRectMake(0, 40, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone14,2"]) { //13 Pro
            %orig(CGRectMake(0, 40, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone14,7"]) { //14
            %orig(CGRectMake(0, 40, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone14,4"]) { //13 Mini
            %orig(CGRectMake(0, 38, 360, 780));
        } else if ([deviceModel isEqualToString:@"iPhone14,3"]) { //13 Pro Max
            %orig(CGRectMake(0, 42, 428, 926));
        }
    } else if (notEnabled) {
        NSString *deviceModel = [Model deviceModel];
        if ([deviceModel isEqualToString:@"iPhone10,3"]) { //X
            %orig;
            %orig(CGRectMake(xNot, yNot, 375, 812));
        } else if ([deviceModel isEqualToString:@"iPhone10,6"]) { //X
            %orig;
            %orig(CGRectMake(xNot, yNot, 375, 812));
        } else if ([deviceModel isEqualToString:@"iPhone11,2"]) { //XS
            %orig;
            %orig(CGRectMake(xNot, yNot, 375, 812));
        } else if ([deviceModel isEqualToString:@"iPhone12,3"]) { //11 Pro
            %orig;
            %orig(CGRectMake(xNot, yNot, 375, 812));
        } else if ([deviceModel isEqualToString:@"iPhone11,6"]) { //XS Max
            %orig;
            %orig(CGRectMake(xNot, yNot, 414, 896));
        } else if ([deviceModel isEqualToString:@"iPhone12,5"]) { //11 Pro Max
            %orig;
            %orig(CGRectMake(xNot, yNot, 414, 896));
        } else if ([deviceModel isEqualToString:@"iPhone11,8"]) { //XR
            %orig;
            %orig(CGRectMake(xNot, yNot, 414, 896));
        } else if ([deviceModel isEqualToString:@"iPhone12,1"]) { //11
            %orig;
            %orig(CGRectMake(xNot, yNot, 414, 896));
        } else if ([deviceModel isEqualToString:@"iPhone13,2"]) { //12
            %orig;
            %orig(CGRectMake(xNot, yNot, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone13,3"]) { //12 Pro
            %orig;
            %orig(CGRectMake(xNot, yNot, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone13,1"]) { //12 Mini
            %orig;
            %orig(CGRectMake(xNot, yNot, 360, 780));
        } else if ([deviceModel isEqualToString:@"iPhone13,4"]) { //12 Pro Max
            %orig;
            %orig(CGRectMake(xNot, yNot, 428, 926));
        } else if ([deviceModel isEqualToString:@"iPhone14,5"]) { //13
            %orig;
            %orig(CGRectMake(xNot, yNot, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone14,2"]) { //13 Pro
            %orig;
            %orig(CGRectMake(xNot, yNot, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone14,7"]) { //14
            %orig(CGRectMake(xNot, yNot, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone14,4"]) { //13 Mini
            %orig;
            %orig(CGRectMake(xNot, yNot, 360, 780));
        } else if ([deviceModel isEqualToString:@"iPhone14,3"]) { //13 Pro Max
            %orig;
            %orig(CGRectMake(xNot, yNot, 428, 926));
        }
    } else {
        %orig(frame);
    }
}

%end

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

void preferencesChanged(){
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.ethxnn88.visibleislandprefs"];

    fixEnabled = (prefs && [prefs objectForKey:@"fixEnabled"] ? [[prefs valueForKey:@"fixEnabled"] boolValue] : NO );
    islandEnabled = (prefs && [prefs objectForKey:@"islandEnabled"] ? [[prefs valueForKey:@"islandEnabled"] boolValue] : NO );
    posEnabled = (prefs && [prefs objectForKey:@"posEnabled"] ? [[prefs valueForKey:@"posEnabled"] boolValue] : NO );
    hideEnabled = (prefs && [prefs objectForKey:@"hideEnabled"] ? [[prefs valueForKey:@"hideEnabled"] boolValue] : NO );
    notificationFix = (prefs && [prefs objectForKey:@"notificationFix"] ? [[prefs valueForKey:@"notificationFix"] boolValue] : NO );
    notEnabled = (prefs && [prefs objectForKey:@"notEnabled"] ? [[prefs valueForKey:@"notEnabled"] boolValue] : NO );
    colorEnabled = (prefs && [prefs objectForKey:@"colorEnabled"] ? [[prefs valueForKey:@"colorEnabled"] boolValue] : NO );
    transEnabled = (prefs && [prefs objectForKey:@"transEnabled"] ? [[prefs valueForKey:@"transEnabled"] boolValue] : NO );
    scaleEnabled = (prefs && [prefs objectForKey:@"scaleEnabled"] ? [[prefs valueForKey:@"scaleEnabled"] boolValue] : NO );
    lineDisabled = (prefs && [prefs objectForKey:@"lineDisabled"] ? [[prefs valueForKey:@"lineDisabled"] boolValue] : NO );
    xPos = [[prefs objectForKey:@"xPos"] floatValue];
    yPos = [[prefs objectForKey:@"yPos"] floatValue];
    xNot = [[prefs objectForKey:@"xNot"] floatValue];
    yNot = [[prefs objectForKey:@"yNot"] floatValue];
    red = [[prefs objectForKey:@"red"] floatValue];
    green = [[prefs objectForKey:@"green"] floatValue];
    blue = [[prefs objectForKey:@"blue"] floatValue];
    alpha = [[prefs objectForKey:@"alpha"] floatValue];
    scale = [[prefs objectForKey:@"scale"] floatValue];
}

// Hàm nhận tín hiệu kích hoạt Face ID từ App / Daemon bên ngoài truyền về SpringBoard
static void handleExternalFaceIDTrigger(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if (CFEqual(name, CFSTR("com.ethxnn88.visibleisland.scanning"))) {
        [[NativeIslandGlyphController sharedInstance] showScanning];
    } else if (CFEqual(name, CFSTR("com.ethxnn88.visibleisland.success"))) {
        [[NativeIslandGlyphController sharedInstance] showSuccess];
    } else if (CFEqual(name, CFSTR("com.ethxnn88.visibleisland.failure"))) {
        [[NativeIslandGlyphController sharedInstance] showFailure];
    }
}

%ctor {
    preferencesChanged();

    // Lắng nghe cập nhật Preferences
    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        (CFNotificationCallback)preferencesChanged,
        CFSTR("com.ethxnn88.visibleislandprefs-updated"),
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );

    NSString *bundleID = [NSBundle mainBundle].bundleIdentifier;

    // Chỉ đăng ký điều khiển UI và nhận lệnh điều phối bên trong SpringBoard
    if ([bundleID isEqualToString:@"com.apple.springboard"]) {
        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            NULL,
            respring,
            CFSTR("com.ethxnn88.visibleislandprefs-respring"),
            NULL,
            CFNotificationSuspensionBehaviorCoalesce
        );

        // Lắng nghe các sự kiện Face ID từ App Store / Apple Pay / Mục ẩn truyền về SpringBoard
        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            NULL,
            handleExternalFaceIDTrigger,
            CFSTR("com.ethxnn88.visibleisland.scanning"),
            NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately
        );

        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            NULL,
            handleExternalFaceIDTrigger,
            CFSTR("com.ethxnn88.visibleisland.success"),
            NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately
        );

        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            NULL,
            handleExternalFaceIDTrigger,
            CFSTR("com.ethxnn88.visibleisland.failure"),
            NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately
        );
    }
}
