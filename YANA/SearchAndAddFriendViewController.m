//
//  SearchAndAddFriendViewController.m
//  YANA
//
//  Created by Gavin Chu on 10/20/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "SearchAndAddFriendViewController.h"
#import "AppDelegate.h"
#import "APIHelper.h"
#import "AddFriendTableViewCell.h"
#import "User.h"
#import "FriendProfileViewController.h"

@interface SearchAndAddFriendViewController ()

@property (nonatomic, strong) User *user;

@end

@implementation SearchAndAddFriendViewController

APIHelper *apiHelper;

#pragma mark - Setup

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initializeUser]; //used to update friends list for filtering
    [self displaySearchResult];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUser];
    apiHelper = [[APIHelper alloc]init];
    self.tableData = [[NSMutableArray alloc] init];
    self.addedFriends = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initializeUser{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = ad.user;
}

#pragma mark - Search

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0)
    {
        [searchBar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //NSLog(@"Search Clicked");
    [self searchFriend];
}

- (void) searchFriend{
    NSLog(@"searchFriend: %@", self.friendSearchBar.text);
    //clear tableData for fresh result
    [self.tableData removeAllObjects];
    
    NSDictionary *response = [apiHelper searchUserByUsername:self.friendSearchBar.text];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            NSArray *users = [response objectForKey:@"users"];
            for(NSDictionary *user in users){
                Friend *friend = [[Friend alloc] initWithid:user[@"user_id"] andUsername:user[@"username"]];
                [self.tableData addObject:friend];
                [friend toString];
            }
            
            [self displaySearchResult];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    //self.friendSearchMessage.text = [NSString stringWithFormat:@"No username with \"%@\" found.", self.friendSearchBar.text];
}

- (void) displaySearchResult{
    NSLog(@"displaySearchResult");
    
    NSMutableArray *toBeFilteredFriends = [[NSMutableArray alloc] init];
    
    //filter search result
    for(Friend *searchedFriend in self.tableData){
        //filter users who are already your friend
        for(Friend *yourFriend in self.user.friends){
            if([searchedFriend.friendUsername isEqualToString:yourFriend.friendUsername]){
                [toBeFilteredFriends addObject:searchedFriend];
                break;
            }
        }
        
        //never include self in result
        if([searchedFriend.friendid isEqualToString:self.user.userid]){
            [toBeFilteredFriends addObject:searchedFriend];
        }
    }
    
    //remove all filtered friends afterwards to avoid mutating self.tableData
    [self.tableData removeObjectsInArray:toBeFilteredFriends];
    
    //sort search result alphabetically
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendUsername" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [self.tableData sortedArrayUsingDescriptors:sortDescriptors];
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *addFriendCellIdentifier = @"addFriendCell";
    
    AddFriendTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:addFriendCellIdentifier];
    
    if (cell == nil) {
        cell = [[AddFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addFriendCellIdentifier];
    }
    
    Friend *friend = [self.tableData objectAtIndex:indexPath.row];
    cell.friendUsername.text = friend.friendUsername;
    cell.addButton.tag = indexPath.row;
    [cell.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Friend *selectedFriend = [self.tableData objectAtIndex:indexPath.row];
    FriendProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendViewController"];
    if(selectedFriend){
        viewController.targetid = selectedFriend.friendid;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Can't open friend profile. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Actions

- (IBAction)addButtonClicked:(UIButton *)sender {
    NSLog(@"add clicked");
    NSLog(@"current Row=%ld", sender.tag);
    Friend *friend = self.tableData[sender.tag];
    
    //update server
    NSDictionary *response = [apiHelper addFriend:friend.friendid toYou:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            [self.user.friends addObject:friend];
            [self saveFriends];
            [self.tableData removeObject:friend];
            [self.tableView reloadData];
        }else if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.ALREADY_FOLLOWED]){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Can't Add User"
                                  message:[NSString stringWithFormat: @"\"%@\" is already your friend."
                                           , friend.friendUsername]
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void) saveFriends{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.user = self.user;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
