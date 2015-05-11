//
//  MealRequestTableViewCell.h
//  YANA
//
//  Created by Gavin Chu on 10/17/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealRequestWithButtonsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mealLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButon;

@end
