#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <sys/sysctl.h>
#import <notify.h>

// ============================================================================
// CẤU HÌNH BIẾN TOÀN CỤC (GIỮ NGUYÊN TỪ TWEAK GỐC + MỞ RỘNG UNIVERSAL)
// ============================================================================
CGFloat red = 0.0;
CGFloat green = 0.0;
CGFloat blue = 0.0;
CGFloat alpha = 1.0;
CGFloat scale = 1.0;

CGFloat xPos = 0.0;
CGFloat yPos = 20.5;
CGFloat xNot = 0.0;
CGFloat yNot = 40.0;

static BOOL fixEnabled = YES;
static BOOL islandEnabled = YES;
static BOOL posEnabled = NO;
static BOOL hideEnabled = NO;
static BOOL notificationFix = YES;
static BOOL notEnabled = NO;
static BOOL colorEnabled = NO;
static BOOL transEnabled = NO;
static BOOL scaleEnabled = NO;
static BOOL lineDisabled = NO;
static BOOL faceIDIslandEnabled = YES; // Mặc định bật hiệu ứng Face ID Dynamic Island cho mọi máy iOS 16+

// ============================================================================
// KHAI BÁO INTERFACES HỆ THỐNG SPRINGBOARD & SYSTEM APERTURE (iOS 16+)
// ============================================================================
@interface FBSystemService : NSObject
+ (id)sharedInstance;
- (void)exitAndRelaunch:(BOOL)arg1;
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

@interface SBUIBiometricResource : NSObject
+ (id)sharedInstance;
- (void)_notifyObserversOfEvent:(unsigned long long)event;
@end

@interface SBLockScreenManager : NSObject
+ (id)sharedInstance;
- (BOOL)isUILocked;
- (void)_finishUIUnlockFromSource:(int)source withOptions:(id)options;
- (BOOL)unlockUIFromSource:(int)source withOptions:(id)options;
@end

@interface SBDashBoardBiometricUnlockController : NSObject
- (void)biometricResource:(id)resource observeEvent:(unsigned long long)event;
@end

@interface SBSystemApertureController : NSObject
@end

@interface SBUIProudLockIconView : UIView
- (void)setState:(NSInteger)state animated:(BOOL)animated;
@end

// ============================================================================
// NHẬN DIỆN MODEL MÁY & TỌA ĐỘ TỰ ĐỘNG CHO TẤT CẢ CÁC DÒNG MÁY (iOS 16+)
// ============================================================================
@interface Model : NSObject
+ (NSString *)deviceModel;
+ (CGFloat)defaultIslandYOffset;
+ (CGRect)defaultBannerFrame;
@end

@implementation Model

+ (NSString *)deviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    if (machine == NULL) return @"Unknown";
    if (sysctlbyname("hw.machine", machine, &size, NULL, 0) == -1) {
        free(machine);
        return @"Unknown";
    }
    NSString *deviceModel = [NSString stringWithUTF8String:machine];
    free(machine);
    return deviceModel;
}

+ (CGFloat)defaultIslandYOffset {
    NSString *m = [self deviceModel];
    // Các máy Touch ID (iPhone 8, 8 Plus, SE 2, SE 3) -> đặt sát mép trên Status Bar đẹp chuẩn
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
    // Mặc định an toàn cho mọi thiết bị iOS 16+ khác
    return 18.0;
}

+ (CGRect)defaultBannerFrame {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    NSString *m = [self deviceModel];
    CGFloat yOffset = 38.0;
    if ([m isEqualToString:@"iPhone13,1"]) yOffset = 33.0;
    else if ([m isEqualToString:@"iPhone10,3"] || [m isEqualToString:@"iPhone10,6"] ||
             [m isEqualToString:@"iPhone11,2"] || [m isEqualToString:@"iPhone12,3"] ||
             [m isEqualToString:@"iPhone13,2"] || [m isEqualToString:@"iPhone13,3"]) yOffset = 35.0;
    else if ([m isEqualToString:@"iPhone11,6"] || [m isEqualToString:@"iPhone12,5"] ||
             [m isEqualToString:@"iPhone11,8"] || [m isEqualToString:@"iPhone12,1"]) yOffset = 37.0;
    else if ([m isEqualToString:@"iPhone14,5"] || [m isEqualToString:@"iPhone14,2"] ||
             [m isEqualToString:@"iPhone14,7"] || [m isEqualToString:@"iPhone14,8"]) yOffset = 40.0;
    else if ([m isEqualToString:@"iPhone14,3"]) yOffset = 42.0;

    return CGRectMake(0, yOffset, screenBounds.size.width, screenBounds.size.height);
}

