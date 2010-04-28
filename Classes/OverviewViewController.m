//
//  OverviewViewController.m
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "OverviewViewController.h"
#import "NSString+Additions.h"
#import "AtomTableViewCell.h"
#import "JSManagedConversion.h"
#import "JSDataCore.h"
#import "ConversionDetailViewController.h"
#import "EditListViewController.h"

@implementation OverviewViewController
@synthesize fetchedResultsController;
@synthesize tableView;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark actions
- (void) updateTableView: (id) sender
{
	[[self tableView] reloadData];
}

- (IBAction) bookmarkPressed: (id) sender
{
	NSInteger index = [sender selectedSegmentIndex];
	NSString *theTitle = [sender titleForSegmentAtIndex: index];
	
	//NSLog(@"%@",theTitle) ;
	[editField setText: theTitle];

	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	
	if ([[editField text] length] <= 0)
	{
		NSNumber *num = [defs objectForKey: @"defaultUserInput"];
		[editField setText: [NSString stringWithFormat: @"%@",num]];
	}
	
	[self updateTableView: self];
	
	NSNumber *num = [NSNumber numberWithDouble: [[editField text] doubleValue]];
	[defs setObject: num forKey: @"lastUserInput"];

}

- (void) updateRates
{
	for (JSManagedConversion *conversion in [fetchedResultsController fetchedObjects])
	{
		[conversion remoteUpdate];
	}
	[[self tableView] reloadData];
}


#pragma mark -
#pragma mark view stuff
- (void) buildBookmarkBar
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];	
	
	//setup bookmark bar
	[bookmarkBar setTitle: [NSString stringWithFormat: @"%@", [defs objectForKey: @"bookmark0"]] forSegmentAtIndex: 0];
	[bookmarkBar setTitle: [NSString stringWithFormat: @"%@", [defs objectForKey: @"bookmark1"]] forSegmentAtIndex: 1];
	[bookmarkBar setTitle: [NSString stringWithFormat: @"%@", [defs objectForKey: @"bookmark2"]] forSegmentAtIndex: 2];
	[bookmarkBar setTitle: [NSString stringWithFormat: @"%@", [defs objectForKey: @"bookmark3"]] forSegmentAtIndex: 3];
	
}

- (void) showEditView: (id) sender
{
	NSLog(@"show edit view");
	EditListViewController *elvc = [[EditListViewController alloc] initWithNibName: @"EditListViewController" bundle: nil];
	[[self navigationController] pushViewController: elvc animated: YES];
	[elvc release];
	
//	[[self tableView] setEditing: YES animated: YES];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	// Set up the edit and add buttons.
	//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
	doneEditingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeypad:)];
	editListButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit target:self action:@selector(showEditView:)];
	//editListButton = [self editButtonItem];
	
	
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh target: self action: @selector(updateRates)];
	[[self navigationItem] setLeftBarButtonItem: refreshButton];
	[[self navigationItem] setRightBarButtonItem: editListButton];
	[refreshButton release];


	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];	
		
	//load last user input
	NSNumber *num = [defs objectForKey: @"lastUserInput"];
	[editField setText: [NSString stringWithFormat: @"%@", num]];


	[self buildBookmarkBar];
	
	[[self navigationItem] setTitleView: editField];
	
	
	NSLog(@"my retcount %i",[self retainCount]);
	
	
	
	
	//- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview
	//[[self view] addSubview: iv];
	
//	[[self view] insertSubview: iv belowSubview: [self tableView]];
//	[[self view] addSubview: iv];
	
//	NSLog(@"%@",[[self view] subviews]);

#ifdef CUSTOM_GRAPHICS
	[[self tableView] setBackgroundColor:  [UIColor clearColor]];
	backgroundView =  [[UIImageView alloc] initWithFrame: [[self view] frame]];
	[backgroundView setImage: [UIImage imageNamed: @"back.png"]];
#endif
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) 
	{
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRates) name: @"watchlistDidChange" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(defaultsDidChange:) name: NSUserDefaultsDidChangeNotification object:nil];
}


- (void) defaultsDidChange: (NSNotification *) aNotification
{
	NSLog(@"defaults changed biatch!");
	
	NSLog (@"%@",[aNotification object]);
	
	[self buildBookmarkBar];
	[self updateTableView: self];
	
}


