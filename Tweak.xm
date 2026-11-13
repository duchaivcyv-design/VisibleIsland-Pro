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

@interface SBSystemApertureElementAuthority : NSObject
@end

@interface SBLockElementViewProvider : NSObject
@property (assign, nonatomic) BOOL allowsBioUnlock;
@property (assign, nonatomic) BOOL isAuthenticated;
- (BOOL)_allowsBiometricUnlock;
- (void)_updateAllowsBioUnlock;
- (void)handleBiometricEvent:(unsigned long long)event;
- (void)setAuthenticated:(BOOL)authenticated;
- (BOOL)hasAlertBehavior;
- (BOOL)isAlerting;
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
- (void)setAuthenticating:(BOOL)arg1; // Thêm dòng này để fix lỗi biên dịch
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
- (void)elementRequestsUpdateToPreferredLayoutMode:(id)arg1;
- (void)elementRequestsUpdateToPreferredLayoutMode:(id)arg1 forReason:(id)arg2;
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
- (void)device:(id)device pearlEventOccurred:(long long)arg2;
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
// HOOK HỆ THỐNG GỐC: AN TOÀN CHO THIẾT BỊ KHÔNG CÓ PEARL (IPHONE 8 PLUS / TOUCH ID)
// ============================================================================

static id activePearlElement = nil;
static BOOL isBioActive = NO;
static BOOL isHandlingBioEvent = NO;

// Lấy Pearl Element an toàn (tránh crash nếu class không tồn tại)
static id getPearlElement() {
    @try {
        if (activePearlElement) return activePearlElement;
        Class pearlClass = %c(SBSystemAperturePearlAuthenticatingElement);
        if (!pearlClass) return nil;
        
        if ([pearlClass respondsToSelector:@selector(sharedInstance)]) {
            activePearlElement = [pearlClass sharedInstance];
        }
        if (!activePearlElement) {
            activePearlElement = [[pearlClass alloc] init];
        }
        
        Class saControllerClass = %c(SBSystemApertureController);
        if (saControllerClass && [saControllerClass respondsToSelector:@selector(sharedInstance)]) {
            id saController = [saControllerClass sharedInstance];
            if (saController && activePearlElement) {
                if ([saController respondsToSelector:@selector(registerElement:)]) {
                    [saController registerElement:activePearlElement];
                }
            }
        }
        return activePearlElement;
    } @catch (NSException *e) {
        return nil;
    }
}

// Hàm kích hoạt an toàn với try-catch chặn đứng SIGABRT
static void triggerPearlAnimation(unsigned long long bioEvent, BOOL expanding) {
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            isBioActive = expanding;
            id pearl = getPearlElement();
            if (!pearl) return;
            
            if ([pearl respondsToSelector:@selector(activate)]) {
                [pearl activate];
            }
            if ([pearl respondsToSelector:@selector(setAuthenticating:)]) {
                [pearl setAuthenticating:expanding];
            }
            if ([pearl respondsToSelector:@selector(setBiometricEvent:)]) {
                [pearl setBiometricEvent:bioEvent];
            } else if ([pearl respondsToSelector:@selector(setBioEvent:)]) {
                [pearl setBioEvent:bioEvent];
            }
            
            UIView *eView = nil;
            if ([pearl respondsToSelector:@selector(elementView)]) {
                eView = [pearl elementView];
            }
            if ([eView isKindOfClass:[UIView class]]) {
                eView.hidden = NO;
                eView.alpha = 1.0;
                [eView setNeedsLayout];
                [eView layoutIfNeeded];
            }
            
            Class saControllerClass = %c(SBSystemApertureController);
            if (saControllerClass && [saControllerClass respondsToSelector:@selector(sharedInstance)]) {
                id saController = [saControllerClass sharedInstance];
                if (saController && [saController respondsToSelector:@selector(elementRequestsUpdateToPreferredLayoutMode:)]) {
                    [saController elementRequestsUpdateToPreferredLayoutMode:pearl];
                }
            }
        } @catch (NSException *exception) {
            // Bắt ngoại lệ để iPhone 8 Plus không bị văng Safe Mode / Crash SpringBoard
        }
    });
}

// 1. Hook an toàn cho SBSystemAperturePearlAuthenticatingElement
%hook SBSystemAperturePearlAuthenticatingElement

