//
//  EditListViewController.h
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditListViewController : UITableViewController 
{
	NSFetchedResultsController *fetchedResultsController;
#ifdef CUSTOM_GRAPHICS	
	UIImageView *backgroundView;
#endif
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
