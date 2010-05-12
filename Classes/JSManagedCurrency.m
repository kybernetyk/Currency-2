//
//  JSManagedCurrency.m
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "JSManagedCurrency.h"


@implementation JSManagedCurrency
@dynamic ISOCode;
@dynamic localizedNames;

- (NSString *) localizedName
{
	NSString *loc = [[NSLocale preferredLanguages] objectAtIndex: 0];

	NSString *ret = [[self localizedNames] objectForKey: loc];

	NSLog(@"loc: %@ = %@", loc,ret);
	
	if (!ret)
	{	
		NSLog(@"no localized (%@) name for %@! fallback to en.",loc, [self ISOCode]);
		ret = [[self localizedNames] objectForKey: @"en"];
		
		if (!ret)
		{
			NSLog(@"there is not even EN locale for this currency! %@",[self ISOCode]);
			abort();
		}
	}
	

	return ret;
}

@end
