#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sys/sysctl.h>
#import <objc/runtime.h>

// ============================================================
// GỐC — biến global giữ nguyên
// ============================================================
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

// ============================================================
// MỚI — công tắc fusion
// ============================================================
static BOOL fusionEnabled = NO;

// ============================================================
// METRICS iPhone 18 Pro Max
// ============================================================
static const CGFloat kIsland18Width   = 108.67;
static const CGFloat kIsland18Height  = 12.33;
static const CGFloat kIsland18OffsetY = 21.0;
static const CGFloat kDropletDiameter = 18.0;
static const CGFloat kDropletGap      = 6.0;
// (Đã xoá kIsland18Radius vì không dùng tới nữa)

// ============================================================
// INTERFACES GỐC
// ============================================================
@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)arg1;
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

#import <objc/message.h>

// ============================================================
// 1. LẤY SỐ LƯỢNG LIVE ACTIVITY BẰNG PRIVATE API (Không dùng view)
// ============================================================
static NSUInteger GetActiveActivityCount(void) {
    // Cách 1: Hỏi thẳng SBSystemApertureController
    Class apertureClass = NSClassFromString(@"SBSystemApertureController");
    if (apertureClass) {
        SEL sharedSel = NSSelectorFromString(@"sharedInstance");
        if ([apertureClass respondsToSelector:sharedSel]) {
            id shared = ((id(*)(id, SEL))objc_msgSend)(apertureClass, sharedSel);
            if (shared) {
                SEL elemsSel = NSSelectorFromString(@"activeElements");
                if ([shared respondsToSelector:elemsSel]) {
                    NSArray *elems = ((NSArray*(*)(id, SEL))objc_msgSend)(shared, elemsSel);
                    if (elems) return elems.count;
                }
            }
        }
    }

    // Cách 2: Hỏi SBActivityManager
    Class actMgrClass = NSClassFromString(@"SBActivityManager");
    if (actMgrClass) {
         SEL sharedSel = NSSelectorFromString(@"sharedInstance");
         if ([actMgrClass respondsToSelector:sharedSel]) {
             id shared = ((id(*)(id, SEL))objc_msgSend)(actMgrClass, sharedSel);
             if (shared) {
                 SEL actsSel = NSSelectorFromString(@"activities");
                 if ([shared respondsToSelector:actsSel]) {
                     NSArray *acts = ((NSArray*(*)(id, SEL))objc_msgSend)(shared, actsSel);
                     if (acts) return acts.count;
                 }
                 actsSel = NSSelectorFromString(@"activeActivities");
                 if ([shared respondsToSelector:actsSel]) {
                     NSArray *acts = ((NSArray*(*)(id, SEL))objc_msgSend)(shared, actsSel);
                     if (acts) return acts.count;
                 }
             }
         }
    }

    return 0;
}

// ============================================================
// 2. ISLAND VIEW — Chỉ vẽ giọt nước, ẩn hoàn toàn Pill đen
// ============================================================
@interface IslandView : UIView
@property (nonatomic, strong) UIView *leftDroplet;
@property (nonatomic, strong) UIView *rightDroplet;
@property (nonatomic, strong) CAShapeLayer *metaballLayer;
@property (nonatomic, assign) NSUInteger taskCount;
@end

@implementation IslandView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.clipsToBounds = NO;
    self.opaque = NO;

    // KHÔNG VẼ PILL Ở ĐÂY NỮA (Để VisibleIsland tự vẽ, tránh chấm đen)

    _leftDroplet = [self createDroplet];
    _rightDroplet = [self createDroplet];
    [self addSubview:_leftDroplet];
    [self addSubview:_rightDroplet];

    _metaballLayer = [CAShapeLayer layer];
    _metaballLayer.fillColor = [UIColor blackColor].CGColor;
    _metaballLayer.hidden = YES;
    [self.layer addSublayer:_metaballLayer];

    return self;
}

