//
//  JSManagedCurrencyList.m
//  Currency2
//
//  Created by jrk on 14/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "JSCurrencyList.h"
#import "JSON.h"

@implementation JSCurrencyList
static JSCurrencyList *sharedSingleton = nil;



+(JSCurrencyList*) sharedCurrencyList 
{
    @synchronized(self) 
	{
        if (sharedSingleton == nil) 
		{
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedSingleton;
}


+(id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) 
	{
        if (sharedSingleton == nil) 
		{
            sharedSingleton = [super allocWithZone:zone];
            return sharedSingleton;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


-(void)dealloc 
{
    [super dealloc];
}

-(id)copyWithZone:(NSZone *)zone 
{
    return self;
}


-(id)retain 
{
    return self;
}


-(unsigned)retainCount 
{
    return UINT_MAX;  //denotes an object that cannot be release
}


-(void)release 
{
    //do nothing    
}


-(id)autorelease 
{
    return self;    
}


-(id)init 
{
    self = [super init];
    sharedSingleton = self;
	
	[self reset];
	
    return self;
}

- (void) reset
{
}

#pragma mark -
#pragma mark remote data fetch
+ (NSFetchedResultsController *) currencyListController
{
	JSDataCore *dataCore = [JSDataCore sharedInstance];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Currency" inManagedObjectContext: [dataCore managedObjectContext]];
	[fetchRequest setEntity:entity];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ISOCode" ascending: YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] 
															 initWithFetchRequest:fetchRequest 
															 managedObjectContext: [dataCore managedObjectContext] 
															 sectionNameKeyPath:nil 
															 cacheName:@"Root"];
	
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	
	return [aFetchedResultsController autorelease];
}





- (void) updateAvailableCurrencyList
{
	
	NSLog(@"updateAvailableCurrencyList");
	
	if (isUpdating)
	{
		NSLog(@"updating already! exit!");
		return;
	}

	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];	
	BOOL offlineMode = [[defs objectForKey: @"offlineMode"] boolValue];
	if (offlineMode)
	{
		NSLog(@"offline mode active. won't update currency list!");
		return;
	}

	BOOL isOnline = [[[UIApplication sharedApplication] delegate] isOnline];
	if (!isOnline)
	{
		[self setConversionRatio: [self conversionRatio]];
		NSLog(@"not connected to net. won't update currency list!");
		return;
	}
	
	isUpdating = YES;
	
	tempUpdateData = [[NSMutableData alloc] initWithLength: 0];
	
	//NSString *url = @"http://www.fluxforge.com/services/english_currency_list.txt";
	NSString *url = @"http://www.fluxforge.com/services/currency_list.json";
	
	NSURLRequest *req = [NSURLRequest requestWithURL: [NSURL URLWithString: url]];
	
	[NSURLConnection connectionWithRequest: req delegate: self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"connection did fail ...");
	[tempUpdateData release];
	tempUpdateData = nil;
	
	isUpdating = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog(@"connection did receive data ...");
	[tempUpdateData appendData: data];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
	NSLog(@"connection did finish!");
	NSString *theList =  [[NSString alloc] initWithData: tempUpdateData encoding: NSUTF8StringEncoding];
	
	NSLog(@"%@",theList);
	
	[self updateStoredListWithJSON: theList];

	
	[theList release];
	[tempUpdateData release];
	tempUpdateData = nil;
	isUpdating = NO;
}

- (void) updateStoredListWithJSON: (NSString *) jsonString
{
	NSLog(@"updateStoredListWithJSON");
	
	SBJSON *json = [[[SBJSON alloc] init] autorelease];
	
	NSArray *listArray = [json objectWithString: jsonString];
	if (!listArray)
		NSLog(@"%@",[json errorTrace]);
	
	//	NSLog(@"list array: %@", listArray);
	
	
	JSDataCore *dataCore = [JSDataCore sharedInstance];
	NSFetchedResultsController *currencyListController = [JSCurrencyList currencyListController];
	
	NSError *err;
	if (![currencyListController performFetch: &err])
	{
		NSLog(@"updateAvailableCurrencyList err: %@",[err localizedDescription]);
		abort();
	}
	NSLog(@"%@",[currencyListController fetchedObjects]);
	
	BOOL shouldAdd = YES;	
	for (NSDictionary *currentEntry in listArray)
	{
		shouldAdd = YES;		
		
		NSString *isoCode = [currentEntry objectForKey: @"ISOCode"];
		if (!isoCode)
			continue;
		
		for (JSManagedCurrency *curr in [currencyListController fetchedObjects])
		{
			if ([[curr ISOCode] isEqualToString: isoCode])
			{
				shouldAdd = NO;
			}
		}
		
		if (shouldAdd)
		{
			NSDictionary *localizations = [currentEntry objectForKey: @"localizedNames"];
			if (!localizations)
				continue;
			
			JSManagedCurrency *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Currency" inManagedObjectContext: [dataCore managedObjectContext]];
			
			[newManagedObject setISOCode: isoCode];
			
			NSDictionary *localizedNames = [NSDictionary dictionaryWithDictionary: localizations];
			[newManagedObject setLocalizedNames: localizedNames];
			
			NSLog(@"adding %@ / %@ ...",isoCode, localizedNames);
			
		}
	}
	
	// Save the context.
    NSError *error = nil;
    if (![[dataCore managedObjectContext] save:&error]) 
	{
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
	
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	
	[defs setObject: [NSDate date] forKey: @"lastListUpdate"];
	
	
	
}

//creates a dummy dataset (in case we have no network)
- (void) createDummyDataSet
{
	NSLog(@"creating dummy data set ...");
	
	NSString *json = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"currency_list" ofType: @"json"]];
	[self updateStoredListWithJSON: json];
}


@end
