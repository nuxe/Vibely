//
//  TableViewController.h
//  BlogReader2
//
//  Created by Class Account on 3/30/13.
//  Copyright (c) 2013 Kush Agrawal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface TableViewController : UITableViewController

@property (nonatomic, strong) NSArray *blogPosts2;
@property (nonatomic, strong) NSArray *blogPosts3;

@property (nonatomic, strong) NSArray *googlePosts;
@property (nonatomic, strong) NSDictionary *final;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;



@end
