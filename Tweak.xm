#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sys/sysctl.h>

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
static BOOL g_isSpringBoard = NO;
static BOOL g_islandReady = NO;   // true sau khi SpringBoard khởi tạo xong; trước đó không gọi UIKit
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

static void IslandApplyState(void);

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
    if (g_isSpringBoard && g_islandReady) {
        dispatch_async(dispatch_get_main_queue(), ^{ IslandApplyState(); });
    }
}

// ===== Đảo kiểu iPhone 18 Pro: tai trái/phải theo hoạt động. Chưa kiểm chứng trên máy. =====
static UIView *g_left = nil, *g_right = nil, *g_pill = nil;
static UILabel *g_label = nil, *g_leftIcon = nil, *g_rightIcon = nil;
static int g_appCount = 0;          // số app đang dùng (cập nhật qua Darwin notification)
static BOOL g_musicOn = NO;         // có app nghe nhạc nền
static BOOL g_prevMusicOn = NO;
static const CGFloat kD = 37.0, kGap = 120.0, kTop = 9.0, kExpandedW = 300.0;

static void IslandEnsure(void) {
    if (!g_isSpringBoard || !g_islandReady) return;
    if (g_win) return;
    CGRect s = [UIScreen mainScreen].bounds;
    g_win = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, s.size.width, 60)];
    g_win.windowLevel = UIWindowLevelStatusBar + 10;
    g_win.backgroundColor = UIColor.clearColor;
    g_win.userInteractionEnabled = NO;
    g_win.rootViewController = [UIViewController new];
    g_win.hidden = NO;
    UIView *root = g_win.rootViewController.view;
    root.backgroundColor = UIColor.clearColor;
    CGFloat cx = s.size.width / 2;
    g_left = [[UIView alloc] initWithFrame:CGRectMake(cx, kTop, kD, kD)];
    g_right = [[UIView alloc] initWithFrame:CGRectMake(cx, kTop, kD, kD)];
    for (UIView *v in @[g_left, g_right]) {
        v.backgroundColor = UIColor.blackColor;
        v.layer.cornerRadius = kD / 2;
        v.alpha = 0.0;
        [root addSubview:v];
    }
    g_leftIcon = [[UILabel alloc] initWithFrame:g_left.bounds];
    g_rightIcon = [[UILabel alloc] initWithFrame:g_right.bounds];
    for (UILabel *l in @[g_leftIcon, g_rightIcon]) {
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        l.textColor = UIColor.whiteColor;
    }
    [g_left addSubview:g_leftIcon];
    [g_right addSubview:g_rightIcon];
    g_pill = [[UIView alloc] initWithFrame:CGRectMake(cx - kD / 2, kTop, kD, kD)];
    g_pill.backgroundColor = UIColor.blackColor;
    g_pill.layer.cornerRadius = kD / 2;
    g_pill.clipsToBounds = YES;
    g_pill.alpha = 0.0;
    [root addSubview:g_pill];
    g_label = [[UILabel alloc] initWithFrame:g_pill.bounds];
    g_label.textColor = UIColor.whiteColor;
    g_label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    g_label.textAlignment = NSTextAlignmentCenter;
    g_label.alpha = 0.0;
    [g_pill addSubview:g_label];
}

// Một tai bật ra từ điểm giữa rồi nở về vị trí đích (lò xo); tắt thì co lại về giữa.
static void IslandPopView(UIView *v, CGRect target, CGRect center, BOOL show, NSTimeInterval delay) {
    if (show && v.alpha < 0.5) v.frame = center;
    [UIView animateWithDuration:0.5 delay:delay usingSpringWithDamping:0.62 initialSpringVelocity:0.8
                        options:UIViewAnimationOptionAllowUserInteraction animations:^{
        v.frame = show ? target : center;
        v.alpha = show ? 1.0 : 0.0;
    } completion:nil];
}

static void IslandRefreshCompact(void) {
    if (!g_isSpringBoard || !g_islandReady) return;
    IslandEnsure();
    CGRect s = [UIScreen mainScreen].bounds;
    CGFloat cx = s.size.width / 2;
    CGRect leftFrame = CGRectMake(cx - kGap / 2 - kD, kTop, kD, kD);
    CGRect rightFrame = CGRectMake(cx + kGap / 2, kTop, kD, kD);
    CGRect center = CGRectMake(cx - kD / 2, kTop, kD, kD);
    g_leftIcon.text = @"♪";
    g_rightIcon.text = @"●";
    g_pill.alpha = 0.0;
    g_label.alpha = 0.0;
    BOOL wantLeft = g_musicOn;
    BOOL wantRight = g_appCount >= 2;
    // Nhạc vừa bật: đảo hút vào giữa trước rồi mới tách tai trái
    if (wantLeft && !g_prevMusicOn) {
        [UIView animateWithDuration:0.18 animations:^{
            g_left.frame = center;
            g_right.frame = center;
        } completion:^(BOOL f) {
            IslandPopView(g_left, leftFrame, center, YES, 0);
            IslandPopView(g_right, rightFrame, center, wantRight, 0.05);
        }];
    } else {
        IslandPopView(g_left, leftFrame, center, wantLeft, 0);
        IslandPopView(g_right, rightFrame, center, wantRight, 0.05);
    }
    g_prevMusicOn = wantLeft;
}

