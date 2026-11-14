#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sys/sysctl.h>
#import <notify.h>
#import <objc/runtime.h>
#import <objc/message.h>

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

static BOOL lockIndicatorEnabled = YES;
static BOOL appAuthIslandEnabled = YES;   // hiện hoạt 
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

@interface SBUIPasscodeBiometricResource : NSObject
@end

@interface SBDashBoardLockScreenEnvironment : NSObject
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

@interface SBBiometricMonitorPearlDataSource : NSObject
- (void)_setMatching:(BOOL)arg1;
- (void)device:(id)arg1 pearlEventOccurred:(long long)arg2;
@end
@interface SBUIPasscodeBiometricAuthenticationView : UIView
- (void)setBiometricAuthenticationState:(NSInteger)state animated:(BOOL)animated;
@end

@interface SBLockScreenBiometricAuthenticationCoordinator : NSObject
- (void)biometricResource:(id)resource observeEvent:(unsigned long long)event;
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
    if ([m isEqualToString:@"iPhone14,5"] || 
        [m isEqualToString:@"iPhone14,7"] || [m isEqualToString:@"iPhone14,8"]) {
        return 24.0;
    }
    if ([m isEqualToString:@"iPhone14,3"]) return 26.0;
    return 20.5;
}

@end

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
 isEqualToString:@"iPhone14,2"]) { //13 Pro
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
    islandEnabled = (prefs && [prefs objectForKey:@"islandEnabled"] ? 
    posEnabled = (prefs && [prefs objectForKey:@"posEnabled"] ? [[prefs valueForKey:@"posEnabled"] boolValue] : NO );
    hideEnabled = (prefs && [prefs objectForKey:@"hideEnabled"] ? [[prefs valueForKey:@"hideEnabled"] boolValue] : NO );
    notificationFix = (prefs && [prefs objectForKey:@"notificationFix"] ? [[prefs valueForKey:@"notificationFix"] boolValue] : NO );
    notEnabled = (prefs && [prefs objectForKey:@"notEnabled"] ? [[prefs valueForKey:@"notEnabled"] boolValue] : NO );
    colorEnabled = (prefs && [prefs objectForKey:@"colorEnabled"] ? [[prefs valueForKey:@"colorEnabled"] boolValue] : NO );
    transEnabled = (prefs && [prefs objectForKey:@"transEnabled"] ? [[prefs valueForKey:@"transEnabled"] boolValue] : NO );
    scaleEnabled = (prefs && [prefs objectForKey:@"scaleEnabled"] ? [[prefs valueForKey:@"scaleEnabled"] boolValue] : NO );
    lineDisabled = (prefs && [prefs objectForKey:@"lineDisabled"] ? [[prefs valueForKey:@"lineDisabled"] boolValue] : NO );
    lockIndicatorEnabled = (prefs && [prefs objectForKey:@"lockIndicatorEnabled"] ? [[prefs valueForKey:@"lockIndicatorEnabled"] boolValue] : YES );
    faceIDAnimationEnabled = (prefs && [prefs objectForKey:@"faceIDAnimationEnabled"] ? [[prefs valueForKey:@"faceIDAnimationEnabled"] boolValue] : NO );
    appAuthIslandEnabled = (prefs && [prefs objectForKey:@"appAuthIslandEnabled"] ? [[prefs valueForKey:@"appAuthIslandEnabled"] boolValue] : YES );
    xPos = [[prefs objectForKey:@"xPos"] floatValue];
    yPos = [[prefs objectForKey:@"yPos"] floatValue];
    xNot = [[prefs objectForKey:@"xNot"] floatValue];
    red = [[prefs objectForKey:@"red"] floatValue];
    green = [[prefs objectForKey:@"green"] floatValue];
    blue = [[prefs objectForKey:@"blue"] floatValue];
    alpha = [[prefs objectForKey:@"alpha"] floatValue];
    scale = [[prefs objectForKey:@"scale"] floatValue];

    if (isSpringBoardProcess) {
        VILog(@"prefs: faceID=%d appAuth=%d lockIndicator=%d", faceIDAnimationEnabled, appAuthIslandEnabled, lockIndicatorEnabled);
    }
    VIApplyLockState();
}

#define VI_LOG_PATH @"/var/mobile/Documents/VisibleIsland_lock_log.txt"
#define VI_LOCK_ELEMENT_ID @"com.ethxnn88.visibleisland.lock"

@interface SAAssertion : NSObject
- (BOOL)isValid;
- (void)invalidateWithReason:(NSString *)reason;
@end

@interface SBSystemApertureController : NSObject
- (id)initWithWindowScene:(id)scene;
- (id)registerElement:(id)element;
@end

@interface SBSystemApertureProvidedContentElement : NSObject
- (id)initWithIdentifier:(id)identifier contentProvider:(id)provider;
- (long long)layoutMode;
- (long long)preferredLayoutMode;
- (BOOL)_canShowWhileLocked;
- (BOOL)shouldSuppressElementWhileOnCoversheet;
@end

@interface SBUISystemApertureContentProvider : NSObject
- (void)setLeadingContentViewProvider:(id)provider;
- (void)setTrailingContentViewProvider:(id)provider;
- (void)setMinimalContentViewProvider:(id)provider;
@end

@interface SBUISystemApertureImageContentProvider : NSObject
- (id)initWithSystemImageName:(NSString *)name;
- (id)initWithImage:(UIImage *)image;
- (void)setContentColor:(UIColor *)color;
- (UIView *)providedView;
@end

static __weak id viController = nil;                       // SBSystemApertureController
static SBSystemApertureProvidedContentElement *viElement = nil;
static SAAssertion *viAssertion = nil;
static BOOL viDeviceLocked = NO;

static void VILog(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);
static void VILog(NSString *format, ...) 
    va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    NSData *line = [[NSString stringWithFormat:@"%@  %@\n", [NSDate date], msg] dataUsingEncoding:NSUTF8StringEncoding];

    @synchronized ([NSFileHandle class]) {
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:VI_LOG_PATH];
        if (!handle) {
            [line writeToFile:VI_LOG_PATH atomically:NO];
            return;
        }
        [handle seekToEndReturningOffset:nil error:nil];
        [handle writeData:line error:nil];
        [handle closeAndReturnError:nil];
    }
}

static UIColor *VILockColor(void) {
    // TẠM THỜI màu vàng để phân biệt với ổ khóa gốc của hệ thống khi test
    return [UIColor systemYellowColor];
}

// Hệ thống gọi -elementIdentifier / -clientIdentifier lên đối tượng truyền vào initWithIdentifier:
// (giống SBChargingSystemApertureElementProvider, tuân thủ SAElementIdentifying).
@interface VILockElementIdentity : NSObject
- (NSString *)elementIdentifier;
- (NSString *)clientIdentifier;
@end

@implementation VILockElementIdentity
- (NSString *)elementIdentifier { return VI_LOCK_ELEMENT_ID; }
- (NSString *)clientIdentifier { return @"com.ethxnn88.visibleisland"; }
@end

static void VILogException(NSString *where, NSException *exception) {
    NSArray<NSString *> *symbols = exception.callStackSymbols;
    NSUInteger count = MIN((NSUInteger)15, symbols.count);
    NSString *stack = [[symbols subarrayWithRange:NSMakeRange(0, count)] componentsJoinedByString:@"\n    "];
    VILog(@"NSException khi %@: %@ | %@\n    %@", where, exception.name, exception.reason, stack);
}

#define VI_BUILD_TAG @"glyph-green-4"
#define VI_GUARD_PATH @"/var/mobile/Documents/VisibleIsland_lock_guard.txt"

static BOOL viGuardTripped = NO;
static NSUInteger viGuardToken = 0;

static void VIGuardArm(void) {
    viGuardToken++;
    [VI_BUILD_TAG writeToFile:VI_GUARD_PATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

static void VIGuardDisarmSoon(void) {
    NSUInteger token = viGuardToken;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (token == viGuardToken) {
            [[NSFileManager defaultManager] removeItemAtPath:VI_GUARD_PATH error:nil];
        }
    });
}