- (UIView *)createDroplet {
    UIView *drop = [[UIView alloc] initWithFrame:CGRectZero];
    drop.backgroundColor = [UIColor blackColor];
    drop.layer.cornerRadius = kDropletDiameter / 2.0;
    drop.layer.cornerCurve = kCACornerCurveContinuous;
    drop.layer.borderWidth = 0.5;
    drop.layer.borderColor = [UIColor colorWithWhite:0.25 alpha:1.0].CGColor;
    drop.hidden = YES;
    return drop;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutForTaskCount:_taskCount animated:NO];
}

- (void)layoutForTaskCount:(NSUInteger)count animated:(BOOL)animated {
    _taskCount = count;
    CGFloat cx = self.bounds.size.width / 2.0;
    CGFloat cy = self.bounds.size.height / 2.0;

    BOOL showDrops = (count >= 2);
    
    // Khoảng cách từ tâm ra 2 bên (Đảo 18 Pro Max rộng ~108.67pt, gap ~6pt)
    CGFloat dropXOffset = (kIsland18Width / 2.0) + kDropletGap + (kDropletDiameter / 2.0);

    void (^layoutBlock)(void) = ^{
        if (showDrops) {
            self.leftDroplet.frame = CGRectMake(
                cx - dropXOffset - (kDropletDiameter / 2.0),
                cy - kDropletDiameter / 2.0,
                kDropletDiameter, kDropletDiameter);
            self.rightDroplet.frame = CGRectMake(
                cx + dropXOffset - (kDropletDiameter / 2.0),
                cy - kDropletDiameter / 2.0,
                kDropletDiameter, kDropletDiameter);
        }
        self.leftDroplet.hidden  = !showDrops;
        self.rightDroplet.hidden = !showDrops;
        self.leftDroplet.alpha   = showDrops ? 1.0 : 0.0;
        self.rightDroplet.alpha  = showDrops ? 1.0 : 0.0;

        [self updateMetaballPath];
    };

    if (animated) {
        [UIView animateWithDuration:0.42 delay:0 usingSpringWithDamping:0.72 initialSpringVelocity:0.6 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:layoutBlock completion:nil];
    } else {
        layoutBlock();
    }
}

- (void)updateMetaballPath {
    if (self.taskCount < 2) {
        self.metaballLayer.hidden = YES;
        return;
    }
    
    CGFloat cx = self.bounds.size.width / 2.0;
    CGFloat cy = self.bounds.size.height / 2.0;

    CGFloat pillLeft = cx - kIsland18Width / 2.0;
    CGFloat pillRight = cx + kIsland18Width / 2.0;
    CGFloat pillTop = cy - kIsland18Height / 2.0;
    CGFloat pillBottom = cy + kIsland18Height / 2.0;

    CGFloat dropLeftX = self.leftDroplet.center.x;
    CGFloat dropRightX = self.rightDroplet.center.x;
    CGFloat dropR = kDropletDiameter / 2.0;

    UIBezierPath *path = [UIBezierPath bezierPath];

    // Nối chất lỏng bên trái
    [path moveToPoint:CGPointMake(pillLeft, pillTop)];
    [path addQuadCurveToPoint:CGPointMake(dropLeftX, cy - dropR) controlPoint:CGPointMake(pillLeft - kDropletGap / 2.0, pillTop - 2)];
    [path addQuadCurveToPoint:CGPointMake(pillLeft, pillBottom) controlPoint:CGPointMake(pillLeft - kDropletGap / 2.0, pillBottom + 2)];
    [path closePath];

    // Nối chất lỏng bên phải
    [path moveToPoint:CGPointMake(pillRight, pillTop)];
    [path addQuadCurveToPoint:CGPointMake(dropRightX, cy - dropR) controlPoint:CGPointMake(pillRight + kDropletGap / 2.0, pillTop - 2)];
    [path addQuadCurveToPoint:CGPointMake(pillRight, pillBottom) controlPoint:CGPointMake(pillRight + kDropletGap / 2.0, pillBottom + 2)];
    [path closePath];

    self.metaballLayer.path = path.CGPath;
    self.metaballLayer.hidden = NO;
}

- (void)pulse {
    [UIView animateWithDuration:0.28 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:0.9 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.leftDroplet.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.rightDroplet.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.leftDroplet.transform = CGAffineTransformIdentity;
            self.rightDroplet.transform = CGAffineTransformIdentity;
        }];
    }];
}

