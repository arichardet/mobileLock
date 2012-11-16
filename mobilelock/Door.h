//
//  Door.h
//  mobilelock
//
//  Created by Allison Steinman on 9/16/12.
//  Copyright (c) 2012 Allison Steinman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Door : NSObject
{
    int id;
    NSString *city;
    NSString *name;
    NSString *state;
    NSString *streetName;
    NSString *streetNumber;
    NSString *zip;
}

@property (nonatomic,assign) int id;
@property (nonatomic,retain) NSString *city;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *state;
@property (nonatomic,retain) NSString *streetName;
@property (nonatomic,retain) NSString *streetNumber;
@property (nonatomic,retain) NSString *zip;

- (id) initWithDictionary:(NSDictionary*)dict;

@end
