//
//  TweetCell.h
//  twitter
//
//  Created by Laura Yao on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TweetCellDelegate;
@interface TweetCell : UITableViewCell
@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameOfUser;
@property (weak, nonatomic) IBOutlet UILabel *userNameT;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UIButton *replyB;
@property (weak, nonatomic) IBOutlet UIButton *retweetB;
@property (weak, nonatomic) IBOutlet UIButton *likeB;
@property (weak, nonatomic) IBOutlet UIButton *messageB;
@property (weak, nonatomic) IBOutlet UIImageView *tweetImage;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
- (void) didTapUserProfile:(UITapGestureRecognizer *)sender;

@end
@protocol TweetCellDelegate
- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;
- (void)tweetCell:(TweetCell *) tweetCell didReply: (Tweet *)tweet;
@end


NS_ASSUME_NONNULL_END
