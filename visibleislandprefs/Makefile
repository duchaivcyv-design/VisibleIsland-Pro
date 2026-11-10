ARCHS = arm64 arm64e
TARGET := iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = VisibleIslandPrefs

VisibleIslandPrefs_FILES = VISRootListController.m CLRRootListController.m NOTRootListController.m SCLRootListController.m
VisibleIslandPrefs_FRAMEWORKS = UIKit Foundation
VisibleIslandPrefs_PRIVATE_FRAMEWORKS = Preferences
VisibleIslandPrefs_INSTALL_PATH = /Library/PreferenceBundles
VisibleIslandPrefs_CFLAGS = -fobjc-arc -Wno-error -Wno-deprecated-declarations
VisibleIslandPrefs_RESOURCE_DIRS = Resources

include $(THEOS_MAKE_PATH)/bundle.mk
