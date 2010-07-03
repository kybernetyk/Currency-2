//
//  OverviewViewController.h
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "TenKeyPad.h"


@interface OverviewViewController : UIViewController 
{
	NSFetchedResultsController *fetchedResultsController;
	
	IBOutlet UITextField *editField;
	IBOutlet UIButton *editButton;
	//UILabel *editLabel;
	IBOutlet UISegmentedControl *bookmarkBar;
	
	UITableView *tableView;
	
	UIBarButtonItem *doneEditingButton;
	UIBarButtonItem *editListButton;
#ifdef CUSTOM_GRAPHICS
	UIImageView *backgroundView;
#endif

	//iad stuff
	IBOutlet ADBannerView *bannerView;
	CGRect tableAdVisibleFrame;
	CGRect tableStandardFrame;	
	CGRect adOffscreenFrame;
	CGRect adOnscreenFrame;
	BOOL isBannerVisible;
	BOOL bannerLoaded;
}

- (void) updateTableView: (id) sender;
- (void) updateRates;

- (IBAction) bookmarkPressed: (id) sender;
- (IBAction) showKeypadView: (id) sender;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@end
