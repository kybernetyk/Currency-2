//
//  main.m
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright flux forge 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


int main(int argc, char *argv[]) 
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	srand(time(0));
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}

