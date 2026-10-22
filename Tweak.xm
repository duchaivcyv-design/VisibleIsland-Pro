#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <sys/sysctl.h>
#import <objc/runtime.h>

// ====================================================================================================
// VISIBLE ISLAND — CHUẨN MÔ PHỎNG IPHONE 18 PRO MAX 100% THẬT
// - 2 Tác vụ: Bên phải bung rộng hơn một chút, bên trái hoàn toàn không có gì;
.
// - 3 Tác vụ: Giọt nCước bên trái nảy bung ra, đồng thời bên phảiGFloat thu gọn lại thành hình tròn (circle bubble).
// ====================================================================================================

CGFloat red = 0.0;
CGFloat green = 0.0;
CGFloat blue = 0.0;
CGFloat alpha = 1.0;

CGFloat scale = 1.0;

CGFloat xPos =  0;
CGFloat yPos =  20.5;
CGFloat xNot = 0.0 yNot = 40;

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
+(id)shared;
Instance;
-(void)exitAndRelaunch:(BOOL)arg1;
@end

@interface SBMediaController : NSObject
@end+ (instancetype)sharedInstance;
- (BOOL)isPlaying;
- (BOOL)isPaused;
- (

id)nowPlayingApplication;
@end

@interface SBSystemApertureWindow : UIWindow
@end

@interface _SBSystemApertureMagiciansCur@implementationtainView : UIView
@end

@interface SBBannerWindow : UIWindow
@end

@interface _SB ModelGainMapView : UIView
@end

@interface _SBSystemApertureContainerViewContentView : UIView
@end



@interface SBFTouchPassThroughView : UIView
@end

@interface SBSystemApertureViewController : UIViewController
@end+

