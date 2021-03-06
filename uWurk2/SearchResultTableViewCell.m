//
//  SearchResultTableViewCell.m
//  uWurk2
//
//  Created by Avery Bonner on 9/23/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "SearchResultTableViewCell.h"
#import "AFNetworking.h"

@implementation SearchResultTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(NSString*)getUserDefault:(NSString*)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs stringForKey:key];
}

- (IBAction)pressFavorites:(id)sender
{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager.requestSerializer setValue:[self getUserDefault:@"api_auth_token"] forHTTPHeaderField:@"API-AUTH"];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        if (self.btnFavorite.selected == NO) {
            [params setObject:self.searchID forKey:@"search_id"];
            [params setObject:self.profileID forKey:@"user_id"];
            if([params count]){
                [manager POST:@"http://uwurk.tscserver.com/api/v1/add_favorite_employee" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"\nAdd Favorite - Json Response:\n%@", responseObject);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.btnFavorite setSelected:YES];
                    });

                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    [self.searchViewController handleErrorAccessError:error];
                }];
            }
        }
        else {
            [params setObject:self.searchID forKey:@"search_id"];
            [params setObject:self.profileID forKey:@"user_id"];
            if([params count]){
                [manager POST:@"http://uwurk.tscserver.com/api/v1/remove_favorite_employee" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"\nRemove Favorite - Json Response:\n%@", responseObject);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.btnFavorite setSelected:NO];
                    });
    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    [self.searchViewController handleErrorAccessError:error];
                }];
            }
        }
}

@end
