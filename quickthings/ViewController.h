//
//  ViewController.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/11/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerDelegate <NSObject>
@end
@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    id <ViewControllerDelegate> _delegate;
}
@property (nonatomic, strong) id delegate;

- (IBAction)addReminderButton:(id)sender;
- (IBAction)settingsButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *reminderInputField;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *inputContainerView;
@property (weak, nonatomic) IBOutlet UIToolbar *middleToolBar;
@property (weak, nonatomic) IBOutlet UIToolbar *topToolBar;
@property (weak, nonatomic) IBOutlet UIToolbar *inputToolBar;

@property (strong, nonatomic) NSString *recivedString;
@property (nonatomic) NSInteger recivedIndex;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *textLabelHowTo;

@end

