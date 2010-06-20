//
//  MyTabBarController.m
//  Currency2Lite
//
//  Created by jrk on 20/6/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "UITabBarController+rotationfix.h"


@implementation UITabBarController (rotationfix)
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	NSLog(@"psnis gross!");
	// Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
