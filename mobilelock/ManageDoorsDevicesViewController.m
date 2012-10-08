//
//  ManageDoorsDevicesViewController.m
//  mobilelock
//
//  Created by Allison Steinman on 9/2/12.
//  Copyright (c) 2012 Allison Steinman. All rights reserved.
//

#import "ManageDoorsDevicesViewController.h"

@interface ManageDoorsDevicesViewController ()

@end

@implementation ManageDoorsDevicesViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"Manage Doors & Devices";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
