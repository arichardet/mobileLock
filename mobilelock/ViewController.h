//
//  ViewController.h
//  mobilelock
//
//  Created by Allison Steinman on 8/31/12.
//  Copyright (c) 2012 Allison Steinman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSURLConnection *urlConnectionStatus;
    NSMutableData *receivedData;
    NSDictionary *responseDict;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonMyDoors;
@property (weak, nonatomic) IBOutlet UIButton *buttonChangePassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonRegisterDevice;
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceRegistrationStatus;

- (IBAction)buttonMyDoorsPressed:(id)sender;
- (IBAction)buttonChangePasswordPressed:(id)sender;
- (IBAction)buttonRegisterDevicePressed:(id)sender;


@end
