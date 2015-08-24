//
//  ViewController.m
//  MultipeerChat
//
//  Created by Shawn Hung on 8/24/15.
//  Copyright (c) 2015 Paganini Plus. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <Toast/UIView+Toast.h>

@import MultipeerConnectivity;

@interface ViewController ()<MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate>

@property (strong, nonatomic) MCPeerID *localPeerID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.session.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickDiscover:(id)sender {
    self.localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    MCBrowserViewController *browserViewController = [[MCBrowserViewController alloc] initWithServiceType:ServiceType session:appDelegate.session];
    browserViewController.delegate = self;
    
    [appDelegate.assistant start];
    
    [self presentViewController:browserViewController animated:YES completion:nil];
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info{
    NSLog(@"browser withDiscoveryInfo");
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID{
    NSLog(@"browser lostPeer");
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    NSLog(@"browserViewControllerDidFinish");
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSLog(@"browser didChangeState");
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view makeToast:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    });
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    NSLog(@"session didReceiveStream");
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    NSLog(@"session didStartReceivingResourceWithName");
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    NSLog(@"session didFinishReceivingResourceWithName");
}


- (IBAction)didClickSayHello:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MCSession *session = appDelegate.session;
    [session sendData:[@"Hello" dataUsingEncoding:NSUTF8StringEncoding] toPeers:session.connectedPeers withMode:MCSessionSendDataReliable error:nil];
}
@end
