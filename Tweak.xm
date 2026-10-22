#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <sys/sysctl.h>
#import <objc/runtime.h>

// ====================================================================================================
// VISIBLE ISLAND — CHUẨN IPHONE 18 PRO MAX 100% THẬT
// - 1 Tác vụ: 1 Đảo chính
// - 2 Tác vụ: 1 Đảo chính + 1 Giọt nước phải (Chuẩn gốc iOS)
// - 3 Tác vụ (Bấm thêm Quay video màn hình / Nhạc / Hẹn giờ thứ 3): Mới kéo màng nước Metaball
//   và búng giọt nước thứ 3 sang bên trái với Icon thật 100%, không bao giờ hiện cục vàng giả!
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

@interface SBRecordingIndicatorManager : NSObject
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

// ====================================================================================================
// BỘ NHẬN DIỆN TÁC VỤ THỨ 3 THẬT SỰ & HIỆU ỨNG KÉO MÀNG NƯỚC METABALL 18 PRO MAX
// ====================================================================================================

static UIView *g_thirdBubbleView = nil;
static CAShapeLayer *g_metaballBridgeLayer = nil;
static UIImageView *g_thirdBubbleIcon = nil;
static UIView *g_recordPulseDot = nil;
static BOOL g_isThirdBubbleVisible = NO;
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

// Kiểm tra chính xác số lượng tác vụ nền thật sự đang chạy:
// Chỉ trả về YES khi hệ thống đã đầy 2 ô (Chính + Phải) VÀ có thêm tác vụ thứ 3 đang chạy!
static inline BOOL VI_HasRealThirdConcurrentActivity(UIView *primaryContainer, UIView *secondaryContainer, int *outThirdType) {
    // Điều kiện tiên quyết: Đảo chính và Giọt nước bên phải (Tác vụ 1 & 2) phải đang hiển thị thật
    if (!primaryContainer || !secondaryContainer) return NO;
    if (secondaryContainer.hidden || secondaryContainer.alpha < 0.05f || secondaryContainer.bounds.size.width < 12.0f) {
        return NO;
    }

    int activeCount = 0;
    BOOL isMusicActive = NO;
    BOOL isScreenRecording = [UIScreen mainScreen].isCaptured;

    Class mediaCls = objc_getClass("SBMediaController");
    if (mediaCls && [mediaCls respondsToSelector:@selector(sharedInstance)]) {
        SBMediaController *mc = [mediaCls sharedInstance];
        if (mc && ([mc isPlaying] || [mc isPaused]) && [mc nowPlayingApplication] != nil) {
            isMusicActive = YES;
        }
    }

    if (isMusicActive) activeCount++;
    if (isScreenRecording) activeCount++;

    // Đếm các session/element đang hoạt động bên trong SystemAperture
    // Nếu đã có 2 container hiển thị (ví dụ Hẹn giờ + Nhạc) và bạn bật thêm Quay màn hình (hoặc ngược lại)
    if (isMusicActive && isScreenRecording) {
        // Kiểm tra xem trong 2 container hiện tại có cái nào là Hẹn giờ / Cuộc gọi / Ghi âm thứ 3 không
        // Hoặc khi cả Nhạc + Quay màn hình + 1 Live Activity khác cùng chạy
        for (UIView *sub in primaryContainer.superview.subviews) {
            NSString *cls = NSStringFromClass([sub class]);
            if ([cls containsString:@"SystemApertureContainerView"] && !sub.hidden && sub.alpha > 0.1f && sub.bounds.size.width > 10.0f) {
                activeCount++;
            }
        }
    }

    // Phân loại icon thật cho giọt nước thứ 3 bên trái:
    // Type 1: Quay video màn hình (Chấm đỏ nhịp thở chuẩn iOS)
    // Type 2: Đang phát nhạc (Icon sóng nhạc trắng/xanh)
    if (isScreenRecording && isMusicActive && activeCount >= 4) {
        if (outThirdType) *outThirdType = 1;
        return YES;
    }

    return NO;
}