- (void)viewWillAppear:(BOOL)animated 
{
//[[NSNotificationCenter defaultCenter] postNotificationName:@"watchlistDidChange" object: nil];
//	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(UIKeyboardWillHideNotification:) name:@"willHideKeyboard" object:nil];

	
	// Register to Recieve notifications of the Decimal Key Being Pressed and when it is pressed do the corresponding addDecimal action.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDecimal:) name:@"DecimalPressed" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
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

- (void)viewWillDisappear:(BOOL)animated 
{
	//[[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillShowNotification object:nil];
	//[[NSNotificationCenter defaultCenter] removeObserver: self name: @"willHideKeyboard" object:nil];	

	[[NSNotificationCenter defaultCenter] removeObserver: self name: @"DecimalPressed" object: nil];
	[[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillShowNotification object: nil];
	
	[super viewWillDisappear:animated];
}

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
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}

#ifndef CUSTOM_GRAPHICS	
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (![[[UIApplication sharedApplication] delegate] isOnline])
		return @"Your Watchlist [no network]";

	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];	
	BOOL offlineMode = [[defs objectForKey: @"offlineMode"] boolValue];
	if (offlineMode)
			return @"Your Watchlist [offline mode]";
	
	return @"Your Watchlist";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if ([[fetchedResultsController fetchedObjects] count] <= 0)
		return @"Last Update: Never";	
	
	JSManagedConversion *firstConversion = [[fetchedResultsController fetchedObjects] objectAtIndex: 0];
	
	if (firstConversion && [firstConversion lastUpdated])
	{
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		
		return [NSString stringWithFormat: @"Last Update: %@", [dateFormatter stringFromDate:  [firstConversion lastUpdated]]];
	}
	else
	{
		return @"Last Update: Never";
	}
	
	return @"Last Update: Never";
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

	AtomTableViewCell *cell = (AtomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
//	NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
	if (cell == nil) 
	{
		cell = (AtomTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"AtomCell" owner:self options: nil] objectAtIndex:0];
		
	//	UISwitch *mySwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
	//	[cell addSubview: mySwitch];
	//	[cell setAccessoryView: mySwitch];
	}
//	NSTimeInterval stop = [[NSDate date] timeIntervalSince1970];
//	NSLog(@"load: %f",stop - start);
	
	
    
	if ([[editField text] length] == 0 ||
		[[editField text] floatValue] == 0.0)
	{
		[cell setText1:@"Wrong input!"];
		[cell setText2:@"Conversion not possible."];	


		return cell;
	}
	
//	start = [[NSDate date] timeIntervalSince1970];
	JSManagedConversion *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
//	stop = [[NSDate date] timeIntervalSince1970];
//	NSLog(@"fetch: %f",stop - start);
	

	
	//float input = [[editField text] floatValue];
//	start = [[NSDate date] timeIntervalSince1970];
	NSDecimalNumber *input = [NSDecimalNumber decimalNumberWithString: [editField text]];
	NSDecimalNumber *conversionRatio = [managedObject conversionRatio]; 

	if ([conversionRatio isEqual: [NSDecimalNumber notANumber]] ||
		[conversionRatio isEqual: [NSDecimalNumber zero]])
	{
		[cell setText1:@"NaN or Zero!"];	
		[cell setText2:@"Conversion not possible."];	
		
		return cell;
	}

	NSDecimalNumber *output1 = [input decimalNumberByMultiplyingBy: conversionRatio];
	NSDecimalNumber *output2 = [input decimalNumberByDividingBy: conversionRatio];

//	stop = [[NSDate date] timeIntervalSince1970];
//	NSLog(@"decimal: %f",stop - start);

	NSString *fromCurrency =  [managedObject fromCurrency]; 
	NSString *toCurrency = [managedObject toCurrency]; 
	
	
	short theScale = 4;
	
	if ([[editField text] floatValue] >= 10.0f)
		theScale = 2;

//	start = [[NSDate date] timeIntervalSince1970];

	NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers
																							 scale: theScale
																				  raiseOnExactness:NO
																				   raiseOnOverflow:NO
																				  raiseOnUnderflow:NO
																			   raiseOnDivideByZero:NO];
	
	output1 = [output1 decimalNumberByRoundingAccordingToBehavior:handler];
	output2 = [output2 decimalNumberByRoundingAccordingToBehavior:handler];
	
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[formatter setMinimumFractionDigits: 2];
	[formatter setMaximumFractionDigits: 4];
	
	
	NSString *zeile1_text = [NSString stringWithFormat:@"%@ %@ = %@ %@", [formatter stringFromNumber: input], fromCurrency, [formatter stringFromNumber: output1], toCurrency];
	NSString *zeile2_text = [NSString stringWithFormat:@"%@ %@ = %@ %@", [formatter stringFromNumber: input], toCurrency, [formatter stringFromNumber: output2], fromCurrency];
	
	
	[cell setText1: zeile1_text];
	[cell setText2: zeile2_text];
	
	if ([managedObject isUpdating])
		[[cell activityIndicator] startAnimating];
	else
		[[cell activityIndicator] stopAnimating];
	
	[formatter release];
	
//	stop = [[NSDate date] timeIntervalSince1970];
//	NSLog(@"format: %f",stop - start);
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Navigation logic may go here -- for example, create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
	ConversionDetailViewController *cdvc = [[ConversionDetailViewController alloc] initWithNibName: @"ConversionDetailViewController" bundle: nil];
	JSManagedConversion *selectedConversion = [[self fetchedResultsController] objectAtIndexPath: indexPath];
	[cdvc setConversion: selectedConversion];
	[[self navigationController] pushViewController: cdvc animated: YES];
	[cdvc release];
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
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		// Save the context.
		NSError *error = nil;
		if (![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // The table view should not be re-orderable.
    return NO;
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
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Conversion" inManagedObjectContext:[dataCore managedObjectContext]];
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending: YES];
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
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
	NSLog(@"overview content changed!");
	
//	[self updateRates];
	// In the simplest, most efficient, case, reload the table view.
	[self.tableView reloadData];
}

