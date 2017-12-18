//
//  DateModificationViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/15/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "DateModificationViewController.h"

@interface DateModificationViewController () {
    NSDateFormatter *timeFormatter;
    NSDateFormatter *dayFormatter;
    NSString *labelText;
}
@end

@implementation DateModificationViewController

@synthesize largeTimeDisplayLabel = _largeTimeDisplayLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDate *now = [NSDate date];
    
    timeFormatter = [[NSDateFormatter alloc] init];
    dayFormatter = [[NSDateFormatter alloc] init];
    
    [timeFormatter setDateFormat:@"hh:mm a"];
    [dayFormatter setDateFormat:@"EEEE"];
    
    
    [_datePickerAction setDate:now];
    
    _labelString = [NSString stringWithFormat:@"%@, %@", [dayFormatter stringFromDate:now], [timeFormatter stringFromDate:now]];
    
    _largeTimeDisplayLabel.text = _labelString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) test: (NSDate *) date {
    [_datePickerAction setDate:date];

    NSString *stringOfRecivedDate = [NSString stringWithFormat:@"%@, %@", [dayFormatter stringFromDate:date], [timeFormatter stringFromDate:date]];
    
    NSLog(@"Receved time, %@", stringOfRecivedDate);
    _largeTimeDisplayLabel.text = stringOfRecivedDate;
}

- (IBAction)datePickerActionChanged:(id)sender {
    NSDate *chosen = [_datePickerAction date];
    
    _largeTimeDisplayLabel.text = [NSString stringWithFormat:@"%@, %@", [dayFormatter stringFromDate:chosen], [timeFormatter stringFromDate:chosen]];
}

@end
