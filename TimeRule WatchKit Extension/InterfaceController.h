//
//  InterfaceController.h
//  TimeRule WatchKit Extension
//
//  Created by Alex Lelievre on 8/22/17.
//  Copyright © 2017 Far Out Labs, LLC. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface InterfaceController : WKInterfaceController
{
}
@property (retain, nonatomic) IBOutlet WKInterfaceSKScene* spriteKitScene;

- (void)setTime;

@end

// EOF