@end

// ============================================================================
// BỘ ĐIỀU KHIỂN HIỆU ỨNG FACE ID TRÊN DYNAMIC ISLAND (CHUẨN VIDEO + NATIVE)
// Hỗ trợ: Face ID, Touch ID (Vân tay), Passcode, Visage, Camera Tweak, Mọi iOS 16+
// ============================================================================
typedef NS_ENUM(NSInteger, DIFaceIDState) {
    DIFaceIDStateIdle = 0,
    DIFaceIDStateScanning = 1, // Vòng cầu 3D xanh lá xoay quét (như trong video)
    DIFaceIDStateSuccess = 2,  // Mặt cười xanh lá Face ID + khoá mở
    DIFaceIDStateFailed = 3    // Lắc đảo báo lỗi
};

@interface DIFaceIDIslandManager : NSObject
@property (nonatomic, strong) UIWindow *overlayWindow;
@property (nonatomic, strong) UIView *islandPill;
@property (nonatomic, strong) UIView *scannerContainer;
@property (nonatomic, strong) CAShapeLayer *ringLayer1;
@property (nonatomic, strong) CAShapeLayer *ringLayer2;
@property (nonatomic, strong) CAShapeLayer *faceLayer;
@property (nonatomic, strong) UIImageView *lockIconView;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) NSTimer *collapseTimer;

+ (instancetype)sharedManager;
- (void)triggerScanningEffect;
- (void)triggerUnlockSuccessEffect;
- (void)triggerUnlockFailedEffect;
- (void)collapseIsland;
@end

@implementation DIFaceIDIslandManager

+ (instancetype)sharedManager {
    static DIFaceIDIslandManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[DIFaceIDIslandManager alloc] init];
    });
    return shared;
}

- (void)ensureOverlaySetup {
    if (self.overlayWindow) return;

    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.overlayWindow = [[UIWindow alloc] initWithFrame:screenBounds];
    self.overlayWindow.windowLevel = UIWindowLevelStatusBar + 500.0;
    self.overlayWindow.backgroundColor = [UIColor clearColor];
    self.overlayWindow.userInteractionEnabled = NO;
    self.overlayWindow.hidden = NO;

    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            self.overlayWindow.windowScene = (UIWindowScene *)scene;
            break;
        }
    }

    CGFloat topY = posEnabled ? yPos : [Model defaultIslandYOffset];
    CGFloat pillW = 126.0;
    CGFloat pillH = 37.0;
    self.islandPill = [[UIView alloc] initWithFrame:CGRectMake((screenBounds.size.width - pillW) / 2.0, topY, pillW, pillH)];
    self.islandPill.backgroundColor = [UIColor blackColor];
    self.islandPill.layer.cornerRadius = pillH / 2.0;
    self.islandPill.layer.cornerCurve = kCACornerCurveContinuous;
    self.islandPill.clipsToBounds = YES;
    self.islandPill.alpha = 0.0;
    [self.overlayWindow addSubview:self.islandPill];

    // Container chứa hiệu ứng cầu xoay 3D & mặt cười xanh lá (giống hệt video)
    self.scannerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 76)];
    self.scannerContainer.center = CGPointMake(pillW / 2.0, pillH / 2.0);
    [self.islandPill addSubview:self.scannerContainer];

    UIColor *neonGreen = [UIColor colorWithRed:0.35 green:0.98 blue:0.48 alpha:1.0];

    // Vòng elip 3D số 1 (như giây 0:00 trong video)
    self.ringLayer1 = [CAShapeLayer layer];
    self.ringLayer1.frame = CGRectMake(14, 14, 48, 48);
    self.ringLayer1.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 8, 48, 32)].CGPath;
    self.ringLayer1.strokeColor = neonGreen.CGColor;
    self.ringLayer1.fillColor = [UIColor clearColor].CGColor;
    self.ringLayer1.lineWidth = 3.2;
    self.ringLayer1.shadowColor = neonGreen.CGColor;
    self.ringLayer1.shadowRadius = 6.0;
    self.ringLayer1.shadowOpacity = 0.85;
    self.ringLayer1.shadowOffset = CGSizeZero;
    self.ringLayer1.opacity = 0.0;
    [self.scannerContainer.layer addSublayer:self.ringLayer1];

    // Vòng elip 3D số 2 vuông góc (như giây 0:00 trong video)
    self.ringLayer2 = [CAShapeLayer layer];
    self.ringLayer2.frame = CGRectMake(14, 14, 48, 48);
    self.ringLayer2.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(8, 0, 32, 48)].CGPath;
    self.ringLayer2.strokeColor = neonGreen.CGColor;
    self.ringLayer2.fillColor = [UIColor clearColor].CGColor;
    self.ringLayer2.lineWidth = 3.2;
    self.ringLayer2.shadowColor = neonGreen.CGColor;
    self.ringLayer2.shadowRadius = 6.0;
    self.ringLayer2.shadowOpacity = 0.85;
    self.ringLayer2.shadowOffset = CGSizeZero;
    self.ringLayer2.opacity = 0.0;
    [self.scannerContainer.layer addSublayer:self.ringLayer2];

    // Khung Mặt cười Face ID xanh lá (như giây 0:01 trong video)
    self.faceLayer = [CAShapeLayer layer];
    self.faceLayer.frame = CGRectMake(14, 14, 48, 48);
    self.faceLayer.path = [self createFaceIDSmilePathWithSize:48.0].CGPath;
    self.faceLayer.strokeColor = neonGreen.CGColor;
    self.faceLayer.fillColor = [UIColor clearColor].CGColor;
    self.faceLayer.lineWidth = 3.2;
    self.faceLayer.lineCap = kCALineCapRound;
    self.faceLayer.lineJoin = kCALineJoinRound;
    self.faceLayer.shadowColor = neonGreen.CGColor;
    self.faceLayer.shadowRadius = 5.0;
    self.faceLayer.shadowOpacity = 0.7;
    self.faceLayer.shadowOffset = CGSizeZero;
    self.faceLayer.opacity = 0.0;
    [self.scannerContainer.layer addSublayer:self.faceLayer];
}

