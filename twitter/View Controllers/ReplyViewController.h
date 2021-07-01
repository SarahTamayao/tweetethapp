//
//  ReplyViewController.h
//  twitter
//
//  Created by Laura Yao on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ReplyViewControllerDelegate

- (void)didReply:(Tweet *)tweet;

@end

@interface ReplyViewController : UIViewController
@property (nonatomic, weak) id<ReplyViewControllerDelegate> delegate;
@property (nonatomic, strong) Tweet *tweeter;

@end

NS_ASSUME_NONNULL_END
