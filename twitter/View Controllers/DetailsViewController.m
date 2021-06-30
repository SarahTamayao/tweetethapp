//
//  DetailsViewController.m
//  twitter
//
//  Created by Laura Yao on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *usernameText;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (weak, nonatomic) IBOutlet UIButton *replyB;
@property (weak, nonatomic) IBOutlet UIButton *retweetB;
@property (weak, nonatomic) IBOutlet UIButton *likeB;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupDetailView];
}

- (void)setupDetailView{
    self.nameText.text = self.tweeter.user.name;
    NSString *atName = @"@";
    NSString *screenName = [atName stringByAppendingString:self.tweeter.user.screenName];
    self.usernameText.text = screenName;
    self.tweetText.text = self.tweeter.text;
    NSString *dateofTweet = [self.tweeter.createdAtString stringByAppendingString:@" ago"];
    self.dateText.text = dateofTweet;
    NSString* favCount = [NSString stringWithFormat:@"%i", self.tweeter.favoriteCount];
    NSString* replyCount =[NSString stringWithFormat:@"%i", self.tweeter.retweetCount];
    
    [self.likeB setTitle:favCount forState:UIControlStateNormal];
    [self.retweetB setTitle:replyCount forState:UIControlStateNormal];
    
    NSString *URLString = self.tweeter.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profilePic.image = [UIImage imageWithData:urlData];
    
    if (self.tweeter.favorited==YES){
        [self.likeB setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
    else{
        [self.likeB setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    }
    
    if (self.tweeter.retweeted==YES){
        [self.retweetB setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    else{
        [self.retweetB setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    }
}
- (IBAction)retweetAction:(id)sender {
    if (self.tweeter.retweeted==YES){
        self.tweeter.retweeted = NO;
        self.tweeter.retweetCount -= 1;
        [self setupDetailView];
        [[APIManager shared] unretweet:self.tweeter completion:^(Tweet *tweet, NSError *error) {
            if(error){
              NSLog(@"Error unretweeting tweet: %@", error.localizedDescription   );
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    else{
        self.tweeter.retweeted = YES;
        self.tweeter.retweetCount += 1;
        [self setupDetailView];
        [[APIManager shared] retweet:self.tweeter completion:^(Tweet *tweet, NSError *error) {
            if(error){
              NSLog(@"Error retweeting tweet: %@", error.localizedDescription   );
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    
}
- (IBAction)likeAction:(id)sender {
    if (self.tweeter.favorited==YES){
        self.tweeter.favorited = NO;
        self.tweeter.favoriteCount -= 1;
        [self setupDetailView];
        [[APIManager shared] unfavorite:self.tweeter completion:^(Tweet *tweet, NSError *error) {
            if(error){
              NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription   );
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else{
        self.tweeter.favorited = YES;
        self.tweeter.favoriteCount += 1;
        [self setupDetailView];
        [[APIManager shared] favorite:self.tweeter completion:^(Tweet *tweet, NSError *error) {
            if(error){
              NSLog(@"Error favoriting tweet: %@", error.localizedDescription   );
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
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
