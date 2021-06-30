//
//  DetailsViewController.h
//  twitter
//
//  Created by Laura Yao on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (nonatomic, strong) Tweet *tweeter;

@end

NS_ASSUME_NONNULL_END
