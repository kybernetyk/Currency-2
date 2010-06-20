//
//  Currency2AppDelegate.m
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright flux forge 2010. All rights reserved.
//

#import "Currency2AppDelegate.h"
#import "JSDataCore.h"
#import "JSCurrencyList.h"

@implementation Currency2AppDelegate

@synthesize isOnline;

@synthesize window;
@synthesize tabBarController;
@synthesize overviewViewController;
@synthesize editListViewController;

- (void) registerUserDefaults
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];	
	//register default preferences
	
	NSDictionary *reg = [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithDouble: 1.0], @"lastUserInput",
						 [NSNumber numberWithDouble: 1.0], @"defaultUserInput",
//						 [NSNumber numberWithInt: 0], @"leftPickerState",
//						 [NSNumber numberWithInt: 0], @"rightPickerState",						 
						 @"Never", @"lastListUpdate",
						 [NSNumber numberWithBool: NO], @"offlineMode",
						 [NSNumber numberWithDouble: 1.0], @"bookmark0",
						 [NSNumber numberWithDouble: 19.95], @"bookmark1",
 						 [NSNumber numberWithDouble: 49.95], @"bookmark2",
						 [NSNumber numberWithDouble: 79.95], @"bookmark3",
						 [NSNumber numberWithInt: 0], @"appStarts",
						 [NSNumber numberWithBool: YES], @"firstStart",		//status to check if the app was launched for the first time -> create default data
						 nil];
	
	[defs registerDefaults: reg];
	
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	NSString *loc = [[NSLocale preferredLanguages] objectAtIndex: 0];
	NSLog(@"current locale: %@", loc);
	
	NSLog(@"pref languages: %@", [NSLocale preferredLanguages]);
	
	
	[self registerUserDefaults];
	[self setIsOnline: NO];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	
	reachability = [[Reachability reachabilityWithHostName: @"download.finance.yahoo.com"] retain];
	[reachability startNotifer];

	int astarts = [[NSUserDefaults standardUserDefaults] integerForKey: @"appStarts"];
	astarts ++;
	[[NSUserDefaults standardUserDefaults] setInteger: astarts forKey: @"appStarts"];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
	
    // Add the tab bar controller's current view as a subview of the window
   [window addSubview:tabBarController.view];
	
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application 
{
	JSDataCore *dataCore = [JSDataCore sharedInstance];
    NSError *error = nil;
    if ([dataCore managedObjectContext] != nil) 
	{
        if ([[dataCore managedObjectContext] hasChanges] && ![[dataCore managedObjectContext] save:&error]) 
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}



/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	
	NSLog(@"LOL LOL LOL");
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Reachability
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	
	NetworkStatus stat = [curReach currentReachabilityStatus];
	
	NSLog(@"reachability changed to %i",stat);
	
	if (stat == NotReachable)
	{	
		[self setIsOnline: NO];
		
	}
	else
	{
		[self setIsOnline: YES];
		
		[[JSCurrencyList sharedCurrencyList] updateAvailableCurrencyList];
		[overviewViewController updateRates];
	}
}



#pragma mark -
#pragma mark Memory management


- (void)dealloc 
{
	[reachability stopNotifer];
	[reachability release];
	[tabBarController release];
    [window release];
    [super dealloc];
}

@end

