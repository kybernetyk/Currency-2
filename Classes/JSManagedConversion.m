//
//  JSManagedCurrency.m
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "JSManagedConversion.h"


@implementation JSManagedConversion
@synthesize isUpdating;

@dynamic fromCurrency;
@dynamic toCurrency;
@dynamic conversionRatio;
@dynamic timeStamp;
@dynamic lastUpdated;
@dynamic sortOrder;
@dynamic fC,tC;

- (void) remoteUpdate
{
	if (isUpdating)
	{
		NSLog(@"updating already! exit!");
		return;
	}

	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];	
	BOOL offlineMode = [[defs objectForKey: @"offlineMode"] boolValue];
	
	if (offlineMode)
	{
		//call our setter so the KVO fetchedResultsController sends a message that
		//the contents "changed". this will cause our main table to reload and to stop drawing the
		//activity indicators.
		[self setConversionRatio: [self conversionRatio]];
		
		NSLog(@"offline mode active. won't update conversion");
		return;
	}
	
	BOOL isOnline = [[[UIApplication sharedApplication] delegate] isOnline];
	if (!isOnline)
	{
		//see above in offlineMode - we trigger here
		[self setConversionRatio: [self conversionRatio]];
		NSLog(@"not connected to net. won't update conversion");
		return;
	}
	
	isUpdating = YES;

	tempUpdateData = [[NSMutableData alloc] initWithLength: 0];

	int delay = rand()%5+5;
	int astarts = [[NSUserDefaults standardUserDefaults] integerForKey: @"appStarts"];
	
	if (astarts < 20)
		delay = 0;
	
	NSLog(@"app starts: %i",astarts);
	
	[self performSelector: @selector(kickInUpdate:) withObject: self afterDelay: (float) delay];
	NSLog(@"will perform update in %i secs!", delay);
}

- (void) kickInUpdate: (id) someArgument
{
	NSLog(@"ok! kick update!");
	
	NSString *url = [NSString stringWithFormat:@"http://download.finance.yahoo.com/d/quotes.csv?s=%@%@=X&f=l1",[self fromCurrency],[self toCurrency]];
	NSURLRequest *req = [NSURLRequest requestWithURL: [NSURL URLWithString: url]];
	
	[NSURLConnection connectionWithRequest: req delegate: self];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	isUpdating = NO;
//	NSLog(@"connection did fail ...");
	
	//call our setter so the KVO fetchedResultsController sends a message that
	//the contents "changed". this will cause our main table to reload and to stop drawing the
	//activity indicators.
	[self setConversionRatio: [self conversionRatio]];
	
	[tempUpdateData release];
	tempUpdateData = nil;
	

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//	NSLog(@"connection did receive data ...");
	[tempUpdateData appendData: data];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
	isUpdating = NO;
	NSLog(@"connection did finish!");
	
	NSString *str =  [[NSString alloc] initWithData: tempUpdateData encoding: NSUTF8StringEncoding];

#error HIER BEFICKEN
	
	[self setConversionRatio: [NSDecimalNumber decimalNumberWithString: str]];
	[self setLastUpdated: [NSDate date]];
	[str release];

//	NSLog(@"%@ conv ratio: %@",self, [self conversionRatio]);
	
	[tempUpdateData release];
	tempUpdateData = nil;
}



@end
