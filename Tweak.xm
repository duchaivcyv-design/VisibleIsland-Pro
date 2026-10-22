#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <sys/sysctl.h>
#import <objc/runtime.h>

// ====================================================================================================
// VISIBLE ISLAND — CHUẨN MÔ PHỎNG IPHONE 18 PRO MAX (100 phan tram that)
// - 2 Tác vụ: Bên phải bung rộng hơn một chút, bên trái hoàn toàn không có gì.
// - 3 Tác vụ: Giọt nước bên trái nảy bung ra, đồng thời bên phải thu gọn lại thành hình tròn (circle bubble).
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

@interface SBMediaController : NSObject
+ (instancetype)sharedInstance;
- (BOOL)isPlaying;
- (BOOL)isPaused;
- (id)nowPlayingApplication;
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

@interface Model : NSObject
+ (NSString *)deviceModel;
@end

@implementation Model

+ (NSString *)deviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    if (machine == NULL) return nil;
    if (sysctlbyname("hw.machine", machine, &size, NULL, 0) == -1) {
        free(machine);
        return nil;
    }
    NSString *deviceModel = [NSString stringWithUTF8String:machine];
    free(machine);
    return deviceModel;
}

@end

// [FIX V2]: Tương tác cho giọt nước bên trái — tap vào bubble sẽ có hiệu ứng pulse
@interface UIView (VisibleIslandBubbleTap)
- (void)vi_handleBubbleTap:(UITapGestureRecognizer *)tap;
@end
@implementation UIView (VisibleIslandBubbleTap)
- (void)vi_handleBubbleTap:(UITapGestureRecognizer *)tap {
    @try {
        UIView *bubble = tap.view;
        if (!bubble) return;
        [UIView animateWithDuration:0.12 animations:^{
            bubble.transform = CGAffineTransformMakeScale(1.28f, 1.28f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.20
                                  delay:0.0
                 usingSpringWithDamping:0.55f
                  initialSpringVelocity:0.8f
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                bubble.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
    } @catch (__unused NSException *e) {}
}
@end

// ====================================================================================================
// BỘ ĐIỀU KHIỂN HIỆU ỨNG 18 PRO MAX CHUẨN XÁC (3 TÁC VỤ: TRÁI NẢY - PHẢI THU TRÒN)
// ====================================================================================================

static UIView *g_leftTripleBubble = nil;
static CAShapeLayer *g_metaballBridgeLayer = nil;
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

static inline BOOL VI_HasThreeOrMoreConcurrentActivities(UIView *primaryContainer, UIView *secondaryContainer) {
    if (!primaryContainer || !secondaryContainer) return NO;
    if (secondaryContainer.hidden || secondaryContainer.alpha < 0.05f || secondaryContainer.bounds.size.width < 10.0f) {
        return NO;
    }

    int activeTaskCount = 2; // Đã có chính + phải
    BOOL isScreenRecording = [UIScreen mainScreen].isCaptured;

    Class mediaCls = objc_getClass("SBMediaController");
    BOOL isMusicActive = NO;
    if (mediaCls && [mediaCls respondsToSelector:@selector(sharedInstance)]) {
        SBMediaController *mc = [mediaCls sharedInstance];
        if (mc && ([mc isPlaying] || [mc isPaused]) && [mc nowPlayingApplication] != nil) {
            isMusicActive = YES;
        }
    }

    for (UIView *sub in primaryContainer.superview.subviews) {
        NSString *cls = NSStringFromClass([sub class]);
        if ([cls containsString:@"SystemApertureContainerView"] && sub != primaryContainer && sub != secondaryContainer && !sub.hidden && sub.alpha > 0.1f) {
            activeTaskCount++;
        }
    }

    if (isScreenRecording) activeTaskCount++;
    if (isMusicActive) activeTaskCount++;

    return (activeTaskCount >= 3);
}

static void VI_UpdateMetaballBridge(UIView *parentView, CGRect mainRect, CGRect bubbleRect, CGFloat progress) {
    if (!g_metaballBridgeLayer) {
        g_metaballBridgeLayer = [CAShapeLayer layer];
        g_metaballBridgeLayer.fillColor = [UIColor blackColor].CGColor;
    }
    if (g_metaballBridgeLayer.superlayer != parentView.layer) {
        [parentView.layer insertSublayer:g_metaballBridgeLayer atIndex:0];
    }

    if (progress <= 0.02f || progress >= 0.95f) {
        g_metaballBridgeLayer.path = NULL;
        g_metaballBridgeLayer.opacity = 0.0f;
        return;
    }

    CGFloat midY = CGRectGetMidY(mainRect);
    CGFloat neckHalfHeight = (mainRect.size.height * 0.32f) * (1.0f - progress);
    CGFloat leftX = CGRectGetMaxX(bubbleRect) - 4.0f;
    CGFloat rightX = CGRectGetMinX(mainRect) + 4.0f;

    if (rightX <= leftX) {
        g_metaballBridgeLayer.path = NULL;
        return;
    }

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(leftX, midY - neckHalfHeight * 1.3f)];
    [path addQuadCurveToPoint:CGPointMake(rightX, midY - neckHalfHeight * 1.3f)
                 controlPoint:CGPointMake((leftX + rightX) * 0.5f, midY - neckHalfHeight * 0.3f)];
    [path addLineToPoint:CGPointMake(rightX, midY + neckHalfHeight * 1.3f)];
    [path addQuadCurveToPoint:CGPointMake(leftX, midY + neckHalfHeight * 1.3f)
                 controlPoint:CGPointMake((leftX + rightX) * 0.5f, midY + neckHalfHeight * 0.3f)];
    [path closePath];

    g_metaballBridgeLayer.path = path.CGPath;
    g_metaballBridgeLayer.opacity = (float)(1.0f - (progress * 0.8f));
}

static inline CGFloat VI_DefaultDeviceYOffset(NSString *deviceModel) {
    if (!deviceModel) return 20.5;
    if ([deviceModel isEqualToString:@"iPhone10,3"] || [deviceModel isEqualToString:@"iPhone10,6"] || [deviceModel isEqualToString:@"iPhone11,2"] || [deviceModel isEqualToString:@"iPhone12,3"]) return 20.5;
    if ([deviceModel isEqualToString:@"iPhone11,6"] || [deviceModel isEqualToString:@"iPhone12,5"] || [deviceModel isEqualToString:@"iPhone11,8"] || [deviceModel isEqualToString:@"iPhone12,1"] || [deviceModel isEqualToString:@"iPhone14,4"]) return 22.5;
    if ([deviceModel isEqualToString:@"iPhone13,2"] || [deviceModel isEqualToString:@"iPhone13,3"]) return 21.5;
    if ([deviceModel isEqualToString:@"iPhone13,1"]) return 19.5;
    if ([deviceModel isEqualToString:@"iPhone13,4"]) return 22.3;
    if ([deviceModel isEqualToString:@"iPhone14,5"] || [deviceModel isEqualToString:@"iPhone14,2"] || [deviceModel isEqualToString:@"iPhone14,7"]) return 24.0;
    if ([deviceModel isEqualToString:@"iPhone14,3"]) return 26.0;
    return 11.0;
}

static inline CGFloat VI_DefaultBannerYOffset(NSString *deviceModel) {
    if (!deviceModel) return 35.0;
    if ([deviceModel isEqualToString:@"iPhone13,1"]) return 33.0;
    if ([deviceModel isEqualToString:@"iPhone13,4"] || [deviceModel isEqualToString:@"iPhone14,4"]) return 38.0;
    if ([deviceModel isEqualToString:@"iPhone14,5"] || [deviceModel isEqualToString:@"iPhone14,2"] || [deviceModel isEqualToString:@"iPhone14,7"]) return 40.0;
    if ([deviceModel isEqualToString:@"iPhone14,3"]) return 42.0;
    return 35.0;
}

%hook SBSystemApertureWindow

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

    if (isLandscape) {
        if (scaleEnabled) {
            self.transform = CGAffineTransformMakeScale(safeScale, safeScale);
        } else {
            self.transform = CGAffineTransformIdentity;
        }
        CGRect frame = self.frame;
        CGFloat landY = posEnabled ? (yPos / (scaleEnabled ? safeScale : 1.0f)) : 10.0f;
        CGFloat landX = posEnabled && xPos != 0 ? (xPos / (scaleEnabled ? safeScale : 1.0f)) : -([UIScreen mainScreen].bounds.size.width * 0.28f);
        frame.origin.y = landY;
        frame.origin.x = landX;
        self.frame = frame;
        self.hidden = NO;
        self.alpha = 1.0f;
        return;
    }

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

// ====================================================================================================
// LOGIC IPHONE 18 PRO MAX: 2 TÁC VỤ BÊN PHẢI RỘNG RA — 3 TÁC VỤ BÊN TRÁI NẢY RA, BÊN PHẢI THU TRÒN
// ====================================================================================================

%hook SBFTouchPassThroughView

- (void)layoutSubviews {
    %orig;

    self.clipsToBounds = NO; // [FIX V2]: cho phép bubble/metaball hiển thị ngoài bounds (nguyên nhân chính làm giọt nước trái vô hình)

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

    if (!primaryContainer) return;

    if (@available(iOS 13.0, *)) {
        primaryContainer.layer.cornerCurve = kCACornerCurveContinuous;
    }
    BOOL isExpandedNow = (primaryContainer.bounds.size.height > 62.0f || primaryContainer.bounds.size.width > 270.0f);

    if (VI_IsLandscapeOrientation()) {
        CGRect pFrame = primaryContainer.frame;
        pFrame.origin.x = 18.0f;
        pFrame.origin.y = isExpandedNow ? 12.0f : 10.0f;
        primaryContainer.frame = pFrame;
    }

    BOOL hasTwoOrMore = (secondaryContainer && !secondaryContainer.hidden && secondaryContainer.alpha > 0.05f && !isExpandedNow);
    BOOL hasThreeOrMore = (!isExpandedNow) && VI_HasThreeOrMoreConcurrentActivities(primaryContainer, secondaryContainer);

    // KHI CÓ 2 TÁC VỤ
    if (hasTwoOrMore && !hasThreeOrMore) {
        if (@available(iOS 13.0, *)) {
            secondaryContainer.layer.cornerCurve = kCACornerCurveContinuous;
        }
        CGRect rFrame = secondaryContainer.frame;
        rFrame.origin.x = CGRectGetMaxX(primaryContainer.frame) + 7.0f;
        secondaryContainer.frame = rFrame;

        if (g_leftTripleBubble && g_leftTripleBubble.alpha > 0.0f) {
            g_leftTripleBubble.alpha = 0.0f;
        }
    }

    // KHI CÓ 3 TÁC VỤ TRỞ LÊN
    // [FIX V3]: State machine — tránh layoutSubviews gọi liên tục giết animation giữa chừng (gây cứng đơ).
    // Đồng thời đưa bubble lên window để nhận chạm thật (vì SBFTouchPassThroughView chuyển tiếp chạm, không nhận).
    static BOOL s_vi_bubbleVisible = NO;
    static BOOL s_vi_bubbleAnimating = NO;

    if (hasThreeOrMore) {
        if (@available(iOS 13.0, *)) {
            secondaryContainer.layer.cornerCurve = kCACornerCurveContinuous;
        }
        CGRect mainRect = primaryContainer.frame;
        CGFloat bubbleSize = mainRect.size.height;
        if (bubbleSize < 28.0f) bubbleSize = 35.0f;

        CGRect rightCircleRect = secondaryContainer.frame;
        rightCircleRect.size.width = bubbleSize;
        rightCircleRect.size.height = bubbleSize;
        rightCircleRect.origin.y = mainRect.origin.y;
        rightCircleRect.origin.x = CGRectGetMaxX(mainRect) + 7.0f;
        secondaryContainer.frame = rightCircleRect;
        secondaryContainer.layer.cornerRadius = bubbleSize / 2.0f;

        UIView *vi_hostView = self.window ?: (self.superview ?: self);
        CGRect mainRectHost = [self convertRect:mainRect toView:vi_hostView];
        CGRect targetLeftRectHost = CGRectMake(CGRectGetMinX(mainRectHost) - bubbleSize - 7.5f, mainRectHost.origin.y, bubbleSize, bubbleSize);
        CGRect startRectHost = CGRectMake(CGRectGetMinX(mainRectHost) + 6.0f, mainRectHost.origin.y, bubbleSize, bubbleSize);

        if (!g_leftTripleBubble) {
            g_leftTripleBubble = [[UIView alloc] initWithFrame:startRectHost];
            g_leftTripleBubble.backgroundColor = [UIColor blackColor];
            if (@available(iOS 13.0, *)) {
                g_leftTripleBubble.layer.cornerCurve = kCACornerCurveContinuous;
            }
            g_leftTripleBubble.clipsToBounds = YES;
            g_leftTripleBubble.alpha = 0.0f;
            g_leftTripleBubble.userInteractionEnabled = YES;
            UITapGestureRecognizer *vi_bubbleTap = [[UITapGestureRecognizer alloc] initWithTarget:g_leftTripleBubble action:@selector(vi_handleBubbleTap:)];
            [g_leftTripleBubble addGestureRecognizer:vi_bubbleTap];

            UIView *innerDot = [[UIView alloc] initWithFrame:CGRectMake(6.0f, 6.0f, bubbleSize - 12.0f, bubbleSize - 12.0f)];
            innerDot.backgroundColor = [UIColor systemGreenColor];
            innerDot.layer.cornerRadius = (bubbleSize - 12.0f) / 2.0f;
            innerDot.tag = 1902;
            [g_leftTripleBubble addSubview:innerDot];
        }

        if (g_leftTripleBubble.superview != vi_hostView) {
            [g_leftTripleBubble removeFromSuperview];
            [vi_hostView addSubview:g_leftTripleBubble];
        }
        [vi_hostView bringSubviewToFront:g_leftTripleBubble];
        g_leftTripleBubble.layer.cornerRadius = bubbleSize / 2.0f;
        UIView *dot = [g_leftTripleBubble viewWithTag:1902];
        if (dot) {
            dot.frame = CGRectMake(6.0f, 6.0f, bubbleSize - 12.0f, bubbleSize - 12.0f);
            dot.layer.cornerRadius = (bubbleSize - 12.0f) / 2.0f;
        }

        if (!s_vi_bubbleVisible && !s_vi_bubbleAnimating) {
            s_vi_bubbleAnimating = YES;
            g_leftTripleBubble.frame = startRectHost;
            g_leftTripleBubble.transform = CGAffineTransformMakeScale(0.4f, 0.4f);
            g_leftTripleBubble.alpha = 1.0f;
            [UIView animateWithDuration:0.55
                                  delay:0.0
                 usingSpringWithDamping:0.58f
                  initialSpringVelocity:0.85f
                                options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                g_leftTripleBubble.transform = CGAffineTransformIdentity;
                g_leftTripleBubble.frame = targetLeftRectHost;
            } completion:^(BOOL finished) {
                s_vi_bubbleAnimating = NO;
                s_vi_bubbleVisible = YES;
            }];
        } else if (!s_vi_bubbleAnimating) {
            // ỔN ĐỊNH: chỉ đặt frame khi không đang animate — tránh giết animation giữa chừng
            if (!CGRectEqualToRect(g_leftTripleBubble.frame, targetLeftRectHost)) {
                g_leftTripleBubble.frame = targetLeftRectHost;
            }
        }
    } else {
        if ((s_vi_bubbleVisible || (g_leftTripleBubble && g_leftTripleBubble.alpha > 0.01f)) && !s_vi_bubbleAnimating) {
            s_vi_bubbleAnimating = YES;
            UIView *vi_hostViewHide = g_leftTripleBubble.superview ?: (self.window ?: self);
            CGRect mainRectHide = [self convertRect:primaryContainer.frame toView:vi_hostViewHide];
            CGFloat bubbleSizeHide = mainRectHide.size.height;
            if (bubbleSizeHide < 28.0f) bubbleSizeHide = 35.0f;
            CGRect absorbRectHost = CGRectMake(CGRectGetMinX(mainRectHide) + 8.0f, mainRectHide.origin.y, bubbleSizeHide, bubbleSizeHide);
            [UIView animateWithDuration:0.38
                                  delay:0.0
                 usingSpringWithDamping:0.72f
                  initialSpringVelocity:0.6f
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                g_leftTripleBubble.frame = absorbRectHost;
                g_leftTripleBubble.transform = CGAffineTransformMakeScale(0.35f, 0.35f);
                g_leftTripleBubble.alpha = 0.0f;
            } completion:^(BOOL finished) {
                s_vi_bubbleAnimating = NO;
                s_vi_bubbleVisible = NO;
            }];
        }
    }

    if (isExpandedNow != g_isIslandExpanded) {
        g_isIslandExpanded = isExpandedNow;
        primaryContainer.transform = CGAffineTransformMakeScale(0.94f, 0.94f);
        [UIView animateWithDuration:0.46
                              delay:0.0
             usingSpringWithDamping:0.72f
              initialSpringVelocity:0.85f
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
            primaryContainer.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

%end

%hook _SBSystemApertureMagiciansCurtainView

- (void)didMoveToWindow {
    %orig;
    self.hidden = YES;
    self.alpha = 0.0f;
}

- (void)layoutSubviews {
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
    blue = (prefs && [prefs objectForKey:@"blue"] ? [[prefs valueForKey:@"blue"] floatValue] : 0.0f);
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