static void VIGuardCheckAtLaunch(void) {
    NSString *saved = [NSString stringWithContentsOfFile:VI_GUARD_PATH encoding:NSUTF8StringEncoding error:nil];
    if (!saved) return;
    if ([saved isEqualToString:VI_BUILD_TAG]) {
        viGuardTripped = YES
static SBSystemApertureProvidedContentElement *VIBuildLockElement(void) {
    VILog(@"[1] tìm class hệ thống");
    Class providerClass = NSClassFromString(@"SBUISystemApertureContentProvider");
    Class imageClass = NSClassFromString(@"SBUISystemApertureImageContentProvider");
    Class elementClass = NSClassFromString(@"SBSystemApertureProvidedContentElement");
    if (!providerClass || !imageClass || !elementClass) {
        VILog(@"thiếu class: provider=%d image=%d element=%d",
              providerClass != nil, imageClass != nil, elementClass != nil);
        return nil;
    }

    VILog(@"[2] tạo provider ảnh bên trái");
    SBUISystemApertureImageContentProvider *leading = [[imageClass alloc] initWithSystemImageName:@"lock.fill"];
    [leading setContentColor:VILockColor()];

    VILog(@"[3] tạo provider ảnh minimal");
    SBUISystemApertureImageContentProvider *minimal = [[imageClass alloc] initWithSystemImageName:@"lock.fill"];
    [minimal setContentColor:VILockColor()];

    VILog(@"[4] tạo provider ảnh trong suốt bên phải");
    // Bên phải chỉ để giữ chỗ cho pill compact cân đối: dùng ảnh trong suốt qua image provider
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(14, 14)];
    UIImage *clearImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext *context) {}];
    SBUISystemApertureImageContentProvider *trailing = [[imageClass alloc] initWithImage:clearImage];

    VILog(@"[5] ghép content provider");
    SBUISystemApertureContentProvider *provider = [[providerClass alloc] init];
    [provider setLeadingContentViewProvider:leading];
    [provider setTrailingContentViewProvider:trailing];
    [provider setMinimalContentViewProvider:minimal];

    VILog(@"[6] chẩn đoán: element có initWithIdentifier:contentProvider: = %d, provider tuân thủ SBUISystemApertureContentProviding = %d",
          [elementClass instancesRespondToSelector:@selector(initWithIdentifier:contentProvider:)],
          [provider conformsToProtocol:NSProtocolFromString(@"SBUISystemApertureContentProviding")]);

    SBSystemApertureProvidedContentElement *element = nil;
    @try {
        VILog(@"[6a] providedView trái: %@", [leading providedView]);
        VILog(@"[6b] providedView phải: %@", [trailing providedView]);
        VILog(@"[6c] providedView minimal: %@", [minimal providedView]);
        Protocol *identifying = NSProtocolFromString(@"SAElementIdentifying");
        if (identifying && ![VILockElementIdentity conformsToProtocol:identifying]) {
            class_addProtocol([VILockElementIdentity class], identifying);
        }
        VILog(@"[6d] identity tuân thủ SAElementIdentifying = %d, gọi initWithIdentifier:contentProvider:",
              identifying ? [VILockElementIdentity conformsToProtocol:identifying] : -1);
        VILockElementIdentity *identity = [[VILockElementIdentity alloc] init];
        element = [[elementClass alloc] initWithIdentifier:identity contentProvider:provider];
    } @catch (NSException *exception) {
        VILogException(@"dựng element", exception);
        return nil;
    }
    VILog(@"[7] tạo element xong: %@", element);
    return element;
}

// ============================================================================
// CHẨN ĐOÁN (bản này chưa đăng ký ổ khóa): lấy thông tin để dựng element đúng cách
// ============================================================================
@interface SBChargingSystemApertureElementProvider : NSObject
- (id)powerElementWithBatteryCapacity:(double)capacity;
@end

// Bản chẩn đoán KHÔNG đăng ký ổ khóa vào island (bản trước crash ở bước này)
static BOOL viRegisterEnabled = NO;
static BOOL viVerboseDiag = NO; // bật để ghi cây view / state package mỗi lần khóa, mở khóa
static __weak id viSystemLockElement = nil; // element khóa do hệ thống đăng ký (SBLockElementViewProvider)

static NSString *VISafeValue(id object, NSString *key) {
    @try {
        id value = [object valueForKey:key];
        NSString *text = value ? [NSString stringWithFormat:@"%@", value] : @"nil";
        return text.length > 160 ? [text substringToIndex:160] : text;
    } @catch (NSException *exception) {
        return [NSString stringWithFormat:@"(lỗi %@)", exception.name];
    }
}

static NSString *VIClassOfValue(id object, NSString *key) {
    if (!object) return @"-";
    @try {
        id value = [object valueForKey:key];
        return value ? NSStringFromClass([value class]) : @"nil";
    } @catch (NSException *exception) {
        return @"(không có)";
    }
}

static BOOL VIConforms(id object, NSString *protocolName) {
    Protocol *protocol = NSProtocolFromString(protocolName);
    return protocol && [object conformsToProtocol:protocol];
}

static NSString *VIClassNameOf(id object) {
    return object ? NSStringFromClass([object class]) : @"nil";
}

// Ghi đặc điểm của một element: lớp, hành vi (activity/alert/indicator), chế độ layout, view
static void VILogElementTraitsUnsafe(NSString *label, id element) {
    if (!element) {
        VILog(@"[DIAG] %@: element nil", label);
        return;
    }
    id contentProvider = nil;
    @try {
        contentProvider = [element valueForKey:@"_contentProvider"];
    } @catch (NSException *exception) {
        contentProvider = nil;
    }
    VILog(@"[DIAG] %@: class=%@ super=%@ activity=%d alert=%d indicator=%d | layout=%@ preferred=%@ min=%@ max=%@ | contentProvider=%@ leading=%@ trailing=%@ minimal=%@ primary=%@",
          label, VIClassNameOf(element), NSStringFromClass(class_getSuperclass([element class])),
          VIConforms(element, @"SAActivityBehavior"), VIConforms(element, @"SAAlertBehavior"), VIConforms(element, @"SAIndicatorBehavior"),
          VISafeValue(element, @"layoutMode"), VISafeValue(element, @"preferredLayoutMode"),
          VISafeValue(element, @"minimumSupportedLayoutMode"), VISafeValue(element, @"maximumSupportedLayoutMode"),
          VIClassNameOf(contentProvider),
          VIClassOfValue(contentProvider, @"leadingContentViewProvider"),
          VIClassOfValue(contentProvider, @"trailingContentViewProvider"),
          VIClassOfValue(contentProvider, @"minimalContentViewProvider"),
          VIClassOfValue(contentProvider, @"primaryContentViewProvider"));
}

static void VILogElementTraits(NSString *label, id element) {
    @try {
        VILogElementTraitsUnsafe(label, element);
    } @catch (NSException *exception) {
        VILogException(@"ghi đặc điểm element", exception);
    }
}

#define VI_LOCK_DUMP_PATH @"/var/mobile/Documents/VisibleIsland_lock_dump.txt"

// recursiveDescription của một view lấy qua key (vd. leadingView) của element
static NSString *VITree(id object, NSString *key) {
    @try {
        id view = [object valueForKey:key];
        if (!view) return @"nil";
        NSString *text = [view valueForKey:@"recursiveDescription"];
        if (![text isKindOfClass:[NSString class]]) return @"(không có recursiveDescription)";
        return text.length > 4000 ? [text substringToIndex:4000] : text;
    } @catch (NSException *exception) {
        return [NSString stringWithFormat:@"(lỗi %@)", exception.name];
    }
}

static void VILogLockViews(id element) {
    VILog(@"[DIAG] leadingView:\n%@", VITree(element, @"leadingView"));
    VILog(@"[DIAG] trailingView:\n%@", VITree(element, @"trailingView"));
}

