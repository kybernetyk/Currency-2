#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AtomTableViewCell : UITableViewCell
{
	IBOutlet UIView *accessoryView;
    IBOutlet UIView *backgroundView;
    IBOutlet UIView *selectedBackgroundView;
    IBOutlet UILabel *zeile1;
    IBOutlet UILabel *zeile2;
	
	UIActivityIndicatorView *activityIndicator;
}

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void) setText1: (NSString *)theText;
-(void) setText2: (NSString *)theText;

@end
