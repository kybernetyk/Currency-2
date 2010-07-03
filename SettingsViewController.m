//
//  SettingsViewController.m
//  Currency2
//
//  Created by jrk on 19/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void) offlineSwitchDidChange: (id) sender
{
	//NSLog(@"sender: %@",sender);
	BOOL offlineMode = [offlineModeSwitch isOn];
	NSNumber *om = [NSNumber numberWithBool: offlineMode];
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	[defs setObject: om forKey: @"offlineMode"];
}

- (void) iAdsSwitchDidChange: (id) sender
{
	BOOL iAdsEnabled = [iAdsSwitch isOn];
	NSNumber *ie = [NSNumber numberWithBool: iAdsEnabled];
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	[defs setObject: ie forKey: @"iAdsEnabled"];
	
}


- (void)viewDidLoad 
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	offlineModeSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	[offlineModeSwitch addTarget: self action: @selector(offlineSwitchDidChange:) forControlEvents: UIControlEventValueChanged];
	
	iAdsSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	[iAdsSwitch addTarget: self action: @selector(iAdsSwitchDidChange:) forControlEvents: UIControlEventValueChanged];
	
	
	
	bookmark0TextField = [[UITextField alloc] initWithFrame: CGRectMake(0, 0, 140, 31)];
	bookmark1TextField = [[UITextField alloc] initWithFrame: CGRectMake(0, 0, 140, 31)];
	bookmark2TextField = [[UITextField alloc] initWithFrame: CGRectMake(0, 0, 140, 31)];
	bookmark3TextField = [[UITextField alloc] initWithFrame: CGRectMake(0, 0, 140, 31)];
	
	NSArray *temp = [NSArray arrayWithObjects: bookmark0TextField, bookmark1TextField, bookmark2TextField, bookmark3TextField, nil];
	
	for (UITextField *bmt in temp)
	{
		[bmt setBorderStyle: UITextBorderStyleRoundedRect];
		[bmt setText: @"auto generated"];
		[bmt setClearsOnBeginEditing: NO];
		[bmt setClearButtonMode: UITextFieldViewModeAlways];
		[bmt setKeyboardType: UIKeyboardTypeNumbersAndPunctuation];
		[bmt setEnablesReturnKeyAutomatically: YES];
		[bmt setReturnKeyType: UIReturnKeyDone];
		
//		[bmt addTarget: self action: @selector(textFieldDidBeginEditing:) forControlEvents: UIControlEventEditingDidBegin];
//		[bmt addTarget: self action: @selector(textFieldDidEndEditing:) forControlEvents: UIControlEventEditingDidEnd];
		[bmt setDelegate: self];

	}

	
	doneEditingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeypad:)];
}



- (void)viewWillAppear:(BOOL)animated 
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSString *bookmark0 = [[defs objectForKey: @"bookmark0"] stringValue];
	NSString *bookmark1 = [[defs objectForKey: @"bookmark1"] stringValue];
	NSString *bookmark2 = [[defs objectForKey: @"bookmark2"] stringValue];
	NSString *bookmark3 = [[defs objectForKey: @"bookmark3"] stringValue];
	
	if (bookmark0)
		[bookmark0TextField setText: bookmark0];
	if (bookmark1)
		[bookmark1TextField setText: bookmark1];
	if (bookmark2)
		[bookmark2TextField setText: bookmark2];
	if (bookmark3)
		[bookmark3TextField setText: bookmark3];
	
	BOOL offlineMode = [[defs objectForKey: @"offlineMode"] boolValue];
	[offlineModeSwitch setOn: offlineMode];

	BOOL iAdsEnabled = [[defs objectForKey: @"iAdsEnabled"] boolValue];
	[iAdsSwitch setOn: iAdsEnabled];

	
	
	[super viewWillAppear:animated];

}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/


