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

- (void) reloadTweets;
- (void) handleTwitterData: (NSData *)data
               urlResponse: (NSHTTPURLResponse *)urlResponse
                     error: (NSError *)error;
@end

@implementation PRPViewController

//property name = instance variable name
@synthesize twitterTextView = _twitterTextView;

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
        
        tweetVC.completionHandler = ^(TWTweetComposeViewControllerResult result) {
            if (result ==TWTweetComposeViewControllerResultDone) {
                [self dismissModalViewControllerAnimated:YES];
                [self reloadTweets];
            }
        };
        
        [self presentViewController:tweetVC animated:YES completion:NULL];
    } else {
        NSLog(@"Can't send tweet");
    }
}

- (IBAction)handleShowMyTweetsTapped:(id)sender {
    [self reloadTweets];
}

- (void)reloadTweets {
    NSURL *twitterAPIURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/user_timeline.json"];
    NSDictionary *twitterParams = [NSDictionary dictionaryWithObjectsAndKeys:@"matiasleidemer", @"screen_name", nil];
    TWRequest *request = [[TWRequest alloc] initWithURL:twitterAPIURL parameters:twitterParams requestMethod:TWRequestMethodGET];
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        [self handleTwitterData:responseData urlResponse:urlResponse error:error];
    }];
}

- (void) handleTwitterData:(NSData *)data urlResponse:(NSHTTPURLResponse *)urlResponse error:(NSError *)error {
    NSError *jsonError = nil;
    NSJSONSerialization *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    
    if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *tweets = (NSArray *) jsonResponse;
            NSSortDescriptor *sortByText = [NSSortDescriptor sortDescriptorWithKey:@"text" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects: sortByText, nil];
            tweets = [tweets sortedArrayUsingDescriptors:sortDescriptors];
            
            for (NSDictionary *tweetDict in tweets) {
                NSString *tweetText = [NSString stringWithFormat:@"%@: %@ (%@)",
                                       [tweetDict valueForKeyPath:@"user.name"],
                                       [tweetDict valueForKey:@"text"],
                                       [tweetDict valueForKey:@"created_at"]];
                
                self.twitterTextView.text = [NSString stringWithFormat:@"%@%@\n\n", self.twitterTextView.text, tweetText];
            }
        });
    }
}

@end
