//
//  AddCurrencyViewController.h
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddCurrencyViewController : UIViewController 
{
	IBOutlet UILabel *fromLabel;
	IBOutlet UILabel *toLabel;
	IBOutlet UIPickerView *picker;
	IBOutlet UILabel *infoLabel;
	NSFetchedResultsController *fetchedResultsController;
}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