// Mở rộng thành viên thuốc có nội dung (dùng cho sự kiện như sạc, thử)
static void IslandShowExpanded(NSString *text) {
    if (!g_isSpringBoard || !g_islandReady) return;
    IslandEnsure();
    CGRect s = [UIScreen mainScreen].bounds;
    CGFloat cx = s.size.width / 2;
    g_label.text = text;
    [UIView animateWithDuration:0.55 delay:0 usingSpringWithDamping:0.72 initialSpringVelocity:0.6
                        options:UIViewAnimationOptionAllowUserInteraction animations:^{
        g_left.alpha = 0.0; g_right.alpha = 0.0;
        g_pill.frame = CGRectMake(cx - kExpandedW / 2, kTop, kExpandedW, kD);
        g_pill.layer.cornerRadius = kD / 2;
        g_pill.alpha = 1.0;
        g_label.frame = g_pill.bounds;
        g_label.alpha = 1.0;
    } completion:nil];
}

static void IslandHide(void) {
    if (!g_isSpringBoard || !g_islandReady) return;
    IslandEnsure();
    CGRect s = [UIScreen mainScreen].bounds;
    CGFloat cx = s.size.width / 2;
    CGRect center = CGRectMake(cx - kD / 2, kTop, kD, kD);
    [UIView animateWithDuration:0.4 animations:^{
        g_left.frame = center; g_right.frame = center;
        g_left.alpha = 0.0; g_right.alpha = 0.0;
        g_pill.alpha = 0.0; g_label.alpha = 0.0;
    }];
}

// Sự kiện mở rộng 2,6 giây rồi quay lại trạng thái tai hiện tại
static void IslandFlash(NSString *expandedText, NSString *leftText, NSString *rightText) {
    if (!islandEnabled || !g_isSpringBoard || !g_islandReady) return;
    IslandShowExpanded(expandedText);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        IslandRefreshCompact();
    });
}

%hook SBUIController
- (void)_handleBatteryStateChange:(id)arg {
    %orig;
    UIDevice *d = [UIDevice currentDevice];
    d.batteryMonitoringEnabled = YES;
    if (d.batteryState == UIDeviceBatteryStateCharging || d.batteryState == UIDeviceBatteryStateFull) {
        IslandFlash([NSString stringWithFormat:@"⚡ %d%%", (int)(d.batteryLevel * 100)], @"⚡", @"");
    }
}
%end

// Darwin notification: app mở/đóng, nhạc bật/tắt (gọi từ bên ngoài, ví dụ notifyutil -p ...)
static void IslandAppAdd(CFNotificationCenterRef c, void *o, CFStringRef n, const void *obj, CFDictionaryRef info) {
    dispatch_async(dispatch_get_main_queue(), ^{ g_appCount++; if (islandEnabled) IslandRefreshCompact(); });
}
static void IslandAppRemove(CFNotificationCenterRef c, void *o, CFStringRef n, const void *obj, CFDictionaryRef info) {
    dispatch_async(dispatch_get_main_queue(), ^{ if (g_appCount > 0) g_appCount--; if (islandEnabled) IslandRefreshCompact(); });
}
static void IslandMusicOn(CFNotificationCenterRef c, void *o, CFStringRef n, const void *obj, CFDictionaryRef info) {
    dispatch_async(dispatch_get_main_queue(), ^{ g_musicOn = YES; if (islandEnabled) IslandRefreshCompact(); });
}
static void IslandMusicOff(CFNotificationCenterRef c, void *o, CFStringRef n, const void *obj, CFDictionaryRef info) {
    dispatch_async(dispatch_get_main_queue(), ^{ g_musicOn = NO; if (islandEnabled) IslandRefreshCompact(); });
}

static void IslandTestCallback(CFNotificationCenterRef c, void *o, CFStringRef n, const void *obj, CFDictionaryRef info) {
    IslandFlash(@"Dynamic Island", @"●", @"✓");
}


static void IslandApplyState(void) {
    if (islandEnabled) { IslandRefreshCompact(); } else { IslandHide(); }
}

%ctor{
	preferencesChanged();
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
        g_isSpringBoard = YES;
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, IslandTestCallback,
            CFSTR("com.taojb.island.test"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, IslandAppAdd,
            CFSTR("com.taojb.island.app.add"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, IslandAppRemove,
            CFSTR("com.taojb.island.app.remove"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, IslandMusicOn,
            CFSTR("com.taojb.island.music.on"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, IslandMusicOff,
            CFSTR("com.taojb.island.music.off"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            g_islandReady = YES;
            IslandApplyState();
        });
    }

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("com.ethxnn88.visibleislandprefs-updated"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.ethxnn88.visibleislandprefs-respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    }
}
