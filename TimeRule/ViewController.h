//
//  ViewController.h
//  TimeRule
//
//  Created by Alex Lelievre on 8/22/17.
//  Copyright © 2017 Far Out Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ViewController : UIViewController
{
}
@property (retain, nonatomic) IBOutlet SKView* spriteKitView;

+(ViewController*)getController;
-(void)appWillResume;
@end

// EOF

