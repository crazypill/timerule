//
//  ViewController.m
//  TimeRule
//
//  Created by Alex Lelievre on 8/22/17.
//  Copyright © 2017 Far Out Labs, LLC. All rights reserved.
//

#import "ViewController.h"


ViewController* sMainViewController = NULL;


@implementation ViewController

+(ViewController*)getController
{  
    return sMainViewController;
}

- (void)setTime
{
    NSDate*    sourceDate = [NSDate date];
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* dateComponents = [gregorian components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:sourceDate];
    NSInteger hour = [dateComponents hour] % 12;
    NSInteger mins = [dateComponents minute];
    NSInteger secs = [dateComponents second];
//    NSInteger hour = 12;
//    NSInteger mins = 0;
//    NSInteger secs = 0;
    
    // convert hours into minutes and add the minutes in (analog isn't quantized)
    NSInteger totalMinutes = hour * 60 + mins;
    NSInteger totalSeconds = mins * 60 + secs;
    
    // compute where that is on the watch face, there are 720 minutes in 12 hours (and 2π radians)
    // there are 3600 seconds in the minutes wheel
    double hourRads = totalMinutes / 720.0 * (2 * M_PI);
    double minsRads = totalSeconds / 3600.0 * (2 * M_PI);
    double secsRads = secs / 60.0 * (2 * M_PI);
    
    SKScene* scene = self.spriteKitView.scene;
    SKNode*  hours = [scene childNodeWithName:@"//Hours"];
    if( hours )
        hours.zRotation = hourRads;
    
    SKNode* minutes = [scene childNodeWithName:@"//Minutes"];
    if( minutes )
        minutes.zRotation = minsRads;
    
    SKNode* seconds = [scene childNodeWithName:@"//Seconds"];
    if( seconds )
        seconds.zRotation = secsRads;
}

- (CIFilter*)magnifyFilter
{
    // get the ruler node for positioning information
    SKNode* ruler = [self.spriteKitView.scene childNodeWithName:@"//Ruler"];
    if( !ruler )
        return nil;

    CGFloat backRatio = 528.0 / 375.0; // just a default value (should be the same as below but just in case something changes in the scene file)
    SKNode* base = [self.spriteKitView.scene childNodeWithName:@"//Base"];
    SKNode* back = [self.spriteKitView.scene childNodeWithName:@"//Backdrop"];
    if( base && back )
        backRatio = back.frame.size.width / base.frame.size.width; 
    if( back )
        back.hidden = YES;
    
    CGPoint positionInScene = [self.spriteKitView.scene convertPointToView:[ruler.scene convertPoint:ruler.position toNode:ruler.scene]];
    
    // commented out because it seems the scale value should be 2 but it's 3 on iPhone X...  We probably don't want the screen scale but the backing buffer scale... !!@
    CGFloat centerX = 529;// (positionInScene.x * backRatio) * [[UIScreen mainScreen] scale];  
    
    // for the iPhone 7
    CGFloat point0  = 1126;
    CGFloat point1  = 633;

    NSLog( @"positionInScene: (%0.2f, %0.2f), centerX: %f, scale: %f, baseWidth: %f, backWidth: %f\n", positionInScene.x, positionInScene.y, centerX, [[UIScreen mainScreen] scale], base.frame.size.width, back.frame.size.width );


    CIFilter* filter = [CIFilter filterWithName:@"CIGlassLozenge"];
    [filter setDefaults];    
    [filter setValue:[NSNumber numberWithFloat:65]           forKey:@"inputRadius"];
    [filter setValue:[CIVector vectorWithX:centerX Y:point0] forKey:@"inputPoint0"];
    [filter setValue:[CIVector vectorWithX:centerX Y:point1] forKey:@"inputPoint1"];
    [filter setValue:[NSNumber numberWithFloat:1.04]         forKey:@"inputRefraction"];
    return filter;
}


- (void)viewDidLoad 
{
    [super viewDidLoad];

    SKEffectNode*  fx = (SKEffectNode*)[self.spriteKitView.scene childNodeWithName:@"//GlassFx"];
    if( !sMainViewController && fx )
    {
        self.spriteKitView.ignoresSiblingOrder = YES;

        // test code !!@ -- this works nicely, I suspect because the acculated frame never changes...
//        self.spriteKitView.scene.filter = [self magnifyFilter];
//        self.spriteKitView.scene.shouldEnableEffects = true;
        
        fx.filter = [self magnifyFilter];
        fx.shouldEnableEffects = YES;
        fx.shouldCenterFilter  = NO;
        NSLog( @"Position at start: %@, %f, shouldCenter: %d\n", fx, fx.zRotation, fx.shouldCenterFilter );
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    [self setTime];
    sMainViewController = self;
    NSLog( @"Position after setTime: %@, %f\n", fx, fx.zRotation );
}


-(void)appWillResume
{
    [self setTime];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
