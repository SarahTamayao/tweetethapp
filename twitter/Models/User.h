//
//  User.h
//  twitter
//
//  Created by Laura Yao on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic) int statusCount;
@property (nonatomic) int followerCount;
@property (nonatomic) int followingCount;
@property (nonatomic, strong) NSString *bannerPicture;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