- (id)init {
    @try {
        id orig = %orig;
        activePearlElement = orig;
        return orig;
    } @catch (NSException *e) {
        return %orig;
    }
}

- (BOOL)isAuthenticating {
    @try {
        return isBioActive ? YES : %orig;
    } @catch (NSException *e) {
        return NO;
    }
}

- (UIView *)elementView {
    @try {
        UIView *v = %orig;
        if ([v isKindOfClass:[UIView class]]) {
            v.hidden = NO;
            v.alpha = 1.0;
            v.userInteractionEnabled = YES;
        }
        return v;
    } @catch (NSException *e) {
        return nil;
    }
}

- (void)setAuthenticating:(BOOL)authenticating {
    @try {
        %orig(isBioActive ? YES : authenticating);
    } @catch (NSException *e) {}
}

%end

// 2. Hook ủy quyền System Aperture
%hook SBSystemApertureElementAuthority

- (BOOL)systemApertureApertureElementAuthority:(id)authority isActivityElementAlerting:(id)element {
    if (isBioActive) return YES;
    return %orig;
}

- (BOOL)systemApertureApertureElementAuthority:(id)authority isElementExpandedDueToUserInteraction:(id)element {
    if (isBioActive) return YES;
    return %orig;
}

- (BOOL)systemApertureApertureElementAuthority:(id)authority isElementRequiredToRemainVisible:(id)element {
    if (isBioActive) return YES;
    return %orig;
}

- (long long)systemApertureApertureElementAuthority:(id)authority preferredLayoutModeForElement:(id)element {
    if (isBioActive) {
        return 3; // Mode 3: Expanded / Alerting
    }
    return %orig;
}

- (unsigned long long)systemApertureApertureElementAuthorityMaximumNumberOfSimultaneouslyVisibleElements:(id)authority {
    return 2;
}

%end

// 3. Ép Controller nhận diện phần cứng
%hook SBSystemApertureController

- (BOOL)isPearlAvailable {
    return YES;
}

- (BOOL)isPearlActive {
    return isBioActive;
}

- (id)activePearlElement {
    @try {
        return getPearlElement() ?: %orig;
    } @catch (NSException *e) {
        return %orig;
    }
}

%end

// Ép hệ thống nhận diện cờ điều hướng tràn viền
%hook BSPlatform
- (NSInteger)homeButtonType {
    return 2; // HomeButtonTypeNone (Giả lập kiểu dáng tràn viền)
}
%end

%hook SBFMobileKeyBag
- (BOOL)hasPearl {
    return YES;
}
%end

// 4. Xử lý sự kiện sinh trắc học / mở khóa
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

    if (event == 1 || event == 2 || event == 12 || event == 13) {
        triggerPearlAnimation(1, YES);
    }
    else if (event == 3 || event == 4 || event == 14 || event == 15) {
        AudioServicesPlaySystemSound(1394);
        triggerPearlAnimation(4, YES);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            triggerPearlAnimation(4, NO);
        });
    } 
    else if (event == 9 || event == 10 || event == 11) {
        AudioServicesPlaySystemSound(1395);
        triggerPearlAnimation(9, YES);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            triggerPearlAnimation(9, NO);
        });
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        isHandlingBioEvent = NO;
    });
}
%end

%hook CSCoverSheetViewController
- (void)viewWillAppear:(BOOL)animated {
    %orig;
    @try {
        [[%c(SBUIBiometricResource) sharedInstance] noteScreenWillTurnOn];
    } @catch (NSException *e) {}
    triggerPearlAnimation(1, YES);
}
%end

%hook SBLockScreenManager
- (void)lockUIFromSource:(int)source withOptions:(id)options {
    %orig;
    @try {
        [[%c(SBUIBiometricResource) sharedInstance] noteScreenWillTurnOn];
    } @catch (NSException *e) {}
    triggerPearlAnimation(1, YES);
}

- (BOOL)unlockUIFromSource:(int)source withOptions:(id)options {
    BOOL res = %orig;
    if (res) {
        AudioServicesPlaySystemSound(1394);
        triggerPearlAnimation(4, YES);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            triggerPearlAnimation(4, NO);
        });
    }
    return res;
}
%end