// Vẽ icon mặt cười Face ID chuẩn từng nét như video gửi (Vòng tròn/khung + 2 mắt + mũi chữ J + miệng cười)
- (UIBezierPath *)createFaceIDSmilePathWithSize:(CGFloat)s {
    UIBezierPath *path = [UIBezierPath bezierPath];

    // Vòng bao ngoài
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(2, 2, s - 4, s - 4)];
    [path appendPath:circle];

    // Mắt trái
    [path moveToPoint:CGPointMake(s * 0.34, s * 0.34)];
    [path addLineToPoint:CGPointMake(s * 0.34, s * 0.43)];

    // Mắt phải
    [path moveToPoint:CGPointMake(s * 0.66, s * 0.34)];
    [path addLineToPoint:CGPointMake(s * 0.66, s * 0.43)];

    // Sống mũi uốn cong nhẹ chuẩn Apple Face ID
    [path moveToPoint:CGPointMake(s * 0.50, s * 0.36)];
    [path addLineToPoint:CGPointMake(s * 0.50, s * 0.52)];
    [path addQuadCurveToPoint:CGPointMake(s * 0.43, s * 0.55)
                 controlPoint:CGPointMake(s * 0.50, s * 0.55)];

    // Miệng cười
    [path moveToPoint:CGPointMake(s * 0.33, s * 0.65)];
    [path addQuadCurveToPoint:CGPointMake(s * 0.67, s * 0.65)
                 controlPoint:CGPointMake(s * 0.50, s * 0.79)];

    return path;
}

- (void)startGlobeSpinAnimation {
    [self.ringLayer1 removeAllAnimations];
    [self.ringLayer2 removeAllAnimations];

    CABasicAnimation *rot1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rot1.fromValue = @(0);
    rot1.toValue = @(M_PI * 2.0);
    rot1.duration = 0.65;
    rot1.repeatCount = HUGE_VALF;

    CABasicAnimation *rot2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    rot2.fromValue = @(0);
    rot2.toValue = @(M_PI * 2.0);
    rot2.duration = 0.65;
    rot2.repeatCount = HUGE_VALF;

    CABasicAnimation *rotZ = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotZ.fromValue = @(0);
    rotZ.toValue = @(M_PI * 2.0);
    rotZ.duration = 1.3;
    rotZ.repeatCount = HUGE_VALF;

    [self.ringLayer1 addAnimation:rot1 forKey:@"spinY"];
    [self.ringLayer1 addAnimation:rotZ forKey:@"spinZ"];
    [self.ringLayer2 addAnimation:rot2 forKey:@"spinX"];
}

