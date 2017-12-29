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

- (IBAction)cellButton:(id)sender;
@end