@end

// ============================================================
// ISLAND18 — Animator
// ============================================================
@interface IslandAnimator : NSObject
@property (nonatomic, weak) IslandView *island;
@property (nonatomic, weak) UIWindow *hostWindow;
+ (instancetype)shared;
- (void)attachToWindow:(UIWindow *)window;
- (void)setTaskCount:(NSUInteger)count;
@end

@implementation IslandAnimator

+ (instancetype)shared {
    static IslandAnimator *inst;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ inst = [IslandAnimator new]; });
    return inst;
}

- (void)attachToWindow:(UIWindow *)window {
    if (!window) return;
    if (self.island && self.island.superview == window) return;

    [self.island removeFromSuperview];

    CGFloat containerW = kIsland18Width + 2 * (kDropletGap + kDropletDiameter) + 40.0;
    CGFloat containerH = MAX(kDropletDiameter, kIsland18Height) + 20.0;
    CGFloat screenW = window.bounds.size.width;
    CGFloat safeTop = kIsland18OffsetY - (containerH - kIsland18Height) / 2.0;

    IslandView *v = [[IslandView alloc] initWithFrame:CGRectMake(
        (screenW - containerW) / 2.0,
        safeTop,
        containerW,
        containerH)];
    [window addSubview:v];
    self.island = v;
    self.hostWindow = window;
}

- (void)setTaskCount:(NSUInteger)count {
    if (!self.island) return;
    NSUInteger prev = self.island.taskCount;
    if (prev == count) return;

    [self.island layoutForTaskCount:count animated:YES];
    if (count > prev) [self.island pulse];
}

@end

static NSUInteger CountLiveTasks(UIView *root) {
    if (!root) return 0;

    NSUInteger count = 0;
    NSMutableArray<UIView *> *stack = [NSMutableArray arrayWithObject:root];

    // Các class có thể đại diện cho một Live Activity container trên iOS 16+
    NSSet *containerClasses = [NSSet setWithArray:@[
        @"_SBSystemApertureContainerViewContentView",
        @"_SBSystemApertureContainerView",
        @"SBSystemApertureContainerView",
        @"_SBSystemApertureLiveActivityView",
        @"SBSystemApertureLiveActivityView"
    ]];

    while (stack.count > 0) {
        UIView *v = stack.lastObject;
        [stack removeLastObject];

        NSString *cls = NSStringFromClass([v class]);
        if ([containerClasses containsObject:cls]) {
            count++;
            // Không đệ quy vào bên trong container đã đếm để tránh đếm trùng
            continue;
        }

        if (v.subviews.count > 0) {
            [stack addObjectsFromArray:v.subviews];
        }
    }

    return count;
}

// ============================================================
// HOOK GỐC — SBSystemApertureWindow layoutSubviews
// ============================================================
%hook SBSystemApertureWindow

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

    // ---- FUSION: chèn đảo 18 Pro Max nếu công tắc bật ----
    if (fusionEnabled) {
        UIWindow *hostWin = (UIWindow *)self;
        [[IslandAnimator shared] attachToWindow:hostWin];
        
        // GỌI BẰNG PRIVATE API
        NSUInteger live = GetActiveActivityCount();
        
        // Nếu API private trả về 0 (do app không phải Apple), fallback đếm view
        if (live == 0) {
            live = CountLiveTasks(self);
        }
        
        [[IslandAnimator shared] setTaskCount:live];
    }
}

