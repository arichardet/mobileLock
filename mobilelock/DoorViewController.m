//
//  DoorViewController.m
//  mobilelock
//
//  Created by Allison Steinman on 9/16/12.
//  Copyright (c) 2012 Allison Steinman. All rights reserved.
//

#import "DoorViewController.h"

@interface DoorViewController ()

@end

@implementation DoorViewController

@synthesize door;
@synthesize doorNameLabel;
@synthesize doorStreetNumberLabel;
@synthesize doorStreetNameLabel;
@synthesize doorCityLabel;
@synthesize doorStateLabel;
@synthesize doorZipLabel;
@synthesize buttonDoorUnlock;
@synthesize doorUnlockStatusLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

#pragma mark -
#pragma mark View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.doorNameLabel.text = door.name;
    self.doorStreetNumberLabel.text = door.streetNumber;
    self.doorStreetNameLabel.text = door.streetName;
    self.doorCityLabel.text = door.city;
    self.doorStateLabel.text = door.state;
    self.doorZipLabel.text = door.zip;
    
    self.buttonDoorUnlock.enabled = NO;
    [self.buttonDoorUnlock setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.doorUnlockStatusLabel.text = @"Connection Not Made";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [defaults objectForKey:@"deviceToken"];
    NSLog(@"My token is: %@", deviceToken);
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@"-" withString:@""];

    NSString *urlStr = [NSString stringWithFormat:@"http://servo.local:8000/dooraccess/status/%d/%@",self.door.id, deviceToken];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    NSLog(@"%@",urlStr);
    // create the connection with the request
    // and start loading the data
    urlConnectionStatus = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if(urlConnectionStatus) {
        // Create the NSMutableData that will hold
        // the received data
        statusReceivedData = [NSMutableData data];
    }
    else {
        // inform the user the connection could not be made
        self.doorUnlockStatusLabel.text = @"Server Offline";
    }
}

- (void)viewDidUnload
{
    [self setDoorNameLabel:nil];
    [self setDoorStreetNumberLabel:nil];
    [self setDoorStreetNameLabel:nil];
    [self setDoorCityLabel:nil];
    [self setDoorStateLabel:nil];
    [self setDoorZipLabel:nil];
    [self setDoorUnlockStatusLabel:nil];
    [self setButtonDoorUnlock:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark IBAction
- (IBAction)doorUnlockButtonPressed:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [defaults objectForKey:@"deviceToken"];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://servo.local:8000/dooraccess/unlock/%d/%@",self.door.id, deviceToken];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    // create the connection with the request
    // and start loading the data
    urlConnectionUnlock = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if(urlConnectionUnlock) {
        // Create the NSMutableData that will hold
        // the received data
        unlockReceivedData = [NSMutableData data];
        //self.doorUnlockStatusLabel.text = @"Unlock Request Sent....";
    }
    else {
        // inform the user the connection could not be made
        //self.doorUnlockStatusLabel.text = @"Unlock Not Sent.....";
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == urlConnectionUnlock) {
        [unlockReceivedData appendData:data];
    }
    else if(connection == urlConnectionStatus) {
        [statusReceivedData appendData:data];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == urlConnectionUnlock)
    {
        NSError *error;
        responseDict = [NSJSONSerialization JSONObjectWithData:unlockReceivedData options:NSJSONWritingPrettyPrinted error:&error];
        
        if (error) {
            self.doorUnlockStatusLabel.text = @"Server Failure";
        }
        else {
            self.buttonDoorUnlock.enabled = YES;
            [self.buttonDoorUnlock setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
            self.doorUnlockStatusLabel.text = @"Unlock Request Sent";
        }
        
        NSString *str = [responseDict objectForKey:@"result"];
        
        if ([str isEqualToString:@"error"]) {
            UIAlertView *errorAlert;
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Door not Unlocked" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
        
    }
    else if(connection == urlConnectionStatus)
    {
        NSString *s = [[NSString alloc] initWithData:statusReceivedData encoding:NSASCIIStringEncoding];
        NSLog(@"Received Data:%@",s);
        NSError *error;
        responseDict = [NSJSONSerialization JSONObjectWithData:statusReceivedData options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"Response: %@",[responseDict description]);
        
        if (error) {
            self.doorUnlockStatusLabel.text = @"Server Failure";
            self.buttonDoorUnlock.enabled = NO;
            [self.buttonDoorUnlock setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        }
        else {
            self.buttonDoorUnlock.enabled = YES;
            [self.buttonDoorUnlock setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
            self.doorUnlockStatusLabel.text = @"";
        }
        
        NSString *str = [responseDict objectForKey:@"result"];
        
        if ([str isEqualToString:@"error"]) {
            UIAlertView *errorAlert;
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Arduino Offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
    }
}

@end
