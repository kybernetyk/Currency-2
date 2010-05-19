//
//  listconverterAppDelegate.m
//  listconverter
//
//  Created by jrk on 19/5/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "listconverterAppDelegate.h"
#import "SBJSON.h"

@implementation listconverterAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
	// Insert code here to initialize your application 
	NSString *english_list = [NSString stringWithContentsOfURL: [NSURL URLWithString: @"http://www.fluxforge.com/services/english_currency_list.txt"]];
	NSString *german_list = [NSString stringWithContentsOfURL: [NSURL URLWithString: @"http://www.fluxforge.com/services/german_currency_list_utf8.txt"]];
	
	
	NSArray *english_array = [english_list componentsSeparatedByString: @","];
	NSArray *german_array = [german_list componentsSeparatedByString: @","];
	
	NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity: 32];
	
	int count = [english_array count];
	for (int i = 0; i < count; i+= 2)
	{
		NSString *code = [[english_array objectAtIndex: i] uppercaseString];
		NSString *description = [[english_array objectAtIndex: i+1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] ;

		NSMutableDictionary *localization = [NSMutableDictionary dictionaryWithCapacity: 2];
		[localization setObject: description forKey: @"en"];
		[localization setObject: @"$REPLACEME$" forKey: @"de"];
		 
		NSMutableDictionary *entry = [NSMutableDictionary dictionaryWithCapacity: 4];
		[entry setObject: code forKey: @"ISOCode"];
		[entry setObject: localization forKey: @"localizedNames"];
		
		[tempDict setObject: entry forKey: code];
	}
	
	count = [german_array count];
	for (int i = 0; i < count; i+= 2)
	{
		NSString *code = [[german_array objectAtIndex: i] uppercaseString];
		NSString *description = [[german_array objectAtIndex: i+1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] ;

		NSMutableDictionary *entry = [tempDict objectForKey: code];
		if (!entry)
			continue;
		NSMutableDictionary *localization = [entry objectForKey: @"localizedNames"];
		if (!localization)
			continue;
		
		[localization setObject: description forKey: @"de"];
		
	}

	NSArray *sortedKeys = [[tempDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
	NSMutableArray *outputArray = [NSMutableArray arrayWithCapacity: 255];
		
	for (id key in sortedKeys)
	{
		NSMutableDictionary *entry = [tempDict objectForKey: key];
		
		[outputArray addObject: entry];
	}
	
	
	NSLog(@"%@",[outputArray JSONRepresentation]);
	
	[[outputArray JSONRepresentation] writeToFile: @"currency_list.json" atomically: YES];
}

@end