// 1. HIỆU ỨNG QUÉT (Bung đảo vuông to + 2 vòng cầu xanh lá xoay 3D như giây 0:00 video)
- (void)triggerScanningEffect {
    if (!faceIDIslandEnabled) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ensureOverlaySetup];
        [self.collapseTimer invalidate];

        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGFloat topY = posEnabled ? yPos : [Model defaultIslandYOffset];
        CGFloat expandedW = 156.0;
        CGFloat expandedH = 156.0;

        self.faceLayer.opacity = 0.0;
        self.ringLayer1.opacity = 1.0;
        self.ringLayer2.opacity = 1.0;
        [self startGlobeSpinAnimation];

        [UIView animateWithDuration:0.42
                              delay:0.0
             usingSpringWithDamping:0.72
              initialSpringVelocity:0.8
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self.islandPill.alpha = 1.0;
            self.islandPill.frame = CGRectMake((screenBounds.size.width - expandedW) / 2.0, topY, expandedW, expandedH);
            self.islandPill.layer.cornerRadius = 42.0;
            self.scannerContainer.center = CGPointMake(expandedW / 2.0, expandedH / 2.0);
            self.scannerContainer.transform = CGAffineTransformMakeScale(1.35, 1.35);
            if (scaleEnabled && scale > 0.1) {
                self.islandPill.transform = CGAffineTransformMakeScale(scale, scale);
            }
        } completion:nil];

        self.collapseTimer = [NSTimer scheduledTimerWithTimeInterval:2.6
                                                              target:self
                                                            selector:@selector(collapseIsland)
                                                            userInfo:nil
                                                             repeats:NO];
    });
}

// 2. HIỆU ỨNG MỞ KHOÁ THÀNH CÔNG (Quả cầu xoay -> Mặt cười Face ID xanh lá -> Thu gọn về đảo chuẩn)
- (void)triggerUnlockSuccessEffect {
    if (!faceIDIslandEnabled) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ensureOverlaySetup];
        [self.collapseTimer invalidate];

        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGFloat topY = posEnabled ? yPos : [Model defaultIslandYOffset];
        CGFloat expandedW = 156.0;
        CGFloat expandedH = 156.0;

        // Bước A: Bung đảo & Xoay quả cầu 3D xanh lá trong 0.35s đầu (giây 0:00 video)
        self.faceLayer.opacity = 0.0;
        self.ringLayer1.opacity = 1.0;
        self.ringLayer2.opacity = 1.0;
        [self startGlobeSpinAnimation];

        [UIView animateWithDuration:0.36
                              delay:0.0
             usingSpringWithDamping:0.70
              initialSpringVelocity:0.9
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            self.islandPill.alpha = 1.0;
            self.islandPill.frame = CGRectMake((screenBounds.size.width - expandedW) / 2.0, topY, expandedW, expandedH);
            self.islandPill.layer.cornerRadius = 42.0;
            self.scannerContainer.center = CGPointMake(expandedW / 2.0, expandedH / 2.0);
            self.scannerContainer.transform = CGAffineTransformMakeScale(1.35, 1.35);
        } completion:nil];

        // Bước B: Chuyển từ quả cầu xoay sang Mặt cười Face ID xanh lá có hiệu ứng vẽ nét (giây 0:01 video)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.32 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.ringLayer1 removeAllAnimations];
            [self.ringLayer2 removeAllAnimations];
            self.ringLayer1.opacity = 0.0;
            self.ringLayer2.opacity = 0.0;

            self.faceLayer.opacity = 1.0;
            CABasicAnimation *strokeAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            strokeAnim.fromValue = @(0.15);
            strokeAnim.toValue = @(1.0);
            strokeAnim.duration = 0.25;
            [self.faceLayer addAnimation:strokeAnim forKey:@"drawFace"];

            // Nhịp nảy nhẹ khi xác thực thành công
            [UIView animateWithDuration:0.25
                                  delay:0.0
                 usingSpringWithDamping:0.55
                  initialSpringVelocity:1.0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                self.scannerContainer.transform = CGAffineTransformMakeScale(1.48, 1.48);
            } completion:nil];
        });

        // Bước C: Thu đảo gọn lại mượt mà sau khi mở khoá xong
        self.collapseTimer = [NSTimer scheduledTimerWithTimeInterval:1.25
                                                              target:self
                                                            selector:@selector(collapseIsland)
                                                            userInfo:nil
                                                             repeats:NO];
    });
}

