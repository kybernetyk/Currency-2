//
//  Currency2AppDelegate.h
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright flux forge 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverviewViewController.h"
#import "EditListViewController.h"
#import "Reachability.h"


@interface Currency2AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> 
{
    UIWindow *window;
    UITabBarController *tabBarController;

	
	OverviewViewController *overviewViewController;
	EditListViewController *editListViewController;
	
	Reachability *reachability;
	
	BOOL isOnline;
	
	
}

@property (readwrite, assign) BOOL isOnline;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet OverviewViewController *overviewViewController;
@property (nonatomic, retain) IBOutlet EditListViewController *editListViewController;
	

@end