// Dump method/ivar/protocol của các class có tên chứa một trong các chuỗi `needles`
static void VIDumpClassesMatching(NSArray<NSString *> *needles, NSString *outputPath) {
    NSMutableString *out = [NSMutableString stringWithFormat:@"iOS %@ | %@\n", [UIDevice currentDevice].systemVersion, [Model deviceModel]];

    unsigned int classCount = 0;
    Class *classes = objc_copyClassList(&classCount);
    NSMutableArray<NSValue *> *matched = [NSMutableArray array];
    for (unsigned int i = 0; i < classCount; i++) {
        NSString *name = NSStringFromClass(classes[i]);
        for (NSString *needle in needles) {
            if ([name containsString:needle]) {
                [matched addObject:[NSValue valueWithPointer:(__bridge const void *)classes[i]]];
                break;
            }
        }
    }
    free(classes);

    [matched sortUsingComparator:^NSComparisonResult(NSValue *a, NSValue *b) {
        Class ca = (__bridge Class)[a pointerValue];
        Class cb = (__bridge Class)[b pointerValue];
        return strcmp(class_getName(ca), class_getName(cb)) < 0 ? NSOrderedAscending : NSOrderedDescending;
    }];

    [out appendFormat:@"\n== %lu class khớp ==\n", (unsigned long)matched.count];
    for (NSValue *value in matched) {
        Class cls = (__bridge Class)[value pointerValue];
        Class sup = class_getSuperclass(cls);
        const char *image = class_getImageName(cls);
        [out appendFormat:@"\n@interface %s : %s   // %s\n", class_getName(cls), sup ? class_getName(sup) : "(root)", image ? image : "?"];

        unsigned int protoCount = 0;
        Protocol * __unsafe_unretained *protos = class_copyProtocolList(cls, &protoCount);
        for (unsigned int p = 0; p < protoCount; p++) {
            [out appendFormat:@"  <%s>\n", protocol_getName(protos[p])];
        }
        free(protos);

        unsigned int ivarCount = 0;
        Ivar *ivars = class_copyIvarList(cls, &ivarCount);
        for (unsigned int k = 0; k < ivarCount; k++) {
            const char *type = ivar_getTypeEncoding(ivars[k]);
            [out appendFormat:@"  ivar %s  %s\n", ivar_getName(ivars[k]), type ? type : ""];
        }
        free(ivars);

        unsigned int classMethodCount = 0;
        Method *classMethods = class_copyMethodList(object_getClass(cls), &classMethodCount);
        for (unsigned int m = 0; m < classMethodCount; m++) {
            const char *type = method_getTypeEncoding(classMethods[m]);
            [out appendFormat:@"  + %s  %s\n", sel_getName(method_getName(classMethods[m])), type ? type : ""];
        }
        free(classMethods);

        unsigned int methodCount = 0;
        Method *methods = class_copyMethodList(cls, &methodCount);
        for (unsigned int m = 0; m < methodCount; m++) {
            const char *type = method_getTypeEncoding(methods[m]);
            [out appendFormat:@"  - %s  %s\n", sel_getName(method_getName(methods[m])), type ? type : ""];
        }
        free(methods);
    }
    [out writeToFile:outputPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

static void VIDiagnoseLock(void) {
    VILog(@"[DIAG] bắt đầu dump class liên quan tới ổ khóa / activity / alert");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        VIDumpClassesMatching(@[@"LockElement", @"ProudLock", @"ActivityProvidedContent", @"AlertProvidedContent",
                                @"PowerAlertElement", @"RingerAlertElement", @"UserNotificationAlertElement",
                                @"LockIcon", @"PearlGlyph", @"Unlock"], VI_LOCK_DUMP_PATH);
        VILog(@"[DIAG] dump xong: %@", VI_LOCK_DUMP_PATH);
    });
}

// ---- Chẩn đoán độ sáng/màu glyph Face ID của ổ khóa gốc ------------------------------------
static void VIDumpLayerTree(CALayer *layer, int depth, NSMutableString *out) {
    if (!layer || depth > 7) return;
    NSString *indent = [@"" stringByPaddingToLength:(NSUInteger)(depth * 2) withString:@" " startingAtIndex:0];
    [out appendFormat:@"%@%@ opacity=%.2f hidden=%d filters=%lu comp=%@\n", indent, NSStringFromClass([layer class]),
        layer.opacity, layer.hidden, (unsigned long)layer.filters.count, layer.compositingFilter ? layer.compositingFilter : @"-"];
    for (CALayer *sub in layer.sublayers) {
        VIDumpLayerTree(sub, depth + 1, out);
    }
}

static void VILogGlyphState(id element, NSString *when) {
    if (!element) {
        VILog(@"[GLYPH %@] chưa có element khóa gốc", when);
        return;
    }
    @try {
        NSMutableString *out = [NSMutableString string];
        for (NSString *key in @[@"_isAcquiring", @"_isAuthenticated", @"_hasActiveUnlockAttempt", @"_isEmpty",
                                @"_isInBloomMode", @"_allowsBioUnlock", @"_unlockMode", @"_layoutMode"]) {
            [out appendFormat:@" %@=%@", key, VISafeValue(element, key)];
        }
        UIView *trailing = [element valueForKey:@"trailingView"];
        UIView *package = [element valueForKey:@"trailingPackageView"];
        [out appendFormat:@"\n trailingView alpha=%.2f hidden=%d | package alpha=%.2f hidden=%d\n",
            trailing.alpha, trailing.hidden, package.alpha, package.hidden];
        VIDumpLayerTree(package.layer, 0, out);
        VILog(@"[GLYPH %@]%@", when, out);
    } @catch (NSException *exception) {
        VILogException(@"ghi trạng thái glyph", exception);
    }
}

// Ghi tên các state (CAState) và ivar của package glyph để biết cách chuyển glyph sang trạng thái sáng
static void VICollectStates(CALayer *layer, int depth, NSMutableString *out) {
    if (!layer || depth > 3) return;
    NSString *indent = [@"" stringByPaddingToLength:(NSUInteger)(depth * 2) withString:@" " startingAtIndex:0];
    NSString *names = @"-";
    @try {
        id states = [layer valueForKey:@"states"];
        if ([states isKindOfClass:[NSArray class]]) {
            names = [[(NSArray *)states valueForKey:@"name"] componentsJoinedByString:@", "];
        }
    } @catch (NSException *exception) {
        names = @"(không có)";
    }
    [out appendFormat:@"%@%@ name=%@ states=[%@]\n", indent, NSStringFromClass([layer class]), layer.name ? layer.name : @"-", names];
    for (CALayer *sub in layer.sublayers) {
        VICollectStates(sub, depth + 1, out);
    }
}

static void VILogPackageStates(id element) {
    if (!element) return;
    @try {
        UIView *package = [element valueForKey:@"trailingPackageView"];
        NSMutableString *out = [NSMutableString stringWithFormat:@"class=%@\n", NSStringFromClass([package class])];
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([package class], &count);
        for (unsigned int i = 0; i < count; i++) {
            const char *name = ivar_getName(ivars[i]);
            [out appendFormat:@" ivar %s = %@\n", name, VISafeValue(package, [NSString stringWithUTF8String:name])];
        }
        free(ivars);
        VICollectStates(package.layer, 0, out);
        VILog(@"[PKG] %@", out);
    } @catch (NSException *exception) {
        VILogException(@"ghi state package", exception);
    }
}

// ---- Glyph Face ID sáng trắng kiểu iOS 26 -----------------------------------------------------
// Trên iOS 16 layer khuôn mặt ("face-rounder.png", blend screen) chỉ ở opacity 0.2 nên mờ. Ta nâng nó lên 1.0
// mỗi khi hệ thống đặt giá trị lưng chừng; giá trị 0 (ẩn) và 1 (đã sáng) được giữ nguyên.
static CALayer *VIFindLayerNamed(CALayer *layer, NSString *name, int depth) {
    if (!layer || depth > 5) return nil;
    if ([layer.name isEqualToString:name]) return layer;
    for (CALayer *sub in layer.sublayers) {
        CALayer *found = VIFindLayerNamed(sub, name, depth + 1);
        if (found) return found;
    }
    return nil;
}

static NSUInteger viBrightenLogCount = 0;
static UIImage *viFaceImage = nil;      // ảnh glyph Face ID gốc của hệ thống (face-rounder.png), dùng lại cho island app-lock
static BOOL viOutsetsLogged = NO;
static BOOL viLockMatched = NO;   // vân tay khớp (giả lập Face ID thành công)
static int viGlyphLastMode = -1;   // 0 = trắng sáng (đang quét), 1 = xanh lá phát sáng (đã xác thực)

// Màu đo từ video màn hình iPhone 14 Pro (video 4): xanh lá ~ (67..83, 181..186, 97..107)
static UIColor *VIGlyphGreen(void) {
    return [UIColor colorWithRed:0.28 green:0.74 blue:0.40 alpha:1.0];
}

typedef NSDirectionalEdgeInsets (*VIOutsetsFn)(id, SEL, long long, NSDirectionalEdgeInsets, NSDirectionalEdgeInsets);

// Ghi lại kích thước (outsets) mà ổ khóa gốc dùng để island ở đúng cỡ "to" khi mở khóa
static void VILogLockOutsets(id lock) {
    if (viOutsetsLogged || !lock) return;
    viOutsetsLogged = YES;
    SEL sel = NSSelectorFromString(@"preferredEdgeOutsetsForLayoutMode:suggestedOutsets:maximumOutsets:");
    if (![lock respondsToSelector:sel]) { VILog(@"[LOCKSIZE] ổ khóa gốc không có preferredEdgeOutsets"); return; }
    NSDirectionalEdgeInsets zero = NSDirectionalEdgeInsetsZero;
    NSDirectionalEdgeInsets big = NSDirectionalEdgeInsetsMake(60, 60, 60, 60);
    for (long long mode = 1; mode <= 3; mode++) {
        NSDirectionalEdgeInsets r = ((VIOutsetsFn)objc_msgSend)(lock, sel, mode, zero, big);
        VILog(@"[LOCKSIZE] mode=%lld outsets top=%.1f leading=%.1f bottom=%.1f trailing=%.1f (suggested=0, max=60)",
              mode, r.top, r.leading, r.bottom, r.trailing);
    }
}

