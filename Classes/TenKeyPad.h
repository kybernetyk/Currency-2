//
//  TenKeyPad.h
//  TenKeyPad
//


#import <UIKit/UIKit.h>

@protocol TenKeyPadDelegate;

@interface TenKeyPad : UIViewController 
{
	id <TenKeyPadDelegate> delegate;
	
	// Goal is to use returnValue in the Delegate calling this class
	NSMutableString *returnValue;
	IBOutlet UILabel *totalLabel;
	
	IBOutlet UIButton *doneButton;
	IBOutlet UIButton *clearButton;
	
	double initValue;
}

@property (nonatomic, assign) id <TenKeyPadDelegate> delegate;
@property (nonatomic, retain) NSMutableString *returnValue;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;

- (id) initWithNumber: (NSNumber *)initNumber;

// Button IBActions Interface
- (IBAction) done;
- (IBAction) press1;
- (IBAction) press2;
- (IBAction) press3;
- (IBAction) press4;
- (IBAction) press5;
- (IBAction) press6;
- (IBAction) press7;
- (IBAction) press8;
- (IBAction) press9;
- (IBAction) press0;
- (IBAction) pressDot;
- (IBAction) pressBack;
- (IBAction) clearField;

@end

// Make sure to Implement this function in your code
@protocol TenKeyPadDelegate
- (void)tenKeyPadDidFinish:(TenKeyPad *) controller;
@end