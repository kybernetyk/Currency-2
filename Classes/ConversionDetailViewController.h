//
//  ConversionDetailViewController.h
//  Currency2
//
//  Created by jrk on 14/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSManagedConversion.h"

@interface ConversionDetailViewController : UIViewController 
{
	JSManagedConversion *conversion;
	IBOutlet UIWebView *chartImageView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (readwrite, retain) JSManagedConversion *conversion;

@end