- (void)viewWillDisappear:(BOOL)animated 
{
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


#pragma mark Table view methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return NSLocalizedString(@"Forced Offline Mode",@"forced offline mode");
	
	if (section == 1)
		return NSLocalizedString(@"Quick Access Bookmarks","quick access bookmarks");

	if (section == 2)	
		return NSLocalizedString(@"iAds","iAds");
	return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if (section == 0)
		return NSLocalizedString(@"Forces Currency 2 to stay offline.",@"");
	if (section == 1)
		return NSLocalizedString(@"The green bar in the main view.",@"");
	if (section == 2)
		return NSLocalizedString(@"Enable or disable iAds.",@"");
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
		return 1;
	
	if (section == 1)
		return 5;

	if (section == 2)
		return 1;
	
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	//offline mode
    if ([indexPath section] == 0)
	{
		if ([indexPath row] == 0)
		{
			NSString *CellIdentifier = @"OfflineModeCell";
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];			

			if (cell == nil) 
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				 [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
				//	[cell addSubview: mySwitch];
				//[cell setAccessoryView: mySwitch];
				
				[cell setAccessoryView: offlineModeSwitch];
			}
			
			// Set up the cell...
			[[cell textLabel] setText: NSLocalizedString(@"Offline Mode",@"")];
			return cell;
		}
	}

	//bookmarks
	if ([indexPath section] == 1)
	{
		NSString *CellIdentifier = @"QuickKeyCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];			
		
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			 [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
		}
		
		// Set up the cell...
		switch ([indexPath row])
		{
			case 0:
				[cell setAccessoryView: bookmark0TextField];
				break;
			case 1:
				[cell setAccessoryView: bookmark1TextField];
				break;
			case 2:
				[cell setAccessoryView: bookmark2TextField];
				break;
			case 3:
				[cell setAccessoryView: bookmark3TextField];
				break;
			case 4:
				[cell setAccessoryView: nil];
				break;
			default:
				break;
		}
		
		
		if ([indexPath row] < 4)
		{	
			[[cell textLabel] setText: [NSString stringWithFormat: @"Bookmark %i",[indexPath row]+1] ];
			[cell setSelectionStyle: UITableViewCellSelectionStyleNone];
		}
		else
		{	
			[[cell textLabel] setText: NSLocalizedString(@"Restore Defaults",@"")];
			 [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
		}
		
		return cell;
		
	}
	
	
	//iAds
	if ([indexPath section] == 2)
	{
		if ([indexPath row] == 0)
		{
			NSString *CellIdentifier = @"iAdsCell";
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];			
			
			if (cell == nil) 
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				[cell setSelectionStyle: UITableViewCellSelectionStyleNone];
				//	[cell addSubview: mySwitch];
				//[cell setAccessoryView: mySwitch];
				
				[cell setAccessoryView: iAdsSwitch];
			}
			
			// Set up the cell...
			[[cell textLabel] setText: NSLocalizedString(@"Show iAds",@"")];
			return cell;
		}
	}
	
    
	NSString *CellIdentifier = @"GenericCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];			
	
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				 [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
		//UISwitch *mySwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
		//	[cell addSubview: mySwitch];
//		[cell setAccessoryView:  ];
	}
    
	[[cell textLabel] setText: @"Generic Cell"];  
    
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	if ([indexPath section] == 1 && [indexPath row] == 4)
	{
		NSLog(@"restore!");
		/*[NSNumber numberWithDouble: 1.0], @"bookmark0",
		[NSNumber numberWithDouble: 19.95], @"bookmark1",
		[NSNumber numberWithDouble: 49.95], @"bookmark2",
		[NSNumber numberWithDouble: 79.95], @"bookmark3",*/
		[bookmark0TextField setText: @"1"];
		[bookmark1TextField setText: @"19.95"];
		[bookmark2TextField setText: @"49.95"];		
		[bookmark3TextField setText: @"79.95"];
		
		[self saveBookmarks];
	}
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



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
- (void) saveBookmarks
{
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];	
	
	double dnum0 = [[bookmark0TextField text] doubleValue];
	double dnum1 = [[bookmark1TextField text] doubleValue];
	double dnum2 = [[bookmark2TextField text] doubleValue];
	double dnum3 = [[bookmark3TextField text] doubleValue];
	
	if (dnum0 > 0.0)
		[defs setObject: [NSNumber numberWithDouble: dnum0] forKey: @"bookmark0"];
	if (dnum1 > 0.0)
		[defs setObject: [NSNumber numberWithDouble: dnum1] forKey: @"bookmark1"];
	if (dnum2 > 0.0)
		[defs setObject: [NSNumber numberWithDouble: dnum2] forKey: @"bookmark2"];
	if (dnum3 > 0.0)
		[defs setObject: [NSNumber numberWithDouble: dnum3] forKey: @"bookmark3"];
	
	[defs synchronize];
	
	
}
#pragma mark -
#pragma mark keyboard

- (void) hideKeypad: (id) sender
{
	//[editField resignFirstResponder];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"willHideKeyboard" object: nil];
	
	[currentTextField resignFirstResponder];
	
	[self saveBookmarks];	
/*	
	NSNumber *num = [NSNumber numberWithDouble: [[editField text] doubleValue]];
	[defs setObject: num forKey: @"lastUserInput"];*/
}



- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
	NSLog(@"start editing!");
	
	//	NSLog(@"textFieldDidBeginEditing");
	currentTextField = textField;
	[[self navigationItem] setRightBarButtonItem: doneEditingButton];
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	NSLog(@"end editing!");
	currentTextField = nil;
	//	currentTextField = nil;
	[[self navigationItem] setRightBarButtonItem: nil];
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	
	if ([[textField text] length] <= 0)
	{
		NSNumber *num = [defs objectForKey: @"defaultUserInput"];
		[textField setText: [NSString stringWithFormat: @"%@",num]];
	}
	
}


- (BOOL) textFieldShouldReturn: (UITextField *)textField
{
	[self hideKeypad: self];
	return YES;
}


#pragma mark -
#pragma mark dealloc
- (void)dealloc 
{
	[offlineModeSwitch release], offlineModeSwitch = nil;
	[iAdsSwitch release], iAdsSwitch = nil;
    [super dealloc];
}


@end

