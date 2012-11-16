//
//  MyDoorsViewController.h
//  mobilelock
//
//  Created by Allison Steinman on 9/2/12.
//  Copyright (c) 2012 Allison Steinman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDoorsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSURLConnection *urlConnection;
    NSMutableData *receivedData;
    NSDictionary *doorsDict;
}
@property (weak, nonatomic) IBOutlet UITableView *doorsTableView;
@end