- (void)didMoveToWindow {
    %orig;
    if (fusionEnabled) {
        UIWindow *hostWin = (UIWindow *)self;
        [[IslandAnimator shared] attachToWindow:hostWin];
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


        } else if ([deviceModel isEqualToString:@"iPhone11,6"]) { //XS Max FAKE OFFSETS??
            %orig;
            return CGRectMake(0, 37, 414, 896);
        } else if ([deviceModel isEqualToString:@"iPhone12,5"]) { //11 Pro Max FAKE OFFSTES??
            %orig;
            return CGRectMake(0, 37, 414, 896);


        } else if ([deviceModel isEqualToString:@"iPhone11,8"]) { //XR FIND OFFSETS - USING ESTIMATED
            %orig;
            return CGRectMake(0, 37, 414, 896);
        } else if ([deviceModel isEqualToString:@"iPhone12,1"]) { //11 FIND OFFSETS - USING ESTIMATED
            %orig;
            return CGRectMake(0, 37, 414, 896);


        } else if ([deviceModel isEqualToString:@"iPhone13,2"]) { //12 FIND OFFSETS - USING ESTIMATED
            %orig;
            return CGRectMake(0, 35, 390, 844);
        } else if ([deviceModel isEqualToString:@"iPhone13,3"]) { //12 Pro FIND OFFSETS - USING ESTIMATED
            %orig;
            return CGRectMake(0, 35, 390, 844);


        } else if ([deviceModel isEqualToString:@"iPhone13,1"]) { //12 Mini FIND OFFSETS - USING ESTIMATED
            %orig;
            return CGRectMake(0, 33, 360, 780);


        } else if ([deviceModel isEqualToString:@"iPhone13,4"]) { //12 Pro Max FIND OFFSETS - USING ESTIMATED
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


        } else if ([deviceModel isEqualToString:@"iPhone14,4"]) { //13 Mini FAKE OFFSETS??
            %orig;
            return CGRectMake(0, 38, 360, 780);


        } else if ([deviceModel isEqualToString:@"iPhone14,3"]) { //13 Pro Max FAKE OFFSETS??
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


        } else if ([deviceModel isEqualToString:@"iPhone11,6"]) { //XS Max FAKE OFFSETS??
            %orig(CGRectMake(0, 37, 414, 896));
        } else if ([deviceModel isEqualToString:@"iPhone12,5"]) { //11 Pro Max FAKE OFFSETS??
            %orig(CGRectMake(0, 37, 414, 896));


        } else if ([deviceModel isEqualToString:@"iPhone11,8"]) { //XR FIND OFFSETS - USING ESTIMATED
            %orig(CGRectMake(0, 37, 414, 896));
        } else if ([deviceModel isEqualToString:@"iPhone12,1"]) { //11 FIND OFFSETS - USING ESTIMATED
            %orig(CGRectMake(0, 37, 414, 896));


        } else if ([deviceModel isEqualToString:@"iPhone13,2"]) { //12 FIND OFFSETS - USING ESTIMATED
            %orig(CGRectMake(0, 35, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone13,3"]) { //12 Pro FIND OFFSETS - USING ESTIMATED
            %orig(CGRectMake(0, 35, 390, 844));


        } else if ([deviceModel isEqualToString:@"iPhone13,1"]) { //12 Mini FIND OFFSETS - USING ESTIMATED
            %orig(CGRectMake(0, 33, 360, 780));


        } else if ([deviceModel isEqualToString:@"iPhone13,4"]) { //12 Pro Max FIND OFFSETS - USING ESTIMATED
            %orig(CGRectMake(0, 38, 428, 926));


        } else if ([deviceModel isEqualToString:@"iPhone14,5"]) { //13
            %orig(CGRectMake(0, 40, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone14,2"]) { //13 Pro
            %orig(CGRectMake(0, 40, 390, 844));
        } else if ([deviceModel isEqualToString:@"iPhone14,7"]) { //14
            %orig(CGRectMake(0, 40, 390, 844));


        } else if ([deviceModel isEqualToString:@"iPhone14,4"]) { //13 Mini FAKE OFFSETS??
            %orig(CGRectMake(0, 38, 360, 780));


        } else if ([deviceModel isEqualToString:@"iPhone14,3"]) { //13 Pro Max FAKE OFFSETS??
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
            %orig;
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

// ============================================================
// PREFS — thêm fusionEnabled vào domain gốc
// ============================================================
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

    // ---- FUSION toggle ----
    fusionEnabled = (prefs && [prefs objectForKey:@"fusionEnabled"]
                     ? [[prefs valueForKey:@"fusionEnabled"] boolValue]
                     : NO);
}

%ctor{
    preferencesChanged();

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("com.ethxnn88.visibleislandprefs-updated"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.ethxnn88.visibleislandprefs-respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    }
}
