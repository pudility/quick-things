//
//  CellActions.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/23/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "CellActions.h"
#import "CollectionViewCell.h"
#import "FetchSettings.h"

@implementation CellActions {
    NSMutableArray *settings;
    NSDateFormatter *timeFormatter;
    NSDateFormatter *dayFormatter;
}

- (CellActions *) init {
    FetchSettings *fetchSettingsAction = [[FetchSettings alloc] init];
    settings = [fetchSettingsAction fetchSettings];
    
    [self initilizeFormaters];
    
    return self;
}

- (void) initilizeFormaters {
    timeFormatter = [[NSDateFormatter alloc] init];
    dayFormatter = [[NSDateFormatter alloc] init];
    
    [timeFormatter setDateFormat:@"hh:mm a"];
    [dayFormatter setDateFormat:@"EEEE"];
}

@end
