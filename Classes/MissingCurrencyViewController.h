//
//  MissingCurrencyViewController.h
//  Currency2
//
//  Created by jrk on 9/5/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MissingCurrencyViewController : UIViewController 
{
	IBOutlet UITextField *currencyList;
}

- (IBAction) showCompositionView: (id) sender;

@end
