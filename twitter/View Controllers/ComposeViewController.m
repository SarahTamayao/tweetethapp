//
//  ComposeViewController.m
//  twitter
//
//  Created by Laura Yao on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *charCount;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetText.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tweetText.layer.borderWidth = 1.0;
    self.tweetText.layer.cornerRadius = 8;
    self.tweetText.delegate = self;
    // Do any additional setup after loading the view.
}
- (IBAction)closeAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)tweetAction:(UIBarButtonItem *)sender {
    [[APIManager shared]  postStatusWithText:self.tweetText.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
                NSLog(@"Error composing Tweet: %@", error.localizedDescription);
            }
            else{
                [self.delegate didTweet:tweet];
                NSLog(@"Compose Tweet Success!");
                [self dismissViewControllerAnimated:true completion:nil];
            }
    }];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 280;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.tweetText.text stringByReplacingCharactersInRange:range withString:text];

    // TODO: Update character count label
    self.charCount.text = [NSString stringWithFormat:@"%lu",characterLimit-newText.length];

    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
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
