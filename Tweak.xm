#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioServices.h>
#import <sys/sysctl.h>
#import <notify.h>

// ============================================================================
// CẤU HÌNH BIẾN TOÀN CỤC CỦA VISIBLEISLAND
// ============================================================================
static CGFloat red = 0.0;
static CGFloat green = 0.0;
static CGFloat blue = 0.0;
static CGFloat alpha = 1.0;

static CGFloat scale = 1.0;

static CGFloat xPos = 0;
static CGFloat yPos = 20.5;
static CGFloat xNot = 0.0;
static CGFloat yNot = 40;

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
// INTERFACES NATIVE PHÁT HIỆN TỪ CACHE CRYPTEX (ĐÃ ĐẦY ĐỦ - KHÔNG TRÙNG)
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

@interface SAAssertion : NSObject
- (void)invalidateWithReason:(id)arg1;
@end

@interface SAElement : NSObject
- (NSString *)clientIdentifier;
- (NSString *)elementIdentifier;
@end

// Provider điều phối hiệu ứng mở rộng khóa/Face ID trên Dynamic Island iOS 16
@interface SBLockElementViewProvider : NSObject
@property (assign, nonatomic) BOOL allowsBioUnlock;
@property (assign, nonatomic) BOOL isAuthenticated;
- (BOOL)_allowsBiometricUnlock;
- (void)_updateAllowsBioUnlock;
- (void)handleBiometricEvent:(unsigned long long)event;
- (void)biometricResource:(id)resource observeEvent:(unsigned long long)event;
- (void)setAuthenticated:(BOOL)authenticated;
@end

@interface SBSystemApertureSceneElement : NSObject
- (BOOL)isBiometricKit;
@end

@interface SBPearlInterstitialsElement : NSObject
- (BOOL)isAuthenticating;
- (void)setAuthenticating:(BOOL)arg1;
- (void)setBiometricEvent:(unsigned long long)arg1;
@end

@interface SBSystemAperturePearlAuthenticatingElement : NSObject
+ (instancetype)sharedInstance;
- (void)activate;
- (void)deactivate;
- (void)setBioEvent:(unsigned long long)arg1;
- (void)setBiometricEvent:(unsigned long long)arg1;
- (BOOL)isAuthenticating;
- (UIView *)elementView;
@end

@interface SBSystemApertureController : NSObject
+ (id)sharedInstance;
- (BOOL)isPearlAvailable;
- (BOOL)isPearlActive;
- (BOOL)isElementReady:(id)arg1;
- (id)acquireAssertionForReason:(id)arg1;
- (void)registerElement:(id)arg1;
- (void)element:(id)arg1 visibilityChanged:(BOOL)visible;
- (id)activePearlElement;
@end

@interface SBUIBiometricResource : NSObject
+ (id)sharedInstance;
- (BOOL)hasPearlSupport;
- (BOOL)isPearlDetectEnabled;
- (BOOL)isPearlAvailableForSystemAperture;
- (BOOL)isPearlDetectDesired;
- (BOOL)hasBiometricAuthenticationCapabilityMatchingType:(long long)arg1;
- (void)_notifyObserversOfEvent:(unsigned long long)event;
- (void)noteScreenWillTurnOn;
@end

@interface SBLockScreenManager : NSObject
+ (id)sharedInstance;
- (BOOL)isUILocked;
- (void)_finishUIUnlockFromSource:(int)source withOptions:(id)options;
- (BOOL)unlockUIFromSource:(int)source withOptions:(id)options;
- (void)lockUIFromSource:(int)source withOptions:(id)options;
@end

@interface SBUIProudLockIconView : UIView
- (void)setState:(NSInteger)state animated:(BOOL)animated;
@end

@interface SBBiometricMonitorPearlDataSource : NSObject
- (BOOL)isPosePresenceDetected;
- (void)_setMatching:(BOOL)arg1;
- (void)device:(id)arg1 pearlEventOccurred:(long long)arg2;
@end

@interface SBUIPasscodeBiometricAuthenticationView : UIView
- (void)setBiometricAuthenticationState:(NSInteger)state animated:(BOOL)animated;
@end

@interface SBLockScreenBiometricAuthenticationCoordinator : NSObject
- (void)biometricResource:(id)resource observeEvent:(unsigned long long)event;
- (void)_handleBiometricEvent:(unsigned long long)event;
@end

@interface SBFMobileKeyBag : NSObject
- (BOOL)hasPearl;
@end

@interface BSPlatform : NSObject
- (NSInteger)homeButtonType;
@end

@interface CSCoverSheetViewController : UIViewController
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
// HOOK HỆ THỐNG GỐC: ÉP BẬT GIAO DIỆN DYNAMIC ISLAND PEARL GỐC CỦA IOS 16
// (NHẬN DIỆN TOUCH ID VÂN TAY + FACE ID TWEAK + IN-APP)
// ============================================================================