/*
 Instead of using controllerDidChangeContent: to respond to all changes, you can implement all the delegate methods to update the table view in response to individual changes.  This may have performance implications if a large number of changes are made simultaneously.
 
 // Notifies the delegate that section and object changes are about to be processed and notifications will be sent. 
 - (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
 [self.tableView beginUpdates];
 }
 
 - (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
 // Update the table view appropriately.
 }
 
 - (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
 // Update the table view appropriately.
 }
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
 [self.tableView endUpdates];
 } 
 */
#pragma mark -
#pragma mark keyboard

- (void) hideKeypad: (id) sender
{
	[editField resignFirstResponder];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"willHideKeyboard" object: nil];
	
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];

	if ([[editField text] length] <= 0)
	{
		NSNumber *num = [defs objectForKey: @"defaultUserInput"];
		[editField setText: [NSString stringWithFormat: @"%@",num]];
	}

	NSNumber *num = [NSNumber numberWithDouble: [[editField text] doubleValue]];
	[defs setObject: num forKey: @"lastUserInput"];
}


// This function is called each time the keyboard is shown
- (void)keyboardWillShow:(NSNotification *)note 
{
	
	//NSLog(@"keyboard will show ...");
	
	// Just used to reference windows of our application while we iterate though them
	UIWindow* tempWindow;
	
	// Because we cant get access to the UIKeyboard throught the SDK we will just use UIView. 
	// UIKeyboard is a subclass of UIView anyways
	UIView* keyboard;
	
	// Check each window in our application
	for(int c = 0; c < [[[UIApplication sharedApplication] windows] count]; c ++)
	{
		// Get a reference of the current window
		tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
		
		// Loop through all views in the current window
		for(int i = 0; i < [tempWindow.subviews count]; i++)
		{
			// Get a reference to the current view
			keyboard = [tempWindow.subviews objectAtIndex:i];
			
			// From all the apps i have made, they keyboard view description always starts with <UIKeyboard so I did the following
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
			{
			//	NSLog(@"found keyboard: %@",[keyboard description]);
				
				// First test to see if the button has been created before.  If not, create the button.
				if (dotButton == nil) 
				{			
					dotButton = [UIButton buttonWithType:UIButtonTypeCustom];
				}
				
				// Position the button - I found these numbers align fine (0, 0 = top left of keyboard)
				dotButton.frame = CGRectMake(0, 163, 106, 53);
				
				// Add images to our button so that it looks just like a native UI Element.
				[dotButton setImage:[UIImage imageNamed:@"dotNormal.png"] forState:UIControlStateNormal];
				[dotButton setImage:[UIImage imageNamed:@"dotHighlighted.png"] forState:UIControlStateHighlighted];
				
				
				// Add the button to the keyboard
				[keyboard addSubview: dotButton];
				// Set the button to hidden. We will only unhide it when we need it.
				dotButton.hidden = YES;
				
				// When the decimal button is pressed, we send a message to ourself (the AppDelegate) which will then post a notification that will then append a decimal in the UITextField in the Appropriate View Controller.
				[dotButton addTarget:self action:@selector(sendDecimal:)  forControlEvents:UIControlEventTouchUpInside];
				
				return;
			}
		}
	}
}

- (void)sendDecimal:(id)sender 
{
	// Post a Notification that the Decimal Key was Pressed.
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DecimalPressed" object:nil];	
}




- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
//	NSLog(@"textFieldDidBeginEditing");
//	currentTextField = textField;
	
	
//	if (textField != unitsTextField)
		[dotButton setHidden: NO];
	
	//self.navigationItem.rightBarButtonItem = addButton;
	
	[[self navigationItem] setRightBarButtonItem: doneEditingButton];
	
	/*	// We need to access the dot Button declared in the Delegate.
	 ExampleAppDelegate *appDelegate = (ExampleAppDelegate *)[[UIApplication sharedApplication] delegate];
	 // Only if we are editing within the Number Pad Text Field do we want the dot.
	 if (numericTextField.editing) {
	 // Show the Dot.
	 appDelegate.dot.hidden = NO;
	 } else {
	 // Otherwise, Hide the Dot.
	 appDelegate.dot.hidden = YES;
	 }*/
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//	currentTextField = nil;
	[[self navigationItem] setRightBarButtonItem: editListButton];
	[dotButton setHidden: YES];
}

- (void)addDecimal:(NSNotification *)notification 
{
	//NSLog(@"add decimal!");
	
	
	if (![[editField text] containsString: @"."])
		[editField setText: [[editField text] stringByAppendingString: @"."]];
	
	// Apend the Decimal to the TextField.
	//	numericTextField.text = [numericTextField.text stringByAppendingString:@"."];
}



#pragma mark -
#pragma mark Memory management


- (void)dealloc 
{
	NSLog(@"overview controller wech");
	
#ifdef CUSTOM_GRAPHICS	
	[backgroundView release];
#endif
	
	[fetchedResultsController release];
    [super dealloc];
}



@end