%hook SBUIPasscodeBiometricAuthenticationView
- (void)setBiometricAuthenticationState:(NSInteger)state animated:(BOOL)animated {
    %orig;
    if (state == 1 || state == 2) {
        @try {
            [[%c(SBUIBiometricResource) sharedInstance] noteScreenWillTurnOn];
        } @catch (NSException *e) {}
        triggerPearlAnimation(1, YES);
    } else if (state == 3 || state == 0) {
        AudioServicesPlaySystemSound(1395);
        triggerPearlAnimation(9, YES);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            triggerPearlAnimation(9, NO);
        });
    }
}
%end

%hook SBBiometricMonitorPearlDataSource
- (BOOL)isPosePresenceDetected {
    return YES;
}

- (void)_setMatching:(BOOL)matching {
    %orig;
    if (matching) {
        triggerPearlAnimation(1, YES);
    }
}

- (void)device:(id)device pearlEventOccurred:(long long)event {
    %orig;
    if (event == 1 || event == 2) {
        triggerPearlAnimation(1, YES);
    } else if (event == 4) {
        AudioServicesPlaySystemSound(1394);
        triggerPearlAnimation(4, YES);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            triggerPearlAnimation(4, NO);
        });
    } else if (event == 8 || event == 9) {
        AudioServicesPlaySystemSound(1395);
        triggerPearlAnimation(9, YES);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            triggerPearlAnimation(9, NO);
        });
    }
}
%end


// ============================================================================
// CẤU HÌNH GIAO DIỆN HỆ THỐNG CỦA VISIBLEISLAND
// ============================================================================
%hook SBSystemApertureWindow

