//
//  AddCurrencyViewController.m
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "AddCurrencyViewController.h"
#import "JSCurrencyList.h"
#import "JSManagedConversion.h"
#import "JSManagedCurrency.h"
#import "JSDataCore.h"
#import "JSCurrencyList.h"

@implementation AddCurrencyViewController
@synthesize fetchedResultsController;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[[self navigationItem] setHidesBackButton: YES];

	
//	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle: @"Save" style: UIBarButtonItemStyleDone target: self action: @selector(confirmAction)];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target:self action: @selector(confirmAction)];

	[[self navigationItem] setRightBarButtonItem: saveButton];
	[saveButton release];

	
//	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle: @"Cancel" style: UIBarButtonItemStylePlain target: self action: @selector(cancelAction)];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancelAction)];

	[[self navigationItem] setLeftBarButtonItem: cancelButton];
	[cancelButton release];
	
	[self setFetchedResultsController: [JSCurrencyList currencyListController]];
	[[self fetchedResultsController] setDelegate: self];
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) 
	{
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	if ([[[self fetchedResultsController] fetchedObjects] count] <= 0)
	{
		[[JSCurrencyList sharedCurrencyList] createDummyDataSet];
	}
	
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	
/*	NSInteger leftRow = [[defs objectForKey: @"leftPickerState"] integerValue];
	NSInteger rightRow = [[defs objectForKey: @"rightPickerState"] integerValue];
	if (leftRow < 0)
		leftRow = 0;
	if (rightRow < 0)
		rightRow = 0;*/
	
	NSInteger leftRow = 0;
	NSInteger rightRow = 0;
	
	NSString *leftRowISO = [defs objectForKey: @"leftPickerState"];
	NSString *rightRowISO = [defs objectForKey: @"rightPickerState"];
	

	for (JSManagedCurrency *currency in [[self fetchedResultsController] fetchedObjects])
	{	
		if (leftRowISO && [[currency ISOCode] isEqualToString: leftRowISO])
			leftRow = [[[self fetchedResultsController] fetchedObjects] indexOfObject: currency];
	
		if (rightRowISO && [[currency ISOCode] isEqualToString: rightRowISO])
			rightRow = [[[self fetchedResultsController] fetchedObjects] indexOfObject: currency];
	
	}
	
	[picker selectRow: leftRow inComponent: 0 animated: NO];
	[picker selectRow: rightRow inComponent: 1 animated: NO];	
	
	//update our labels
	[self pickerView: picker didSelectRow: leftRow inComponent: 0];
	[self pickerView: picker didSelectRow: rightRow inComponent: 1];

	[self setTitle: NSLocalizedString(@"New Conversion",@"new conversion")];
	[infoLabel setText: [NSString stringWithFormat: NSLocalizedString(@"Currently %i currencies in list.\nLast list update: %@",@"whatever man"),[[[self fetchedResultsController] fetchedObjects] count], [defs objectForKey:@"lastListUpdate"] ]];
}

- (void)viewWillAppear:(BOOL)animated 
{
	
    [super viewDidAppear:animated];
}


- (void) cancelAction
{
	[[self navigationController] popViewControllerAnimated: YES];
	
	//[[JSCurrencyList sharedCurrencyList] updateAvailableCurrencyList];
}

- (NSNumber *) lastSortOrder
{
	JSDataCore *dataCore = [JSDataCore sharedInstance];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Conversion" inManagedObjectContext: [dataCore managedObjectContext]];
	[fetchRequest setEntity:entity];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending: YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] 
															 initWithFetchRequest:fetchRequest 
															 managedObjectContext: [dataCore managedObjectContext] 
															 sectionNameKeyPath:nil 
															 cacheName:@"Root"];
	NSError *err;
	[aFetchedResultsController performFetch: &err];
	NSNumber *ret = [[[aFetchedResultsController fetchedObjects] lastObject] sortOrder];
	
	//NSLog(@"%@",[aFetchedResultsController fetchedObjects]);
	
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	[aFetchedResultsController release];
	return ret;
	
//	return [aFetchedResultsController autorelease];
	
}

