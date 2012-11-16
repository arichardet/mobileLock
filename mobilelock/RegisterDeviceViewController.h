//
//  RegisterDeviceViewController.h
//  mobilelock
//
//  Created by Allison Steinman on 10/30/12.
//  Copyright (c) 2012 Allison Steinman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterDeviceViewController : UIViewController
{
    NSMutableData *receivedData;
    NSURLConnection *urlConnectionRegister;
    NSURLConnection *urlConnectionStatus;
    NSDictionary *responseDict;
}

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *buttonRegisterDevice;


- (IBAction)registerDeviceButtonPressed:(id)sender;
- (IBAction)didEndEditingField:(id)sender;


@end