// Hai lớp phụ cùng ảnh khuôn mặt: một lớp cộng sáng (plusL) và một lớp nhòe để phát sáng chói
static void VIAddGlare(CALayer *face) {
    for (CALayer *sub in face.sublayers) {
        if ([sub.name hasPrefix:@"vi.glare"]) return;
    }
    if (!face.contents || CGRectIsEmpty(face.bounds)) return;
    id blurFilter = nil;
    Class filterClass = NSClassFromString(@"CAFilter");
    if (filterClass) {
        blurFilter = ((id (*)(id, SEL, id))objc_msgSend)(filterClass, NSSelectorFromString(@"filterWithType:"), @"gaussianBlur");
        @try { [blurFilter setValue:@3.5 forKey:@"inputRadius"]; } @catch (NSException *e) { blurFilter = nil; }
    }
    for (int i = 0; i < 2; i++) {
        CALayer *g = [CALayer layer];
        g.name = i == 0 ? @"vi.glare1" : @"vi.glare2";
        g.frame = face.bounds;
        g.contents = face.contents;
        g.contentsGravity = face.contentsGravity;
        g.contentsScale = face.contentsScale;
        g.contentsRect = face.contentsRect;
        g.compositingFilter = @"plusL";
        @try { [g setValue:(id)[UIColor colorWithRed:0.0 green:1.0 blue:0.30 alpha:1.0].CGColor forKey:@"contentsMultiplyColor"]; } @catch (NSException *e) {}
        if (i == 1 && blurFilter) g.filters = @[blurFilter];
        [face addSublayer:g];
    }
    VILog(@"[GLYPH] đã thêm lớp chói (glare)");
}

static void VIBrightenGlyph(id element) {
    if (!faceIDAnimationEnabled || !element) return;
    @try {
        UIView *package = [element valueForKey:@"trailingPackageView"];
        CALayer *face = VIFindLayerNamed(package.layer, @"face-rounder.png", 0);
        if (!face) return;

        // Giữ lại ảnh glyph gốc để island app-lock dùng lại
        if (!viFaceImage && face.contents && CFGetTypeID((__bridge CFTypeRef)face.contents) == CGImageGetTypeID()) {
            viFaceImage = [UIImage imageWithCGImage:(__bridge CGImageRef)face.contents scale:MAX(face.contentsScale, 1.0) orientation:UIImageOrientationUp];
            VILog(@"[GLYPH] đã lưu ảnh glyph gốc %@", NSStringFromCGSize(viFaceImage.size));
        }
        @try {
            if ([[element valueForKey:@"_isInBloomMode"] boolValue]) VILogLockOutsets(element);
        } @catch (NSException *e) {}

        BOOL authenticated = NO;
        @try { authenticated = [[element valueForKey:@"_isAuthenticated"] boolValue]; } @catch (NSException *e) {}

        float value = face.opacity;
        BOOL hidden = value <= 0.01f;
        if (!hidden && value < 0.99f) {
            CALayer *presentation = face.presentationLayer;
            float from = presentation ? presentation.opacity : value;
            [face removeAllAnimations];
            face.opacity = 1.0f;
            CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fade.fromValue = @(from);
            fade.toValue = @1.0;
            fade.duration = 0.25;
            [face addAnimation:fade forKey:@"vi.brighten"];
            if (viBrightenLogCount < 6) {
                viBrightenLogCount++;
                VILog(@"[GLYPH] nâng opacity layer khuôn mặt %.2f -> 1.00", value);
            }
        }
        if (hidden) return;

        // Máy không có phần cứng Face ID nên hệ thống không bao giờ báo "đã xác thực": glyph luôn xanh lá như yêu cầu
        if (viGlyphLastMode != 1) {
            viGlyphLastMode = 1;
            @try {
                [face setValue:(id)[UIColor colorWithRed:0.20 green:0.90 blue:0.38 alpha:1.0].CGColor forKey:@"contentsMultiplyColor"];
            } @catch (NSException *e) { VILogException(@"contentsMultiplyColor", e); }
            VILog(@"[GLYPH] glyph xanh lá (authenticated=%d matched=%d bounds=%@)", authenticated, viLockMatched, NSStringFromCGRect(face.bounds));
        }
        // Gỡ bóng đổ: bóng của ảnh vuông chính là khung viền trắng quanh biểu tượng
        if (face.shadowOpacity != 0.0f) face.shadowOpacity = 0.0f;

        // Cắt sát mép ảnh vuông để mất viền
        if (!face.mask && !CGRectIsEmpty(face.bounds)) {
            CALayer *clip = [CALayer layer];
            clip.frame = CGRectInset(face.bounds, 2.0, 2.0);
            clip.cornerRadius = 8.0;
            clip.backgroundColor = [UIColor whiteColor].CGColor;
            face.mask = clip;
        }

        VIAddGlare(face);

        // Quầng sáng xanh mờ dần, hình tròn nên không tạo khung
        CALayer *root = package.layer;
        BOOL hasHalo = NO;
        for (CALayer *sub in root.sublayers) { if ([sub.name isEqualToString:@"vi.halo"]) { hasHalo = YES; break; } }
        if (!hasHalo && !CGRectIsEmpty(root.bounds)) {
            CAGradientLayer *halo = [CAGradientLayer layer];
            halo.name = @"vi.halo";
            halo.type = @"radial";
            halo.frame = root.bounds;
            halo.startPoint = CGPointMake(0.5, 0.5);
            halo.endPoint = CGPointMake(1.0, 1.0);
            halo.colors = @[(id)[VIGlyphGreen() colorWithAlphaComponent:0.50].CGColor,
                            (id)[VIGlyphGreen() colorWithAlphaComponent:0.20].CGColor,
                            (id)[VIGlyphGreen() colorWithAlphaComponent:0.0].CGColor];
            halo.locations = @[@0.0, @0.55, @1.0];
            [root insertSublayer:halo atIndex:0];
        }
    } @catch (NSException *exception) {
        VILogException(@"làm sáng glyph", exception);
    }
}

static NSTimer *viGlyphTimer = nil;

static void VIGlyphTimerStop(void) {
    [viGlyphTimer invalidate];
    viGlyphTimer = nil;
}

static void VIGlyphTimerStart(void) {
    if (!faceIDAnimationEnabled) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [viGlyphTimer invalidate];
        viGlyphTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer *timer) {
            if (!viDeviceLocked || !faceIDAnimationEnabled) {
                [timer invalidate];
                return;
            }
            VIBrightenGlyph(viSystemLockElement);
        }];
    });
}

// Đồng bộ ổ khóa với (máy đang khóa) và (người dùng bật tính năng)
static void VIApplyLockState(void) {
    if (!isSpringBoardProcess) return;

    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL wantByState = viDeviceLocked && lockIndicatorEnabled;
        BOOL want = wantByState && !viGuardTripped && viRegisterEnabled;
        BOOL shown = viAssertion && [viAssertion isValid];

        if (wantByState && viGuardTripped && !shown) {
            VILog(@"bỏ qua đăng ký ổ khóa vì guard đang bật");
        }
        if (wantByState && !viRegisterEnabled && !shown) {
            VILog(@"bản chẩn đoán: bỏ qua đăng ký ổ khóa");
        }

        if (want && !shown) {
            id controller = viController;
            if (!controller) {
                VILog(@"chưa có SBSystemApertureController, không đăng ký được ổ khóa");
                return;
            }
            VILog(@"[A] bắt đầu dựng element");
            VIGuardArm();
            viElement = VIBuildLockElement();
            if (!viElement) {
                VIGuardDisarmSoon();
                return;
            }
            VILog(@"[B] đã dựng element, chuẩn bị registerElement:");
            @try {
                viAssertion = [controller registerElement:viElement];
            } @catch (NSException *exception) {
                VILogException(@"registerElement:", exception);
                viAssertion = nil;
                VIGuardDisarmSoon();
                return;
            }
            VILog(@"[C] registerElement: trả về %@ valid=%d", viAssertion, viAssertion ? [viAssertion isValid] : 0);
            VILog(@"[D] layoutMode=%lld preferred=%lld", [viElement layoutMode], [viElement preferredLayoutMode]);
            VIGuardDisarmSoon();
        } else if (!want && shown) {
            VILog(@"[E] chuẩn bị gỡ element");
            VIGuardArm();
            @try {
                [viAssertion invalidateWithReason:@"VisibleIsland: máy đã mở khóa"];
            } @catch (NSException *exception) {
                VILogException(@"invalidateWithReason:", exception);
            }
            viAssertion = nil;
            VILog(@"[F] đã gỡ element");
            VIGuardDisarmSoon();
        }
    });
}

