//
//  MyDoorsViewController.m
//  mobilelock
//
//  Created by Allison Steinman on 9/2/12.
//  Copyright (c) 2012 Allison Steinman. All rights reserved.
//

#import "MyDoorsViewController.h"
#import "DoorViewController.h"

@interface MyDoorsViewController ()

@end

@implementation MyDoorsViewController
@synthesize doorsTableView;

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
    
    self.title = @"My Doors";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [defaults objectForKey:@"deviceToken"];
    NSLog(@"My token is: %@", deviceToken);
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://servo.local:8000/device/doors/%@", deviceToken];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    // create the connection with the request
    // and start loading the data
    urlConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (urlConnection) {
        // Create the NSMutableData that will hold
        // the received data
        // receivedData is declared as a method instance elsewhere
        receivedData=[NSMutableData data];
    } else {
        #warning TODO inform the user that the download could not be made
    }
    
    self.doorsTableView.delegate = self;
    self.doorsTableView.dataSource = self;
}


- (void)viewDidUnload
{
    [self setDoorsTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITableView Delegates
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DoorCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString *key = [NSString stringWithFormat:@"%d",[indexPath row]];
    NSDictionary *dict = [doorsDict objectForKey:key];
        
    cell.textLabel.text = [dict objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"zip"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[doorsDict allKeys] count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Door *door = [[Door alloc] initWithDictionary:[doorsDict objectForKey:[NSString stringWithFormat:@"%d",[indexPath row]]]];
    
    DoorViewController *vc = [[DoorViewController alloc] initWithNibName:@"DoorView" bundle:nil];
    vc.door = door;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -
#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == urlConnection)
    {
        [receivedData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == urlConnection)
    {
        NSLog(@"Received Data");
        NSError *error;
        doorsDict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"Response: %@",[doorsDict description]);
        NSLog(@"%@",[error description]);
    }
    [self.doorsTableView reloadData];
}


@end
