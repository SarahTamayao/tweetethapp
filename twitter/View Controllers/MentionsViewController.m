//
//  MentionsViewController.m
//  twitter
//
//  Created by Laura Yao on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "MentionsViewController.h"
#import "APIManager.h"
#import "TweetCell.h"

@interface MentionsViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchTweets];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview: self.refreshControl atIndex:0];
}
- (void) fetchTweets {
    // Get timeline
    [[APIManager shared] getMentionsTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded mentions timeline");
            for (Tweet *tweet in tweets) {
                NSLog(@"%@", tweet.text);
            }
            self.arrayOfTweets =(NSMutableArray *) tweets;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];

        } else {
            NSLog(@"😫😫😫 Error getting mentions timeline: %@", error.localizedDescription);
        }
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = (TweetCell *) [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    //cell.delegate = self;
    cell.tweet = self.arrayOfTweets[indexPath.row];
    cell.nameOfUser.text = cell.tweet.user.name;
    NSString *atName = @"@";
    NSString *screenName = [atName stringByAppendingString:cell.tweet.user.screenName];
    cell.userNameT.text = screenName;
    cell.tweetText.text = cell.tweet.text;
    cell.tweetDate.text = cell.tweet.createdAtString;
    NSString* favCount = [NSString stringWithFormat:@"%i", cell.tweet.favoriteCount];
    NSString* replyCount =[NSString stringWithFormat:@"%i", cell.tweet.retweetCount];
    
    [cell.likeB setTitle:favCount forState:UIControlStateNormal];
    [cell.retweetB setTitle:replyCount forState:UIControlStateNormal];
    
    NSString *URLString = cell.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.profilePhoto.image = [UIImage imageWithData:urlData];
    
    NSString *mURLString = cell.tweet.mediaURLString;
    cell.tweetImage.image = nil;
    if(mURLString != nil){
        NSURL *murl = [NSURL URLWithString:mURLString];
        NSData *murlData = [NSData dataWithContentsOfURL:murl];
        cell.tweetImage.image = [UIImage imageWithData:murlData];
    }
    
    if (cell.tweet.favorited==YES){
        [cell.likeB setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.likeB setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    }
    
    if (cell.tweet.retweeted==YES){
        [cell.retweetB setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.retweetB setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    }
    
    
    
    return cell;
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
