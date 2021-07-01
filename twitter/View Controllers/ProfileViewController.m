//
//  ProfileViewController.m
//  twitter
//
//  Created by Laura Yao on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *usernameText;
@property (weak, nonatomic) IBOutlet UILabel *taglineText;
@property (weak, nonatomic) IBOutlet UILabel *locationText;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *tweetCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
    [self setupProfileView];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(setupProfileView) forControlEvents:UIControlEventValueChanged];
    [self.scrollView insertSubview: self.refreshControl atIndex:0];
}
-(NSString*) suffixNumber:(NSNumber*)number
{
    if (!number)
        return @"";

    long long num = [number longLongValue];

    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );

    num = llabs(num);

    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];

    int exp = (int) (log10l(num) / 3.f); //log10l(1000));

    NSArray* units = @[@"K",@"M",@"G",@"T",@"P",@"E"];

    return [NSString stringWithFormat:@"%@%.1f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}

-(void) setupProfileView{
    self.nameText.text = self.user.name;
    NSString *atName = @"@";
    NSString *screenName = [atName stringByAppendingString:self.user.screenName];
    self.usernameText.text = screenName;
    self.locationText.text = self.user.location;
    self.followingCount.text = [self suffixNumber:[NSNumber numberWithInt:self.user.followingCount]];
    self.followerCount.text = [self suffixNumber:[NSNumber numberWithInt:self.user.followerCount]];
    self.tweetCount.text =[self suffixNumber:[NSNumber numberWithInt:self.user.statusCount]];
    self.taglineText.text = self.user.tagline;
    NSString *URLString = self.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profileView.image = [UIImage imageWithData:urlData];
    
    NSString *backURLString = self.user.bannerPicture;
    NSURL *backurl = [NSURL URLWithString:backURLString];
    NSData *backurlData = [NSData dataWithContentsOfURL:backurl];
    self.bannerView.image = [UIImage imageWithData:backurlData];
    [self fetchTweets];
    
    
}

- (void) fetchTweets {
    // Get timeline
    [[APIManager shared] getUserTimeline:self.user.screenName completion:
     ^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded user timeline");
            self.arrayOfTweets =(NSMutableArray *) tweets;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];

        } else {
            NSLog(@"😫😫😫 Error getting user timeline: %@", error.localizedDescription);
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
