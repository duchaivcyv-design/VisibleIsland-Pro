TARGET := iphone:clang:latest:12.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = VisibleIslandPrefs

ARCHS = arm64 arm64e

VisibleIslandPrefs_FILES = VISRootListController.m CLRRootListController.m NOTRootListController.m SCLRootListController.m
VisibleIslandPrefs_FRAMEWORKS = UIKit
VisibleIslandPrefs_PRIVATE_FRAMEWORKS = Preferences
VisibleIslandPrefs_INSTALL_PATH = /Library/PreferenceBundles
VisibleIslandPrefs_CFLAGS = -fobjc-arc
VisibleIslandPrefs_RESOURCE_DIRS = Resources   # đóng gói Root.plist, Color/Scale/Not.plist, icon vào bundle

include $(THEOS_MAKE_PATH)/bundle.mk
