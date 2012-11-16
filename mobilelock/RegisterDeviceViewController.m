//
//  RegisterDeviceViewController.m
//  mobilelock
//
//  Created by Allison Steinman on 10/30/12.
//  Copyright (c) 2012 Allison Steinman. All rights reserved.
//

#import "RegisterDeviceViewController.h"

@interface RegisterDeviceViewController (PrivateMethods)
- (void)registerDevice;
- (void)registerForRemoteNotificationsWithDeviceToken:(NSString*)deviceToken;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
@end

@implementation RegisterDeviceViewController

@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize phoneNumberTextField;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setFirstNameTextField:nil];
    [self setLastNameTextField:nil];
    [self setPhoneNumberTextField:nil];
    [self setButtonRegisterDevice:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark IBAction
- (IBAction)registerDeviceButtonPressed:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"deviceToken"];
    
    // only register device & generate token if has not been done
    if (!str) {
        [self registerDevice];
    }

    return;
}

- (IBAction)didEndEditingField:(id)sender {
    UITextField *field;
    field = (UITextField*)sender;
    [field resignFirstResponder];
}

#pragma mark -
#pragma mark Private Methods
- (void)registerDevice {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    
    [self registerForRemoteNotificationsWithDeviceToken:(__bridge_transfer NSString *)(string)];
}

- (void)registerForRemoteNotificationsWithDeviceToken:(NSString*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://servo.local:8000/register/device/%@/%@/%@/%@",firstNameTextField.text, lastNameTextField.text, phoneNumberTextField.text, deviceToken];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    NSLog(@"%@",urlStr);
    // create the connection with the request
    // and start loading the data
    urlConnectionRegister = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (urlConnectionRegister) {
        receivedData = [NSMutableData data];
    }
    else {
        #warning TODO inform the user the connection could not be made
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceToken forKey:@"deviceToken"];
    [defaults synchronize];
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"There was an error registering for push notifications."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
    NSLog(@"%@",[error description]);
}

#pragma mark -
#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == urlConnectionRegister)
    {
        NSLog(@"Received Data");
        NSError *error;
        responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"Response: %@",[responseDict description]);
        
        if (error) {
            NSLog(@"Error: %@",[error description]);
        }
        
        NSString *str = [responseDict objectForKey:@"result"];
        
        if ([str isEqualToString:@"error"]) {
            UIAlertView *errorAlert;
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device not Registered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        } 
    } 
}

@end
