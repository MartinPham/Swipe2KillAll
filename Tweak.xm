/**
 * Swipe Homescreen card in AppSwitcher to kill all apps
 * MartinPham.com
**/
#include <notify.h>

// Interfaces needed, I'm too lazy to include full header files
@interface UIApplication (Z)
- (void)_simulateHomeButtonPress;
@end

%hook SBDeckSwitcherViewController
// Enable swipe for all cards
- (_Bool)isDisplayItemOfContainerRemovable:(id)arg1 {
	return YES;
}

// Listen when the card is swiped
- (void)scrollViewKillingProgressUpdated:(double)arg1 ofContainer:(id)arg2 {
	if (arg1 >= 1) {
		// It got killed
		if ([[[arg2 performSelector:@selector(displayItem)] performSelector:@selector(uniqueStringRepresentation)] isEqualToString:@"Homescreen-com.apple.springboard"])
		{
			// It is Homescreen card
			@try {
				id appSwitcherModel = [%c(SBAppSwitcherModel) performSelector:@selector(sharedInstance)];
				NSArray *items = [appSwitcherModel performSelector:@selector(mainSwitcherDisplayItems)];
				for(id item in items) {
					[appSwitcherModel performSelector:@selector(remove:) withObject:item]; 
				}

				// Optional, I want to click Home button after killing all
				notify_post("com.martinpham.swipe2killall.killed");
			}
			@catch (NSException *exception) {

			}
			return;
		}
	}


	%orig;
}

%end

// Implement listener, in this case we want to simulate Home button
static void Swipe2KillAll_Killed(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	@try {
		[[UIApplication sharedApplication] _simulateHomeButtonPress];
	}
	@catch (NSException *exception) {
		NSLog(@">>>> Exception:%@",exception);
	}
}

%hook SpringBoard
// Register listener
- (void)applicationDidFinishLaunching: (id) application {
    %orig;

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, Swipe2KillAll_Killed, CFSTR("com.martinpham.swipe2killall.killed"), NULL, CFNotificationSuspensionBehaviorCoalesce);

}
%end

