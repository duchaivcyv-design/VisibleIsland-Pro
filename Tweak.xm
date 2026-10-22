#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <sys/sysctl.h>
#import <objc/runtime.h>
#import <math.h>

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

@interface SBRingerControl : NSObject
+ (instancetype)sharedInstance;
- (BOOL)isSilentMode;
@end

@interface SBSystemApertureWindow : UIWindow @end
@interface _SBSystemApertureMagiciansCurtainView : UIView @end
@interface SBBannerWindow : UIWindow @end
@interface _SBGainMapView : UIView @end
@interface _SBSystemApertureContainerViewContentView : UIView @end
@interface SBFTouchPassThroughView : UIView @end
@interface SBSystemApertureViewController : UIViewController @end
@interface SBRingerIndicatorView : UIView @end

@interface Model : NSObject
+ (NSString *)deviceModel;
@end

@implementation Model
+ (NSString *)deviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    if (!machine) return nil;
    if (sysctlbyname("hw.machine", machine, &size, NULL, 0) == -1) {
        free(machine);
        return nil;
    }
    NSString *deviceModel = [NSString stringWithUTF8String:machine];
    free(machine);
    return deviceModel;
}
@end

__attribute__((unused)) static void VI_UpdateMetaballBridge(UIView *parentView, CGRect mainRect, CGRect bubbleRect, CGFloat progress) {
}

static UIView *g_leftTripleBubble = nil;
static UIView *g_rightSecondaryPill = nil;
static CAShapeLayer *g_metaballBridgeLayer = nil;
static CADisplayLink *g_animationLink = nil;

static CGRect s_vi_fromRect;
static CGRect s_vi_toRect;
static CGRect s_vi_mainRect;

static CGFloat s_vi_animProgress = 0.0;
static CGFloat s_vi_targetProgress = 0.0;
static BOOL s_vi_bubbleVisible = NO;
static BOOL s_vi_bubbleAnimating = NO;
static BOOL s_vi_bubbleManuallyDismissed = NO;
static NSTimeInterval s_lastActivityCheck = 0;
static int s_consecutiveThreeChecks = 0;

static inline BOOL VI_IsLandscapeOrientation(void) {
    UIInterfaceOrientation orient = UIInterfaceOrientationPortrait;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    orient = [[UIApplication sharedApplication] statusBarOrientation];
    #pragma clang diagnostic pop
    if (UIInterfaceOrientationIsLandscape(orient)) return YES;
    UIDeviceOrientation devOrient = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(devOrient)) return YES;
    return ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height);
}

static inline BOOL VI_HasThreeOrMoreConcurrentActivities(UIView *primaryContainer, UIView *secondaryContainer) {
    if (!primaryContainer || !secondaryContainer) return NO;
    if (secondaryContainer.hidden || secondaryContainer.alpha < 0.05f || secondaryContainer.bounds.size.width < 10.0f) {
        return NO;
    }
    int activeTaskCount = 2;

    // Nguồn 1: Quay màn hình
    BOOL isScreenRecording = [UIScreen mainScreen].isCaptured;
    if (isScreenRecording) activeTaskCount++;

    // Nguồn 2: Nhạc/Phát lại
    Class mediaCls = objc_getClass("SBMediaController");
    if (mediaCls && [mediaCls respondsToSelector:@selector(sharedInstance)]) {
        SBMediaController *mc = [mediaCls sharedInstance];
        if (mc && ([mc isPlaying] || [mc isPaused]) && [mc nowPlayingApplication] != nil) {
            activeTaskCount++;
        }
    }

    // Nguồn 3: Đếm các container phụ khác
    for (UIView *sub in primaryContainer.superview.subviews) {
        if (sub == primaryContainer || sub == secondaryContainer) continue;
        NSString *cls = NSStringFromClass([sub class]);
        if ([cls containsString:@"SystemApertureContainerView"] && !sub.hidden && sub.alpha > 0.1f && sub.bounds.size.width > 10) {
            activeTaskCount++;
        }
    }

    // Nguồn 4: Đếm các chỉ báo hệ thống đang hiện — ĐÃ SỬA lỗi kiểu dữ liệu
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) continue;
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            for (UIWindow *w in windowScene.windows) {
            #pragma clang diagnostic pop
                if (w.isKeyWindow || w.hidden || w.alpha < 0.8) continue;
                NSString *winCls = NSStringFromClass([w class]);
                if ([winCls containsString:@"SystemAperture"] || [winCls containsString:@"BannerWindow"]) continue;
                if (w.rootViewController && !w.hidden) {
                    activeTaskCount++;
                    break;
                }
            }
        }
    }

    // Yêu cầu ổn định 3 khung hình liên tiếp trước khi kích hoạt
    if (activeTaskCount >= 3) {
        s_consecutiveThreeChecks++;
        if (s_consecutiveThreeChecks >= 3) return YES;
    } else {
        s_consecutiveThreeChecks = 0;
    }
    return NO;
}

