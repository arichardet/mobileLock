//
//  ViewController.m
//  mobilelock
//
//  Created by Allison Steinman on 8/31/12.
//  Copyright (c) 2012 Allison Steinman. All rights reserved.
//

#import "ViewController.h"
#import "MyDoorsViewController.h"
#import "ManageDoorsDevicesViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)buttonMyDoorsPressed:(id)sender {
    MyDoorsViewController *vc = [[MyDoorsViewController alloc] initWithNibName:@"MyDoorsView" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buttonManageDoorsDevicesPressed:(id)sender {
    ManageDoorsDevicesViewController *vc = [[ManageDoorsDevicesViewController alloc] initWithNibName:@"ManageDoorsDevicesView" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buttonChangePasswordPressed:(id)sender {
}
@end
