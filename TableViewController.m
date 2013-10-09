//
//  TableViewController.m
//  BlogReader2
//
//  Created by Class Account on 3/30/13.
//  Copyright (c) 2013 Kush Agrawal. All rights reserved.
//

#import "TableViewController.h"
#import "BlogPost.h"
#import "DetailViewController.h"
#import <CoreLocation/CoreLocation.h>




@interface TableViewController ()
-(IBAction)refresh:(id)sender;


@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Location
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];
    
    
    
    self.latitude = [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
    
  //  NSLog(@"*dLatitude : %@", self.latitude);
   // NSLog(@"*dLongitude : %@",self.longitude);
 
    //Location
    
    BlogPost *blogPost = [[BlogPost alloc] init];
    
    blogPost.title = @"some title";
    blogPost.author = @"some author";
   
     [self getGoogleResults];
    [self getTwitterResults];
 //   int x = [[[self.final objectForKey:self.google  Posts[0]] objectForKey:@"name"] count];
    
    
    NSMutableDictionary *trial = [[NSMutableDictionary alloc] init];
    
    for (int i=0; i<self.googlePosts.count;i++){
        int dummy = [self getValues:[self.final objectForKey:[self.googlePosts[i] objectForKey:@"name"]]];
        id object = [self.final objectForKey:[self.googlePosts[i] objectForKey:@"name"]];
        
        if (object[dummy]!=NULL){
     [trial setObject:object[dummy]
              forKey:[self.googlePosts[i] objectForKey:@"name"]];
        }
    
        // NSLog(@"%f", [[trial objectForKey:[self.googlePosts[i] objectForKey:@"name"]] floatValue]);
 //      NSString *value = (NSString *)[[trial objectForKey:[self.googlePosts[i] objectForKey:@"name"]] objectForKey:@"text"];
  //      printf("%s \n", [value UTF8String]);
                }
    
    
    
    //printf("%s", [value UTF8String]);
    
    
    
    self.blogPosts2 = [trial allValues];
    
 //   self.blogPosts2 = trial;
    
    
    
    //[self.final objectForKey:[self.googlePosts[0] objectForKey:@"name"]];
    
    
    
    
    
    
       

    
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (!oldLocation ||
        (oldLocation.coordinate.latitude != newLocation.coordinate.latitude &&
         oldLocation.coordinate.longitude != newLocation.coordinate.longitude &&
         newLocation.horizontalAccuracy <= 100.0)) {
        }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}


-(NSInteger)getValues:(NSArray *)tweetArray{
    
    int sum[tweetArray.count];
    int values2[tweetArray.count][tweetArray.count];
    for (int i=0;i<tweetArray.count;i++){
        for (int j=0;j<tweetArray.count;j++){
            values2[i][j] = [self commonCount:[tweetArray[i] objectForKey:@"text"] andSecond:[tweetArray[j] objectForKey:@"text"]];
            
            if (i!=j){
                sum[i]+=values2[i][j];
                
            }
            
        }
        
    }
    int max = 0;
    int returnvalue;
    for (int i=0;i<tweetArray.count;i++){
        if (sum[i]>=max){
            max = sum[i];
            returnvalue = i;
        }
        
    }
    
    return returnvalue;
    
}

-(void)getGoogleResults{
    
    NSString *detailed2 = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=";
    detailed2 = [detailed2 stringByAppendingString:self.latitude];
    detailed2 = [detailed2 stringByAppendingString:@","];
    detailed2 = [detailed2 stringByAppendingString:self.longitude];
    detailed2 = [detailed2 stringByAppendingString:@"&radius=5000&types=museum&sensor=false&key=AIzaSyCHl9bDP5h5rdI6k39THGK9RWtX0QlVzTA"];
    
    NSLog(detailed2);
    
    
    
    NSURL *googleURL = [NSURL URLWithString:detailed2];
    NSData *googleData = [NSData dataWithContentsOfURL:googleURL];
    NSError *googleError = nil;
    NSDictionary *googleDictionary = [NSJSONSerialization JSONObjectWithData:googleData options:0 error:&googleError];
    self.googlePosts = [googleDictionary objectForKey:@"results"];
    
}