// 3. HIỆU ỨNG THẤT BẠI (Lắc ngang đảo Dynamic Island)
- (void)triggerUnlockFailedEffect {
    if (!faceIDIslandEnabled) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ensureOverlaySetup];
        [self triggerScanningEffect];

        CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        shake.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        shake.duration = 0.45;
        shake.values = @[@(-12), @(12), @(-9), @(9), @(-5), @(5), @(0)];
        [self.islandPill.layer addAnimation:shake forKey:@"shakeError"];
    });
}

- (void)collapseIsland {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGFloat topY = posEnabled ? yPos : [Model defaultIslandYOffset];
        CGFloat pillW = 126.0;
        CGFloat pillH = 37.0;

        [UIView animateWithDuration:0.45
                              delay:0.0
             usingSpringWithDamping:0.80
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            self.scannerContainer.transform = CGAffineTransformMakeScale(0.3, 0.3);
            self.faceLayer.opacity = 0.0;
            self.ringLayer1.opacity = 0.0;
            self.ringLayer2.opacity = 0.0;
            self.islandPill.frame = CGRectMake((screenBounds.size.width - pillW) / 2.0, topY, pillW, pillH);
            self.islandPill.layer.cornerRadius = pillH / 2.0;
            self.scannerContainer.center = CGPointMake(pillW / 2.0, pillH / 2.0);
            self.islandPill.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.ringLayer1 removeAllAnimations];
                [self.ringLayer2 removeAllAnimations];
            }
        }];
    });
}

@end

// ============================================================================
// KÍCH HOẠT DYNAMIC ISLAND GỐC TRÊN MỌI MÁY iOS 16+ (KỂ CẢ TOUCH ID / NOTCH)
// ============================================================================
%hook BSPlatform

- (NSInteger)homeButtonType {
    // Báo cho SystemAperture biết thiết bị hỗ trợ cử chỉ hiện đại để không tắt Island trên máy Touch ID
    if (islandEnabled) return 2;
    return %orig;
}

%end

// ============================================================================
// BẮT TOÀN BỘ SỰ KIỆN MỞ KHOÁ: FACE ID, VÂN TAY (TOUCH ID), PASSCODE, VISAGE, TWEAK CAM
// ============================================================================

// 1. Bắt mọi sự kiện mở khoá tại SBLockScreenManager (Mở khoá bằng vân tay, mật khẩu, Visage, Tweak Camera, AutoUnlock...)
%hook SBLockScreenManager

- (void)_finishUIUnlockFromSource:(int)source withOptions:(id)options {
    [[DIFaceIDIslandManager sharedManager] triggerUnlockSuccessEffect];
    %orig(source, options);
}

- (BOOL)unlockUIFromSource:(int)source withOptions:(id)options {
    BOOL res = %orig(source, options);
    if (res) {
        [[DIFaceIDIslandManager sharedManager] triggerUnlockSuccessEffect];
    }
    return res;
}

- (void)lockUIFromSource:(int)source withOptions:(id)options {
    %orig(source, options);
    // Khi vừa khoá màn hình hoặc bật sáng màn hình khoá -> bung nhẹ hiệu ứng quét
    [[DIFaceIDIslandManager sharedManager] triggerScanningEffect];
}

%end

// 2. Bắt sự kiện Cảm biến Sinh trắc học (Touch ID / Face ID / BiometricKit / PearlID)
%hook SBUIBiometricResource

