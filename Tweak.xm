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

// ============================================================
//  METABALL "2 GIỌT NƯỚC" — cầu lỏng căng giữa island & bubble
// ============================================================

static UIView *g_leftTripleBubble = nil;
static CAShapeLayer *g_metaballBridgeLayer = nil;

static CGRect s_vi_mainRect;
static BOOL s_vi_bubbleVisible = NO;
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

    BOOL isScreenRecording = [UIScreen mainScreen].isCaptured;
    if (isScreenRecording) activeTaskCount++;

    Class mediaCls = objc_getClass("SBMediaController");
    if (mediaCls && [mediaCls respondsToSelector:@selector(sharedInstance)]) {
        SBMediaController *mc = [mediaCls sharedInstance];
        if (mc && ([mc isPlaying] || [mc isPaused]) && [mc nowPlayingApplication] != nil) {
            activeTaskCount++;
        }
    }

    for (UIView *sub in primaryContainer.superview.subviews) {
        if (sub == primaryContainer || sub == secondaryContainer) continue;
        NSString *cls = NSStringFromClass([sub class]);
        if ([cls containsString:@"SystemApertureContainerView"] && !sub.hidden && sub.alpha > 0.1f && sub.bounds.size.width > 10) {
            activeTaskCount++;
        }
    }

    // Nguồn 4 — đã fix false positive: chỉ đếm window overlay nhỏ (PiP/call),
    // bỏ qua window fullscreen của app thường (nguyên nhân bubble hiện lung tung)
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) continue;
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            for (UIWindow *w in windowScene.windows) {
            #pragma clang diagnostic pop
                if (w.hidden || w.alpha < 0.8) continue;
                NSString *winCls = NSStringFromClass([w class]);
                if ([winCls containsString:@"SystemAperture"] || [winCls containsString:@"BannerWindow"]) continue;
                if (w.frame.size.width > 100 && w.frame.size.height > 100) continue; // window fullscreen → bỏ
                if (w.rootViewController) {
                    activeTaskCount++;
                    break;
                }
            }
        }
    }

    if (activeTaskCount >= 3) {
        s_consecutiveThreeChecks++;
        if (s_consecutiveThreeChecks >= 3) return YES;
    } else {
        s_consecutiveThreeChecks = 0;
    }
    return NO;
}

// ==== METABALL: vẽ "cầu nước" giữa 2 giọt — phình ở gốc, thắt giữa, dính mượt ====
static void VI_DrawMetaballBridge(CGRect mainRect, CGRect bubbleRect, CGFloat progress) {
    if (!g_metaballBridgeLayer) {
        g_metaballBridgeLayer = [CAShapeLayer layer];
        g_metaballBridgeLayer.fillColor = [UIColor blackColor].CGColor;
        g_metaballBridgeLayer.lineJoin = kCALineJoinRound;
        g_metaballBridgeLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    if (progress <= 0.02f || progress >= 0.98f) {
        g_metaballBridgeLayer.path = NULL;
        g_metaballBridgeLayer.opacity = 0.0f;
        return;
    }

    CGFloat midY = CGRectGetMidY(mainRect);
    CGFloat mainH = mainRect.size.height;
    CGFloat leftX  = CGRectGetMaxX(bubbleRect);   // mép phải giọt trái
    CGFloat rightX = CGRectGetMinX(mainRect);     // mép trái island
    CGFloat distance = rightX - leftX;
    if (distance < 1.5f) {
        // 2 giọt đã chạm → cầu kín hoàn toàn, không khe hở
        UIBezierPath *seal = [UIBezierPath bezierPathWithRect:
            CGRectMake(leftX, midY - mainH * 0.5f, rightX - leftX + 1.0f, mainH)];
        g_metaballBridgeLayer.path = seal.CGPath;
        g_metaballBridgeLayer.opacity = 1.0f;
        return;
    }

    // Cầu nước: dày ở 2 đầu (phình như giọt nước bám mặt), thắt ở giữa.
    // progress gần 0.5 → gần nhất → cầu dày nhất (đang hút dính vào nhau)
    CGFloat nearness = 1.0f - fabs(progress - 0.5f) * 2.0f;   // 1 = gần nhất
    CGFloat neck = mainH * (0.18f + 0.42f * nearness);        // bán kính giữa
    CGFloat endR = mainH * 0.46f;                             // bán kính 2 đầu

    CGFloat cx = (leftX + rightX) * 0.5f;

    UIBezierPath *path = [UIBezierPath bezierPath];
    // Nửa trên: từ đỉnh giọt trái, cong phình ra rồi vào eo giữa, ra đỉnh island
    [path moveToPoint:CGPointMake(leftX, midY - endR)];
    [path addCurveToPoint:CGPointMake(cx, midY - neck)
            controlPoint1:CGPointMake(leftX + distance * 0.30f, midY - endR * 0.95f)
            controlPoint2:CGPointMake(cx - distance * 0.28f,   midY - neck * 1.25f)];
    [path addCurveToPoint:CGPointMake(rightX, midY - endR)
            controlPoint1:CGPointMake(cx + distance * 0.28f,   midY - neck * 1.25f)
            controlPoint2:CGPointMake(rightX - distance * 0.30f, midY - endR * 0.95f)];
    // Nửa dưới: đối xứng
    [path addCurveToPoint:CGPointMake(cx, midY + neck)
            controlPoint1:CGPointMake(rightX - distance * 0.30f, midY + endR * 0.95f)
            controlPoint2:CGPointMake(cx + distance * 0.28f,   midY + neck * 1.25f)];
    [path addCurveToPoint:CGPointMake(leftX, midY + endR)
            controlPoint1:CGPointMake(cx - distance * 0.28f,   midY + neck * 1.25f)
            controlPoint2:CGPointMake(leftX + distance * 0.30f, midY + endR * 0.95f)];
    [path closePath];

    g_metaballBridgeLayer.path = path.CGPath;
    g_metaballBridgeLayer.opacity = fminf(1.0f, progress * 3.0f);
}

// ============================================================
//  SPRING DRIVER — vật lý nảy thật, đúng 120Hz ProMotion
// ============================================================

@interface VI_SpringDriver : NSObject
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) CGFloat position;   // 0 = ẩn, 1 = hiện
@property (nonatomic, assign) CGFloat velocity;
@property (nonatomic, assign) CGFloat target;
@property (nonatomic, strong) NSTimer *failSafe;
- (void)start;
- (void)stop;
- (void)tickOnce;
@end

