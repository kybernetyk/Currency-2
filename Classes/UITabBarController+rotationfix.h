//
//  MyTabBarController.h
//  Currency2Lite
//
//  Created by jrk on 20/6/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>

// hack for iAd orientation shit

@interface UITabBarController (rotationfix)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation ;
@end