static SBLockElementViewProvider *activeLockElementProvider = nil;
static BOOL isHandlingBioEvent = NO;

// 1. Ép định tuyến SpringBoard & nắm giữ instance Provider của Dynamic Island
%hook SBLockElementViewProvider

- (id)init {
    id orig = %orig;
    activeLockElementProvider = orig;
    return orig;
}

- (BOOL)_allowsBiometricUnlock {
    return YES;
}

- (BOOL)allowsBioUnlock {
    return YES;
}

%end

// Ép nhận diện Element sinh trắc học của Dynamic Island
%hook SBSystemApertureSceneElement
- (BOOL)isBiometricKit {
    return YES;
}
%end

// Ép hệ thống nhận diện cờ điều hướng tràn viền (Gesture), bỏ khóa cứng Home Button
%hook BSPlatform
- (NSInteger)homeButtonType {
    return 2; // HomeButtonTypeNone (iPhone X / 14 Pro style)
}
%end

// 2. Ép phần cứng và xử lý mọi sự kiện Vân tay (Touch ID) lẫn Face ID
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
- (BOOL)isPearlAvailableForSystemAperture {
    return YES;
}
- (BOOL)isPearlDetectDesired {
    return YES;
}
- (BOOL)hasBiometricAuthenticationCapabilityMatchingType:(long long)arg1 {
    return YES;
}

- (void)_notifyObserversOfEvent:(unsigned long long)event {
    %orig;

    if (isHandlingBioEvent) return;
    isHandlingBioEvent = YES;

    // Đẩy sự kiện trực tiếp vào Provider quản lý đảo
    if (activeLockElementProvider) {
        if ([activeLockElementProvider respondsToSelector:@selector(handleBiometricEvent:)]) {
            [activeLockElementProvider handleBiometricEvent:event];
        }
        if ([activeLockElementProvider respondsToSelector:@selector(biometricResource:observeEvent:)]) {
            [activeLockElementProvider biometricResource:self observeEvent:event];
        }
    }

    // Chạm cảm biến vân tay (Touch ID) / Tweak Face ID quét khuôn mặt
    if (event == 1 || event == 2 || event == 12 || event == 13) {
        if (activeLockElementProvider && [activeLockElementProvider respondsToSelector:@selector(setAuthenticated:)]) {
            [activeLockElementProvider setAuthenticated:NO];
        }
    }
    // Xác thực thành công (Khớp vân tay/khuôn mặt/in-app) -> Tích V + Chuông Face ID gốc
    else if (event == 3 || event == 4 || event == 14 || event == 15) {
        AudioServicesPlaySystemSound(1394);
        if (activeLockElementProvider && [activeLockElementProvider respondsToSelector:@selector(setAuthenticated:)]) {
            [activeLockElementProvider setAuthenticated:YES];
        }
    } 
    // Quét thất bại / Sai vân tay / Sai mặt -> Rung lắc đảo + Chuông lỗi gốc
    else if (event == 9 || event == 10 || event == 11) {
        AudioServicesPlaySystemSound(1395);
        if (activeLockElementProvider && [activeLockElementProvider respondsToSelector:@selector(setAuthenticated:)]) {
            [activeLockElementProvider setAuthenticated:NO];
        }
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        isHandlingBioEvent = NO;
    });
}
%end

// 3. LỖI 1: Bật nút nguồn / Mở sáng màn hình -> Bung quét ngay trên đảo
%hook CSCoverSheetViewController

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    [[%c(SBUIBiometricResource) sharedInstance] noteScreenWillTurnOn];
    if (activeLockElementProvider && [activeLockElementProvider respondsToSelector:@selector(handleBiometricEvent:)]) {
        [activeLockElementProvider handleBiometricEvent:1];
    }
}

%end

%hook SBLockScreenManager

- (void)lockUIFromSource:(int)source withOptions:(id)options {
    %orig;
    [[%c(SBUIBiometricResource) sharedInstance] noteScreenWillTurnOn];
    if (activeLockElementProvider && [activeLockElementProvider respondsToSelector:@selector(handleBiometricEvent:)]) {
        [activeLockElementProvider handleBiometricEvent:1];
    }
}

- (BOOL)unlockUIFromSource:(int)source withOptions:(id)options {
    BOOL res = %orig;
    if (res) {
        AudioServicesPlaySystemSound(1394);
        if (activeLockElementProvider) {
            if ([activeLockElementProvider respondsToSelector:@selector(setAuthenticated:)]) {
                [activeLockElementProvider setAuthenticated:YES];
            }
            if ([activeLockElementProvider respondsToSelector:@selector(handleBiometricEvent:)]) {
                [activeLockElementProvider handleBiometricEvent:4];
            }
        }
    }
    return res;
}

%end

// 4. LỖI 2: Vuốt lên gõ Passcode -> Kích hoạt quét lần 2
%hook SBUIPasscodeBiometricAuthenticationView

