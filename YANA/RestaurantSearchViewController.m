//
//  RestaurantSearchViewController.m
//  YANA
//
//  Created by Shane on 11/2/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "RestaurantSearchViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "OAMutableURLRequest.h"
#import "InviteFriendsTableViewController.h"
#import "CreateMealRequestViewController.h"

@interface RestaurantSearchViewController ()

@end

@implementation RestaurantSearchViewController
@synthesize checkedIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUser];
    self.restaurants = [[NSMutableArray alloc] init];
    self.imageURLs = [[NSMutableArray alloc] init];
    self.inviteFriendsButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// initialize User
- (void)initializeUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //NSLog(@"searchBarTextDidBeginEditing");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"textDidChange");
    self.searchTerm = searchBar.text;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self.restaurants removeAllObjects];
    self.inviteFriendsButton.enabled = NO;
    [self searchRestaurant];
}

- (void)searchRestaurant {
    NSLog(@"search restaurant....");
    NSLog(@"searchTerm is %@", self.searchTerm);
    NSString *urlString = [NSString stringWithFormat:@"http://api.yelp.com/v2/search?term=%@&location=berkeley",self.searchTerm];
    NSLog(@"urlString is %@", urlString);
    NSURL *URL = [NSURL URLWithString:urlString];
    //customer key and secret provided by Yelp
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"82yR04gPM2XKnQ_hAHEs6A" secret:@"8UqXa3N64AXvQFaj6ki3SUXzQKY"];
    //token and secret provided by yelp
    OAToken *token = [[OAToken alloc] initWithKey:@"-8H9NbueOkM2fugXfeW9L9HCLSWCQ4Ti" secret:@"UAEOWnFHtfUjMJbAQZBAsgpwHFU"] ;
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init] ;
    NSString *realm = nil;
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    [request prepare];
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [requestReply dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: nil];
    
    NSMutableArray *venueList = [JSON objectForKey:@"businesses"];
    NSLog(@"businesses are %@", venueList);
    for (int i = 0; i < [venueList count] ; i++) {
        [self.restaurants addObject:[[JSON objectForKey:@"businesses"][i] objectForKey:@"name"]];
        NSString *url = [[JSON objectForKey:@"businesses"][i] objectForKey:@"image_url"];
        if (url) {
            [self.imageURLs addObject:url];
        } else {
            [self.imageURLs addObject:@"No Image"];
        }
    }

    [self.tableView reloadData];
    NSLog(@"Restaurants are %@", self.restaurants);
    NSLog(@"Image URLs are %@", self.imageURLs);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.restaurants count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"restaurantCell" forIndexPath:indexPath];
    
    //load images
    NSString *u = [self.imageURLs objectAtIndex:indexPath.row];
    if (![u isEqualToString:@"No Image"]) {
        NSURL *url = [NSURL URLWithString:[self.imageURLs objectAtIndex:indexPath.row]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        [cell.imageView setImage:image];
    }
    //load texts
    cell.textLabel.text = [self.restaurants objectAtIndex:indexPath.row];
    //uncheck checkmarks
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRestaurant = [self.restaurants objectAtIndex:indexPath.row];
    NSLog(@"selected restaurant is %@", self.selectedRestaurant);
    if(self.checkedIndexPath)
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
    if([self.checkedIndexPath isEqual:indexPath])
    {
        self.checkedIndexPath = nil;
    }
    else
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.checkedIndexPath = indexPath;
    }
    self.inviteFriendsButton.enabled = YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"inviteFriendsButton"]) {
        NSLog(@"Preparing for segue to InviteFriendsViewController");
        
        //update MealRequest object with selectedRestaurant
        self.mealRequest.restaurant = self.selectedRestaurant;
        
        //pass MealRequest object to InviteFriendViewController
        InviteFriendsTableViewController *controller = segue.destinationViewController;
        controller.mealRequest = self.mealRequest;
        
        [controller.mealRequest toString];
    }
    
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (![parent isEqual:self.parentViewController]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.selectedRestaurant = self.selectedRestaurant;
    }
}

@end