static CGFloat VI_EaseOutBack(CGFloat t) {
    CGFloat c1 = 1.70158;
    CGFloat c3 = c1 + 1;
    return 1 + c3 * pow(t - 1, 3) + c1 * pow(t - 1, 2);
}

static CGFloat VI_EaseInOut(CGFloat t) {
    return t < 0.5 ? 2.0f * t * t : -1.0f + (4.0f - 2.0f * t) * t;
}

static void VI_DrawMetaballBridge(CGRect mainRect, CGRect bubbleRect, CGFloat progress) {
    if (!g_metaballBridgeLayer) {
        g_metaballBridgeLayer = [CAShapeLayer layer];
        g_metaballBridgeLayer.fillColor = [UIColor blackColor].CGColor;
        g_metaballBridgeLayer.lineJoin = kCALineJoinRound;
        g_metaballBridgeLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    if (progress <= 0.05f || progress >= 0.95f) {
        g_metaballBridgeLayer.path = NULL;
        g_metaballBridgeLayer.opacity = 0.0f;
        return;
    }
    CGFloat midY = CGRectGetMidY(mainRect);
    CGFloat mainH = mainRect.size.height;
    CGFloat neckMaxHeight = mainH * 0.30f;
    CGFloat neckHeight = neckMaxHeight * (1.0f - fabs(progress - 0.5f) * 1.8f);
    CGFloat leftX = CGRectGetMaxX(bubbleRect);
    CGFloat rightX = CGRectGetMinX(mainRect);
    CGFloat distance = rightX - leftX;
    if (distance < 2.0f) {
        g_metaballBridgeLayer.path = NULL;
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(leftX, midY - neckHeight * 0.5f)];
    [path addCurveToPoint:CGPointMake(rightX, midY - neckHeight * 0.5f)
            controlPoint1:CGPointMake(leftX + distance * 0.38f, midY - neckHeight * 0.75f)
            controlPoint2:CGPointMake(rightX - distance * 0.38f, midY - neckHeight * 0.75f)];
    [path addLineToPoint:CGPointMake(rightX, midY + neckHeight * 0.5f)];
    [path addCurveToPoint:CGPointMake(leftX, midY + neckHeight * 0.5f)
            controlPoint1:CGPointMake(rightX - distance * 0.38f, midY + neckHeight * 0.75f)
            controlPoint2:CGPointMake(leftX + distance * 0.38f, midY + neckHeight * 0.75f)];
    [path closePath];
    g_metaballBridgeLayer.path = path.CGPath;
    g_metaballBridgeLayer.opacity = 1.0f;
}

static void VI_AnimationLoop(void) {
    if (!s_vi_bubbleAnimating) return;
    CGFloat speed = s_vi_targetProgress > s_vi_animProgress ? 1.8f : 2.2f;
    CGFloat dt = 1.0f / 60.0f;
    if (s_vi_targetProgress > s_vi_animProgress) {
        s_vi_animProgress += speed * dt;
    } else {
        s_vi_animProgress -= speed * dt;
    }
    s_vi_animProgress = fmax(0.0f, fmin(1.0f, s_vi_animProgress));
    if (fabs(s_vi_animProgress - s_vi_targetProgress) < 0.008f) {
        s_vi_animProgress = s_vi_targetProgress;
        s_vi_bubbleAnimating = NO;
        if (s_vi_animProgress <= 0.005f && g_animationLink) {
            [g_animationLink invalidate];
            g_animationLink = nil;
        }
    }
    CGFloat t;
    if (s_vi_targetProgress > 0) {
        t = VI_EaseOutBack(s_vi_animProgress);
    } else {
        t = VI_EaseInOut(s_vi_animProgress);
    }
    CGRect currentRect;
    currentRect.origin.x = s_vi_fromRect.origin.x + (s_vi_toRect.origin.x - s_vi_fromRect.origin.x) * t;
    currentRect.origin.y = s_vi_fromRect.origin.y + (s_vi_toRect.origin.y - s_vi_fromRect.origin.y) * t;
    currentRect.size.width = s_vi_fromRect.size.width + (s_vi_toRect.size.width - s_vi_fromRect.size.width) * t;
    currentRect.size.height = s_vi_fromRect.size.height + (s_vi_toRect.size.height - s_vi_fromRect.size.height) * t;
    if (g_leftTripleBubble) {
        g_leftTripleBubble.frame = currentRect;
        CGFloat scaleVal = 0.05f + 0.95f * t;
        g_leftTripleBubble.transform = CGAffineTransformMakeScale(scaleVal, scaleVal);
        g_leftTripleBubble.alpha = 0.1f + 0.9f * t;
    }
    VI_DrawMetaballBridge(s_vi_mainRect, currentRect, s_vi_animProgress);
}

@interface UIView_VIHelper : UIView
@end
@implementation UIView_VIHelper
- (void)vi_handleTap:(UITapGestureRecognizer *)gr {
    if (!g_leftTripleBubble || !s_vi_bubbleVisible) return;
    s_vi_bubbleManuallyDismissed = YES;
    s_vi_targetProgress = 0.0f;
    s_vi_bubbleAnimating = YES;
    if (!g_animationLink) {
        g_animationLink = [CADisplayLink displayLinkWithTarget:[NSBlockOperation blockOperationWithBlock:^{ VI_AnimationLoop(); }] selector:@selector(main)];
        [g_animationLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    [UIView animateWithDuration:0.12 animations:^{
        g_leftTripleBubble.transform = CGAffineTransformMakeScale(0.85f, 0.85f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.28 delay:0 usingSpringWithDamping:0.52 initialSpringVelocity:6 options:0 animations:^{
            g_leftTripleBubble.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}
- (void)vi_handleLongPress:(UILongPressGestureRecognizer *)gr {
    if (!g_leftTripleBubble || !s_vi_bubbleVisible) return;
    if (gr.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:3.5 options:0 animations:^{
            g_leftTripleBubble.transform = CGAffineTransformMakeScale(1.12f, 1.12f);
        } completion:nil];
    } else if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:3.5 options:0 animations:^{
            g_leftTripleBubble.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}
@end

static void VI_PrepareBubbleIfNeeded(CGRect mainRect, UIView *containerView) {
    if (g_leftTripleBubble) return;
    CGFloat bubbleSize = mainRect.size.height;
    if (bubbleSize < 28.0f) bubbleSize = 35.0f;
    CGRect startRect = CGRectMake(CGRectGetMidX(mainRect) - bubbleSize/2.0f,
                                  CGRectGetMidY(mainRect) - bubbleSize/2.0f,
                                  bubbleSize, bubbleSize);
    g_leftTripleBubble = [[UIView_VIHelper alloc] initWithFrame:startRect];
    g_leftTripleBubble.backgroundColor = [UIColor blackColor];
    if (@available(iOS 13.0, *)) {
        g_leftTripleBubble.layer.cornerCurve = kCACornerCurveContinuous;
    }
    g_leftTripleBubble.layer.cornerRadius = bubbleSize / 2.0f;
    g_leftTripleBubble.clipsToBounds = YES;
    g_leftTripleBubble.alpha = 0.0f;
    g_leftTripleBubble.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    UIView *innerDot = [[UIView alloc] initWithFrame:CGRectMake(6.0f, 6.0f, bubbleSize - 12.0f, bubbleSize - 12.0f)];
    innerDot.backgroundColor = [UIColor systemGreenColor];
    innerDot.layer.cornerRadius = (bubbleSize - 12.0f) / 2.0f;
    innerDot.tag = 1902;
    innerDot.hidden = YES;
    [g_leftTripleBubble addSubview:innerDot];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:g_leftTripleBubble action:@selector(vi_handleTap:)];
    [g_leftTripleBubble addGestureRecognizer:tap];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:g_leftTripleBubble action:@selector(vi_handleLongPress:)];
    longPress.minimumPressDuration = 0.3;
    [g_leftTripleBubble addGestureRecognizer:longPress];
    g_leftTripleBubble.userInteractionEnabled = YES;
    UIWindow *targetWindow = containerView.window;
    if (targetWindow) {
        [targetWindow addSubview:g_leftTripleBubble];
        [targetWindow bringSubviewToFront:g_leftTripleBubble];
    }
    if (g_metaballBridgeLayer.superlayer != containerView.layer) {
        [containerView.layer insertSublayer:g_metaballBridgeLayer atIndex:0];
    }
}

static void VI_ShowBubble(CGRect mainRect, UIView *containerView) {
    if (!g_leftTripleBubble) {
        VI_PrepareBubbleIfNeeded(mainRect, containerView);
    }
    if (s_vi_bubbleManuallyDismissed && s_vi_animProgress < 0.1f) return;
    CGFloat bubbleSize = mainRect.size.height;
    if (bubbleSize < 28.0f) bubbleSize = 35.0f;
    
    // Bắt đầu từ trung tâm island — đúng gốc nảy ra
    s_vi_fromRect = CGRectMake(CGRectGetMidX(mainRect) - bubbleSize/2.0f,
                               CGRectGetMidY(mainRect) - bubbleSize/2.0f,
                               bubbleSize, bubbleSize);
    
    s_vi_toRect = CGRectMake(CGRectGetMinX(mainRect) - bubbleSize - 8.0f,
                             mainRect.origin.y,
                             bubbleSize, bubbleSize);
    
    s_vi_mainRect = mainRect;
    s_vi_targetProgress = 1.0f;
    s_vi_bubbleVisible = YES;
    s_vi_bubbleAnimating = YES;
    
    // Reset trạng thái bắt đầu animation
    s_vi_animProgress = 0.0f;
    g_leftTripleBubble.frame = s_vi_fromRect;
    g_leftTripleBubble.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    g_leftTripleBubble.alpha = 0.0f;
    
    UIView *dot = [g_leftTripleBubble viewWithTag:1902];
    if (dot) dot.hidden = NO;
    
    if (!g_animationLink) {
        g_animationLink = [CADisplayLink displayLinkWithTarget:[NSBlockOperation blockOperationWithBlock:^{ VI_AnimationLoop(); }] selector:@selector(main)];
        [g_animationLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

static void VI_HideBubble(void) {
    if (!g_leftTripleBubble || !s_vi_bubbleVisible) return;
    s_vi_targetProgress = 0.0f;
    s_vi_bubbleVisible = NO;
    s_vi_bubbleAnimating = YES;
    UIView *dot = [g_leftTripleBubble viewWithTag:1902];
    if (dot) dot.hidden = YES;
    if (!g_animationLink) {
        g_animationLink = [CADisplayLink displayLinkWithTarget:[NSBlockOperation blockOperationWithBlock:^{ VI_AnimationLoop(); }] selector:@selector(main)];
        [g_animationLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

static inline CGFloat VI_DefaultDeviceYOffset(NSString *deviceModel) {
    if (!deviceModel) return 20.5;
    if ([deviceModel hasPrefix:@"iPhone17"] || [deviceModel hasPrefix:@"iPhone18"]) return 14.5;
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
- (BOOL)_shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)o {
    return YES;
}
- (void)layoutSubviews {
    %orig;
    BOOL isLandscape = VI_IsLandscapeOrientation();
    CGFloat safeScale = (scale > 0.1f) ? scale : 1.0f;
    NSString *deviceModel = [Model deviceModel];
    if (isLandscape) {
        self.transform = scaleEnabled ? CGAffineTransformMakeScale(safeScale, safeScale) : CGAffineTransformIdentity;
        CGRect f = self.frame;
        f.origin.y = posEnabled ? (yPos / safeScale) : 10.0f;
        f.origin.x = posEnabled && xPos != 0 ? (xPos / safeScale) : -([UIScreen mainScreen].bounds.size.width * 0.28f);
        self.frame = f;
        self.hidden = NO;
        self.alpha = 1.0f;
        return;
    }
    if (scaleEnabled && fixEnabled) {
        self.transform = CGAffineTransformMakeScale(safeScale, safeScale);
        CGRect f = self.frame;
        f.origin.y = VI_DefaultDeviceYOffset(deviceModel)/safeScale;
        self.frame = f;
    } else if (scaleEnabled && posEnabled) {
        self.transform = CGAffineTransformMakeScale(safeScale, safeScale);
        CGRect f = self.frame;
        f.origin.y = yPos/safeScale;
        if (xPos!=0) f.origin.x = xPos/safeScale;
        self.frame = f;
    } else if (fixEnabled) {
        CGRect f = self.frame;
        f.origin.y = VI_DefaultDeviceYOffset(deviceModel);
        self.frame = f;
    } else if (posEnabled) {
        CGRect f = self.frame;
        f.origin.y = yPos;
        f.origin.x = xPos;
        self.frame = f;
    } else if (scaleEnabled) {
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
    for (UIView *v in self.view.subviews) {
        NSString *cls = NSStringFromClass([v class]);
        if ([cls containsString:@"Curtain"] || [cls containsString:@"GainMap"]) {
            if (fixEnabled || posEnabled || hideEnabled) {
                v.hidden = YES;
                v.alpha = 0.0f;
            }
        }
    }
}
%end

%hook SBRingerIndicatorView
- (void)setState:(long long)arg1 animated:(BOOL)arg2 {
    %orig(arg1, arg2);
    // Giữ nguyên hành vi hệ thống, chỉ chỉnh giao diện hiển thị
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.subviews.count == 0 || CGRectIsEmpty(self.frame)) return;
        self.layer.cornerRadius = 24.0f;
        self.layer.masksToBounds = YES;
        // ĐÃ SỬA lỗi cú pháp UIColor.blackColor → [UIColor blackColor]
        self.layer.shadowColor = [[UIColor.blackColor colorWithAlphaComponent:0.15f] CGColor];
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 8.0f;
        self.layer.shadowOpacity = 1.0f;
        // Tăng kích thước giống nút bấm lớn khi chuyển trạng thái
        if (arg1 != 0) {
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect f = self.frame;
                f.size.width = 140.0f;
                f.size.height = 60.0f;
                self.frame = f;
                self.layer.cornerRadius = 18.0f;
            } completion:nil];
        }
    });
}
- (void)didMoveToWindow {
    %orig;
    if (self.window) {
        self.backgroundColor = [UIColor systemBackgroundColor];
        self.layer.cornerRadius = 18.0f;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor.systemGray4Color CGColor];
    }
}
%end

%hook SBFTouchPassThroughView
- (void)layoutSubviews {
    %orig;
    
    if (transEnabled && self.subviews.count >= 3) {
        UIView *sub = self.subviews[2];
        if (sub.alpha == 1.0 && sub.userInteractionEnabled == 0) {
            sub.alpha = alpha;
        }
    }
    if (lineDisabled && self.subviews.count >= 2) {
        UIView *line = self.subviews[1];
        if (line.alpha == 1.0 && line.userInteractionEnabled == 0) {
            line.hidden = YES;
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
    
    CGRect mainRect = primaryContainer.frame;
    BOOL isExpandedNow = (mainRect.size.height > 62.0f || mainRect.size.width > 270.0f);
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    if (VI_IsLandscapeOrientation()) {
        CGRect pFrame = primaryContainer.frame;
        pFrame.origin.x = 18.0f;
        pFrame.origin.y = isExpandedNow ? 12.0f : 10.0f;
        primaryContainer.frame = pFrame;
        return;
    }
    
    BOOL hasTwo = (secondaryContainer && !secondaryContainer.hidden && secondaryContainer.alpha > 0.05f && !isExpandedNow);
    BOOL hasThree = (!isExpandedNow) && VI_HasThreeOrMoreConcurrentActivities(primaryContainer, secondaryContainer);
    
    if (!hasThree && s_vi_bubbleManuallyDismissed && now - s_lastActivityCheck > 0.8f) {
        s_vi_bubbleManuallyDismissed = NO;
    }
    s_lastActivityCheck = now;
    
    // ==== 2 hoạt động: chỉ chỉnh bên phải, giữ dạng pill ====
    if (hasTwo && !hasThree) {
        if (@available(iOS 13.0, *)) {
            secondaryContainer.layer.cornerCurve = kCACornerCurveContinuous;
        }
        // Không co thành tròn — giữ dạng pill bình thường
        CGRect rFrame = secondaryContainer.frame;
        rFrame.origin.x = CGRectGetMaxX(mainRect) + 7.0f;
        secondaryContainer.frame = rFrame;
        secondaryContainer.layer.cornerRadius = mainRect.size.height / 2.0f;
        
        if (s_vi_bubbleVisible) {
            VI_HideBubble();
        }
    }
    
    // ==== 3 hoạt động: Bên phải co thành TRÒN, bên trái NỔI RA từ island ====
    if (hasThree && !s_vi_bubbleManuallyDismissed) {
        if (@available(iOS 13.0, *)) {
            secondaryContainer.layer.cornerCurve = kCACornerCurveContinuous;
        }
        
        CGFloat bubbleSize = mainRect.size.height;
        if (bubbleSize < 28.0f) bubbleSize = 35.0f;
        
        // ✅ Bên phải co thành TRÒN — ĐÚNG tỉ lệ, không méo
        CGRect rightRect = secondaryContainer.frame;
        CGFloat centerY = CGRectGetMidY(rightRect);
        rightRect.size.width = bubbleSize;
        rightRect.size.height = bubbleSize;
        rightRect.origin.x = CGRectGetMaxX(mainRect) + 7.0f;
        rightRect.origin.y = centerY - bubbleSize/2.0f;
        secondaryContainer.frame = rightRect;
        secondaryContainer.layer.cornerRadius = bubbleSize / 2.0f;
        
        // ✅ Bên trái NỔI RA từ trung tâm island — chỉ gọi 1 lần khi BẮT ĐẦU có 3 hoạt động
        if (!s_vi_bubbleVisible && !s_vi_bubbleAnimating) {
            VI_ShowBubble(mainRect, self);
        } else if (s_vi_bubbleVisible && !s_vi_bubbleAnimating) {
            // Đã hiện rồi → chỉ cập nhật vị trí mượt mà
            s_vi_mainRect = mainRect;
            CGFloat leftX = CGRectGetMinX(mainRect) - bubbleSize - 8.0f;
            if (g_leftTripleBubble) {
                CGPoint targetCenter = CGPointMake(leftX + bubbleSize/2.0f, CGRectGetMidY(mainRect));
                CGPoint currentCenter = g_leftTripleBubble.center;
                if (hypotf(targetCenter.x - currentCenter.x, targetCenter.y - currentCenter.y) > 0.5f) {
                    g_leftTripleBubble.center = targetCenter;
                }
            }
        }
    }
    
    // ==== Mất 3 hoạt động → HÚT VỀ ====
    if (!hasThree && s_vi_bubbleVisible && !s_vi_bubbleAnimating && !s_vi_bubbleManuallyDismissed) {
        VI_HideBubble();
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
    UIColor *bg = [self backgroundColor];
    if (colorEnabled && !bg) {
        [self setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]];
    }
    %orig;
}
%end

%hook SBBannerWindow
- (CGRect)frame {
    CGRect f = %orig;
    NSString *m = [Model deviceModel];
    if (notificationFix) {
        f.origin.x = 0;
        f.origin.y = VI_DefaultBannerYOffset(m);
    } else if (notEnabled) {
        f.origin.x = xNot;
        f.origin.y = yNot;
    }
    return f;
}
- (void)setFrame:(CGRect)frame {
    NSString *m = [Model deviceModel];
    if (notificationFix) {
        frame.origin.x = 0;
        frame.origin.y = VI_DefaultBannerYOffset(m);
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

static void respring(CFNotificationCenterRef c, void *o, CFStringRef n, const void *ob, CFDictionaryRef u) {
    [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

void preferencesChanged() {
    NSString *domain = @"com.ethxnn88.visibleislandprefs";
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:domain];
    if (!prefs) {
        NSString *p1 = @"/var/jb/var/mobile/Library/Preferences/com.ethxnn88.visibleislandprefs.plist";
        NSString *p2 = @"/var/mobile/Library/Preferences/com.ethxnn88.visibleislandprefs.plist";
        prefs = [NSDictionary dictionaryWithContentsOfFile:p1] ?: [NSDictionary dictionaryWithContentsOfFile:p2];
    }
    #define SET_BOOL(k) k = (prefs && prefs[@#k]) ? [prefs[@#k] boolValue] : NO
    #define SET_FLOAT(k) k = (prefs && prefs[@#k]) ? [prefs[@#k] floatValue] : k
    SET_BOOL(fixEnabled); SET_BOOL(islandEnabled); SET_BOOL(posEnabled); SET_BOOL(hideEnabled);
    SET_BOOL(notificationFix); SET_BOOL(notEnabled); SET_BOOL(colorEnabled);
    SET_BOOL(transEnabled); SET_BOOL(scaleEnabled); SET_BOOL(lineDisabled);
    SET_FLOAT(xPos); SET_FLOAT(yPos); SET_FLOAT(xNot); SET_FLOAT(yNot);
    SET_FLOAT(red); SET_FLOAT(green); SET_FLOAT(blue); SET_FLOAT(alpha); SET_FLOAT(scale);
    if (scale <= 0.05f) scale = 1.0f;
}

%ctor {
    preferencesChanged();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, 
        (CFNotificationCallback)preferencesChanged, 
        CFSTR("com.ethxnn88.visibleislandprefs-updated"), NULL, 
        CFNotificationSuspensionBehaviorDeliverImmediately);
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
            respring, CFSTR("com.ethxnn88.visibleislandprefs-respring"), NULL,
            CFNotificationSuspensionBehaviorCoalesce);
    }
}
