//
//  ConversionDetailViewController.m
//  Currency2
//
//  Created by jrk on 14/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "ConversionDetailViewController.h"


@implementation ConversionDetailViewController
@synthesize conversion;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[self setTitle: [NSString stringWithFormat: @"%@/%@",[conversion fromCurrency],[conversion toCurrency]] ];

	[super viewDidLoad];
}

/*- (void) setConversion:(JSManagedConversion *) newConversion
{
	NSLog(@"set conversion!");
	conversion = newConversion;
	
}*/

/*- (void)viewWillAppear:(BOOL)animated 
{
	NSLog(@"%@",[self conversion]);
    

	[super viewWillAppear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[self setConversion: nil];
    [super dealloc];
}


@end