- (void)setBiometricAuthenticationState:(NSInteger)state animated:(BOOL)animated {
    %orig;
    if (state == 1 || state == 2) {
        [[%c(SBUIBiometricResource) sharedInstance] noteScreenWillTurnOn];
        if (activeLockElementProvider && [activeLockElementProvider respondsToSelector:@selector(handleBiometricEvent:)]) {
            [activeLockElementProvider handleBiometricEvent:1];
        }
    } else if (state == 3 || state == 0) {
        if (activeLockElementProvider && [activeLockElementProvider respondsToSelector:@selector(handleBiometricEvent:)]) {
            [activeLockElementProvider handleBiometricEvent:9];
        }
    }
}

%end

// 5. LỖI 3: Điều hướng xác thực trong App (Ảnh ẩn/xoá, Keychain, App Store, Apple Pay)
%hook SBBiometricMonitorPearlDataSource

- (BOOL)isPosePresenceDetected {
    return YES;
}

- (void)_setMatching:(BOOL)matching {
    %orig;
    if (matching && activeLockElementProvider) {
        if ([activeLockElementProvider respondsToSelector:@selector(handleBiometricEvent:)]) {
            [activeLockElementProvider handleBiometricEvent:1];
        }
    }
}

- (void)device:(id)device pearlEventOccurred:(long long)event {
    %orig;
    if (!activeLockElementProvider) return;

    if (event == 1 || event == 2) {
        if ([activeLockElementProvider respondsToSelector:@selector(handleBiometricEvent:)]) {
            [activeLockElementProvider handleBiometricEvent:1];
        }
    } else if (event == 4) {
        AudioServicesPlaySystemSound(1394);
        if ([activeLockElementProvider respondsToSelector:@selector(setAuthenticated:)]) {
            [activeLockElementProvider setAuthenticated:YES];
        }
        if ([activeLockElementProvider respondsToSelector:@selector(handleBiometricEvent:)]) {
            [activeLockElementProvider handleBiometricEvent:4];
        }
    } else if (event == 8 || event == 9) {
        AudioServicesPlaySystemSound(1395);
        if ([activeLockElementProvider respondsToSelector:@selector(setAuthenticated:)]) {
            [activeLockElementProvider setAuthenticated:NO];
        }
        if ([activeLockElementProvider respondsToSelector:@selector(handleBiometricEvent:)]) {
            [activeLockElementProvider handleBiometricEvent:9];
        }
    }
}

%end

// ============================================================================
// GIỮ NGUYÊN HOÀN TOÀN TẤT CẢ CÁC HOOK CỦA VISIBLEISLAND (BỔ SUNG CHỐNG ĐÈ LỖI 5)
// ============================================================================
%hook SBSystemApertureWindow

- (void)didMoveToWindow {
    %orig;
    // LỖI 5: Tự động ẩn đảo gốc khi bung Face ID để không bị 2 đảo đè nhau
    [[NSNotificationCenter defaultCenter] addObserverForName:@"VI_HideNativeIslandForPearl" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.alpha = 0.0;
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"VI_RestoreNativeIsland" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.0;
        }];
    }];
}

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

static void handleExternalFaceIDTrigger(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if (CFEqual(name, CFSTR("com.ethxnn88.visibleisland.scanning"))) {
        [[%c(SBUIBiometricResource) sharedInstance] noteScreenWillTurnOn];
        if (activeLockElementProvider && [activeLockElementProvider respondsToSelector:@selector(handleBiometricEvent:)]) {
            [activeLockElementProvider handleBiometricEvent:1];
        }
    } else if (CFEqual(name, CFSTR("com.ethxnn88.visibleisland.success"))) {
        AudioServicesPlaySystemSound(1394);
        if (activeLockElementProvider) {
            [activeLockElementProvider setAuthenticated:YES];
            if ([activeLockElementProvider respondsToSelector:@selector(handleBiometricEvent:)]) {
                [activeLockElementProvider handleBiometricEvent:4];
            }
        }
    } else if (CFEqual(name, CFSTR("com.ethxnn88.visibleisland.failure"))) {
        AudioServicesPlaySystemSound(1395);
        if (activeLockElementProvider) {
            [activeLockElementProvider setAuthenticated:NO];
            if ([activeLockElementProvider respondsToSelector:@selector(handleBiometricEvent:)]) {
                [activeLockElementProvider handleBiometricEvent:9];
            }
        }
    }
}

%ctor {
    preferencesChanged();

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        (CFNotificationCallback)preferencesChanged,
        CFSTR("com.ethxnn88.visibleislandprefs-updated"),
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );

    NSString *bundleID = [NSBundle mainBundle].bundleIdentifier;

    if ([bundleID isEqualToString:@"com.apple.springboard"]) {
        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            NULL,
            respring,
            CFSTR("com.ethxnn88.visibleislandprefs-respring"),
            NULL,
            CFNotificationSuspensionBehaviorCoalesce
        );

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