static void VISetDeviceLocked(BOOL locked) {
    BOOL changed = (viDeviceLocked != locked);
    viDeviceLocked = locked;
    if (changed) {
        VILog(@"[DIAG] trạng thái khóa -> %d", locked);
        if (locked) {
            viBrightenLogCount = 0;
            viGlyphLastMode = -1;
            viLockMatched = NO;
            viOutsetsLogged = NO;
            VIGlyphTimerStart();
            if (viVerboseDiag) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    VILogGlyphState(viSystemLockElement, @"2s sau khi khóa");
                    VILogPackageStates(viSystemLockElement);
                });
            }
        } else {
            VIGlyphTimerStop();
        }
        if (!locked && viVerboseDiag) {
            // Chụp cây view của ổ khóa gốc lúc nó chạy animation mở khóa
            for (NSNumber *delay in @[@0.05, @0.3, @0.7, @1.2]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([delay doubleValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    id element = viSystemLockElement;
                    if (element) {
                        VILog(@"[DIAG] cây view ổ khóa gốc sau %.2f giây kể từ lúc mở khóa", [delay doubleValue]);
                        VILogLockViews(element);
                    }
                });
            }
        }
    }
    VIApplyLockState();
}

// Lấy SBSystemApertureController của hệ thống
%hook SBSystemApertureController

- (id)initWithWindowScene:(id)scene {
    id result = %orig;
    if (result) {
        viController = result;
    }
    return result;
}

- (id)registerElement:(id)element {
    // Dự phòng: nếu bỏ lỡ lúc khởi tạo thì lấy ở lần đăng ký element đầu tiên của hệ thống
    if (!viController) {
        viController = self;
    }
    VILogElementTraits(@"hệ thống đăng ký", element);
    if ([NSStringFromClass([element class]) isEqualToString:@"SBLockElementViewProvider"]) {
        viSystemLockElement = element;
        if (viVerboseDiag) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                VILog(@"[DIAG] cây view của element khóa gốc, 2 giây sau khi đăng ký");
                VILogLockViews(element);
            });
        }
    }
    return %orig;
}

%end

// Cho phép element của mình hiện trên màn hình khóa (coversheet)
%hook SBSystemApertureProvidedContentElement

- (BOOL)_canShowWhileLocked {
    if (viElement && self == viElement) return YES;
    if (viAuthElement && self == viAuthElement) return YES;
    return %orig;
}

- (BOOL)shouldSuppressElementWhileOnCoversheet {
    if (viElement && self == viElement) return NO;
    if (viAuthElement && self == viAuthElement) return NO;
    return %orig;
}

// Element hệ thống dựng sẵn (SBLockElementViewProvider) tự trả 1 = compact. Lớp SBActivityProvidedContentElement
// thuần thì mặc định 3, nên ép về compact cho element xác thực của mình
- (long long)preferredLayoutMode {
    if (viAuthElement && self == viAuthElement) return 3;
    return %orig;
}

- (long long)minimumSupportedLayoutMode {
    if (viAuthElement && self == viAuthElement) return 1;
    return %orig;
}

- (long long)maximumSupportedLayoutMode {
    if (viAuthElement && self == viAuthElement) return 3;
    return %orig;
}

%end

%hook SBLockScreenManager

- (void)lockUIFromSource:(int)source withOptions:(id)options {
    %orig;
    VISetDeviceLocked(YES);
}

- (void)_finishUIUnlockFromSource:(int)source withOptions:(id)options {
    VISetDeviceLocked(NO);
    %orig;
}

- (BOOL)unlockUIFromSource:(int)source withOptions:(id)options {
    BOOL result = %orig;
    if (result) {
        VISetDeviceLocked(NO);
    }
    return result;
}

%end

// ============================================================================
// HOẠT ẢNH FACE ID (phỏng theo cơ chế "ProudLock" của Little12 / ProudLock2)
// Cách hoạt động: báo cho SpringBoard rằng máy có phần cứng Face ID (Pearl) và không có Touch ID (Mesa),
// nên hệ thống tự dựng biểu tượng ổ khóa + hoạt ảnh quét/mở khóa kiểu Face ID.
// Cần respring sau khi bật/tắt công tắc.
// ============================================================================
static void VISetBoolIvar(id object, const char *name, BOOL value) {
    if (!object) return;
    Ivar ivar = class_getInstanceVariable(object_getClass(object), name);
    if (!ivar) {
        VILog(@"[FaceID] không có ivar %s trong %@", name, NSStringFromClass([object class]));
        return;
    }
    *(BOOL *)((uint8_t *)(__bridge void *)object + ivar_getOffset(ivar)) = value;
}

%hook SBUIBiometricResource

- (id)init {
    id result = %orig;
    if (faceIDAnimationEnabled && result) {
        VISetBoolIvar(result, "_hasMesaHardware", NO);
        VISetBoolIvar(result, "_hasPearlHardware", YES);
    }
    return result;
}

%end

%hook SBUIPasscodeBiometricResource

- (BOOL)hasPearlSupport {
    return faceIDAnimationEnabled ? YES : %orig;
}

- (BOOL)hasMesaSupport {
    return faceIDAnimationEnabled ? NO : %orig;
}

%end

%hook SBDashBoardLockScreenEnvironment

// Sự kiện 4 = vân tay khớp. Với Face ID thật máy tự mở khóa, nên khi người dùng bật "đặt ngón tay để mở"
// ta mở khóa sau 0.25 giây giống Little12
- (void)handleBiometricEvent:(unsigned long long)event {
    %orig;
    if (!faceIDAnimationEnabled || event != 4) return;

    // Máy không có phần cứng Face ID nên hệ thống không bao giờ báo "đã xác thực": tự đánh dấu để glyph chuyển xanh
    viLockMatched = YES;
    VILog(@"[GLYPH] vân tay khớp -> chuyển glyph xanh lá");
    VIBrightenGlyph(viSystemLockElement);

    @try {
        id controller = [self valueForKey:@"_biometricUnlockController"];
        id configuration = controller ? [controller valueForKey:@"_biometricUnlockBehaviorConfiguration"] : nil;
        SEL restingSelector = NSSelectorFromString(@"_isAccessibilityRestingUnlockPreferenceEnabled");
        if (!configuration || ![configuration respondsToSelector:restingSelector]) return;

        BOOL resting = ((BOOL (*)(id, SEL))objc_msgSend)(configuration, restingSelector);
        if (!resting) return;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            id manager = [%c(SBLockScreenManager) sharedInstance];
            if ([manager respondsToSelector:@selector(isUILocked)] && [manager isUILocked]) {
                [manager _finishUIUnlockFromSource:12 withOptions:nil];
            }
        });
    } @catch (NSException *exception) {
        VILogException(@"mở khóa sau khi vân tay khớp", exception);
    }
}

%end

// ============================================================================
// HOẠT ẢNH FACE ID KHI KHÓA ỨNG DỤNG (LockTouchX) TRÊN DYNAMIC ISLAND
// LockTouchX gọi -[LAContext evaluatePolicy:localizedReason:reply:] ngay trong SpringBoard.
// Ta hook hàm đó: lúc bắt đầu -> hiện island quét, lúc reply -> thành công / thất bại rồi thu lại.
// Element là SBActivityProvidedContentElement (cùng họ với ổ khóa gốc SBLockElementViewProvider).
// ============================================================================
@interface LAContext : NSObject
@end

@interface VIAuthElementIdentity : NSObject
- (NSString *)elementIdentifier;
- (NSString *)clientIdentifier;
@end

@implementation VIAuthElementIdentity
- (NSString *)elementIdentifier { return @"com.ethxnn88.visibleisland.appauth"; }
- (NSString *)clientIdentifier { return @"com.ethxnn88.visibleisland"; }
@end

// LAUIPearlGlyphView không vẽ gì trên máy không có Face ID nên tự vẽ biểu tượng quét như iPhone 14 Pro:
// vòng tròn + hai kinh tuyến xoay (quả cầu lưới xanh cyan có quầng sáng); thành công = vòng xanh lá + dấu tích.
@interface VIScanView : UIView
- (void)startScanning;
- (void)showSuccess;
- (void)showFailure;
@end

@implementation VIScanView {
    CAShapeLayer *_ring;
    CAShapeLayer *_m1;
    CAShapeLayer *_m2;
    CAShapeLayer *_check;
    BOOL _finished;
}

