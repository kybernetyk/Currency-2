//
//  OverviewViewController.h
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OverviewViewController : UIViewController 
{
	NSFetchedResultsController *fetchedResultsController;
	
	IBOutlet UITextField *editField;
	IBOutlet UISegmentedControl *bookmarkBar;
	
	UITableView *tableView;
	
	UIBarButtonItem *doneEditingButton;
	UIBarButtonItem *editListButton;
#ifdef CUSTOM_GRAPHICS
	UIImageView *backgroundView;
#endif
	UIButton *dotButton;
}

- (void) updateTableView: (id) sender;
- (void) updateRates;

- (IBAction) bookmarkPressed: (id) sender;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@end
