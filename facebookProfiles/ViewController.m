//
//  ViewController.m
//  facebookProfiles
//
//  Created by Rachel Dorn on 9/5/16.
//  Copyright © 2016 RachelDorn. All rights reserved.
//

#import "ViewController.h"
#import "PostViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import WebKit;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) NSArray *aboutMe;
@property (nonatomic, strong) NSString *imageUrl;

@end
    
@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.79 green:0.85 blue:0.97 alpha:1.0];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions = @[@"email", @"public_profile", @"user_likes", @"user_posts"];
    // Optional: Place the button in the center of your view.
    loginButton.center = CGPointMake(self.view.frame.size.width / 2, 87);
    [self.view addSubview:loginButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height - 110) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]
                                        initWithGraphPath:@"me" parameters:@{@"fields": @"name,email,gender,picture"}];
        FBSDKGraphRequest *requestPosts = [[FBSDKGraphRequest alloc]
                                           initWithGraphPath:@"me/posts" parameters:@{@"fields" : @"created_time,message,picture,story,link"}];
        FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
        [connection addRequest:requestMe
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //process me information
                 if (!error) {
                     self.aboutMe = @[[result objectForKey:@"name"], [result objectForKey:@"email"], [result objectForKey:@"gender"]];
                     self.imageUrl = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                     NSLog(@"%@", result);
                     [self.tableView reloadData];
                     
                 }
             }];
        [connection addRequest:requestPosts
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //process posts information
                 if (!error) {
                     self.posts = [result objectForKey:@"data"];
                     NSLog(@"posts: %@", result);
                     [self.tableView reloadData];
        
                 }
             }];
        [connection start];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return @"About Me";
            break;
        case 2:
            return @"Posts";
            break;
        default:
            return @"";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.aboutMe.count;
            break;
        case 2:
            return self.posts.count;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (cell) {
        switch (indexPath.section) {
            case 0:
                if (true) {
                    UIImageView *profileImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]]];
                    profileImageView.center = CGPointMake(cell.frame.size.width / 2, cell.frame.size.height / 2 + 8);
                    [cell addSubview:profileImageView];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                break;
            case 1:
                cell.textLabel.text = [self.aboutMe objectAtIndex:indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 2:
                if (true) {
                    NSString *time = [[self.posts objectAtIndex:indexPath.row] objectForKey:@"created_time"];
                    cell.textLabel.text = [time substringToIndex:10];
                }
                break;
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSDictionary *postInfo = [self.posts objectAtIndex:indexPath.row];
        Post *post = [[Post alloc] initWithDate:[[postInfo objectForKey:@"created_time"] substringToIndex:11]
                                          image:[postInfo objectForKey:@"picture"]
                                          story:[postInfo objectForKey:@"story"]
                                        message:[postInfo objectForKey:@"message"]];
        PostViewController *postVC = [[PostViewController alloc] initWithPost:post];
        [self.navigationController pushViewController:postVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    } else {
        return 44;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