- (void) confirmAction
{
	JSDataCore *dataCore = [JSDataCore sharedInstance];	
	
	// Create a new instance of the entity managed by the fetched results controller.
//	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
//	NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];

	//NSManagedObject *fromCurrency = [[[RemoteDataStore sharedInstance] availableCurrencyList] objectAtIndex: [picker selectedRowInComponent: 0]];	
	//NSManagedObject *toCurrency = [[[RemoteDataStore sharedInstance] availableCurrencyList] objectAtIndex: [picker selectedRowInComponent: 1]];
	
/*	JSManagedCurrency *fromCurrency = [[[RemoteDataStore sharedInstance] availableCurrencyList] objectAtIndex: [picker selectedRowInComponent: 0]];	
	JSManagedCurrency *toCurrency = [[[RemoteDataStore sharedInstance] availableCurrencyList] objectAtIndex: [picker selectedRowInComponent: 1]];
*/
	
	
	JSManagedCurrency *fromCurrency = [[[self fetchedResultsController] fetchedObjects] objectAtIndex: [picker selectedRowInComponent: 0]];
	JSManagedCurrency *toCurrency = [[[self fetchedResultsController] fetchedObjects] objectAtIndex: [picker selectedRowInComponent: 1]];

	JSManagedConversion *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Conversion" inManagedObjectContext: [dataCore managedObjectContext]];
	
	// If appropriate, configure the new managed object.
//	[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
	
	NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString: @"1.0"];
	
	[newManagedObject setTimeStamp: [NSDate date]];
	[newManagedObject setFromCurrency: [fromCurrency ISOCode]];
	[newManagedObject setToCurrency: [toCurrency ISOCode]];
	[newManagedObject setConversionRatio: num];

	[newManagedObject setFC: fromCurrency];
	[newManagedObject setTC: toCurrency];
	
	//[newManagedObject setValue: fromCurrency forKey: @"fC"];
//	[newManagedObject setValue: toCurrency forKey: @"tC"];
	
	NSInteger lastOrder = [[self lastSortOrder] integerValue];
	lastOrder++;
	
	[newManagedObject setSortOrder: [NSNumber numberWithInteger: lastOrder] ];
	
	NSLog(@"last Order: %@",[self lastSortOrder]);
	
//	[newManagedObject setValue: [fromCurrency valueForKey: @"ISOCode"]  forKey: @"fromCurrency"];
//	[newManagedObject setValue: [toCurrency valueForKey: @"ISOCode"] forKey: @"toCurrency"];
//	[newManagedObject setValue:num forKey: @"conversionRatio"];
	
	
	// Save the context.
    NSError *error = nil;
    if (![[dataCore managedObjectContext] save:&error]) 
	{
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }

	//save picker view state
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];

//	NSNumber *save = [NSNumber numberWithInteger: [picker selectedRowInComponent: 0]];
//	NSNumber *save2 = [NSNumber numberWithInteger: [picker selectedRowInComponent: 1]];
	[defs setObject: [fromCurrency ISOCode] forKey: @"leftPickerState"];
	[defs setObject: [toCurrency ISOCode] forKey: @"rightPickerState"];
	[defs synchronize];
	
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"watchlistDidChange" object: nil];

	[[self navigationController] popViewControllerAnimated: YES];
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
	[self setFetchedResultsController: nil];
    [super dealloc];
}

#pragma mark -
#pragma mark Fetched results controller


// NSFetchedResultsControllerDelegate method to notify the delegate that all section and object changes have been processed. 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
	// In the simplest, most efficient, case, reload the table view.
	//[self.tableView reloadData];
	[picker reloadAllComponents];
	
	
	[picker selectRow: 0 inComponent: 0 animated: NO];
	[picker selectRow: 0 inComponent: 1 animated: NO];	
	
	//update our labels
	[self pickerView: picker didSelectRow: 0 inComponent: 0];
	[self pickerView: picker didSelectRow: 0 inComponent: 1];
	
}


#pragma mark -
#pragma mark picker view
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//	NSLog(@"numberOfRowsInComponent: %i",[[[RemoteDataStore sharedInstance] availableCurrencyList] count]);
	
//	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];

  //  return [sectionInfo numberOfObjects];
	
//	NSLog(@"%@",[[self fetchedResultsController] fetchedObjects]);
	
	return [[[self fetchedResultsController] fetchedObjects] count];
	
	//return [[[RemoteDataStore sharedInstance] availableCurrencyList] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{	
	//NSManagedObject *currency = [[[RemoteDataStore sharedInstance] availableCurrencyList] objectAtIndex: row];
	
	JSManagedCurrency *currency = [[[self fetchedResultsController] fetchedObjects] objectAtIndex: row ];
	
//	NSLog(@"titleFor: %@",[currency valueForKey: @"ISOCode"]);

	return [currency ISOCode];
//	return [currency valueForKey: @"ISOCode"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component == 0)
	{
		//NSManagedObject *fromCurrency = [[[RemoteDataStore sharedInstance] availableCurrencyList] objectAtIndex: row];	
//		[fromLabel setText: [fromCurrency valueForKey: @"longTextDescription"]];
		
//		NSLog(@"from: %@",fromCurrency);
		JSManagedCurrency *fromCurrency = [[[self fetchedResultsController] fetchedObjects] objectAtIndex: row ];
		[fromLabel setText: [fromCurrency localizedName]];
		
	}

	 if (component == 1)
	 {
		 JSManagedCurrency *toCurrency = [[[self fetchedResultsController] fetchedObjects] objectAtIndex: row ];
		 [toLabel setText: [toCurrency localizedName]];

	 }
			  
		
	
	
	/*	if (component == 0)
		[addViewLabel1 setText: [[currencyList objectAtIndex:row] currencyDescription]];
	else
		[addViewLabel2 setText: [[currencyList objectAtIndex:row] currencyDescription]];*/
}




@end
