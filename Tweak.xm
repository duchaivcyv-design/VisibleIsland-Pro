#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <sys/sysctl.h>
#import <objc/runtime.h>

// ====================================================================================================
// VISIBLE ISLAND — BẢN MOD CHUẨN IPHONE 18 PRO MAX (GIỮ NGUYÊN SETTINGS GỐC + 2 BÊN METABALL + XOAY NGANG)
// ====================================================================================================

CGFloat red = 0.0;
CGFloat green = 0.0;
CGFloat blue = 0.0;
CGFloat alpha = 1.0;

CGFloat scale = 1.0;

CGFloat xPos =  0;
CGFloat yPos =  20.5;
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

@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)arg1;
@end

@interface SBSystemApertureWindow : UIWindow
@end

@interface _SBSystemApertureMagiciansCurtainView : UIView
@end

@interface SBBannerWindow : UIWindow
@end

@interface _SBGainMapView : UIView
@end

@interface _SBSystemApertureContainerViewContentView : UIView
@end

@interface SBFTouchPassThroughView : UIView
@end

@interface SBSystemApertureViewController : UIViewController
@end

@interface SBSystemApertureContainerView : UIView
@end

@interface Model : NSObject
+ (NSString *)deviceModel;
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

@end

// ====================================================================================================
// BỘ ĐIỀU KHIỂN HIỆU ỨNG IPHONE 18 PRO MAX:
// 1. Nảy giọt nước 2 bên (Trái + Phải) mượt 100% như Video 1 & 2
// 2. Xoay ngang màn hình (Landscape): Giữ nguyên Dynamic Island ở góc trên bên trái, nhấn giữ đang nghe
//    nhạc nảy bung ra từ góc trên bên trái không bị mất hiệu ứng hay đè bóng đen
// ====================================================================================================

static UIView *g_leftDetachedBubble = nil;
static UIView *g_leftMetaballNeck = nil;
static BOOL g_isIslandExpanded = NO;

static inline BOOL VI_IsLandscapeOrientation(void) {
    UIInterfaceOrientation orient = UIInterfaceOrientationPortrait;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    orient = [[UIApplication sharedApplication] statusBarOrientation];
    #pragma clang diagnostic pop
    if (UIInterfaceOrientationIsLandscape(orient)) return YES;

    UIDeviceOrientation devOrient = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(devOrient)) return YES;

    CGRect bounds = [UIScreen mainScreen].bounds;
    return (bounds.size.width > bounds.size.height);
}

static inline CGFloat VI_DefaultDeviceYOffset(NSString *deviceModel) {
    if (!deviceModel) return 20.5;
    if ([deviceModel isEqualToString:@"iPhone10,3"] ||
        [deviceModel isEqualToString:@"iPhone10,6"] ||
        [deviceModel isEqualToString:@"iPhone11,2"] ||
        [deviceModel isEqualToString:@"iPhone12,3"]) {
        return 20.5;
    } else if ([deviceModel isEqualToString:@"iPhone11,6"] ||
               [deviceModel isEqualToString:@"iPhone12,5"] ||
               [deviceModel isEqualToString:@"iPhone11,8"] ||
               [deviceModel isEqualToString:@"iPhone12,1"] ||
               [deviceModel isEqualToString:@"iPhone14,4"]) {
        return 22.5;
    } else if ([deviceModel isEqualToString:@"iPhone13,2"] ||
               [deviceModel isEqualToString:@"iPhone13,3"]) {
        return 21.5;
    } else if ([deviceModel isEqualToString:@"iPhone13,1"]) {
        return 19.5;
    } else if ([deviceModel isEqualToString:@"iPhone13,4"]) {
        return 22.3;
    } else if ([deviceModel isEqualToString:@"iPhone14,5"] ||
               [deviceModel isEqualToString:@"iPhone14,2"] ||
               [deviceModel isEqualToString:@"iPhone14,7"]) {
        return 24.0;
    } else if ([deviceModel isEqualToString:@"iPhone14,3"]) {
        return 26.0;
    }
    return 11.0; // Cho iPhone 8 Plus / Home Button hoặc thiết bị khác
}

