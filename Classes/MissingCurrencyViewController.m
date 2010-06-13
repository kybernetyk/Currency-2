//
//  MissingCurrencyViewController.m
//  Currency2
//
//  Created by jrk on 9/5/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "MissingCurrencyViewController.h"
#import <MessageUI/MessageUI.h>

@implementation MissingCurrencyViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	[textField resignFirstResponder];
	return YES;
}

- (IBAction) showCompositionView: (id) sender;
{
	if ([[currencyList text] length] <= 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString (@"No currency specified",@"") message: NSLocalizedString (@"Please enter at least one currency you would like to see in Currency 2",@"") delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		return;
	}
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self; 
	[picker setToRecipients: [NSArray arrayWithObject: @"support@fluxforge.com"]];
	[picker setSubject: NSLocalizedString (@"Currency 2 - Currency Suggestion",@"email subject")];
	
	// Fill out the email body text
	NSString *emailBody = [NSString stringWithFormat:@"%@ %@\n",NSLocalizedString(@"Hello Flux Forge!\n\nI'd like to see the following currencies added to Currency 2: ",@"email body"),[currencyList text] ];
	
	[picker setMessageBody: emailBody isHTML: NO]; // depends. Mostly YES, unless you want to send it as plain text (boring)
	
	picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
	
	
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
		{	
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString (@"Currency Suggestion",@"") 
															message:NSLocalizedString (@"The suggestion has been sent. We will add the missing currency ASAP and get back to you!",@"")
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
			break;
			
		}
		case MFMailComposeResultFailed:
			break;
			
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString (@"Email",@"")
															message:NSLocalizedString (@"Sending Failed - Unknown Error :-(",@"")
														   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
			
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[[self navigationController] popViewControllerAnimated: YES];
}
	


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
