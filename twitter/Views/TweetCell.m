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
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    [self refreshData];
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
         if(error){
              NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
         }
     }];
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
    
}
@end