+ (UIColor *)cyan { return [UIColor colorWithRed:0.55 green:0.86 blue:0.95 alpha:1.0]; }

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        CGColorRef cyan = [VIScanView cyan].CGColor;

        _ring = [CAShapeLayer layer];
        _ring.fillColor = nil;
        _ring.strokeColor = cyan;
        _ring.lineWidth = 1.6;
        _ring.shadowColor = cyan;
        _ring.shadowOpacity = 0.9f;
        _ring.shadowRadius = 3.0;
        _ring.shadowOffset = CGSizeZero;
        [self.layer addSublayer:_ring];

        CALayer *globe = [CALayer layer];
        CATransform3D persp = CATransform3DIdentity;
        persp.m34 = -1.0 / 120.0;
        globe.sublayerTransform = persp;
        globe.name = @"globe";
        [self.layer addSublayer:globe];

        for (int i = 0; i < 2; i++) {
            CAShapeLayer *m = [CAShapeLayer layer];
            m.fillColor = nil;
            m.strokeColor = cyan;
            m.lineWidth = 1.3;
            m.shadowColor = cyan;
            m.shadowOpacity = 0.8f;
            m.shadowRadius = 2.0;
            m.shadowOffset = CGSizeZero;
            [globe addSublayer:m];
            if (i == 0) _m1 = m; else _m2 = m;
        }

        _check = [CAShapeLayer layer];
        _check.fillColor = nil;
        _check.strokeColor = VIGlyphGreen().CGColor;
        _check.lineWidth = 1.8;
        _check.lineCap = kCALineCapRound;
        _check.lineJoin = kCALineJoinRound;
        _check.strokeEnd = 0.0;
        [self.layer addSublayer:_check];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect b = self.bounds;
    CGFloat d = MIN(b.size.width, b.size.height) * 0.62;
    CGRect circle = CGRectMake(CGRectGetMidX(b) - d / 2, CGRectGetMidY(b) - d / 2, d, d);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circle];
    _ring.frame = b;
    _ring.path = path.CGPath;
    for (CAShapeLayer *m in @[_m1, _m2]) {
        m.frame = b;
        m.path = path.CGPath;
        ((CALayer *)m.superlayer).frame = b;
    }
    _check.frame = b;
    CGFloat cx = CGRectGetMidX(b), cy = CGRectGetMidY(b), u = d / 22.0;
    UIBezierPath *tick = [UIBezierPath bezierPath];
    [tick moveToPoint:CGPointMake(cx - 4.5 * u, cy + 0.5 * u)];
    [tick addLineToPoint:CGPointMake(cx - 1.2 * u, cy + 3.8 * u)];
    [tick addLineToPoint:CGPointMake(cx + 4.8 * u, cy - 3.2 * u)];
    _check.path = tick.CGPath;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window && !_finished) [self startScanning];
}

- (void)startScanning {
    _finished = NO;
    _ring.strokeColor = [VIScanView cyan].CGColor;
    _ring.shadowColor = [VIScanView cyan].CGColor;
    _m1.opacity = 1.0f;
    _m2.opacity = 1.0f;
    _check.strokeEnd = 0.0;
    if ([_m1 animationForKey:@"vi.spin"]) return;
    NSArray *layers = @[_m1, _m2];
    for (NSUInteger i = 0; i < layers.count; i++) {
        CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        spin.fromValue = @(i * M_PI_2);
        spin.toValue = @(i * M_PI_2 + 2 * M_PI);
        spin.duration = 1.6;
        spin.repeatCount = HUGE_VALF;
        [layers[i] addAnimation:spin forKey:@"vi.spin"];
    }
    CALayer *globe = _m1.superlayer;
    CABasicAnimation *tilt = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    tilt.fromValue = @(-0.5);
    tilt.toValue = @(0.5);
    tilt.duration = 1.1;
    tilt.autoreverses = YES;
    tilt.repeatCount = HUGE_VALF;
    tilt.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [globe addAnimation:tilt forKey:@"vi.tilt"];
}

- (void)settleWithColor:(UIColor *)color {
    _finished = YES;
    [_m1 removeAllAnimations];
    [_m2 removeAllAnimations];
    [_m1.superlayer removeAllAnimations];
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = @1.0; fade.toValue = @0.0; fade.duration = 0.15;
    for (CALayer *m in @[_m1, _m2]) { m.opacity = 0.0f; [m addAnimation:fade forKey:@"vi.fade"]; }
    _ring.strokeColor = color.CGColor;
    _ring.shadowColor = color.CGColor;
    CABasicAnimation *tint = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    tint.fromValue = (id)[VIScanView cyan].CGColor; tint.toValue = (id)color.CGColor; tint.duration = 0.2;
    [_ring addAnimation:tint forKey:@"vi.tint"];
}

- (void)showSuccess {
    [self settleWithColor:VIGlyphGreen()];
    _check.strokeColor = VIGlyphGreen().CGColor;
    _check.strokeEnd = 1.0;
    CABasicAnimation *draw = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    draw.fromValue = @0.0; draw.toValue = @1.0; draw.duration = 0.3;
    [_check addAnimation:draw forKey:@"vi.draw"];
}

- (void)showFailure {
    UIColor *red = [UIColor colorWithRed:1.0 green:0.27 blue:0.23 alpha:1.0];
    [self settleWithColor:red];
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.values = @[@0, @-4, @4, @-3, @3, @0];
    shake.duration = 0.4;
    [self.layer addAnimation:shake forKey:@"vi.shake"];
}

@end

// Glyph Face ID bên trái: dùng đúng ảnh glyph xám của ổ khóa gốc (đã lưu ở màn hình khóa), xám -> xanh lá khi xác thực xong
@interface VIFaceView : UIView
- (void)setMode:(int)mode;   // 0 = xám (đang quét), 1 = xanh lá chói (thành công), 2 = đỏ (thất bại)
@end

@implementation VIFaceView {
    CALayer *_icon;
    CAGradientLayer *_halo;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        _halo = [CAGradientLayer layer];
        _halo.type = @"radial";
        _halo.startPoint = CGPointMake(0.5, 0.5);
        _halo.endPoint = CGPointMake(1.0, 1.0);
        _halo.opacity = 0.0f;
        [self.layer addSublayer:_halo];

        _icon = [CALayer layer];
        _icon.contentsGravity = kCAGravityResizeAspect;
        UIImage *image = viFaceImage;
        if (!image) {
            UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:30 weight:UIImageSymbolWeightRegular];
            image = [[UIImage systemImageNamed:@"faceid" withConfiguration:config] imageWithTintColor:[UIColor whiteColor] renderingMode:UIImageRenderingModeAlwaysOriginal];
            VILog(@"[AppAuth] chưa có ảnh glyph gốc, dùng SF Symbol faceid");
        }
        _icon.contentsScale = image.scale > 0 ? image.scale : 3.0;
        _icon.contents = (id)image.CGImage;
        [self.layer addSublayer:_icon];
        [self setMode:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _icon.frame = self.bounds;
    _halo.frame = CGRectInset(self.bounds, -6, -6);
}

- (void)setMode:(int)mode {
    UIColor *tint = [UIColor whiteColor];
    float alpha = 0.62f;
    float halo = 0.0f;
    if (mode == 1) { tint = [UIColor colorWithRed:0.20 green:0.90 blue:0.38 alpha:1.0]; alpha = 1.0f; halo = 1.0f; }
    if (mode == 2) { tint = [UIColor colorWithRed:1.0 green:0.27 blue:0.23 alpha:1.0]; alpha = 1.0f; halo = 0.7f; }
    _halo.colors = @[(id)[tint colorWithAlphaComponent:0.55].CGColor,
                     (id)[tint colorWithAlphaComponent:0.20].CGColor,
                     (id)[tint colorWithAlphaComponent:0.0].CGColor];
    _halo.locations = @[@0.0, @0.55, @1.0];
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    _icon.opacity = alpha;
    _halo.opacity = halo;
    @try { [_icon setValue:(id)tint.CGColor forKey:@"contentsMultiplyColor"]; } @catch (NSException *e) {}
    [CATransaction commit];
}

@end

static NSDirectionalEdgeInsets VIAuthOutsets(id self, SEL _cmd, long long mode, NSDirectionalEdgeInsets suggested, NSDirectionalEdgeInsets maximum) {
    if (mode != 3) return suggested;
    NSDirectionalEdgeInsets result = NSDirectionalEdgeInsetsMake(4, 33, 6, 33);
    const char *source = "mặc định";
    id lock = viSystemLockElement;
    if (lock && [lock respondsToSelector:_cmd]) {
        result = ((VIOutsetsFn)objc_msgSend)(lock, _cmd, mode, suggested, maximum);
        source = "ổ khóa gốc";
    }
    static int logged = 0;
    if (logged < 8) {
        logged++;
        VILog(@"[AppAuth] outsets mode=%lld nguồn=%s -> top=%.1f leading=%.1f bottom=%.1f trailing=%.1f | suggested=(%.1f %.1f %.1f %.1f) max=(%.1f %.1f %.1f %.1f)",
              mode, source, result.top, result.leading, result.bottom, result.trailing,
              suggested.top, suggested.leading, suggested.bottom, suggested.trailing,
              maximum.top, maximum.leading, maximum.bottom, maximum.trailing);
    }
    return result;
}

