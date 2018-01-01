//
//  DateModificationViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/15/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "DateModificationViewController.h"
#import "CellEditViewController.h"
#import "CollectionViewController.h"
#import "RepeatTableViewController.h"
#import "FetchWebHook.h"
#import "RepeatViewController.h"
#import "FetchSmallUserSettings.h"
#import "CompleteReminder.h"
#import "UpdateReminder.h"
#import "FetchRembinders.h"
#import "Reminder.h"
#import "ApplyDarkTheme.h"
#import <UserNotifications/UserNotifications.h>

@interface DateModificationViewController () {
    NSDateFormatter *timeFormatter;
    NSDateFormatter *dayFormatter;
    NSString *labelText;
    NSData *timeToBeRemindedAt;
    ApplyDarkTheme *applyTheme;
}
@end

@implementation DateModificationViewController {
    NSArray *stringWeAreGetting;
    UITapGestureRecognizer *tapRecognizer;
}

@synthesize largeTimeDisplayLabel = _largeTimeDisplayLabel;
@synthesize textPassedDuringSegue = _textPassedDuringSegue;
@synthesize indexPassedDuringSegue = _indexPassedDuringSegue;
@synthesize cellIndexToPassDuringSegue = _cellIndexToPassDuringSegue;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"I was called with tag %lu", self.indexPassedDuringSegue);
    
    [self initilizeFormaters];
    [self initSetDateTimePicker];
    [self applyThemeMethod];
    [self decideWhereToPutBar];
    [self createSwipeGesture];
    
    _largeTimeDisplayLabel.text = _textPassedDuringSegue; //[self formatDateAsString:[_datePickerAction date]];
}

- (void) createSwipeGesture {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe)];
    swipe.numberOfTouchesRequired = 1;
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipe];
}

- (void) handleSwipe {
    UpdateReminder *updateReminderAction = [[UpdateReminder alloc] init];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    
    NSMutableArray *reminders = [fetchRemindersAction fetchRembinders];
    NSInteger index = [self indexPassedDuringSegue];
    
    NSLog(@"Index that we got for done was %lu", index);
    
    NSString *stringNotificationKeyFromIndex = [NSString stringWithFormat:@"%lu", index];
    
    [updateReminderAction reminderToUpdate:reminders[index] date:[self.datePickerAction date] notificationKey:stringNotificationKeyFromIndex snooz:[reminders[index] snooz] indexToUpdateWith:index setRepeat:[reminders[index] repeat]];
    
    [self performSegueWithIdentifier:@"ShowAllRemindersView" sender:self];
    
    [self scheduleNotificationWithTitle:[reminders[index] title] date:[self.datePickerAction date] stringNotificationKeyFromIndex:stringNotificationKeyFromIndex withSnoozFromReminder:[reminders[index] snooz]];
}

- (void) applyThemeMethod {
    applyTheme = [[ApplyDarkTheme alloc] init];
    [applyTheme viewController:self];
    [applyTheme view:self.view];
    [applyTheme label:self.largeTimeDisplayLabel];
    [applyTheme label:self.smallReminderDisplayLabel];
    [applyTheme datePicker:self.datePickerAction];
    [applyTheme toolBar:self.topToolbar];
    [applyTheme toolBar:self.bottomToolbar];
}

- (void) decideWhereToPutBar {
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
            case 1136:
                NSLog(@"iPhone 5 or 5S or 5C");
                self.bottomToolbar.hidden = YES;
                self.topToolbar.hidden = NO;
                break;
            case 1334:
                NSLog(@"iPhone 6/6S/7/8");
                self.bottomToolbar.hidden = YES;
                self.topToolbar.hidden = NO;
                break;
            case 2208:
                NSLog(@"iPhone 6+/6S+/7+/8+");
                self.bottomToolbar.hidden = YES;
                self.topToolbar.hidden = NO;
                break;
            case 2436:
                NSLog(@"iPhone X");
                self.bottomToolbar.hidden = NO;
                self.topToolbar.hidden = YES;
                _smallReminderDisplayLabel.text = [self formatDateAsString:[_datePickerAction date]];
                break;
            default:
                printf("unknown");
        }
    }
}

