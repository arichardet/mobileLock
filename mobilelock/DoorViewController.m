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
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.doorNameLabel.text = door.name;
    self.doorStreetNumberLabel.text = door.streetNumber;
    self.doorStreetNameLabel.text = door.streetName;
    self.doorCityLabel.text = door.city;
    self.doorStateLabel.text = door.state;
    self.doorZipLabel.text = door.zip;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://localhost:8000/dooraccess/status/%d",self.door.id];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSLog(@"%@",urlStr);
    // create the connection with the request
    // and start loading the data
    urlConnectionStatus = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if(urlConnectionStatus) {
        // Create the NSMutableData that will hold
        // the received data
        receivedData = [NSMutableData data];
        
        
    }
    else {
        // inform the user the connection could not be made
        self.doorUnlockStatusLabel.text = @"Connection not Made";
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
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doorUnlockButtonPressed:(id)sender {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://localhost:8000/dooraccess/unlock/%d",self.door.id];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSLog(@"%@",urlStr);
    // create the connection with the request
    // and start loading the data
    urlConnectionUnlock = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if(urlConnectionUnlock) {
        // Create the NSMutableData that will hold
        // the received data
        receivedData = [NSMutableData data];
    }
    else {
        // inform the user the connection could not be made
        self.doorUnlockStatusLabel.text = @"Connection not Made";
    }
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == urlConnectionUnlock)
    {
        NSLog(@"Received Data");
        NSError *error;
        responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"Response: %@",[responseDict description]);
        
        if (error) {
            self.doorUnlockStatusLabel.text = @"Server Failure";
        }
        
        NSString *str = [responseDict objectForKey:@"result"];
        
        if ([str isEqualToString:@"error"]) {
            UIAlertView *errorAlert;
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Door not Unlocked" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
        
    }
    else    //connection == urlConnectionStatus
    {
        NSLog(@"Received Data");
        NSError *error;
        responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"Response: %@",[responseDict description]);
        
        if (error) {
            self.doorUnlockStatusLabel.text = @"Arduino Offline";
            self.buttonDoorUnlock.enabled = NO;
        }
        
        NSString *str = [responseDict objectForKey:@"result"];
        
        if ([str isEqualToString:@"error"]) {
            UIAlertView *errorAlert;
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Door not Unlocked" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }

    }
}

@end
