//
//  HelpDetailViewController.h
//  Currency2
//
//  Created by jrk on 9/5/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpDetailViewController : UIViewController 
{
	NSString *helpText;
	
	IBOutlet UITextView *helpTextView;
	
	IBOutlet UIWebView *helpView;
}

@property (readwrite, copy) NSString *helpText;

@end
