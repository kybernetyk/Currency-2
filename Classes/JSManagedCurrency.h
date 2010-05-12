//
//  JSManagedCurrency.h
//  Currency2
//
//  Created by jrk on 12/4/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JSManagedCurrency : NSManagedObject
{

}

@property (retain) NSString *ISOCode;
@property (retain) NSDictionary *localizedNames;

- (NSString *) localizedName;

@end
