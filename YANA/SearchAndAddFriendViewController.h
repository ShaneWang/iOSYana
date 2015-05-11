//
//  SearchAndAddFriendViewController.h
//  YANA
//
//  Created by Gavin Chu on 10/20/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface SearchAndAddFriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *friendSearchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,retain) NSMutableArray *tableData;

@property (nonatomic, strong) NSMutableArray *addedFriends; //array of Friend

@end