-(void)getTwitterResults{
    
    NSMutableDictionary *tweetDictionary = [[NSMutableDictionary alloc] init];
    for (int i=0; i<self.googlePosts.count; i++) {
        
        
        //    NSString *detailed = [[NSString alloc] initWithString:[[blogPost valueForKey:@"user"] valueForKey:@"name"]];
        //   detailed = [detailed stringByAppendingString:@" "];
        //    detailed = [detailed stringByAppendingString:[blogPost valueForKey:@"created_at"]];
            NSString *query = @"http://search.twitter.com/search.json?q=";
        
        query = [query stringByAppendingString:@"'"];
        query = [query stringByAppendingString:[self.googlePosts[i] objectForKey:@"name"]];
                           query = [query stringByAppendingString:@"'"];
        
        query = [query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
   
        NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"|"];
        
        NSString *trimmedReplacement =
        [[ query componentsSeparatedByCharactersInSet:charactersToRemove ]
         componentsJoinedByString:@"" ];
        query = trimmedReplacement;
        
       // printf("%s \n", [query UTF8String]);
        
        
                           
        
        NSURL *blogURL2 = [NSURL URLWithString:query];
        
        NSData *jsonData2 = [NSData dataWithContentsOfURL:blogURL2];
        
        NSError *error2 = nil;
        
        
 //       if ([NSJSONSerialization JSONObjectWithData:jsonData2 options:0 error:&error2]){
       
        @try{
        
        NSDictionary *twitterDictionary = [NSJSONSerialization JSONObjectWithData:jsonData2 options:0 error:&error2];
         
        if ([[twitterDictionary objectForKey:@"results"] count]>0){
        NSArray *jsonArray = [twitterDictionary objectForKey:@"results"];
        
        
            [tweetDictionary setObject:jsonArray forKey:[self.googlePosts[i] objectForKey:@"name"]]; }
        }
        
        
        @catch (NSException * e) {
            NSLog(@"Got exception: %@ Reason: %@", e.name, e.reason);
        }
        
 //       }
        
    }
    
    self.final = tweetDictionary;
    
    
   
    
}



/*
-(NSMutableDictionary)sortTwitter(NSMutableDictionary tweets){
    
    
}
*/

- (NSInteger)commonCount: (NSString *)aTweet andSecond: (NSString *)bTweet;
{
    
//    NSString *string1= @"Jordan Mike Liam Taylor Jill Gordon Phil Mark a";
//    NSString *string2= @"Marcus Tony Taylor Anny Keenan Brittany Gordon Mike";
    NSMutableSet *set1=[NSMutableSet setWithArray:[aTweet componentsSeparatedByString:@" "]];
    NSMutableSet *set2=[NSMutableSet setWithArray:[bTweet componentsSeparatedByString:@" "]];
    [set1 intersectSet:set2];
    
    NSArray *intersect=[set1 allObjects];//intersect contains all the common elements
    
    return [intersect count];
    
}

-(IBAction)refresh:(id)sender{
    [self viewDidLoad];
    
    [self.tableView reloadData];
    
}

    


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.blogPosts2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (self.blogPosts2!=nil){
    NSDictionary *blogPost = [self.blogPosts2 objectAtIndex:indexPath.row];
        NSDictionary *blogPost2 = [self.googlePosts objectAtIndex:indexPath.row];
    cell.textLabel.text = [blogPost valueForKey:@"text"];
    
//    NSString *detailed = [[NSString alloc] initWithString:[[blogPost valueForKey:@"user"] valueForKey:@"name"]];
 //   detailed = [detailed stringByAppendingString:@" "];
//    detailed = [detailed stringByAppendingString:[blogPost valueForKey:@"created_at"]];
    
        cell.detailTextLabel.text = [blogPost2 valueForKey:@"name"];
    
    NSURL *imageURL = [NSURL URLWithString:[blogPost valueForKey:@"profile_image_url"]];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    
    cell.imageView.image = image;
    
   }

    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {

        NSIndexPath *indexPath =[self.tableView indexPathForSelectedRow];
        
        NSDictionary *blogPost = [self.blogPosts2 objectAtIndex:indexPath.row];
   
        NSDictionary *blogPost2 = [self.googlePosts objectAtIndex:indexPath.row];
        
        
        NSString *someOtherString = [NSString stringWithFormat: @"https://twitter.com/jack/status/%@", [blogPost valueForKey:@"id_str"]];
        
        [[segue destinationViewController] setUrlstr:someOtherString];
        [[segue destinationViewController] setLatitude:[[[blogPost2 objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"]];
        [[segue destinationViewController] setLongitude:[[[blogPost2 objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"]];
 
          
        
                      }
}

@end