static inline CGFloat VI_DefaultBannerYOffset(NSString *deviceModel) {
    if (!deviceModel) return 35.0;
    if ([deviceModel isEqualToString:@"iPhone10,3"] ||
        [deviceModel isEqualToString:@"iPhone10,6"] ||
        [deviceModel isEqualToString:@"iPhone11,2"] ||
        [deviceModel isEqualToString:@"iPhone12,3"] ||
        [deviceModel isEqualToString:@"iPhone13,2"] ||
        [deviceModel isEqualToString:@"iPhone13,3"]) {
        return 35.0;
    } else if ([deviceModel isEqualToString:@"iPhone11,6"] ||
               [deviceModel isEqualToString:@"iPhone12,5"] ||
               [deviceModel isEqualToString:@"iPhone11,8"] ||
               [deviceModel isEqualToString:@"iPhone12,1"]) {
        return 37.0;
    } else if ([deviceModel isEqualToString:@"iPhone13,1"]) {
        return 33.0;
    } else if ([deviceModel isEqualToString:@"iPhone13,4"] ||
               [deviceModel isEqualToString:@"iPhone14,4"]) {
        return 38.0;
    } else if ([deviceModel isEqualToString:@"iPhone14,5"] ||
               [deviceModel isEqualToString:@"iPhone14,2"] ||
               [deviceModel isEqualToString:@"iPhone14,7"]) {
        return 40.0;
    } else if ([deviceModel isEqualToString:@"iPhone14,3"]) {
        return 42.0;
    }
    return 35.0;
}

%hook SBSystemApertureWindow

// Giữ cho cửa sổ Dynamic Island luôn hiển thị cả khi xoay ngang màn hình
- (void)setHidden:(BOOL)hidden {
    if (VI_IsLandscapeOrientation()) {
        %orig(NO);
        return;
    }
    %orig(hidden);
}

- (BOOL)_shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return YES;
}

- (void)layoutSubviews {
    %orig;

    BOOL isLandscape = VI_IsLandscapeOrientation();
    CGFloat safeScale = (scale > 0.1f) ? scale : 1.0f;
    NSString *deviceModel = [Model deviceModel];

    // XỬ LÝ KHI XOAY NGANG MÀN HÌNH (LANDSCAPE):
    // Giữ nguyên hiệu ứng Dynamic Island nằm ở góc trên bên trái và khi giữ nghe nhạc nảy ra từ góc trên bên trái
    if (isLandscape) {
        if (scaleEnabled) {
            self.transform = CGAffineTransformMakeScale(safeScale, safeScale);
        } else {
            self.transform = CGAffineTransformIdentity;
        }
        CGRect frame = self.frame;
        // Neo góc trên bên trái khi xoay ngang để hiệu ứng bung nhạc nảy từ bên trái phía trên
        CGFloat landY = posEnabled ? (yPos / (scaleEnabled ? safeScale : 1.0f)) : 10.0f;
        CGFloat landX = posEnabled && xPos != 0 ? (xPos / (scaleEnabled ? safeScale : 1.0f)) : -([UIScreen mainScreen].bounds.size.width * 0.28f);
        frame.origin.y = landY;
        frame.origin.x = landX;
        self.frame = frame;
        self.hidden = NO;
        self.alpha = 1.0f;
        return;
    }

    // XỬ LÝ MÀN HÌNH DỌC (GIỮ NGUYÊN 100% LOGIC SETTINGS GỐC CỦA TWEAK)
    if (scaleEnabled && fixEnabled) {
        self.transform = CGAffineTransformMakeScale(safeScale, safeScale);
        %orig;
        CGFloat SyPos = VI_DefaultDeviceYOffset(deviceModel) / safeScale;
        CGRect frame = self.frame;
        frame.origin.y = SyPos;
        self.frame = frame;
    } else if (scaleEnabled && posEnabled) {
        self.transform = CGAffineTransformMakeScale(safeScale, safeScale);
        %orig;
        CGFloat SyPos = yPos / safeScale;
        CGRect frame = self.frame;
        frame.origin.y = SyPos;
        if (xPos != 0) {
            CGFloat SxPos = xPos / safeScale;
            frame.origin.x = SxPos;
        }
        self.frame = frame;
    } else if (fixEnabled && !scaleEnabled) {
        %orig;
        CGRect frame = self.frame;
        frame.origin.y = VI_DefaultDeviceYOffset(deviceModel);
        self.frame = frame;
    } else if (posEnabled && !scaleEnabled) {
        %orig;
        CGRect frame = self.frame;
        frame.origin.y = yPos;
        frame.origin.x = xPos;
        self.frame = frame;
    } else if (scaleEnabled && (!posEnabled || !fixEnabled)) {
        self.transform = CGAffineTransformMakeScale(safeScale, safeScale);
    }
}

