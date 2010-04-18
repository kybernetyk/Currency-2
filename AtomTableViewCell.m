#import "AtomTableViewCell.h"

@implementation AtomTableViewCell
@synthesize activityIndicator;

-(void) setText1: (NSString *)theText
{
	[zeile1 setText: theText];
	//zeile1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
	
}
-(void) setText2: (NSString *)theText
{
	[zeile2 setText: theText];
		//zeile2.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
}


@end
