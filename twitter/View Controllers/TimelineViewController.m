//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>
@property NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

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
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            /*for (NSDictionary *dictionary in tweets) {
                NSString *text = dictionary[@"text"];
                NSLog(@"%@", text);
            }*/
            self.arrayOfTweets =(NSMutableArray *) tweets;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];

        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(UIButton *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = (TweetCell *) [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
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