static VI_SpringDriver *g_springDriver = nil;

static const CGFloat kSpringDamping   = 0.62f;  // thấp hơn = nảy nhiều hơn (iPhone ~0.6)
static const CGFloat kSpringStiffness = 190.0f; // cao hơn = nhanh hơn
static const CGFloat kSpringMass      = 1.0f;

@implementation VI_SpringDriver
- (CGRect)currentTargetRectFor:(CGFloat)t {
    CGFloat bubbleSize = s_vi_mainRect.size.height;
    if (bubbleSize < 28.0f) bubbleSize = 35.0f;
    CGRect centerRect = CGRectMake(CGRectGetMidX(s_vi_mainRect) - bubbleSize / 2.0f,
                                   CGRectGetMidY(s_vi_mainRect) - bubbleSize / 2.0f,
                                   bubbleSize, bubbleSize);
    CGRect leftRect = CGRectMake(CGRectGetMinX(s_vi_mainRect) - bubbleSize - 8.0f,
                                 s_vi_mainRect.origin.y,
                                 bubbleSize, bubbleSize);
    return CGRectMake(centerRect.origin.x + (leftRect.origin.x - centerRect.origin.x) * t,
                      centerRect.origin.y + (leftRect.origin.y - centerRect.origin.y) * t,
                      centerRect.size.width  + (leftRect.size.width  - centerRect.size.width) * t,
                      centerRect.size.height + (leftRect.size.height - centerRect.size.height) * t);
}
- (void)tick:(CADisplayLink *)dl {
    CGFloat dt = dl.targetTimestamp - dl.timestamp;  // dt thật → mượt 60 & 120Hz
    if (dt <= 0 || dt > 0.05f) dt = 1.0f / 60.0f;

    // F = -k(x - target) - c*v  → spring nảy thật
    CGFloat displacement = self.position - self.target;
    CGFloat c = 2.0f * kSpringDamping * sqrtf(kSpringStiffness);
    CGFloat force = -kSpringStiffness * displacement - c * self.velocity;
    self.velocity += force * dt / kSpringMass;
    self.position += self.velocity * dt;

    CGFloat t = fmaxf(0.0f, fminf(1.0f, self.position));
    CGRect cur = [self currentTargetRectFor:t];
    if (g_leftTripleBubble) {
        g_leftTripleBubble.hidden = NO;
        g_leftTripleBubble.frame = cur;
        // giọt phình nhẹ khi đang bay (squash & stretch nhẹ như chất lỏng)
        CGFloat stretch = 1.0f + fminf(0.10f, fabsf(self.velocity) * 0.035f);
        g_leftTripleBubble.transform = CGAffineTransformMakeScale(stretch, 2.0f - stretch);
        g_leftTripleBubble.alpha = fmaxf(0.0f, fminf(1.0f, t * 1.5f));
    }
    VI_DrawMetaballBridge(s_vi_mainRect, cur, t);

    if (fabsf(self.velocity) < 0.01f && fabsf(displacement) < 0.002f) {
        self.position = self.target;
        self.velocity = 0;
        [self tickOnce];
        [self stop];
    }
}
- (void)tickOnce {
    if (!g_leftTripleBubble) return;
    CGFloat t = fmaxf(0.0f, fminf(1.0f, self.position));
    g_leftTripleBubble.transform = CGAffineTransformIdentity;
    g_leftTripleBubble.frame = [self currentTargetRectFor:t];
    g_leftTripleBubble.alpha = fmaxf(0.0f, fminf(1.0f, t * 1.5f));
    if (t <= 0.001f) {
        g_leftTripleBubble.hidden = YES;
        UIView *dot = [g_leftTripleBubble viewWithTag:1902];
        dot.hidden = YES;
        g_metaballBridgeLayer.path = NULL;
        g_metaballBridgeLayer.opacity = 0.0f;
    } else {
        g_leftTripleBubble.hidden = NO;
    }
}
- (void)start {
    if (!self.link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        self.link.preferredFramesPerSecond = 120;
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    self.link.paused = NO;
    // Fail-safe chống kẹt: 2.5s chưa ổn định → ép về target
    [self.failSafe invalidate];
    self.failSafe = [NSTimer timerWithTimeInterval:2.5f target:self selector:@selector(forceSettle) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.failSafe forMode:NSRunLoopCommonModes];
}
- (void)forceSettle {
    self.position = self.target;
    self.velocity = 0;
    [self tickOnce];
    [self stop];
}
- (void)stop {
    self.link.paused = YES;
    [self.failSafe invalidate];
}
@end

static void VI_SetBubbleTarget(CGFloat target, CGFloat velocityKick) {
    if (!g_springDriver) g_springDriver = [[VI_SpringDriver alloc] init];
    g_springDriver.target = target;
    g_springDriver.velocity = velocityKick;
    [g_springDriver start];
}

// ============================================================
//  BUBBLE — giọt nước bên trái, có tương tác nảy
// ============================================================

@interface UIView_VIHelper : UIView
@end
@implementation UIView_VIHelper
- (void)vi_handleTap:(UITapGestureRecognizer *)gr {
    if (!g_leftTripleBubble || !s_vi_bubbleVisible) return;
    s_vi_bubbleManuallyDismissed = YES;
    s_vi_bubbleVisible = NO;
    // Nhíu lại như giọt nước bị bóp, rồi hút về island
    [UIView animateWithDuration:0.10 animations:^{
        g_leftTripleBubble.transform = CGAffineTransformMakeScale(0.85f, 1.10f);
    } completion:^(BOOL finished) {
        g_leftTripleBubble.transform = CGAffineTransformIdentity;
        VI_SetBubbleTarget(0.0f, -2.5f);
    }];
}
- (void)vi_handleLongPress:(UILongPressGestureRecognizer *)gr {
    if (!g_leftTripleBubble || !s_vi_bubbleVisible) return;
    if (gr.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:4 options:0 animations:^{
            g_leftTripleBubble.transform = CGAffineTransformMakeScale(1.14f, 0.92f);
        } completion:nil];
    } else if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:4 options:0 animations:^{
            g_leftTripleBubble.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}
@end

static void VI_PrepareBubbleIfNeeded(CGRect mainRect, UIView *containerView) {
    if (g_leftTripleBubble) return;
    CGFloat bubbleSize = mainRect.size.height;
    if (bubbleSize < 28.0f) bubbleSize = 35.0f;
    CGRect startRect = CGRectMake(CGRectGetMidX(mainRect) - bubbleSize / 2.0f,
                                  CGRectGetMidY(mainRect) - bubbleSize / 2.0f,
                                  bubbleSize, bubbleSize);
    g_leftTripleBubble = [[UIView_VIHelper alloc] initWithFrame:startRect];
    g_leftTripleBubble.backgroundColor = [UIColor blackColor];
    if (@available(iOS 13.0, *)) {
        g_leftTripleBubble.layer.cornerCurve = kCACornerCurveContinuous;
    }
    g_leftTripleBubble.layer.cornerRadius = bubbleSize / 2.0f;
    g_leftTripleBubble.clipsToBounds = YES;
    g_leftTripleBubble.alpha = 0.0f;
    g_leftTripleBubble.hidden = YES;
    g_leftTripleBubble.userInteractionEnabled = YES;

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

    UIWindow *targetWindow = containerView.window;
    if (targetWindow) {
        [targetWindow addSubview:g_leftTripleBubble];
        [targetWindow bringSubviewToFront:g_leftTripleBubble];
    }
    if (g_metaballBridgeLayer && g_metaballBridgeLayer.superlayer != containerView.layer) {
        [containerView.layer insertSublayer:g_metaballBridgeLayer atIndex:0];
    }
}

static void VI_ShowBubble(CGRect mainRect, UIView *containerView) {
    if (!g_leftTripleBubble) VI_PrepareBubbleIfNeeded(mainRect, containerView);
    if (!g_leftTripleBubble) return;
    if (s_vi_bubbleManuallyDismissed) return;

    s_vi_mainRect = mainRect;
    s_vi_bubbleVisible = YES;
    g_leftTripleBubble.hidden = NO;

    UIView *dot = [g_leftTripleBubble viewWithTag:1902];
    if (dot) dot.hidden = NO;

    if (g_springDriver.position < 0.05f) {
        g_springDriver.position = 0.0f;
        g_springDriver.velocity = 0.0f;
        g_leftTripleBubble.alpha = 0.0f;
    }
    VI_SetBubbleTarget(1.0f, 4.0f);   // kick mạnh → giọt nước bật ra có nảy
}

static void VI_HideBubble(void) {
    if (!g_leftTripleBubble || !s_vi_bubbleVisible) return;
    s_vi_bubbleVisible = NO;
    UIView *dot = [g_leftTripleBubble viewWithTag:1902];
    if (dot) dot.hidden = YES;
    VI_SetBubbleTarget(0.0f, -1.5f);  // hút về mượt
}

// ============================================================
//  OFFSET THEO THIẾT BỊ
// ============================================================

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

// ============================================================
//  HOOKS
// ============================================================

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
        if (xPos != 0) f.origin.x = xPos/safeScale;
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
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.subviews.count == 0 || CGRectIsEmpty(self.frame)) return;
        self.layer.cornerRadius = 24.0f;
        self.layer.masksToBounds = YES;
        self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.15f].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 8.0f;
        self.layer.shadowOpacity = 1.0f;
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
        self.layer.borderColor = [UIColor systemGray4Color].CGColor;
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

    // ==== 2 hoạt động: pill bên phải, thu gọn lại từ dạng tròn nếu trước đó là tròn ====
    if (hasTwo && !hasThree) {
        if (@available(iOS 13.0, *)) {
            secondaryContainer.layer.cornerCurve = kCACornerCurveContinuous;
        }
        CGRect rFrame = secondaryContainer.frame;
        // giãn lại từ tròn về pill có hiệu ứng lỏng
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2 options:0 animations:^{
            CGRect f = secondaryContainer.frame;
            f.origin.x = CGRectGetMaxX(mainRect) + 7.0f;
            secondaryContainer.frame = f;
        } completion:nil];
        secondaryContainer.layer.cornerRadius = mainRect.size.height / 2.0f;

        if (s_vi_bubbleVisible) {
            VI_HideBubble();
        }
    }

    // ==== 3 hoạt động: phải co TRÒN + trái NỔY RA bằng hiệu ứng giọt nước ====
    if (hasThree && !s_vi_bubbleManuallyDismissed) {
        if (@available(iOS 13.0, *)) {
            secondaryContainer.layer.cornerCurve = kCACornerCurveContinuous;
        }

        CGFloat bubbleSize = mainRect.size.height;
        if (bubbleSize < 28.0f) bubbleSize = 35.0f;

        // Bên phải co thành tròn đúng tỉ lệ, có spring co lại như giọt nước
        if (!CGRectEqualToRect(secondaryContainer.frame.size, CGSizeMake(bubbleSize, bubbleSize))) {
            [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:3 options:0 animations:^{
                CGRect rightRect = secondaryContainer.frame;
                CGFloat centerY = CGRectGetMidY(rightRect);
                rightRect.size.width = bubbleSize;
                rightRect.size.height = bubbleSize;
                rightRect.origin.x = CGRectGetMaxX(mainRect) + 7.0f;
                rightRect.origin.y = centerY - bubbleSize / 2.0f;
                secondaryContainer.frame = rightRect;
            } completion:nil];
        }
        secondaryContainer.layer.cornerRadius = bubbleSize / 2.0f;

        // Bubble trái nổ ra khỏi island (spring + metaball)
        if (!s_vi_bubbleVisible) {
            VI_ShowBubble(mainRect, self);
        } else {
            s_vi_mainRect = mainRect;
        }
    }

    // ==== Mất 3 hoạt động → giọt nước hút về island ====
    if (!hasThree && s_vi_bubbleVisible && !s_vi_bubbleManuallyDismissed) {
        VI_HideBubble();
    }

    // ==== Giọt trái ẩn mà island không còn → dọn cầu metaball ====
    if (!hasThree && !s_vi_bubbleVisible && !hasTwo && g_metaballBridgeLayer) {
        g_metaballBridgeLayer.path = NULL;
        g_metaballBridgeLayer.opacity = 0.0f;
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

// ============================================================
//  PREFS
// ============================================================

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
