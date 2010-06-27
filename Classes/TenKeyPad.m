//
//  TenKeyPad.m
//  TenKeyPad
//


#import "TenKeyPad.h"
#import "NSString+Additions.h"

@implementation TenKeyPad
@synthesize delegate, returnValue, totalLabel, doneButton;

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
	//NSLog(@"lol: %@", [self doneButton]);
	
	if ([returnValue length] <= 0)
	{	
		[doneButton setEnabled: NO];
	//	[doneButton setHidden: YES];
	}
	else
	{
		[doneButton setEnabled: YES];
	//	[doneButton setHidden: NO];
	}
		
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

- (IBAction) clearField
{
	[returnValue setString: @""];
	[self updateLabel];
}

// Standard Methods
- (void)viewDidLoad 
{
	returnValue = [[NSMutableString alloc] initWithFormat:@"%f", initValue];

	NSString *bla = [NSString stringWithFormat: @"%f", initValue];
	if ([bla containsString: @"." ignoringCase: YES])
	{
		//let's count the nachkommastellen
		bla = [bla stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"0"]];
		const char *lolhack = [bla cStringUsingEncoding: NSUTF8StringEncoding];
		char *pstr = lolhack;
		while (1)
		{
			if (*pstr == 0 || *pstr++ == '.') //1. get *pstr / 2. compare it / increment pstr
				break;
		}
		int lolcount = strlen(pstr);
		
		NSString *format = [NSString stringWithFormat: @"%%.%if", lolcount];
		[returnValue release];
		returnValue = [[NSMutableString alloc] initWithFormat:format, initValue];
		
		//printf("\npstr: '%s' count: %i\n", pstr, lolcount);
	}
	// Initial Value of returnValue which is blank
//	returnValue = [[NSMutableString alloc] initWithString:@""];
	[self updateLabel];
	[super viewDidLoad];
	
//	[clearButton setOpaque: NO];	
//	[clearButton setBackgroundColor: [UIColor clearColor]];
//	[[clearButton imageView] setAlpha: 0.0f];
	

//	NSLog(@"done button: %@",clearButton);
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
