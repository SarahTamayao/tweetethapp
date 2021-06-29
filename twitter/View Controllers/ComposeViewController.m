//
//  ComposeViewController.m
//  twitter
//
//  Created by Laura Yao on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetText;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)closeAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)tweetAction:(UIBarButtonItem *)sender {
    [[APIManager shared]  postStatusWithText:_tweetText.text completion:^(Tweet *tweet, NSError *error) {
        if (tweet){
            NSLog(@"😎😎😎 Tweet Sent");
        }
        else{
            NSLog(@"Sad");
        }
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
