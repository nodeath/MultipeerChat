//
//  ViewController.m
//  MultipeerChat
//
//  Created by Shawn Hung on 8/24/15.
//  Copyright (c) 2015 Paganini Plus. All rights reserved.
//

#import "ViewController.h"
#import <Toast/UIView+Toast.h>
#import "ChatViewController.h"

@import MultipeerConnectivity;

@interface ViewController ()

@property (strong, nonatomic) MCPeerID *localPeerID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SessionManager sharedManager].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickDiscover:(id)sender {
    self.localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    
    [self presentViewController:[SessionManager sharedManager].browserViewController animated:YES completion:nil];
}


- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    NSLog(@"browserViewControllerDidFinish");
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickSayHello:(id)sender {
    ChatViewController *chat = [[ChatViewController alloc] init];
    [self.navigationController showViewController:chat sender:sender];
}

- (void)manager:(SessionManager *)manager didReceiveMessage:(NSString *)message{
    [self.view makeToast:message];
}

@end
