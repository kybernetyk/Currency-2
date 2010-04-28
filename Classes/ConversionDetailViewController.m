//
//  ConversionDetailViewController.m
//  Currency2
//
//  Created by jrk on 14/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "ConversionDetailViewController.h"
#import "JSDataCore.h"

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
	
	[chartImageView setOpaque: NO];
	[chartImageView setBackgroundColor: [UIColor clearColor]];
	[chartImageView setAlpha: 1.0f];
	[chartImageView setScalesPageToFit: YES];
//	[chartImageView setDetectsPhoneNumbers: NO];
	[chartImageView setDataDetectorTypes: UIDataDetectorTypeNone];
	[chartImageView setDelegate: self];
	[activityIndicator startAnimating];
	
//	[self getLastCachedImage];
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

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear: animated];
	
	[self loadChart];
}

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
	NSLog(@"detail view bai!");
	
	[self setConversion: nil];
    [super dealloc];
}

#pragma mark -
#pragma mark chart loading

- (NSString *) getLastCachedImage
{
	NSString *cacheDirectory = [[JSDataCore sharedInstance] applicationCachesDirectory];
	
	NSError *err;
	NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: cacheDirectory error: &err];
	if (!contents)
	{
		NSLog(@"no contents. error: %@",[err localizedDescription]);
		return nil;
	}
	
	NSString *searchString = [NSString stringWithFormat: @"%@_%@",[conversion fromCurrency],[conversion toCurrency]];
	NSPredicate *filter = [NSPredicate predicateWithFormat: @"SELF contains 'png' AND SELF contains %@",searchString];
	NSArray *filteredContents = [contents filteredArrayUsingPredicate: filter];
	
	NSString *filename = [filteredContents lastObject];
	if (!filename)
		return nil;
	
	filename = [NSString stringWithFormat:@"%@/%@",cacheDirectory,filename];

	if ([[NSFileManager defaultManager] fileExistsAtPath: filename])
		return filename;

	return nil;
}

/*
- (NSString *) getLastCachedImageWithinTimeInterval: (NSTimeInterval) intvl
{
	NSTimeInterval secondsPerDay = 24 * 60 * 60;
	NSDate *today = [NSDate dateWithTimeIntervalSinceNow:-intvl];
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat: @"_d_M_Y"];
	
	NSString *filename = [NSString stringWithFormat:@"%@_%@%@",[conversion fromCurrency],[conversion toCurrency],[formatter stringFromDate: today]];
	
	NSString *cacheDirectory = [[JSDataCore sharedInstance] applicationCachesDirectory];
	
	filename = [NSString stringWithFormat:@"%@/%@.png",cacheDirectory,filename];
	
	//NSLog(@"trying %@",filename);
	
	//[formatter release];
	if ([[NSFileManager defaultManager] fileExistsAtPath: filename])
		return filename;
	else
	{	
		intvl += secondsPerDay;
		
		if (intvl > 24*60*60*5)
			return [NSString string];
		
		[self getLastCachedImageWithinTimeInterval: intvl];
		
		//return getLastCachedImageFilenameForObject(objectToShowHistory,intvl);

		
	}
	
	return nil;
}*/

- (void) loadChart
{
	//1. check if an image was already downloaded today -> if so show it
	//2. if we're offline check if there are cached versions of the image -> if so show the most recent one
	//3. if there's no cached image and we're online DL the chart from yahoo
	
	
	
	// #1 - image for today already found?
	NSDate	*today = [NSDate date];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat: @"_d_M_Y"];	
	
	NSString *filename = [NSString stringWithFormat:@"%@_%@%@",[conversion fromCurrency],[conversion toCurrency],[formatter stringFromDate: today]];
	NSString *cacheDirectory = [[JSDataCore sharedInstance] applicationCachesDirectory];
	filename = [NSString stringWithFormat:@"%@/%@.png",cacheDirectory,filename];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath: filename])
	{
		NSString *s = [NSString stringWithFormat:@"<html><head></head><body style='background-color: transparent; color: white;'><p><center><img src='%@' width=94%%></center></body></html>",filename];
		[chartImageView loadHTMLString:s baseURL: [NSURL URLWithString: @"file:///"]];
		return;
	}
	

	//offline cache search
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];	
	BOOL offlineMode = [[defs objectForKey: @"offlineMode"] boolValue];
	BOOL isOnline = [[[UIApplication sharedApplication] delegate] isOnline];
	if (!isOnline || offlineMode) //offline cache search
	{	
			NSLog(@"not reachable. let's get cache");
		
		//NSString *filename = getLastCachedImageFilenameForObject(objectToShowHistory, 0);
		NSString *filename = [self getLastCachedImage];
		//	NSLog(@"cache file: %@",filename);
		if (filename && ![filename isEqualToString:[NSString string]])
		{	
			NSString *s = [NSString stringWithFormat:@"<html><head></head><body style='background-color: transparent; color: black;'><p><center><img src='%@' width=94%%></center></body></html>",filename];
			[chartImageView loadHTMLString:s baseURL: [NSURL URLWithString: @"file:///"]];
			return;
		}
		else
		{	
			NSString *s = [NSString stringWithFormat:@"<html><head></head><body style='background-color: transparent; color: black;'><p><center><h2>You're offline!<p>There was also<p> no cached chart found!<p> Please connect<p>to the internet!</h2></center></body></html>"];
			[chartImageView loadHTMLString:s baseURL: [NSURL URLWithString: @"file:///"]];
			
			NSLog(@"############## fuckup ########");
			
			return;
		}
		
		return;
	}
	else //DL chart from yahoo
	{
		UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ichart.finance.yahoo.com/3m?%@%@=x",[conversion fromCurrency],[conversion toCurrency]]]]];
		NSData *d = UIImagePNGRepresentation(img);
		
		NSDate *today = [NSDate date];
		NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
		[formatter setDateFormat: @"_d_M_Y"];
		filename = [NSString stringWithFormat:@"%@_%@%@",[conversion fromCurrency],[conversion toCurrency],[formatter stringFromDate: today]];
		filename = [NSString stringWithFormat:@"%@/%@.png",cacheDirectory,filename];
		
		//NSLog(@"saving as %@",filename);
		[d writeToFile:filename atomically: NO];
	}
	

	
	NSString *s = [NSString stringWithFormat:@"<html><head></head><body style='background-color: transparent; color: black;'><p><center><img src='%@' width=94%%></center></body></html>",filename];
	[chartImageView loadHTMLString:s baseURL: [NSURL URLWithString: @"file:///"]];
	
}

#pragma mark -
#pragma mark webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	//[activityIndicator setHidden: YES];
	[activityIndicator stopAnimating];
}

/*- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	[activityIndicator setHidden: NO];
	return YES;
}*/


@end