- (void) initSetDateTimePicker {
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    NSMutableArray *reminders = [fetchRemindersAction fetchRembinders];
    Reminder *reminder = reminders[self.indexPassedDuringSegue];
    
    if (reminder.date) {
        [_datePickerAction setDate:reminder.date];
    } else {
        NSDate *now = [NSDate date];
        [_datePickerAction setDate:now];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowRepeatTableView"]) {
        RepeatViewController *destViewController = segue.destinationViewController;
        destViewController.indexPassedDuringSegue = self.indexPassedDuringSegue;
    } else if ([segue.identifier isEqualToString:@"ShowCellEditMenu"]) {
        CellEditViewController *destViewController = segue.destinationViewController;
        destViewController.indexPassedDuringSegue = _cellIndexToPassDuringSegue;
    }
}

- (void)highlightLetter:(UITapGestureRecognizer *)sender {
    if (![[self.view viewWithTag:42] isHidden]) {
        [[self.view viewWithTag:12] removeFromSuperview];
        [[self.view viewWithTag:42] setHidden:YES];
        [[[self.view viewWithTag:42] layer] setZPosition:-100];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initilizeFormaters {
    timeFormatter = [[NSDateFormatter alloc] init];
    dayFormatter = [[NSDateFormatter alloc] init];
    
    [timeFormatter setDateFormat:@"hh:mm a"];
    [dayFormatter setDateFormat:@"EEEE"];
}

- (NSString *) formatDateAsString: (NSDate *) date {
    return [NSString stringWithFormat:@"%@, %@", [dayFormatter stringFromDate:date], [timeFormatter stringFromDate:date]];
}

- (void) test: (NSDate *) date {
    [_datePickerAction setDate:date];

    NSString *stringOfRecivedDate = [self formatDateAsString:date];
    
    NSLog(@"Receved time, %@", stringOfRecivedDate);
    _smallReminderDisplayLabel.text = stringOfRecivedDate;
}

- (IBAction)donePressed:(id)sender {
    NSLog(@"Done pressed! ");
    
    UpdateReminder *updateReminderAction = [[UpdateReminder alloc] init];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    
    NSMutableArray *reminders = [fetchRemindersAction fetchRembinders];
    NSInteger index = [self indexPassedDuringSegue];
    
    NSLog(@"Index that we got for done was %lu", index);
    
    NSString *stringNotificationKeyFromIndex = [NSString stringWithFormat:@"%lu", index];
    
    [updateReminderAction reminderToUpdate:reminders[index] date:[self.datePickerAction date] notificationKey:stringNotificationKeyFromIndex snooz:[reminders[index] snooz] indexToUpdateWith:index setRepeat:[reminders[index] repeat]];
    
    [self performSegueWithIdentifier:@"ShowAllRemindersView" sender:self];
    
    [self scheduleNotificationWithTitle:[reminders[index] title] date:[self.datePickerAction date] stringNotificationKeyFromIndex:stringNotificationKeyFromIndex withSnoozFromReminder:[reminders[index] snooz]];
    
    NSLog(@"Done");
}

- (void) scheduleNotificationWithTitle: (NSString *)title date:(NSDate *)date stringNotificationKeyFromIndex:(NSString *) identifierForRequest withSnoozFromReminder:(NSInteger) snooz{
    UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
    notificationContent.title = title;
    UNUserNotificationCenter *userNotificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    NSCalendar *gorgianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponets;
    UNCalendarNotificationTrigger *trigger;
    UNNotificationRequest *request;
    
    FetchSmallUserSettings *smallUserSettings = [[FetchSmallUserSettings alloc] init];
    
    for (NSInteger i = 0; i < [smallUserSettings fetchNumberOfNotificationsToSchedule]; i++) {
        dateComponets = [gorgianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
        trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponets repeats:true];
        request = [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"%@_%lu", identifierForRequest, i] content:notificationContent trigger:trigger];
        
        [userNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }];
        
        date = [date dateByAddingTimeInterval:60*snooz];
        NSLog(@"Next date will be %@ from snooz %lu", [self formatDateAsString:date], snooz);
    }
}