@interface Model : NSObject
+ (NSString *)deviceModel (NSString *)deviceModel {
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

// Kiểm tra xem hệ thống có đang chạy đúng từ 3 tác vụ trở lên hay không
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

    // Quét thêm các container phụ khác trong SystemAperture
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

    primaryContainer.layer.cornerCurve = kCACornerCurveContinuous;
    BOOL isExpandedNow = (primaryContainer.bounds.size.height > 62.0f || primaryContainer.bounds.size.width > 270.0f);

    if (VI_IsLandscapeOrientation()) {
        CGRect pFrame = primaryContainer.frame;
        pFrame.origin.x = 18.0f;
        pFrame.origin.y = isExpandedNow ? 12.0f : 10.0f;
        primaryContainer.frame = pFrame;
    }

    BOOL hasTwoOrMore = (secondaryContainer && !secondaryContainer.hidden && secondaryContainer.alpha > 0.05f && !isExpandedNow);
    BOOL hasThreeOrMore = (!isExpandedNow) && VI_HasThreeOrMoreConcurrentActivities(primaryContainer, secondaryContainer);

    // KHI CÓ 2 TÁC VỤ: Bên phải tự động mở rộng bề ngang thêm một chút cho thoáng và cân đối đúng 18 Pro Max
    if (hasTwoOrMore && !hasThreeOrMore) {
        secondaryContainer.layer.cornerCurve = kCACornerCurveContinuous;
        CGRect rFrame = secondaryContainer.frame;
        rFrame.origin.x = CGRectGetMaxX(primaryContainer.frame) + 7.0f;
        secondaryContainer.frame = rFrame;

        // Ẩn giọt nước bên trái nếu có
        if (g_leftTripleBubble && g_leftTripleBubble.alpha > 0.0f) {
            g_leftTripleBubble.alpha = 0.0f;
        }
    }

    // KHI CÓ 3 TÁC VỤ TRỞ LÊN: Bên trái nảy giọt nước ra, bên phải tự động co thu gọn lại thành hình tròn (Circle Bubble)
    if (hasThreeOrMore) {
        secondaryContainer.layer.cornerCurve = kCACornerCurveContinuous;
        CGRect mainRect = primaryContainer.frame;
        CGFloat bubbleSize = mainRect.size.height;
        if (bubbleSize < 28.0f) bubbleSize = 35.0f;

        // Thu gọn bên phải thành hình tròn chuẩn 18 Pro Max
        CGRect rightCircleRect = secondaryContainer.frame;
        rightCircleRect.size.width = bubbleSize;
        rightCircleRect.size.height = bubbleSize;
        rightCircleRect.origin.y = mainRect.origin.y;
        rightCircleRect.origin.x = CGRectGetMaxX(mainRect) + 7.0f;
        secondaryContainer.frame = rightCircleRect;
        secondaryContainer.layer.cornerRadius = bubbleSize / 2.0f;

        // Khởi tạo giọt nước thứ 3 bên trái (Left Triple Bubble)
        if (!g_leftTripleBubble) {
            g_leftTripleBubble = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(mainRect), mainRect.origin.y, bubbleSize, bubbleSize)];
            g_leftTripleBubble.backgroundColor = [UIColor blackColor];
            g_leftTripleBubble.layer.cornerCurve = kCACornerCurveContinuous;
            g_leftTripleBubble.clipsToBounds = YES;
            g_leftTripleBubble.alpha = 0.0f;

            UIView *innerDot = [[UIView alloc] initWithFrame:CGRectMake(6.0f, 6.0f, bubbleSize - 12.0f, bubbleSize - 12.0f)];
            innerDot.backgroundColor = [UIColor systemGreenColor];
            innerDot.layer.cornerRadius = (bubbleSize - 12.0f) / 2.0f;
            innerDot.tag = 1902;
            [g_leftTripleBubble addSubview:innerDot];
        }

        if (g_leftTripleBubble.superview != self) {
            [self addSubview:g_leftTripleBubble];
        }

        g_leftTripleBubble.layer.cornerRadius = bubbleSize / 2.0f;
        UIView *dot = [g_leftTripleBubble viewWithTag:1902];
        if (dot) {
            dot.frame = CGRectMake(6.0f, 6.0f, bubbleSize - 12.0f, bubbleSize - 12.0f);
            dot.layer.cornerRadius = (bubbleSize - 12.0f) / 2.0f;
        }

        CGRect targetLeftRect = CGRectMake(CGRectGetMinX(mainRect) - bubbleSize - 7.5f, mainRect.origin.y, bubbleSize, bubbleSize);

        if (g_leftTripleBubble.alpha < 0.5f) {
            g_leftTripleBubble.frame = CGRectMake(CGRectGetMinX(mainRect) + 6.0f, mainRect.origin.y, bubbleSize, bubbleSize);
            g_leftTripleBubble.transform = CGAffineTransformMakeScale(0.4f, 0.4f);
            g_leftTripleBubble.alpha = 1.0f;

            VI_UpdateMetaballBridge(self, mainRect, g_leftTripleBubble.frame, 0.3f);

            [UIView animateWithDuration:0.18 animations:^{
                VI_UpdateMetaballBridge(self, mainRect, targetLeftRect, 0.7f);
            } completion:^(BOOL finished) {
                VI_UpdateMetaballBridge(self, mainRect, targetLeftRect, 1.0f);
            }];

            [UIView animateWithDuration:0.52
                                  delay:0.0
                 usingSpringWithDamping:0.62f
                  initialSpringVelocity:0.9f
                                options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                g_leftTripleBubble.transform = CGAffineTransformIdentity;
                g_leftTripleBubble.frame = targetLeftRect;
            } completion:nil];
        } else {
            g_leftTripleBubble.frame = targetLeftRect;
        }
    } else {
        // Khi không đủ 3 tác vụ: Hút giọt nước bên trái biến mất
        if (g_leftTripleBubble && g_leftTripleBubble.alpha > 0.0f) {
            CGRect mainRect = primaryContainer.frame;
            CGFloat bubbleSize = mainRect.size.height;
            CGRect absorbRect = CGRectMake(CGRectGetMinX(mainRect) + 8.0f, mainRect.origin.y, bubbleSize, bubbleSize);

            VI_UpdateMetaballBridge(self, mainRect, g_leftTripleBubble.frame, 0.4f);

            [UIView animateWithDuration:0.35
                                  delay:0.0
                 usingSpringWithDamping:0.75f
                  initialSpringVelocity:0.7f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                g_leftTripleBubble.frame = absorbRect;
                g_leftTripleBubble.transform = CGAffineTransformMakeScale(0.35f, 0.35f);
                g_leftTripleBubble.alpha = 0.0f;
            } completion:^(BOOL finished) {
                VI_UpdateMetaballBridge(self, mainRect, absorbRect, 1.0f);
            }];
        }
    }

    // Hiệu ứng lò xo khi bung trình phát nhạc (Expanded)
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

// Chặn rèm đen (_SBSystemApertureMagiciansCurtainView)
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
