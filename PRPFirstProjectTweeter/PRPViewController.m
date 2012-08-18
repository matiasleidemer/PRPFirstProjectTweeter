//
//  PRPViewController.m
//  PRPFirstProjectTweeter
//
//  Created by Matias Leidemer on 8/13/12.
//  Copyright (c) 2012 Matias Leidemer. All rights reserved.
//

#import "PRPViewController.h"
#import <Twitter/Twitter.h>

@interface PRPViewController ()

@end

@implementation PRPViewController

//property name = instance variable name
@synthesize twitterWebView = _twitterWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)handleTweetButtonTapped:(id)sender {
    if ([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *tweetVC = [[TWTweetComposeViewController alloc] init];
        [tweetVC setInitialText: NSLocalizedString(@"I just finished the first project in iOS SDK Development. #meganti", nil)];
        [self presentViewController:tweetVC animated:YES completion:NULL];
    } else {
        NSLog(@"Can't send tweet");
    }
}

- (IBAction)handleShowMyTweetsTapped:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.twitter.com/matiasleidemer"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.twitterWebView loadRequest:request];
}




@end