%end

// ====================================================================================================
// BẺ KHÓA XOAY NGANG & HIỆU ỨNG NẢY 2 BÊN (DUAL DETACHED BUBBLES NHƯ VIDEO 1 - 2)
// ====================================================================================================

%hook SBSystemApertureViewController

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLayoutSubviews {
    %orig;

    UIView *rootView = self.view;
    if (!rootView) return;

    // Ẩn lớp bóng đen/viền thừa khi bung lớn để không bị lỗi 2 hình đè nhau như Video 3
    for (UIView *sub in rootView.subviews) {
        NSString *clsName = NSStringFromClass([sub class]);
        if ([clsName containsString:@"Curtain"] || [clsName containsString:@"GainMap"]) {
            if (fixEnabled || posEnabled || hideEnabled) {
                sub.hidden = YES;
                sub.alpha = 0.0f;
            }
        }
    }
}

%end

// Hook vào Container của SystemAperture để tạo hiệu ứng nảy 2 giọt nước 2 bên (Trái + Phải) chuẩn 18 Pro Max
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

    // KIỂM TRA CÁC CONTAINER CON CỦA DYNAMIC ISLAND ĐỂ KÍCH HOẠT NẢY 2 BÊN & XOAY NGANG
    if (self.subviews.count >= 2) {
        UIView *primaryContainer = nil;
        UIView *secondaryContainer = nil;

        for (UIView *sub in self.subviews) {
            NSString *cls = NSStringFromClass([sub class]);
            if ([cls containsString:@"SystemApertureContainerView"]) {
                if (!primaryContainer) {
                    primaryContainer = sub;
                } else if (!secondaryContainer) {
                    secondaryContainer = sub;
                }
            }
        }

        if (primaryContainer) {
            primaryContainer.layer.cornerCurve = kCACornerCurveContinuous;
            BOOL isExpandedNow = (primaryContainer.bounds.size.height > 65.0f || primaryContainer.bounds.size.width > 280.0f);

            // Nếu đang xoay ngang màn hình và nhấn giữ bung trình phát nhạc:
            // Ép khung bung nảy ra từ góc trên bên trái mượt mà, không bị mất hiệu ứng
            if (VI_IsLandscapeOrientation()) {
                CGRect pFrame = primaryContainer.frame;
                if (isExpandedNow) {
                    pFrame.origin.x = 18.0f;
                    pFrame.origin.y = 12.0f;
                    primaryContainer.frame = pFrame;
                } else {
                    pFrame.origin.x = 18.0f;
                    pFrame.origin.y = 10.0f;
                    primaryContainer.frame = pFrame;
                }
            }

            // HIỆU ỨNG NẢY 2 CÁI 2 BÊN (TRÁI & PHẢI) GIỐNG VIDEO 1 & 2 (IPHONE 18 PRO MAX)
            // Khi có pill phụ bên phải (secondaryContainer đang hiển thị) và đảo ở trạng thái thu gọn:
            if (secondaryContainer && !secondaryContainer.hidden && secondaryContainer.alpha > 0.01f && !isExpandedNow && secondaryContainer.bounds.size.width > 10.0f) {
                secondaryContainer.layer.cornerCurve = kCACornerCurveContinuous;

                // Căn chỉnh giọt nước bên phải tách chuẩn khoảng cách metaball 8pt
                CGRect mainRect = primaryContainer.frame;
                CGRect rightRect = secondaryContainer.frame;
                CGFloat bubbleSize = mainRect.size.height;
                rightRect.size.width = bubbleSize;
                rightRect.size.height = bubbleSize;
                rightRect.origin.y = mainRect.origin.y;
                rightRect.origin.x = CGRectGetMaxX(mainRect) + 8.0f;
                secondaryContainer.frame = rightRect;
                secondaryContainer.layer.cornerRadius = bubbleSize / 2.0f;

                // Khởi tạo giọt nước đối xứng bên trái (Left Detached Bubble) nảy ra từ bên trái đảo như Video 1
                if (!g_leftDetachedBubble) {
                    g_leftDetachedBubble = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(mainRect), mainRect.origin.y, bubbleSize, bubbleSize)];
                    g_leftDetachedBubble.backgroundColor = [UIColor blackColor];
                    g_leftDetachedBubble.layer.cornerCurve = kCACornerCurveContinuous;
                    g_leftDetachedBubble.clipsToBounds = YES;
                    g_leftDetachedBubble.userInteractionEnabled = NO;

                    // Chấm tròn/vòng biểu tượng bên trái giống hiệu ứng A10 / Live Activity trong Video 1 & 2
                    UIView *innerBadge = [[UIView alloc] initWithFrame:CGRectMake(5.5f, 5.5f, bubbleSize - 11.0f, bubbleSize - 11.0f)];
                    innerBadge.backgroundColor = [UIColor colorWithRed:1.0f green:0.82f blue:0.0f alpha:1.0f];
                    innerBadge.layer.cornerRadius = (bubbleSize - 11.0f) / 2.0f;
                    innerBadge.tag = 1801;
                    [g_leftDetachedBubble addSubview:innerBadge];
                }

                if (g_leftDetachedBubble.superview != self) {
                    [self addSubview:g_leftDetachedBubble];
                }

                CGRect targetLeftRect = CGRectMake(CGRectGetMinX(mainRect) - bubbleSize - 8.0f, mainRect.origin.y, bubbleSize, bubbleSize);
                g_leftDetachedBubble.layer.cornerRadius = bubbleSize / 2.0f;

                UIView *badge = [g_leftDetachedBubble viewWithTag:1801];
                if (badge) {
                    badge.frame = CGRectMake(5.5f, 5.5f, bubbleSize - 11.0f, bubbleSize - 11.0f);
                    badge.layer.cornerRadius = (bubbleSize - 11.0f) / 2.0f;
                }

                if (g_leftDetachedBubble.alpha < 0.5f) {
                    // Bắt đầu từ trong lòng viên thuốc chính rồi búng đàn hồi sang bên trái
                    g_leftDetachedBubble.frame = CGRectMake(CGRectGetMinX(mainRect) + 4.0f, mainRect.origin.y, bubbleSize, bubbleSize);
                    g_leftDetachedBubble.transform = CGAffineTransformMakeScale(0.4f, 0.4f);
                    [UIView animateWithDuration:0.52
                                          delay:0.0
                         usingSpringWithDamping:0.65f
                          initialSpringVelocity:0.9f
                                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                                     animations:^{
                        g_leftDetachedBubble.alpha = 1.0f;
                        g_leftDetachedBubble.transform = CGAffineTransformIdentity;
                        g_leftDetachedBubble.frame = targetLeftRect;
                    } completion:nil];
                } else {
                    g_leftDetachedBubble.frame = targetLeftRect;
                }
            } else {
                // Khi thu về hoặc khi nhấn giữ bung lớn trình phát nhạc: hút giọt nước bên tráiกลับ vào trong đảo chính
                if (g_leftDetachedBubble && g_leftDetachedBubble.alpha > 0.0f) {
                    CGRect mainRect = primaryContainer.frame;
                    [UIView animateWithDuration:0.35
                                          delay:0.0
                         usingSpringWithDamping:0.78f
                          initialSpringVelocity:0.6f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                        g_leftDetachedBubble.alpha = 0.0f;
                        g_leftDetachedBubble.transform = CGAffineTransformMakeScale(0.3f, 0.3f);
                        g_leftDetachedBubble.frame = CGRectMake(CGRectGetMinX(mainRect) + 8.0f, mainRect.origin.y, mainRect.size.height, mainRect.size.height);
                    } completion:nil];
                }
            }

            // Khi nhấn giữ bung trình phát nhạc (Transition Compact -> Expanded):
            // Tạo lực nảy đàn hồi từ vị trí đảo (hoặc góc trái trên khi xoay ngang)
            if (isExpandedNow != g_isIslandExpanded) {
                g_isIslandExpanded = isExpandedNow;
                primaryContainer.transform = CGAffineTransformMakeScale(0.92f, 0.92f);
                [UIView animateWithDuration:0.48
                                      delay:0.0
                     usingSpringWithDamping:0.70f
                      initialSpringVelocity:0.85f
                                    options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                                 animations:^{
                    primaryContainer.transform = CGAffineTransformIdentity;
                } completion:nil];
            }
        }
    }
}

