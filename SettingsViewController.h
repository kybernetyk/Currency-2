//
//  SettingsViewController.h
//  Currency2
//
//  Created by jrk on 19/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UITableViewController 
{
	UISwitch *offlineModeSwitch;
	
	UITextField *bookmark0TextField;
	UITextField *bookmark1TextField;
	UITextField *bookmark2TextField;
	UITextField *bookmark3TextField;
	
	UITextField *currentTextField;
	
	UIBarButtonItem *doneEditingButton;
	UIButton *dotButton;
}

- (void) saveBookmarks;

@end
