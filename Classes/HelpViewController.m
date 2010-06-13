//
//  HelpViewController.m
//  Currency2
//
//  Created by jrk on 23/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpDetailViewController.h"
#import "MissingCurrencyViewController.h"

@implementation HelpViewController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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


#pragma mark Table view methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return NSLocalizedString (@"Help Topics",@"help topics");
	
	if (section == 1)
		return NSLocalizedString (@"Missing Currency", @"");

	if (section == 2)
		return NSLocalizedString (@"Contact Flux Forge", @"");
	
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	/*if (section == 0)
		return @"Select the topic you want to know more about.";

	if (section == 1)
		return @"If you miss a currency, select this.";

	if (section == 2)
		return @"If you need to contact us.";
*/
	
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == 0)
		return 3;
	
	if (section == 1)
		return 1;
    
	if (section == 2)
		return 1;
	
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	[cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];

	if ([indexPath section] == 0 && [indexPath row] == 0)
		[[cell textLabel] setText: NSLocalizedString (@"How to manage the watchlist",@"")];

	if ([indexPath section] == 0 && [indexPath row] == 1)
		[[cell textLabel] setText: NSLocalizedString (@"Quick Access Bookmarks",@"")];

	if ([indexPath section] == 0 && [indexPath row] == 2)
		[[cell textLabel] setText: NSLocalizedString (@"Offline Mode",@"")];
    
    // Set up the cell...
	if ([indexPath section] == 1 && [indexPath row] == 0)
		[[cell textLabel] setText: NSLocalizedString (@"A currency is missing",@"")];
	
	if ([indexPath section] == 2 && [indexPath row] == 0)
		[[cell textLabel] setText: NSLocalizedString (@"Contact Developer",@"")];
	
	
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];

	if ([indexPath section] == 0 && [indexPath row] == 0)
	{
		HelpDetailViewController *hdvc = [[HelpDetailViewController alloc] initWithNibName: @"HelpDetailViewController" bundle: nil];
		[hdvc setTitle: NSLocalizedString (@"Managing the Watchlist", @"")];
		[hdvc setHelpText: NSLocalizedString (@"<center><h2>Managing the Watchlist</h2></center><p>To enter the managment mode of your watchlist press the 'Edit' button in the top right corner of the watchlist view.</p><p>To add a new item to your watchlist press the '+' button. In the following view choose the pair of currencies you'd like to watch.</p><p>To delete an item from your watchlist press the delete control on the item's left side and confirm with a press on the appearing 'Delete' button.</p><p>You can also change the order of the items in your watchlist. Just drag them around by touching the drag control on the item's right side.</p>",@"managing the watchlist help")];
		[[self navigationController] pushViewController: hdvc animated: YES];
		[hdvc release];
	}
	

	if ([indexPath section] == 0 && [indexPath row] == 1)
	{
		HelpDetailViewController *hdvc = [[HelpDetailViewController alloc] initWithNibName: @"HelpDetailViewController" bundle: nil];
		[hdvc setTitle: NSLocalizedString (@"Quick Access Bookmarks",@"")];
		[hdvc setHelpText: NSLocalizedString (@"<center><h2>Quick Access Bookmarks</h2></center><p>The quick access bookmarks are found in the green bar on top of the watchlist view. Those bookmarks offer you quick access to often used values.</p><center><img src='bookmarks.png'><br><i>Quick Access Bookmarks</i></center><p>You can change your bookmarks in the settings view.</p>",@"bookmarks help")];
		[[self navigationController] pushViewController: hdvc animated: YES];
		[hdvc release];
	}

	if ([indexPath section] == 0 && [indexPath row] == 2)
	{
		HelpDetailViewController *hdvc = [[HelpDetailViewController alloc] initWithNibName: @"HelpDetailViewController" bundle: nil];
		[hdvc setTitle: NSLocalizedString (@"Offline Mode",@"")];
		[hdvc setHelpText: NSLocalizedString (@"<center><h2>Offline Mode</h2></center><p>The offline mode forces Currency 2 to stay offline and don't update any exchange rates - even if there is a network connection available.</p><p>This setting is useful if you know that your network connection is really slow or if internet access is blocked. It also helps to save you on roaming fees when you are abroad.</p>",@"offline mode help")];
		[[self navigationController] pushViewController: hdvc animated: YES];
		[hdvc release];
		
	}

	if ([indexPath section] == 1 && [indexPath row] == 0)
	{
		MissingCurrencyViewController *mcvc = [[MissingCurrencyViewController alloc] initWithNibName: @"MissingCurrencyViewController" bundle:nil];
		
		[mcvc setTitle: NSLocalizedString (@"Suggest Currency",@"")];
		[[self navigationController] pushViewController: mcvc animated: YES];
		[mcvc release];
		
	}
	
	
	if ([indexPath section] == 2 && [indexPath row] == 0)
	{
		HelpDetailViewController *hdvc = [[HelpDetailViewController alloc] initWithNibName: @"HelpDetailViewController" bundle: nil];
		[hdvc setTitle: NSLocalizedString (@"Contact Us",@"")];
		[hdvc setHelpText: NSLocalizedString (@"<center><h2>Contact Us</h2></center><p>Should you experience any issues or problems with Currency 2 don't hesitate to <a href='mailto:support@fluxforge.com?Subject=Currency+2+Support'>send us a mail</a>!</p><p>We will be glad to hear your suggestions and feature requests to improve our apps!",@"contact us help")];
		[[self navigationController] pushViewController: hdvc animated: YES];
		[hdvc release];
		
	}
	
	
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc 
{
	
    [super dealloc];
}


@end