// Lớp con của SBActivityProvidedContentElement chỉ khác ở kích thước island, bám theo ổ khóa gốc
static Class VIAuthElementClass(void) {
    static Class cls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        Class base = NSClassFromString(@"SBActivityProvidedContentElement");
        if (!base) return;
        cls = objc_allocateClassPair(base, "VIAuthActivityElement", 0);
        if (!cls) { cls = NSClassFromString(@"VIAuthActivityElement"); return; }
        class_addMethod(cls, NSSelectorFromString(@"preferredEdgeOutsetsForLayoutMode:suggestedOutsets:maximumOutsets:"),
                        (IMP)VIAuthOutsets, "{NSDirectionalEdgeInsets=dddd}@:q{NSDirectionalEdgeInsets=dddd}{NSDirectionalEdgeInsets=dddd}");
        objc_registerClassPair(cls);
    });
    return cls ?: NSClassFromString(@"SBActivityProvidedContentElement");
}

static SAAssertion *viAuthAssertion = nil;
static VIScanView *viAuthScan = nil;
static VIFaceView *viAuthFace = nil;
static NSUInteger viAuthSession = 0;
static CFAbsoluteTime viAuthStart = 0;   // lúc island bắt đầu quét
#define VI_AUTH_MIN_SCAN 0.0              // không chờ: vân tay xong là chuyển ✓ ngay

static BOOL VICalledFromLockTouchX(void) {
    NSArray<NSString *> *symbols = [NSThread callStackSymbols];
    NSUInteger count = MIN((NSUInteger)12, symbols.count);
    for (NSUInteger i = 0; i < count; i++) {
        if ([symbols[i] containsString:@"LockTouchX"]) return YES;
    }
    return NO;
}

static void VIAuthSetFaceMode(int mode) {
    @try {
        [viAuthFace setMode:mode];
    } @catch (NSException *exception) {
        VILogException(@"đổi màu biểu tượng Face ID", exception);
    }
}

static id VIBuildAuthElement(void) {
    Class providerClass = NSClassFromString(@"SBUISystemApertureContentProvider");
    Class imageClass = NSClassFromString(@"SBUISystemApertureImageContentProvider");
    Class customClass = NSClassFromString(@"SBUISystemApertureCustomContentProvider");
    Class elementClass = VIAuthElementClass();
    if (!providerClass || !imageClass || !customClass || !elementClass) {
        VILog(@"[AppAuth] thiếu class: provider=%d image=%d custom=%d element=%d",
              providerClass != nil, imageClass != nil, customClass != nil, elementClass != nil);
        return nil;
    }

    VILog(@"[AppAuth 1] biểu tượng Face ID bên trái");
    VIFaceView *faceView = [[VIFaceView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    viAuthFace = faceView;
    id leading = ((id (*)(id, SEL, id))objc_msgSend)([customClass alloc], NSSelectorFromString(@"initWithView:"), faceView);

    VILog(@"[AppAuth 2] biểu tượng quét bên phải (tự vẽ)");
    VIScanView *container = [[VIScanView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    viAuthScan = container;

    SEL initWithView = NSSelectorFromString(@"initWithView:");
    id trailing = ((id (*)(id, SEL, id))objc_msgSend)([customClass alloc], initWithView, container);

    VILog(@"[AppAuth 3] ghép content provider");
    SBUISystemApertureContentProvider *provider = [[providerClass alloc] init];
    [provider setLeadingContentViewProvider:leading];
    [provider setTrailingContentViewProvider:trailing];

    Protocol *identifying = NSProtocolFromString(@"SAElementIdentifying");
    if (identifying && ![VIAuthElementIdentity conformsToProtocol:identifying]) {
        class_addProtocol([VIAuthElementIdentity class], identifying);
    }
    VILog(@"[AppAuth 4] tạo element");
    id element = nil;
    @try {
        element = [[elementClass alloc] initWithIdentifier:[[VIAuthElementIdentity alloc] init] contentProvider:provider];
    } @catch (NSException *exception) {
        VILogException(@"dựng element xác thực", exception);
        return nil;
    }
    return element;
}

// Hộp thoại "Touch ID cho ..." do hệ thống dựng (cửa sổ remote alert trong SpringBoard). Trong lúc island đang chạy
// ta đặt alpha = 0 cho các cửa sổ đó (vẫn nhận vân tay, chỉ không hiện), xong thì trả lại.
static NSTimer *viAuthUITimer = nil;
static NSHashTable<UIWindow *> *viHiddenAuthWindows = nil;
static NSMutableSet<NSString *> *viSeenWindowSigs = nil;

static void VICollectViewClasses(UIView *view, int depth, NSMutableString *out) {
    if (!view || depth > 3) return;
    [out appendFormat:@"%@,", NSStringFromClass([view class])];
    for (UIView *sub in view.subviews) VICollectViewClasses(sub, depth + 1, out);
}

static void VIAuthHideAlertTick(void) {
    @try {
        NSArray *windows = nil;
        SEL all = NSSelectorFromString(@"allWindowsIncludingInternalWindows:onlyVisibleWindows:");
        if ([UIWindow respondsToSelector:all]) {
            windows = ((id (*)(id, SEL, BOOL, BOOL))objc_msgSend)([UIWindow class], all, YES, YES);
        }
        if (!windows) windows = @[];
        if (!viHiddenAuthWindows) viHiddenAuthWindows = [NSHashTable weakObjectsHashTable];
        if (!viSeenWindowSigs) viSeenWindowSigs = [NSMutableSet set];

        NSArray<NSString *> *tokens = @[@"RemoteAlert", @"CoreAuth", @"LocalAuth", @"LAUI", @"_UIRemoteView"];
        NSArray<NSString *> *skip = @[@"SystemAperture", @"Banner", @"Keyboard", @"TextEffects"];
        for (UIWindow *window in windows) {
            NSString *className = NSStringFromClass([window class]);
            BOOL skipped = NO;
            for (NSString *word in skip) { if ([className containsString:word]) { skipped = YES; break; } }
            if (skipped) continue;

            NSMutableString *signature = [NSMutableString stringWithFormat:@"%@ | root=%@ | ", className,
                                          window.rootViewController ? NSStringFromClass([window.rootViewController class]) : @"-"];
            VICollectViewClasses(window, 0, signature);
            BOOL match = NO;
            for (NSString *token in tokens) { if ([signature containsString:token]) { match = YES; break; } }

            NSString *shortSig = signature.length > 260 ? [signature substringToIndex:260] : signature;
            if (viSeenWindowSigs.count < 40 && ![viSeenWindowSigs containsObject:shortSig]) {
                [viSeenWindowSigs addObject:shortSig];
                VILog(@"[AuthUI] cửa sổ: %@ alpha=%.2f level=%.0f khớp=%d", shortSig, window.alpha, window.windowLevel, match);
            }
            if (match && window.alpha > 0.01) {
                window.alpha = 0.0;
                [viHiddenAuthWindows addObject:window];
            }
        }
    } @catch (NSException *exception) {
        VILogException(@"ẩn hộp thoại Touch ID", exception);
    }
}

static void VIAuthUIStart(void) {
    if (viAuthUITimer) return;
    VIAuthHideAlertTick();
    viAuthUITimer = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer *timer) { VIAuthHideAlertTick(); }];
}

static void VIAuthUIStop(void) {
    [viAuthUITimer invalidate];
    viAuthUITimer = nil;
    NSArray<UIWindow *> *hidden = viHiddenAuthWindows.allObjects;
    [viHiddenAuthWindows removeAllObjects];
    if (!hidden.count) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIWindow *window in hidden) window.alpha = 1.0;
    });
}

static void VIAuthHide(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        VIAuthUIStop();
        if (!viAuthAssertion || ![viAuthAssertion isValid]) {
            viAuthAssertion = nil;
            return;
        }
        VILog(@"[AppAuth] gỡ element xác thực");
        VIGuardArm();
        @try {
            [viAuthAssertion invalidateWithReason:@"VisibleIsland: xác thực xong"];
        } @catch (NSException *exception) {
            VILogException(@"gỡ element xác thực", exception);
        }
        viAuthAssertion = nil;
        VIGuardDisarmSoon();
    });
}

