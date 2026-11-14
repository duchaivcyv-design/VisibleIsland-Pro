#import <Foundation/Foundation.h>
#include "NOTRootListController.h"
#include "VISL10n.h"
#include <sys/sysctl.h>
#import <UIKit/UIKit.h>

@implementation NOTRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Not" target:self];
		[VISL10n localizeSpecifiers:_specifiers forController:self title:@"Notifications"];
	}

	return _specifiers;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [VISL10n refreshController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *respring = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respringAsk:)];
    self.navigationItem.rightBarButtonItem = respring;
}

- (void)respringAsk:(id)sender {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:[VISL10n tr:@"Respring"]
                         message:[VISL10n tr:@"You are about to respring."]
                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *defaultAction = [UIAlertAction
        actionWithTitle:[VISL10n tr:@"Cancel"]
                  style:UIAlertActionStyleCancel
                handler:nil];

    UIAlertAction *yes = [UIAlertAction
        actionWithTitle:[VISL10n tr:@"Respring"]
                  style:UIAlertActionStyleDestructive
                handler:^(UIAlertAction *action) {
                    [self respring];
                }];

    [alert addAction:defaultAction];
    [alert addAction:yes];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)respring {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.ethxnn88.visibleislandprefs-respring"), NULL, NULL, YES);
}

- (void)savePos {
    [self.view endEditing:YES];
}

@end