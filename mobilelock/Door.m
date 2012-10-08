//
//  Door.m
//  mobilelock
//
//  Created by Allison Steinman on 9/16/12.
//  Copyright (c) 2012 Allison Steinman. All rights reserved.
//

#import "Door.h"

@implementation Door

@synthesize city;
@synthesize name;
@synthesize state;
@synthesize streetName;
@synthesize streetNumber;
@synthesize zip;
@synthesize id;

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setId:[[dict objectForKey:@"id"] intValue]];
        [self setCity:[dict objectForKey:@"city"]];
        [self setName:[dict objectForKey:@"name"]];
        [self setState:[dict objectForKey:@"state"]];
        [self setStreetName:[dict objectForKey:@"streetName"]];
        [self setStreetNumber:[NSString stringWithFormat:@"%@",[dict objectForKey:@"streetNumber"]]];
        [self setZip:[NSString stringWithFormat:@"%@",[dict objectForKey:@"zip"]]];
    }
    return self;
}


@end

