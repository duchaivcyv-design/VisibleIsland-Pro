#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include "MORRootListController.h"
#include "VISL10n.h"

@implementation MORRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"More" target:self];
		[VISL10n localizeSpecifiers:_specifiers forController:self title:@"More"];
	}
	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[VISL10n refreshController:self];
}

// Giá trị hiển thị của các dòng thông tin (PSTitleValueCell)
- (id)staticValue:(PSSpecifier *)specifier {
	return [specifier propertyForKey:@"value"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	PSSpecifier *specifier = [self specifierAtIndexPath:indexPath];
	if ([specifier.identifier isEqualToString:@"linkbio"]) {
		NSString *text = [specifier propertyForKey:@"value"] ?: @"Linkbio.co/sleeper";
		cell.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{
			NSForegroundColorAttributeName: [UIColor systemBlueColor],
			NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
		}];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PSSpecifier *specifier = [self specifierAtIndexPath:indexPath];
	if ([specifier.identifier isEqualToString:@"linkbio"]) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		NSURL *url = [NSURL URLWithString:@"https://linkbio.co/sleeper"];
		[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
		return;
	}
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