- (IBAction)snoozPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter new snooz" message:@"This will only be applied to the current reminder" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *stringNotificationKeyFromIndex = [NSString stringWithFormat:@"%lu", [self indexPassedDuringSegue]];
        NSInteger valueGotFromAlert = [[[alertController textFields][0] text] integerValue];
        NSLog(@"Got val %lu", valueGotFromAlert);
        
        UpdateReminder *updateReminderAction = [[UpdateReminder alloc] init];
        FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
        
        NSMutableArray *reminders = [fetchRemindersAction fetchRembinders];
        if (valueGotFromAlert) {
            [updateReminderAction reminderToUpdate:reminders[self.indexPassedDuringSegue] date:[self.datePickerAction date] notificationKey:stringNotificationKeyFromIndex snooz:valueGotFromAlert indexToUpdateWith:self.indexPassedDuringSegue setRepeat:nil];
        }
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)repeatPressed:(id)sender {
    [self performSegueWithIdentifier:@"ShowRepeatTableView" sender:self];
}

- (IBAction)webHookPressed:(id)sender {
    FetchWebHook *fetchWebhookActions = [[FetchWebHook alloc] init];
    NSString *webHook = [fetchWebhookActions fetchWebHook];
    
    if (webHook && ![webHook isEqual: @""]) {
        [self sendToWebHook:webHook];
    } else {
        [self getWebHookWithAlert];
        [self alertHowToChangeWebHook];
    }
}

- (IBAction)checkPressed:(id)sender {
    CompleteReminder *completeReminderAction = [[CompleteReminder alloc] init];
    [completeReminderAction reminderToComplete:[self indexPassedDuringSegue]];
    
    [self performSegueWithIdentifier:@"ShowAllRemindersView" sender:self];
}

- (IBAction)datePickerActionChanged:(id)sender {
    NSDate *chosen = [_datePickerAction date];
    
    if ((int)[[UIScreen mainScreen] nativeBounds].size.height == 2436) {
        _smallReminderDisplayLabel.text = [self formatDateAsString:chosen];
    }
}

- (void) alertHowToChangeWebHook {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Editing webhooks" message:@"If you need to change a webhook, edit the button and create a new webhook - this will re-prompt the webhook url input." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) getWebHookWithAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter the webhook attached to your zapier or ifttt recipy" message:@"Click help for more info" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Ender webhook url";
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FetchWebHook *fetchWebhookActions = [[FetchWebHook alloc] init];
        NSString *textRecivedFromInput = [[alertController textFields][0] text];
        
        [self sendToWebHook:textRecivedFromInput];
        [fetchWebhookActions setWebHook:textRecivedFromInput];
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) sendToWebHook: (NSString *) webHookToSendTo {
    DateModificationViewController *DVC = ((DateModificationViewController *) self.parentViewController);
    DVC.delegate = self;
    
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    NSMutableArray *reminders = [fetchRemindersAction fetchRembinders];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:webHookToSendTo];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [reminders[DVC.indexPassedDuringSegue] title], @"reminder", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error! %@", error.description);
            return;
        } else {
            NSLog(@"Success!");
            
            CompleteReminder *completeReminderAction = [[CompleteReminder alloc] init];
            [completeReminderAction reminderToComplete:[DVC indexPassedDuringSegue]];
            
            [((DateModificationViewController *) self.parentViewController) performSegueWithIdentifier:@"ShowAllRemindersView" sender:self];
        }
    }];
    
    [postDataTask resume];
}

@end