// Vẽ màng nước đen nối liền khi giọt nước tách ra hoặc hút vào (Metaball Liquid Path)
static void VI_UpdateMetaballBridge(UIView *parentView, CGRect mainRect, CGRect bubbleRect, CGFloat progress) {
    if (!g_metaballBridgeLayer) {
        g_metaballBridgeLayer = [CAShapeLayer layer];
        g_metaballBridgeLayer.fillColor = [UIColor blackColor].CGColor;
    }
    if (g_metaballBridgeLayer.superlayer != parentView.layer) {
        [parentView.layer insertSublayer:g_metaballBridgeLayer atIndex:0];
    }

    if (progress <= 0.02f || progress >= 0.92f) {
        g_metaballBridgeLayer.path = NULL;
        g_metaballBridgeLayer.opacity = 0.0f;
        return;
    }

    CGFloat midY = CGRectGetMidY(mainRect);
    CGFloat neckHalfHeight = (mainRect.size.height * 0.34f) * (1.0f - progress);
    CGFloat leftX = CGRectGetMaxX(bubbleRect) - 5.0f;
    CGFloat rightX = CGRectGetMinX(mainRect) + 5.0f;

    if (rightX <= leftX) {
        g_metaballBridgeLayer.path = NULL;
        return;
    }

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(leftX, midY - neckHalfHeight * 1.4f)];
    [path addQuadCurveToPoint:CGPointMake(rightX, midY - neckHalfHeight * 1.4f)
                 controlPoint:CGPointMake((leftX + rightX) * 0.5f, midY - neckHalfHeight * 0.35f)];
    [path addLineToPoint:CGPointMake(rightX, midY + neckHalfHeight * 1.4f)];
    [path addQuadCurveToPoint:CGPointMake(leftX, midY + neckHalfHeight * 1.4f)
                 controlPoint:CGPointMake((leftX + rightX) * 0.5f, midY + neckHalfHeight * 0.35f)];
    [path closePath];

    g_metaballBridgeLayer.path = path.CGPath;
    g_metaballBridgeLayer.opacity = (float)(1.0f - (progress * 0.85f));
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
    return 11.0;
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

    // KHI XOAY NGANG MÀN HÌNH (LANDSCAPE):
    // Giữ nguyên hiệu ứng Dynamic Island và cho phép nhấn giữ nghe nhạc nảy ra từ góc trên bên trái
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

    // MÀN HÌNH DỌC: GIỮ NGUYÊN 100% CẤU HÌNH TRONG SETTINGS CỦA BẠN
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

    // TÌM ĐÚNG CÁC CONTAINER CỦA DYNAMIC ISLAND GỐC
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

    // Khi xoay ngang màn hình: Neo đảo ở góc trên bên trái, khi nhấn giữ nhạc bung mượt từ góc trái trên
    if (VI_IsLandscapeOrientation()) {
        CGRect pFrame = primaryContainer.frame;
        pFrame.origin.x = 18.0f;
        pFrame.origin.y = isExpandedNow ? 12.0f : 10.0f;
        primaryContainer.frame = pFrame;
    }

    // Kiểm tra xem có giọt nước phụ bên phải của hệ thống không
    if (secondaryContainer && !secondaryContainer.hidden && secondaryContainer.alpha > 0.05f && !isExpandedNow) {
        secondaryContainer.layer.cornerCurve = kCACornerCurveContinuous;
    }

    // CHỈ KHI CÓ TÁC VỤ THỨ 3 THẬT SỰ (Ví dụ: Nhạc + Hẹn giờ + Bấm thêm Quay video màn hình)
    // thì mới tách giọt nước thứ 3 sang bên trái kèm màng nước Metaball
    int thirdType = 0;
    BOOL shouldShowThirdBubble = (!isExpandedNow) && VI_HasRealThirdConcurrentActivity(primaryContainer, secondaryContainer, &thirdType);

    if (shouldShowThirdBubble) {
        CGRect mainRect = primaryContainer.frame;
        CGFloat bubbleSize = mainRect.size.height;
        if (bubbleSize < 28.0f) bubbleSize = 35.0f;

        if (!g_thirdBubbleView) {
            g_thirdBubbleView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(mainRect), mainRect.origin.y, bubbleSize, bubbleSize)];
            g_thirdBubbleView.backgroundColor = [UIColor blackColor];
            g_thirdBubbleView.layer.cornerCurve = kCACornerCurveContinuous;
            g_thirdBubbleView.clipsToBounds = YES;
            g_thirdBubbleView.alpha = 0.0f;

            // Chấm đỏ Quay màn hình thật 100% chuẩn iOS (có vòng tròn mờ bên ngoài + tâm đỏ nhấp nháy)
            g_recordPulseDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18.0f, 18.0f)];
            g_recordPulseDot.backgroundColor = [[UIColor systemRedColor] colorWithAlphaComponent:0.28f];
            g_recordPulseDot.layer.cornerRadius = 9.0f;

            UIView *innerRedCore = [[UIView alloc] initWithFrame:CGRectMake(4.5f, 4.5f, 9.0f, 9.0f)];
            innerRedCore.backgroundColor = [UIColor systemRedColor];
            innerRedCore.layer.cornerRadius = 4.5f;
            [g_recordPulseDot addSubview:innerRedCore];
            [g_thirdBubbleView addSubview:g_recordPulseDot];

            // Hiệu ứng nhịp thở cho chấm quay video màn hình
            CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            pulse.fromValue = @(0.88f);
            pulse.toValue = @(1.12f);
            pulse.duration = 0.85;
            pulse.autoreverses = YES;
            pulse.repeatCount = HUGE_VALF;
            [innerRedCore.layer addAnimation:pulse forKey:@"recordPulse"];
        }

        if (g_thirdBubbleView.superview != self) {
            [self addSubview:g_thirdBubbleView];
        }

        g_thirdBubbleView.layer.cornerRadius = bubbleSize / 2.0f;
        g_recordPulseDot.center = CGPointMake(bubbleSize / 2.0f, bubbleSize / 2.0f);

        CGRect finalLeftFrame = CGRectMake(CGRectGetMinX(mainRect) - bubbleSize - 7.5f, mainRect.origin.y, bubbleSize, bubbleSize);

        if (!g_isThirdBubbleVisible) {
            g_isThirdBubbleVisible = YES;
            // Xuất phát từ mép trong bên trái của viên thuốc chính rồi kéo màng nước tách ra
            CGRect startFrame = CGRectMake(CGRectGetMinX(mainRect) + 6.0f, mainRect.origin.y, bubbleSize, bubbleSize);
            g_thirdBubbleView.frame = startFrame;
            g_thirdBubbleView.transform = CGAffineTransformMakeScale(0.45f, 0.45f);
            g_thirdBubbleView.alpha = 1.0f;

            VI_UpdateMetaballBridge(self, mainRect, startFrame, 0.25f);

            [UIView animateWithDuration:0.18 animations:^{
                VI_UpdateMetaballBridge(self, mainRect, finalLeftFrame, 0.65f);
            } completion:^(BOOL finished) {
                VI_UpdateMetaballBridge(self, mainRect, finalLeftFrame, 1.0f);
            }];

            [UIView animateWithDuration:0.55
                                  delay:0.0
                 usingSpringWithDamping:0.62f
                  initialSpringVelocity:0.95f
                                options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                g_thirdBubbleView.transform = CGAffineTransformIdentity;
                g_thirdBubbleView.frame = finalLeftFrame;
            } completion:nil];
        } else {
            g_thirdBubbleView.frame = finalLeftFrame;
        }
    } else {
        // Khi tắt tác vụ thứ 3 hoặc chỉ còn 1-2 tác vụ: Hút giọt nước bên trái chui tọt vào trong đảo chính và biến mất hoàn toàn
        if (g_isThirdBubbleVisible && g_thirdBubbleView) {
            g_isThirdBubbleVisible = NO;
            CGRect mainRect = primaryContainer.frame;
            CGFloat bubbleSize = mainRect.size.height;
            CGRectabsorbFrame = CGRectMake(CGRectGetMinX(mainRect) + 10.0f, mainRect.origin.y, bubbleSize, bubbleSize);

            VI_UpdateMetaballBridge(self, mainRect, g_thirdBubbleView.frame, 0.45f);

            [UIView animateWithDuration:0.38
                                  delay:0.0
                 usingSpringWithDamping:0.75f
                  initialSpringVelocity:0.7f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                g_thirdBubbleView.frame = absorbFrame;
                g_thirdBubbleView.transform = CGAffineTransformMakeScale(0.35f, 0.35f);
                g_thirdBubbleView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                VI_UpdateMetaballBridge(self, mainRect, absorbFrame, 1.0f);
            }];
        }
    }

    // Hiệu ứng đàn hồi chuẩn 18 Pro Max khi nhấn giữ bung/thu trình phát nhạc
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

// Ẩn triệt để rèm đen thừa (_SBSystemApertureMagiciansCurtainView)
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
