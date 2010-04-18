//
//  JSManagedCurrencyList.h
//  Currency2
//
//  Created by jrk on 14/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSManagedCurrency.h"
#import "JSDataCore.h"

@interface JSCurrencyList : NSObject 
{
	BOOL isUpdating;
	NSMutableData *tempUpdateData;
}
+(JSCurrencyList *) sharedCurrencyList;

//factory func for a NSFetchedController with a list of all available currencies
+ (NSFetchedResultsController *) currencyListController;

- (void) updateAvailableCurrencyList;
- (void) createDummyDataSet;


@end
