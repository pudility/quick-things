//
//  TableViewCell.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/18/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cellButton;
@property (weak, nonatomic) IBOutlet UILabel *scheduledDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *diffLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;
@property (weak, nonatomic) IBOutlet UILabel *largeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (weak, nonatomic) IBOutlet UILabel *splashLabel;
@property (weak, nonatomic) IBOutlet UILabel *customTextLabel;

- (IBAction)cellButton:(id)sender;

@end