- (void)_notifyObserversOfEvent:(unsigned long long)event {
    %orig(event);
    // Event 1, 2, 3, 4: Bắt đầu chạm vân tay / quét mặt / xác thực
    // Event 4 (TouchID/FaceID Match Success): Khớp sinh trắc học thành công
    if (event == 4 || event == 3) {
        [[DIFaceIDIslandManager sharedManager] triggerUnlockSuccessEffect];
    } else if (event == 1 || event == 2 || event == 12 || event == 13) {
        [[DIFaceIDIslandManager sharedManager] triggerScanningEffect];
    } else if (event == 9 || event == 10 || event == 11) {
        // Không khớp vân tay / khuôn mặt
        [[DIFaceIDIslandManager sharedManager] triggerUnlockFailedEffect];
    }
}

%end

%hook SBDashBoardBiometricUnlockController

- (void)biometricResource:(id)resource observeEvent:(unsigned long long)event {
    %orig(resource, event);
    if (event == 4) {
        [[DIFaceIDIslandManager sharedManager] triggerUnlockSuccessEffect];
    }
}

%end

// 3. Bắt trực tiếp trạng thái ổ khoá màn hình khoá (SBUIProudLockIconView)
// Tương thích 100% với Visage, Pearl, Checkl0ck và mọi tweak mở khoá bằng Camera!
%hook SBUIProudLockIconView

- (void)setState:(NSInteger)state animated:(BOOL)animated {
    %orig(state, animated);
    // State 1: Locked / Scanning, State 2: Unlocked
    if (state == 1) {
        [[DIFaceIDIslandManager sharedManager] triggerScanningEffect];
    } else if (state == 2) {
        [[DIFaceIDIslandManager sharedManager] triggerUnlockSuccessEffect];
    }
}

%end

// ============================================================================
// GIỮ NGUYÊN & TỐI ƯU CÁC HOOK SYSTEM APERTURE GỐC CỦA TWEAK.XM
// ============================================================================
%hook SBSystemApertureWindow

- (void)layoutSubviews {
    %orig;
    CGFloat targetY = [Model defaultIslandYOffset];

    if (scaleEnabled && fixEnabled) {
        CGFloat safeScale = (scale > 0.1) ? scale : 1.0;
        self.transform = CGAffineTransformMakeScale(safeScale, safeScale);
        CGRect frame = self.frame;
        frame.origin.y = targetY / safeScale;
        self.frame = frame;
    } else if (scaleEnabled && posEnabled) {
        CGFloat safeScale = (scale > 0.1) ? scale : 1.0;
        self.transform = CGAffineTransformMakeScale(safeScale, safeScale);
        CGRect frame = self.frame;
        frame.origin.y = yPos / safeScale;
        if (xPos != 0) {
            frame.origin.x = xPos / safeScale;
        }
        self.frame = frame;
    } else if (fixEnabled && !scaleEnabled) {
        CGRect frame = self.frame;
        frame.origin.y = targetY;
        self.frame = frame;
    } else if (posEnabled && !scaleEnabled) {
        CGRect frame = self.frame;
        frame.origin.y = yPos;
        frame.origin.x = xPos;
        self.frame = frame;
    } else if (scaleEnabled) {
        CGFloat safeScale = (scale > 0.1) ? scale : 1.0;
        self.transform = CGAffineTransformMakeScale(safeScale, safeScale);
    }
}

%end

%hook _SBSystemApertureMagiciansCurtainView

- (void)didMoveToWindow {
    %orig;
    if (fixEnabled || posEnabled || islandEnabled) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}

%end

%hook _SBGainMapView

- (void)didMoveToWindow {
    %orig;
    if (hideEnabled) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }
}

%end

%hook _SBSystemApertureContainerViewContentView

- (void)layoutSubviews {
    if (colorEnabled) {
        UIColor *backgroundColor = [self backgroundColor];
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
        return [Model defaultBannerFrame];
    } else if (notEnabled) {
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        return CGRectMake(xNot, yNot, screenBounds.size.width, screenBounds.size.height);
    }
    return %orig;
}

- (void)setFrame:(CGRect)frame {
    if (notificationFix) {
        %orig([Model defaultBannerFrame]);
    } else if (notEnabled) {
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        %orig(CGRectMake(xNot, yNot, screenBounds.size.width, screenBounds.size.height));
    } else {
        %orig(frame);
    }
}

%end

// ============================================================================
// QUẢN LÝ PREFERENCES & KHỞI TẠO (%ctor)
// ============================================================================
static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

