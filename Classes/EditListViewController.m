//
//  EditListViewController.m
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "EditListViewController.h"
#import "AddCurrencyViewController.h"
#import "JSDataCore.h"

@implementation EditListViewController
@synthesize fetchedResultsController;


#pragma mark -
#pragma mark Add a new object

- (void)insertNewObject 
{
	AddCurrencyViewController *acvc = [[AddCurrencyViewController alloc] initWithNibName: @"AddCurrencyViewController" bundle: nil];
	[[self navigationController] pushViewController: acvc animated: YES];
	[acvc autorelease];
	
	return;
	
}



/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

#pragma mark -
#pragma mark view stuff
- (void)viewDidLoad 
{
    [super viewDidLoad];

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle: @"Add" style: UIBarButtonItemStylePlain target: self action: @selector(insertNewObject)];
	[[self navigationItem] setRightBarButtonItem: addButton];
	[addButton release];
	
	
	
	[[self navigationItem] setLeftBarButtonItem: [self editButtonItem]];

	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) 
	{
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}

#ifdef CUSTOM_GRAPHICS	
	[[self view] setBackgroundColor:  [UIColor clearColor]];
	backgroundView =  [[UIImageView alloc] initWithFrame: [[self view] frame]];
	[backgroundView setImage: [UIImage imageNamed: @"back.png"]];
#endif
}



- (void)viewWillAppear:(BOOL)animated 
{
#ifdef CUSTOM_GRAPHICS
	[self.tableView.superview insertSubview: backgroundView belowSubview: self.tableView];
#endif
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController 
{
    if (fetchedResultsController != nil) 
	{
        return fetchedResultsController;
    }

   	JSDataCore *dataCore = [JSDataCore sharedInstance];
    
	/*
	 Set up the fetched results controller.
	 */
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Conversion" inManagedObjectContext: [dataCore managedObjectContext]];
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending: YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext: [dataCore managedObjectContext] sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}    


// NSFetchedResultsControllerDelegate method to notify the delegate that all section and object changes have been processed. 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// In the simplest, most efficient, case, reload the table view.
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return [[fetchedResultsController sections] count];
}

#ifndef CUSTOM_GRAPHICS	
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return @"You Current Watchlist";
	if (section == 1)
		return @"Add/Remove";
}
#endif

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"MyIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	 if (cell == nil) 
	 {
		 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

#ifdef CUSTOM_GRAPHICS
		 UIImageView *iv = [[UIImageView alloc] initWithFrame: CGRectNull];
		 [iv autorelease];
		 [iv setImage: [UIImage imageNamed: @"cell_1.png"]];
		 [cell setBackgroundColor: [UIColor clearColor]];
		 [cell setBackgroundView: iv];
#endif
	 }

    if ([indexPath section] == 0)
	{
		NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
	
		NSString *fromCurrency = [managedObject valueForKey: @"fromCurrency"];
		NSString *toCurrency = [managedObject valueForKey: @"toCurrency"];

		[[cell textLabel] setText: [NSString stringWithFormat: @"%@ <-> %@",fromCurrency,toCurrency]];
	}
	else
	{
		[[cell textLabel] setText: @"Add New Currency"];
	}
	

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here -- for example, create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        // Delete the managed object for the given index path
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		// Save the context.
		NSError *error = nil;
		if (![context save:&error]) 
		{
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"watchlistDidChange" object: nil];
	}   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}




- (void)dealloc 
{
#ifdef CUSTOM_GRAPHICS
	[backgroundView release];
#endif
    [super dealloc];
}


@end

