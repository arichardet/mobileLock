//
//  ViewController.m
//  mobilelock
//
//  Created by Allison Steinman on 8/31/12.
//  Copyright (c) 2012 Allison Steinman. All rights reserved.
//

#import "ViewController.h"
#import "MyDoorsViewController.h"
#import "RegisterDeviceViewController.h"

@interface ViewController (PrivateMethods)
-(void)checkIfDeviceApproved:(NSString*)deviceToken;
@end

@implementation ViewController

@synthesize buttonRegisterDevice,buttonChangePassword,buttonMyDoors;

#pragma mark -
#pragma mark View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.buttonRegisterDevice setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.buttonChangePassword setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.buttonMyDoors setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [defaults objectForKey:@"deviceToken"];
    NSLog(@"My token is: %@", deviceToken);
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (deviceToken == NULL) {
        // update registration status label
        [self.labelDeviceRegistrationStatus setHidden:NO];
        self.labelDeviceRegistrationStatus.text = @"Must Register Device";
        // disable MyDoors button
        [self.buttonMyDoors setEnabled:NO];
    } else {
        [self.labelDeviceRegistrationStatus setHidden:YES];
        [self.buttonRegisterDevice setEnabled:NO];
        [self checkIfDeviceApproved:deviceToken];
    }
}

- (void)viewDidUnload
{
    [self setButtonMyDoors:nil];
    [self setButtonChangePassword:nil];
    [self setButtonRegisterDevice:nil];
    [self setLabelDeviceRegistrationStatus:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark IBAction
- (IBAction)buttonMyDoorsPressed:(id)sender {
    MyDoorsViewController *vc = [[MyDoorsViewController alloc] initWithNibName:@"MyDoorsView" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buttonChangePasswordPressed:(id)sender {
}

- (IBAction)buttonRegisterDevicePressed:(id)sender {
    RegisterDeviceViewController *vc = [[RegisterDeviceViewController alloc] initWithNibName:@"RegisterDeviceViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark Private Methods
-(void)checkIfDeviceApproved:(NSString*)deviceToken {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://servo.local:8000/device/registrationStatus/%@", deviceToken];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    // create the connection with the request
    // and start loading the data
    urlConnectionStatus = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (urlConnectionStatus) {
        receivedData = [NSMutableData data];
        [self connection:urlConnectionStatus didReceiveData:receivedData];
    }
    else {
        // inform the user the connection could not be made
        self.labelDeviceRegistrationStatus.text = @"Connection Not Made";
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *error;
    responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSString *str = [responseDict objectForKey:@"status"];
    if ([str isEqualToString:@"1"]) {   // pending
        // update registration status label
        [self.labelDeviceRegistrationStatus setHidden:NO];
        self.labelDeviceRegistrationStatus.text = @"Device Registration Pending";
        // disable MyDoors button
        [self.buttonMyDoors setEnabled:NO];
                
    } else if ([str isEqualToString:@"0"]) {    // disabled
        // update registration status label
        [self.labelDeviceRegistrationStatus setHidden:NO];
        self.labelDeviceRegistrationStatus.text = @"Device Disabled";
        // disable MyDoors button
        [self.buttonMyDoors setEnabled:NO];
        
    } else if ([str isEqualToString:@"2"]) {    // enabled
        // update registration status label
        [self.labelDeviceRegistrationStatus setHidden:NO];
        self.labelDeviceRegistrationStatus.text = @"Device Enabled";
        // enable MyDoors button
        [self.buttonMyDoors setEnabled:YES];
    }
}
@end
