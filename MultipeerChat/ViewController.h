//
//  ViewController.h
//  MultipeerChat
//
//  Created by Shawn Hung on 8/24/15.
//  Copyright (c) 2015 Paganini Plus. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MultipeerConnectivity;
#import "SessionManager.h"

@interface ViewController : UIViewController<SessionManagerDelegate>

- (IBAction)didClickSayHello:(id)sender;

@end