%end

// Chặn triệt để lớp rèm đen (_SBSystemApertureMagiciansCurtainView) gây lỗi bóng đen đè lên nhau trong Video 3
%hook _SBSystemApertureMagiciansCurtainView

-(void)didMoveToWindow {
    %orig;
    self.hidden = YES;
    self.alpha = 0.0f;
}

-(void)layoutSubviews {
    %orig;
    self.hidden = YES;
    self.alpha = 0.0f;
}

%end

%hook _SBGainMapView

- (void)didMoveToWindow {
    %orig;
    if (hideEnabled || fixEnabled || posEnabled) {
        self.hidden = YES;
        self.alpha = 0.0f;
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

%hook SBBannerWindow

- (CGRect)frame {
    CGRect origFrame = %orig;
    NSString *deviceModel = [Model deviceModel];
    if (notificationFix) {
        origFrame.origin.x = 0.0f;
        origFrame.origin.y = VI_DefaultBannerYOffset(deviceModel);
        return origFrame;
    } else if (notEnabled) {
        origFrame.origin.x = xNot;
        origFrame.origin.y = yNot;
        return origFrame;
    }
    return origFrame;
}

- (void)setFrame:(CGRect)frame {
    NSString *deviceModel = [Model deviceModel];
    if (notificationFix) {
        frame.origin.x = 0.0f;
        frame.origin.y = VI_DefaultBannerYOffset(deviceModel);
        %orig(frame);
    } else if (notEnabled) {
        frame.origin.x = xNot;
        frame.origin.y = yNot;
        %orig(frame);
    } else {
        %orig(frame);
    }
}

%end

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

void preferencesChanged() {
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.ethxnn88.visibleislandprefs"];
    if (!prefs) {
        NSString *rootlessPath = @"/var/jb/var/mobile/Library/Preferences/com.ethxnn88.visibleislandprefs.plist";
        NSString *rootfulPath = @"/var/mobile/Library/Preferences/com.ethxnn88.visibleislandprefs.plist";
        if ([[NSFileManager defaultManager] fileExistsAtPath:rootlessPath]) {
            prefs = [NSDictionary dictionaryWithContentsOfFile:rootlessPath];
        } else if ([[NSFileManager defaultManager] fileExistsAtPath:rootfulPath]) {
            prefs = [NSDictionary dictionaryWithContentsOfFile:rootfulPath];
        }
    }

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
    xPos = (prefs && [prefs objectForKey:@"xPos"]) ? [[prefs objectForKey:@"xPos"] floatValue] : 0.0f;
    yPos = (prefs && [prefs objectForKey:@"yPos"]) ? [[prefs objectForKey:@"yPos"] floatValue] : 20.5f;
    xNot = (prefs && [prefs objectForKey:@"xNot"]) ? [[prefs objectForKey:@"xNot"] floatValue] : 0.0f;
    yNot = (prefs && [prefs objectForKey:@"yNot"]) ? [[prefs objectForKey:@"yNot"] floatValue] : 40.0f;
    red = (prefs && [prefs objectForKey:@"red"]) ? [[prefs objectForKey:@"red"] floatValue] : 0.0f;
    green = (prefs && [prefs objectForKey:@"green"]) ? [[prefs objectForKey:@"green"] floatValue] : 0.0f;
    blue = (prefs && [prefs objectForKey:@"blue"]) ? [[prefs objectForKey:@"blue"] floatValue] : 0.0f;
    alpha = (prefs && [prefs objectForKey:@"alpha"]) ? [[prefs objectForKey:@"alpha"] floatValue] : 1.0f;
    scale = (prefs && [prefs objectForKey:@"scale"]) ? [[prefs objectForKey:@"scale"] floatValue] : 1.0f;
    if (scale <= 0.05f) scale = 1.0f;
}

%ctor {
    preferencesChanged();

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("com.ethxnn88.visibleislandprefs-updated"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.ethxnn88.visibleislandprefs-respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    }
}
