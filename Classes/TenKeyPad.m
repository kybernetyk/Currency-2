//
//  TenKeyPad.m
//  TenKeyPad
//


#import "TenKeyPad.h"
#import "NSString+Additions.h"

@implementation TenKeyPad
@synthesize delegate, returnValue, totalLabel;

- (id) initWithNumber: (NSNumber *)initNumber
{
	self = [super init];
	if (self)
		initValue = [initNumber doubleValue];
	return self;
}

// Update Label - do your formatting here
- (void) updateLabel
{
	// You may wish to format the NSMutableString here instead of updating whatever the string currently holds
	// IE: totalLabel.text = [
	totalLabel.text = returnValue;
}

// Append Method
- (void) appendValue: (NSString *) argString
{
	[returnValue appendString:argString];
	[self updateLabel];
}

// Back Button Pressed
- (IBAction) pressBack
{
	if (returnValue.length > 0)
	{
		NSRange lastByteRange = {returnValue.length-1,1};
		[returnValue deleteCharactersInRange:lastByteRange];
	}

	[self updateLabel];
}

// Button Implementations
- (IBAction) done
{
	// Send message to delegate class saying we're done here
	[self.delegate tenKeyPadDidFinish:self];
}

- (IBAction) pressDot
{
//	NSLog(@"%@", returnValue);
//	NSString *stringToCheck = [NSString stringWithFormat: @"%@", returnValue];
	
	if (![returnValue containsString: @"." ignoringCase: YES])
		[self appendValue:@"."];
}

- (IBAction) press1
{
	[self appendValue:@"1"];
}

- (IBAction) press2
{
	[self appendValue:@"2"];
}

- (IBAction) press3
{
	[self appendValue:@"3"];
}

- (IBAction) press4
{
	[self appendValue:@"4"];
}

- (IBAction) press5
{
	[self appendValue:@"5"];
}

- (IBAction) press6
{
	[self appendValue:@"6"];
}

- (IBAction) press7
{
	[self appendValue:@"7"];
}

- (IBAction) press8
{
	[self appendValue:@"8"];
}

- (IBAction) press9
{
	[self appendValue:@"9"];
}

- (IBAction) press0
{
	[self appendValue:@"0"];
}


// Standard Methods
- (void)viewDidLoad 
{
	returnValue = [[NSMutableString alloc] initWithFormat:@"%.2f", initValue];
	
	// Initial Value of returnValue which is blank
//	returnValue = [[NSMutableString alloc] initWithString:@""];
	[self updateLabel];
	[super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	
    [super viewDidUnload];
}


- (void)dealloc {
	[returnValue release];
    [super dealloc];
}


@end