- (void)layoutSubviews {
    %orig;
    if (scaleEnabled && fixEnabled) {
        self.transform = CGAffineTransformMakeScale(scale, scale);
        NSString *deviceModel = [Model deviceModel];
        if ([deviceModel isEqualToString:@"iPhone10,3"] || [deviceModel isEqualToString:@"iPhone10,6"] ||
            [deviceModel isEqualToString:@"iPhone11,2"] || [deviceModel isEqualToString:@"iPhone12,3"]) {
            CGFloat SyPos = 20.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone11,6"] || [deviceModel isEqualToString:@"iPhone12,5"] ||
                   [deviceModel isEqualToString:@"iPhone11,8"] || [deviceModel isEqualToString:@"iPhone12,1"] ||
                   [deviceModel isEqualToString:@"iPhone14,4"]) {
            CGFloat SyPos = 22.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,2"] || [deviceModel isEqualToString:@"iPhone13,3"]) {
            CGFloat SyPos = 21.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,1"]) {
            CGFloat SyPos = 19.5 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,4"]) {
            CGFloat SyPos = 22.3 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,5"] || [deviceModel isEqualToString:@"iPhone14,2"] ||
                   [deviceModel isEqualToString:@"iPhone14,7"]) {
            CGFloat SyPos = 24.0 / scale;
            CGRect frame = self.frame;
            frame.origin.y = SyPos;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,3"]) {
            CGFloat SyPos = 26.0 / scale;
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
        if ([deviceModel isEqualToString:@"iPhone10,3"] || [deviceModel isEqualToString:@"iPhone10,6"] ||
            [deviceModel isEqualToString:@"iPhone11,2"] || [deviceModel isEqualToString:@"iPhone12,3"]) {
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 20.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone11,6"] || [deviceModel isEqualToString:@"iPhone12,5"] ||
                   [deviceModel isEqualToString:@"iPhone11,8"] || [deviceModel isEqualToString:@"iPhone12,1"] ||
                   [deviceModel isEqualToString:@"iPhone14,4"]) {
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 22.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,2"] || [deviceModel isEqualToString:@"iPhone13,3"]) {
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 21.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,1"]) {
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 19.5;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone13,4"]) {
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 22.3;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,5"] || [deviceModel isEqualToString:@"iPhone14,2"] ||
                   [deviceModel isEqualToString:@"iPhone14,7"]) {
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 24.0;
            self.frame = frame;
        } else if ([deviceModel isEqualToString:@"iPhone14,3"]) {
            %orig;
            CGRect frame = self.frame;
            frame.origin.y = 26.0;
            self.frame = frame;
        }
    } else if (posEnabled && !scaleEnabled) {
        %orig;
        CGRect frame = self.frame;
        frame.origin.y = yPos;
        frame.origin.x = xPos;
        self.frame = frame;
    } else if ((scaleEnabled && !posEnabled) || (scaleEnabled && !fixEnabled)) {
        self.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

%end

%hook _SBSystemApertureMagiciansCurtainView
- (void)didMoveToWindow {
    if (fixEnabled || posEnabled) {
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
    } 
    if (lineDisabled) {
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
        if ([deviceModel isEqualToString:@"iPhone10,3"] || [deviceModel isEqualToString:@"iPhone10,6"] ||
            [deviceModel isEqualToString:@"iPhone11,2"] || [deviceModel isEqualToString:@"iPhone12,3"] ||
            [deviceModel isEqualToString:@"iPhone13,2"] || [deviceModel isEqualToString:@"iPhone13,3"]) {
            %orig;
            return CGRectMake(0, 35, 375, 812);
        } else if ([deviceModel isEqualToString:@"iPhone11,6"] || [deviceModel isEqualToString:@"iPhone12,5"] ||
                   [deviceModel isEqualToString:@"iPhone11,8"] || [deviceModel isEqualToString:@"iPhone12,1"]) {
            %orig;
            return CGRectMake(0, 37, 414, 896);
        } else if ([deviceModel isEqualToString:@"iPhone13,1"]) {
            %orig;
            return CGRectMake(0, 33, 360, 780);
        } else if ([deviceModel isEqualToString:@"iPhone13,4"] || [deviceModel isEqualToString:@"iPhone14,4"]) {
            %orig;
            return CGRectMake(0, 38, 428, 926);
        } else if ([deviceModel isEqualToString:@"iPhone14,5"] || [deviceModel isEqualToString:@"iPhone14,2"] ||
                   [deviceModel isEqualToString:@"iPhone14,7"]) {
            %orig;
            return CGRectMake(0, 40, 390, 844);
        } else if ([deviceModel isEqualToString:@"iPhone14,3"]) {
            %orig;
            return CGRectMake(0, 42, 428, 926);
        }
    } else if (notEnabled) {
        return CGRectMake(xNot, yNot, self.bounds.size.width, self.bounds.size.height);
    }
    return %orig;
}

- (void)setFrame:(CGRect)frame {
    if (notificationFix) {
        NSString *deviceModel = [Model deviceModel];
        if ([deviceModel isEqualToString:@"iPhone10,3"] || [deviceModel isEqualToString:@"iPhone10,6"] ||
            [deviceModel isEqualToString:@"iPhone11,2"] || [deviceModel isEqualToString:@"iPhone12,3"] ||
            [deviceModel isEqualToString:@"iPhone13,2"] || [deviceModel isEqualToString:@"iPhone13,3"]) {
            %orig(CGRectMake(0, 35, 375, 812));
        } else if ([deviceModel isEqualToString:@"iPhone11,6"] || [deviceModel isEqualToString:@"iPhone12,5"] ||
                   [deviceModel isEqualToString:@"iPhone11,8"] || [deviceModel isEqualToString:@"iPhone12,1"]) {
            %orig(CGRectMake(0, 37, 414, 896));
        } else if ([deviceModel isEqualToString:@"iPhone13,1"]) {
            %orig(CGRectMake(0, 33, 360, 780));
        } else if ([deviceModel isEqualToString:@"iPhone13,4"] || [deviceModel isEqualToString:@"iPhone14,4"]) {
            %orig(CGRectMake(0, 38, 428, 926));
        } else if ([deviceModel isEqualToString:@"iPhone14,5"] || [deviceModel isEqualToString:@"iPhone14,2"] ||
                   [deviceModel isEqualToString:@"iPhone14,7"]) {
            %orig(CGRectMake(0, 40, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone14,3"]) {
            %orig(CGRectMake(0, 42, 428, 926));
        }
    } else if (notEnabled) {
        %orig(CGRectMake(xNot, yNot, frame.size.width, frame.size.height));
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
    dispatch_async(dispatch_get_main_queue(), ^{
        if (CFEqual(name, CFSTR("com.ethxnn88.visibleisland.scanning"))) {
            triggerPearlAnimation(1, YES);
        } else if (CFEqual(name, CFSTR("com.ethxnn88.visibleisland.success"))) {
            AudioServicesPlaySystemSound(1394);
            triggerPearlAnimation(4, YES);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                triggerPearlAnimation(4, NO);
            });
        } else if (CFEqual(name, CFSTR("com.ethxnn88.visibleisland.failure"))) {
            AudioServicesPlaySystemSound(1395);
            triggerPearlAnimation(9, YES);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                triggerPearlAnimation(9, NO);
            });
        }
    });
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