static void triggerTestFaceIDNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [[DIFaceIDIslandManager sharedManager] triggerUnlockSuccessEffect];
}

void preferencesChanged() {
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.ethxnn88.visibleislandprefs"];

    fixEnabled = (prefs && [prefs objectForKey:@"fixEnabled"] ? [[prefs valueForKey:@"fixEnabled"] boolValue] : YES);
    islandEnabled = (prefs && [prefs objectForKey:@"islandEnabled"] ? [[prefs valueForKey:@"islandEnabled"] boolValue] : YES);
    posEnabled = (prefs && [prefs objectForKey:@"posEnabled"] ? [[prefs valueForKey:@"posEnabled"] boolValue] : NO);
    hideEnabled = (prefs && [prefs objectForKey:@"hideEnabled"] ? [[prefs valueForKey:@"hideEnabled"] boolValue] : NO);
    notificationFix = (prefs && [prefs objectForKey:@"notificationFix"] ? [[prefs valueForKey:@"notificationFix"] boolValue] : YES);
    notEnabled = (prefs && [prefs objectForKey:@"notEnabled"] ? [[prefs valueForKey:@"notEnabled"] boolValue] : NO);
    colorEnabled = (prefs && [prefs objectForKey:@"colorEnabled"] ? [[prefs valueForKey:@"colorEnabled"] boolValue] : NO);
    transEnabled = (prefs && [prefs objectForKey:@"transEnabled"] ? [[prefs valueForKey:@"transEnabled"] boolValue] : NO);
    scaleEnabled = (prefs && [prefs objectForKey:@"scaleEnabled"] ? [[prefs valueForKey:@"scaleEnabled"] boolValue] : NO);
    lineDisabled = (prefs && [prefs objectForKey:@"lineDisabled"] ? [[prefs valueForKey:@"lineDisabled"] boolValue] : NO);
    faceIDIslandEnabled = (prefs && [prefs objectForKey:@"faceIDIslandEnabled"] ? [[prefs valueForKey:@"faceIDIslandEnabled"] boolValue] : YES);

    if (prefs && [prefs objectForKey:@"xPos"]) xPos = [[prefs objectForKey:@"xPos"] floatValue];
    if (prefs && [prefs objectForKey:@"yPos"]) yPos = [[prefs objectForKey:@"yPos"] floatValue];
    if (prefs && [prefs objectForKey:@"xNot"]) xNot = [[prefs objectForKey:@"xNot"] floatValue];
    if (prefs && [prefs objectForKey:@"yNot"]) yNot = [[prefs objectForKey:@"yNot"] floatValue];
    if (prefs && [prefs objectForKey:@"red"]) red = [[prefs objectForKey:@"red"] floatValue];
    if (prefs && [prefs objectForKey:@"green"]) green = [[prefs objectForKey:@"green"] floatValue];
    if (prefs && [prefs objectForKey:@"blue"]) blue = [[prefs objectForKey:@"blue"] floatValue];
    if (prefs && [prefs objectForKey:@"alpha"]) alpha = [[prefs objectForKey:@"alpha"] floatValue];
    if (prefs && [prefs objectForKey:@"scale"]) scale = [[prefs objectForKey:@"scale"] floatValue];
}

%ctor {
    // Chỉ chạy trên iOS 16.0 trở lên
    if (@available(iOS 16.0, *)) {
        preferencesChanged();

        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            NULL,
            (CFNotificationCallback)preferencesChanged,
            CFSTR("com.ethxnn88.visibleislandprefs-updated"),
            NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately
        );

        if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
            CFNotificationCenterAddObserver(
                CFNotificationCenterGetDarwinNotifyCenter(),
                NULL,
                respring,
                CFSTR("com.ethxnn88.visibleislandprefs-respring"),
                NULL,
                CFNotificationSuspensionBehaviorCoalesce
            );

            // Cho phép mọi tweak bên ngoài (Visage / Tweak Camera / Activator) gọi thẳng hiệu ứng qua Darwin Notification
            CFNotificationCenterAddObserver(
                CFNotificationCenterGetDarwinNotifyCenter(),
                NULL,
                triggerTestFaceIDNotification,
                CFSTR("com.ethxnn88.visibleisland.triggerfaceid"),
                NULL,
                CFNotificationSuspensionBehaviorDeliverImmediately
            );
        }
    }
}
