ARCHS = arm64 arm64e
TARGET := iphone:clang:16.5:15.0
INSTALL_TARGET_PROCESSES = SpringBoard backboardd

THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VisibleIsland

VisibleIsland_FILES = Tweak.xm
VisibleIsland_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore LocalAuthentication AudioToolbox
VisibleIsland_PRIVATE_FRAMEWORKS = BiometricKitUI

# Cờ biên dịch an toàn cho cả Objective-C ARC và không bị dừng vì warning
VisibleIsland_CFLAGS = -fobjc-arc -Wno-error -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += visibleislandprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
