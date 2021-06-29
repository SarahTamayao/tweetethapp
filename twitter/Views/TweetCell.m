//
//  TweetCell.m
//  twitter
//
//  Created by Laura Yao on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited==YES){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self refreshData];
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
              NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription   );
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else{
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self refreshData];
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
              NSLog(@"Error favoriting tweet: %@", error.localizedDescription   );
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}
- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted==YES){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self refreshData];
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
              NSLog(@"Error unretweeting tweet: %@", error.localizedDescription   );
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    else{
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self refreshData];
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
              NSLog(@"Error retweeting tweet: %@", error.localizedDescription   );
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}


-(void) refreshData{
    self.nameOfUser.text = self.tweet.user.name;
    NSString *atName = @"@";
    NSString *screenName = [atName stringByAppendingString:self.tweet.user.screenName];
    self.userNameT.text = screenName;
    self.tweetText.text = self.tweet.text;
    self.tweetDate.text = self.tweet.createdAtString;
    NSString* favCount = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    NSString* replyCount =[NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    
    [self.likeB setTitle:favCount forState:UIControlStateNormal];
    [self.retweetB setTitle:replyCount forState:UIControlStateNormal];
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profilePhoto.image = [UIImage imageWithData:urlData];
    
    if (self.tweet.favorited==YES){
        [self.likeB setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
    else{
        [self.likeB setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    }
    
    if (self.tweet.retweeted==YES){
        [self.retweetB setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    else{
        [self.retweetB setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    }
    
    
}
@end
