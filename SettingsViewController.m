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


- (void)viewDidLoad 
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	offlineModeSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	[offlineModeSwitch addTarget: self action: @selector(offlineSwitchDidChange:) forControlEvents: UIControlEventValueChanged];
	
	
	
	
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

- (BOOL) textFieldShouldReturn: (UITextField *)textField
{
	[self hideKeypad: self];
	return YES;
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
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDecimal:) name:@"DecimalPressed" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

	
	[super viewWillAppear:animated];

}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/


- (void)viewWillDisappear:(BOOL)animated 
{
	[[NSNotificationCenter defaultCenter] removeObserver: self name: @"DecimalPressed" object: nil];
	[[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillShowNotification object: nil];

	[super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
	
	return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if (section == 0)
		return NSLocalizedString(@"Forces Currency 2 to stay offline.",@"");
	if (section == 1)
		return NSLocalizedString(@"The green bar in the main view.",@"");
	
	return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == 0)
		return 1;
	
	if (section == 1)
		return 5;
	
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
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


// This function is called each time the keyboard is shown
- (void)keyboardWillShow:(NSNotification *)note 
{
	
	NSLog(@"keyboard will show ...");
	
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
					NSLog(@"found keyboard: %@",[keyboard description]);
				
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
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DecimalPressed" object: sender];	
}




- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
	NSLog(@"start editing!");
	
	//	NSLog(@"textFieldDidBeginEditing");
	currentTextField = textField;
	
	
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
	NSLog(@"end editing!");
	currentTextField = nil;
	//	currentTextField = nil;
	[[self navigationItem] setRightBarButtonItem: nil];
	[dotButton setHidden: YES];
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	
	if ([[textField text] length] <= 0)
	{
		NSNumber *num = [defs objectForKey: @"defaultUserInput"];
		[textField setText: [NSString stringWithFormat: @"%@",num]];
	}
	
}

- (void)addDecimal:(NSNotification *)notification 
{
	NSLog(@"add decimal!");
	
	
	if (![[currentTextField text] containsString: @"."])
		[currentTextField setText: [[currentTextField text] stringByAppendingString: @"."]];
	
	// Apend the Decimal to the TextField.
	//	numericTextField.text = [numericTextField.text stringByAppendingString:@"."];
}



#pragma mark -
#pragma mark dealloc
- (void)dealloc {
    [super dealloc];
}


@end

