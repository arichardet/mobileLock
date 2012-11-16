//
//  DoorViewController.h
//  mobilelock
//
//  Created by Allison Steinman on 9/16/12.
//  Copyright (c) 2012 Allison Steinman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Door.h"

@interface DoorViewController : UIViewController <NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    Door *door;
    NSURLConnection *urlConnectionUnlock;
    NSURLConnection *urlConnectionStatus;
    NSMutableData *statusReceivedData;
    NSMutableData *unlockReceivedData;
    NSDictionary *responseDict;
}

@property (nonatomic,retain) Door *door;
@property (weak, nonatomic) IBOutlet UILabel *doorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *doorStreetNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *doorStreetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *doorCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *doorStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *doorZipLabel;

@property (weak, nonatomic) IBOutlet UILabel *doorUnlockStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonDoorUnlock;
- (IBAction)doorUnlockButtonPressed:(id)sender;



@end
