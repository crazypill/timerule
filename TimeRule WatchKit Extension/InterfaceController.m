//
//  InterfaceController.m
//  TimeRule WatchKit Extension
//
//  Created by Alex Lelievre on 8/22/17.
//  Copyright © 2017 Far Out Labs, LLC. All rights reserved.
//

#import "InterfaceController.h"




@interface InterfaceController ()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context 
{
    [super awakeWithContext:context];

    // Configure interface objects here.
    // set the time
    [self setTime];
}


- (void)willActivate 
{
    [self setTime];

    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}


- (void)didDeactivate 
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


- (void)setTime
{
    NSDate*    sourceDate = [NSDate date];
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* dateComponents = [gregorian components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:sourceDate];
    NSInteger hour = [dateComponents hour] % 12;
    NSInteger mins = [dateComponents minute];
    NSInteger secs = [dateComponents second];

    // convert hours into minutes and add the minutes in (analog isn't quantized)
    NSInteger totalMinutes = hour * 60 + mins;
    NSInteger totalSeconds = mins * 60 + secs;
    
    // compute where that is on the watch face, there are 720 minutes in 12 hours (and 2π radians)
    // there are 3600 seconds in the minutes wheel
    double hourRads = totalMinutes / 720.0 * (2 * M_PI);
    double minsRads = totalSeconds / 3600.0 * (2 * M_PI);
    double secsRads = secs / 60.0 * (2 * M_PI);
    
    SKScene* scene = self.spriteKitScene.scene;
    SKNode*  hours = [scene childNodeWithName:@"Hours"];
    if( hours )
        hours.zRotation = hourRads;

    SKNode* minutes = [scene childNodeWithName:@"Minutes"];
    if( minutes )
        minutes.zRotation = minsRads;

    SKNode* seconds = [scene childNodeWithName:@"Seconds"];
    if( seconds )
        seconds.zRotation = secsRads;
}

@end



// EOF
