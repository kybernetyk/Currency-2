//
//  JSManagedCurrency.h
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSManagedCurrency.h"

@interface JSManagedConversion : NSManagedObject 
{
	BOOL isUpdating;
	
	NSMutableData *tempUpdateData;
}

//	[newManagedObject setValue: [fromCurrency valueForKey: @"ISOCode"]  forKey: @"fromCurrency"];
//	[newManagedObject setValue: [toCurrency valueForKey: @"ISOCode"] forKey: @"toCurrency"];
//	[newManagedObject setValue:num forKey: @"conversionRatio"];


@property (retain) NSString *fromCurrency;
@property (retain) NSString *toCurrency;
@property (retain) NSDecimalNumber *conversionRatio;
@property (retain) NSDate *timeStamp;
@property (retain) NSDate *lastUpdated;
@property (retain) NSNumber *sortOrder;

@property (retain) JSManagedCurrency *fC;
@property (retain) JSManagedCurrency *tC;

@property (readonly) BOOL isUpdating;

- (void) remoteUpdate;

@end