static void VIAuthShow(void) {
    if (!isSpringBoardProcess || !appAuthIslandEnabled) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        viAuthSession++;
        NSUInteger session = viAuthSession;
        viAuthStart = CFAbsoluteTimeGetCurrent();

        if (viAuthAssertion && [viAuthAssertion isValid]) {
            VIAuthUIStart();
            [viAuthScan startScanning];
            VIAuthSetFaceMode(0);
        } else {
            if (viGuardTripped) {
                VILog(@"[AppAuth] bỏ qua vì guard đang bật (lần chạy trước crash)");
                return;
            }
            id controller = viController;
            if (!controller) {
                VILog(@"[AppAuth] chưa có SBSystemApertureController");
                return;
            }
            VILog(@"[AppAuth] bắt đầu dựng element");
            VIGuardArm();
            viAuthElement = VIBuildAuthElement();
            if (!viAuthElement) {
                VIGuardDisarmSoon();
                return;
            }
            @try {
                viAuthAssertion = [controller registerElement:viAuthElement];
            } @catch (NSException *exception) {
                VILogException(@"registerElement: (xác thực)", exception);
                viAuthAssertion = nil;
                VIGuardDisarmSoon();
                return;
            }
            VILog(@"[AppAuth] đã đăng ký: %@ valid=%d | preferred=%lld", viAuthAssertion,
                  viAuthAssertion ? [viAuthAssertion isValid] : 0, [viAuthElement preferredLayoutMode]);
            VIGuardDisarmSoon();
            VIAuthUIStart();

            // Glyph chỉ chạy khi đã nằm trong window nên đặt trạng thái quét sau khi island kịp mở ra
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                VILog(@"[AppAuth] scan view frame=%@ window=%d layoutMode=%lld", NSStringFromCGRect(viAuthScan.frame),
                      viAuthScan.window != nil, [viAuthElement layoutMode]);
                [viAuthScan startScanning];
                @try {
                    id host = [viAuthElement valueForKey:@"elementHost"];
                    if (host) {
                        unsigned int n = 0;
                        Method *list = class_copyMethodList([host class], &n);
                        NSMutableArray *names = [NSMutableArray array];
                        for (unsigned int i = 0; i < n; i++) {
                            NSString *name = NSStringFromSelector(method_getName(list[i]));
                            if ([name rangeOfString:@"ayout" options:NSCaseInsensitiveSearch].location != NSNotFound) [names addObject:name];
                        }
                        free(list);
                        VILog(@"[AppAuth] elementHost %@ methods: %@", NSStringFromClass([host class]), [names componentsJoinedByString:@", "]);
                    }
                } @catch (NSException *e) {}
            });
        }

        // Phòng khi reply không bao giờ tới: tự thu island sau 25 giây
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (session == viAuthSession) VIAuthHide();
        });
    });
}

static void VIAuthFinish(BOOL success, NSError *error) {
    if (!isSpringBoardProcess) return;
    NSInteger code = error ? error.code : 0;
    BOOL cancelled = !success && (code == -2 || code == -4 || code == -9);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!viAuthAssertion || ![viAuthAssertion isValid]) return;
        NSUInteger session = viAuthSession;

        // Touch ID trả lời gần như tức thì, còn Face ID thật quét ~2 giây: giữ trạng thái quét cho đủ lâu
        // rồi mới báo kết quả. Hủy (-2/-4/-9) thì thu island ngay, không hiện lỗi.
        NSTimeInterval wait = 0;
        if (!cancelled) {
            wait = VI_AUTH_MIN_SCAN - (CFAbsoluteTimeGetCurrent() - viAuthStart);
            if (wait < 0) wait = 0;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(wait * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (session != viAuthSession || !viAuthAssertion || ![viAuthAssertion isValid]) return;
            NSTimeInterval delay = 0.1;
            if (success) {
                [viAuthScan showSuccess];
                VIAuthSetFaceMode(1);
                delay = 1.0;
            } else if (!cancelled) {
                [viAuthScan showFailure];
                VIAuthSetFaceMode(2);
                delay = 0.8;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (session == viAuthSession) VIAuthHide();
            });
        });
    });
}

// Cầu nối giữa các tiến trình: app gọi LAContext trong tiến trình của nó, island nằm trong SpringBoard
#define VI_NOTE_START   @"com.ethxnn88.visibleisland.auth.start"
#define VI_NOTE_SUCCESS @"com.ethxnn88.visibleisland.auth.success"
#define VI_NOTE_FAIL    @"com.ethxnn88.visibleisland.auth.fail"
#define VI_NOTE_CANCEL  @"com.ethxnn88.visibleisland.auth.cancel"

static void VIPostAuthNote(NSString *name) {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge CFStringRef)name, NULL, NULL, YES);
}

static BOOL VIIsPlainAppProcess(void) {
    static int cached = -1;
    if (cached >= 0) return cached;
    cached = 0;
    if (isSpringBoardProcess) return NO;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *identifier = bundle.bundleIdentifier;
    if (!identifier.length) return NO;
    for (NSString *prefix in @[@"com.apple.CoreAuth", @"com.apple.coreauth", @"com.apple.LocalAuth", @"com.apple.backboardd"]) {
        if ([identifier hasPrefix:prefix]) return NO;
    }
    cached = [[bundle objectForInfoDictionaryKey:@"CFBundlePackageType"] isEqual:@"APPL"] ? 1 : 0;
    return cached;
}

static void VIAuthNoteCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSString *note = (__bridge NSString *)name;
    VILog(@"[AppAuth] nhận thông báo từ app: %@", note);
    if ([note isEqualToString:VI_NOTE_START]) {
        VIAuthShow();
    } else if ([note isEqualToString:VI_NOTE_SUCCESS]) {
        VIAuthFinish(YES, nil);
    } else if ([note isEqualToString:VI_NOTE_FAIL]) {
        VIAuthFinish(NO, [NSError errorWithDomain:@"com.apple.LocalAuthentication" code:-1 userInfo:nil]);
    } else if ([note isEqualToString:VI_NOTE_CANCEL]) {
        VIAuthFinish(NO, [NSError errorWithDomain:@"com.apple.LocalAuthentication" code:-2 userInfo:nil]);
    }
}

%hook LAContext

- (void)evaluatePolicy:(NSInteger)policy localizedReason:(NSString *)localizedReason reply:(void (^)(BOOL, NSError *))reply {
    // policy 1 = chỉ sinh trắc học, 2 = sinh trắc học + mật mã: cả hai đều quét vân tay
    BOOL biometricPolicy = (policy == 1 || policy == 2);
    if (isSpringBoardProcess) {
        NSArray<NSString *> *symbols = [NSThread callStackSymbols];
        NSUInteger count = MIN((NSUInteger)8, symbols.count);
        VILog(@"[AppAuth] evaluatePolicy policy=%ld appAuth=%d lockTouchX=%d\n    %@", (long)policy, appAuthIslandEnabled,
              VICalledFromLockTouchX(), [[symbols subarrayWithRange:NSMakeRange(0, count)] componentsJoinedByString:@"\n    "]);
        if (appAuthIslandEnabled && biometricPolicy) {
            VIAuthShow();
            void (^wrapped)(BOOL, NSError *) = ^(BOOL success, NSError *error) {
                VILog(@"[AppAuth] kết quả: success=%d code=%ld", success, (long)(error ? error.code : 0));
                VIAuthFinish(success, error);
                if (reply) reply(success, error);
            };
            %orig(policy, localizedReason, wrapped);
            return;
        }
    } else if (appAuthIslandEnabled && biometricPolicy && VIIsPlainAppProcess()) {
        VIPostAuthNote(VI_NOTE_START);
        void (^wrapped)(BOOL, NSError *) = ^(BOOL success, NSError *error) {
            NSInteger code = error ? error.code : 0;
            BOOL cancelled = !success && (code == -2 || code == -3 || code == -4 || code == -9);
            VIPostAuthNote(success ? VI_NOTE_SUCCESS : (cancelled ? VI_NOTE_CANCEL : VI_NOTE_FAIL));
            if (reply) reply(success, error);
        };
        %orig(policy, localizedReason, wrapped);
        return;
    }
    %orig;
}

%end

%ctor {
    isSpringBoardProcess = [[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"];
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
        VIGuardCheckAtLaunch();
        for (NSString *note in @[VI_NOTE_START, VI_NOTE_SUCCESS, VI_NOTE_FAIL, VI_NOTE_CANCEL]) {
            CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, VIAuthNoteCallback,
                                            (__bridge CFStringRef)note, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        }
        VILog(@"VisibleIsland khởi động, build %@ | faceID=%d appAuth=%d", VI_BUILD_TAG, faceIDAnimationEnabled, appAuthIslandEnabled);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![[NSFileManager defaultManager] fileExistsAtPath:VI_LOCK_DUMP_PATH]) {
                VIDiagnoseLock();
            }
            NSString *packageDump = @"/var/mobile/Documents/VisibleIsland_pkg_dump.txt";
            if (![[NSFileManager defaultManager] fileExistsAtPath:packageDump]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    VIDumpClassesMatching(@[@"BSUICAPackage", @"SBUIFaceID"], packageDump);
                    VILog(@"[DIAG] dump BSUICAPackage xong");
                });
            }
        });

        // Sau respring máy có thể đang khóa: đồng bộ ổ khóa với trạng thái thật
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            id manager = [%c(SBLockScreenManager) sharedInstance];
            if ([manager respondsToSelector:@selector(isUILocked)]) {
                VISetDeviceLocked([manager isUILocked]);
            }
        });

        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            NULL,
            respring,
            CFSTR("com.ethxnn88.visibleislandprefs-respring"),
            NULL,
            CFNotificationSuspensionBehaviorCoalesce
        );

    }
}
