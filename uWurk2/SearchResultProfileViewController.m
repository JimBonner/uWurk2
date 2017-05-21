//
//  SearchResultProfileViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/27/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "SearchResultProfileViewController.h"
#import "SearchResultsTableViewController.h"
#import "ContactProfileViewController.h"
#import "EditEmployerContactInfoViewController.h"
#import "UrlImageRequest.h"

@interface SearchResultProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAgeWage;
@property (weak, nonatomic) IBOutlet UILabel *lblExp1;
@property (weak, nonatomic) IBOutlet UILabel *lblExp2;
@property (weak, nonatomic) IBOutlet UILabel *lblExp3;
@property (weak, nonatomic) IBOutlet UILabel *lblEdu1;
@property (weak, nonatomic) IBOutlet UILabel *lblEdu2;
@property (weak, nonatomic) IBOutlet UILabel *lblEdu3;
@property (weak, nonatomic) IBOutlet UIButton *btnBio;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntInfoBioViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntExp2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntExp3Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntEdu2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntEdu3Height;
@property (weak, nonatomic) IBOutlet UIButton *btnEdu;
@property (weak, nonatomic) IBOutlet UIButton *btnExp;
@property (weak, nonatomic) IBOutlet UILabel *lblInfoBio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntInfoBio;
@property (strong, nonatomic) IBOutlet NSDictionary *json;
@property (weak, nonatomic) IBOutlet NSDictionary *profileUser;
@property (weak, nonatomic) IBOutlet UIImageView *userImages;
@property (weak, nonatomic) IBOutlet UIImageView *infoDownArrow;
@property (weak, nonatomic) IBOutlet UIImageView *bioDownArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntExpWhole;
@property (weak, nonatomic) IBOutlet UIView *viewExpWhole;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;

@end

@implementation SearchResultProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.paramHolder setValue:self.searchID forKey:@"search_id"];
    
    AFHTTPRequestOperationManager *manager = [self getManager];
    [manager POST:@"http://uwurk.tscserver.com/api/v1/search" parameters:self.paramHolder
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSLog(@"\nSearch Result Favorite - Json: \n%@", responseObject);
               BOOL is_favorite = NO;
               for(NSDictionary *dict in [responseObject objectForKey:@"favorites"]) {
                  if([[dict objectForKey:@"id"]integerValue] == [self.profileID integerValue]) {
                      is_favorite = YES;
                      break;
                   }
               }
               self.btnFavorite.selected = is_favorite;
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [self handleErrorAccessError:@"Search Result Favorite" withError:error];
              return;
          }];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.profileID forKey:@"id"];
    
    if([params count]){
       AFHTTPRequestOperationManager *manager = [self getManager];
       [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                NSString *SchoolStatus1;
                NSString *JobStatus1;
                NSString *TipWork;
                
                NSArray *photoArray = [[responseObject objectForKey:@"user"] objectForKey:@"photos"];
                for(NSDictionary *photoDict in photoArray) {
                    if([[photoDict objectForKey:@"for_profile"] intValue] == 1) {
                        NSURL *photoURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://uwurk.tscserver.com%@",[photoDict objectForKey:@"url"]]];
                        
                        UrlImageRequest *photoRequest = [[UrlImageRequest alloc]initWithURL:photoURL];
                        
                        [photoRequest startWithCompletion:^(UIImage *newImage, NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.userImages setImage:newImage];
                            });
                        }];
                    }
                }

            self.json = [responseObject objectForKey:@"user"];
            NSString *age = [[self.searchedUserDict objectForKey:@"age"]stringValue];
            
            self.lblName.text = [NSString stringWithFormat:@"%@ %@",[self.json objectForKey:@"first_name"], [self.json objectForKey:@"last_name"]];
            if ([[self.json objectForKey:@"tipped_position"] intValue] == 1) {
                TipWork = @"or Tips";
            }if ([[self.json objectForKey:@"tipped_position"] intValue] == 0) {
                TipWork = @"";
            }
            self.lblAgeWage.text = [NSString stringWithFormat:@"Age: %@  |  $%@/hr %@", age, [self.json objectForKey:@"hourly_wage"], TipWork];
            
            NSArray *experienceArray = [self.json objectForKey:@"experience"];
            if([experienceArray count] > 0) {
                NSDictionary *firstExperienceItem = [experienceArray objectAtIndex:0];
                if ([[firstExperienceItem objectForKey:@"status"] intValue] == 1) {
                    JobStatus1 = @"Current";
                }
                if ([[firstExperienceItem objectForKey:@"status"] intValue] == 2) {
                    JobStatus1 = @"Previous";
                }
                self.lblExp1.text = [NSString stringWithFormat:@"%@: %@, %@", JobStatus1,[firstExperienceItem objectForKey:@"company"], [firstExperienceItem objectForKey:@"position"]];
            }
            else {
                self.cnstrntExpWhole.constant = 0;
                self.viewExpWhole.alpha = 0;
            }
            
            NSArray *educationArray = [self.json objectForKey:@"education"];
            if([educationArray count] > 0) {
                NSDictionary *firstEducationItem = [educationArray objectAtIndex:0];
                if ([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 1) {
                    SchoolStatus1 = @"Enrolled";
                }
                if ([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 2) {
                    SchoolStatus1 = @"Graduated";
                }
                if ([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 3) {
                    SchoolStatus1 = @"Attended";
                }
                self.lblEdu1.text = [NSString stringWithFormat:@"%@: %@", SchoolStatus1,[firstEducationItem objectForKey:@"school"]];
            }
            if([experienceArray count] == 0) {
                    self.btnExp.alpha = 0;
            }
            if([educationArray count] <= 1) {
                    self.btnEdu.alpha = 0;
            }
            self.btnBio.selected = YES;
            self.btnInfo.selected = YES;
            self.cnstrntEdu2Height.constant = 0;
            self.cnstrntEdu3Height.constant = 0;
            self.cnstrntExp2Height.constant = 0;
            self.cnstrntExp3Height.constant = 0;
            self.cnstrntInfoBioViewHeight.constant = 0;
            self.lblEdu2.alpha = 0;
            self.lblEdu3.alpha = 0;
            self.lblExp2.alpha = 0;
            self.lblExp3.alpha = 0;
            self.infoDownArrow.alpha = 0;
            self.bioDownArrow.alpha = 0;
            self.lblInfoBio.alpha = 0;
            self.cnstrntInfoBio.constant = 500;
            
            [self.view layoutIfNeeded];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self handleErrorAccessError:@"Search Result Profile" withError:error];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)pressEditProfile:(id)sender
{
    UITableViewController *myController = [[UIStoryboard storyboardWithName:@"EmployeeProfile" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileEditStep1"];
    [self.navigationController setViewControllers:@[myController] animated:YES];
}

- (IBAction)pressInfo:(id)sender
{
    NSString *BodyArt;
    NSString *DriversLicense;
    NSString *Language;
    NSString *Veteran;
    NSString *Tattoos;
    NSString *FacePierce;
    NSString *TonguePierce;
    NSString *Gauges;
    if ([[self.json objectForKey:@"has_body_art"] intValue] == 0) {
        BodyArt = @"No Body Art";
    }
    if ([[self.json objectForKey:@"has_tattoo"] intValue] == 0) {
        Tattoos = @"";
    }
    if ([[self.json objectForKey:@"has_tattoo"] intValue] == 1) {
        Tattoos = @"Tattoos";
    }
    if ([[self.json objectForKey:@"has_facial_piercing"] intValue] == 0) {
        FacePierce = @"";
    }
    if ([[self.json objectForKey:@"has_facial_piercing"] intValue] == 1) {
        FacePierce = @"Facial Piercings";
    }
    if ([[self.json objectForKey:@"has_tongue_piercing"] intValue] == 0) {
        TonguePierce = @"";
    }
    if ([[self.json objectForKey:@"has_tongue_piercing"] intValue] == 1) {
        TonguePierce = @"Tongue Piercing";
    }
    if ([[self.json objectForKey:@"has_ear_gauge"] intValue] == 0) {
        Gauges = @"";
    }
    if ([[self.json objectForKey:@"has_ear_gauge"] intValue] == 1) {
        Gauges = @"Gauges";
    }
    if ([[self.json objectForKey:@"has_body_art"] intValue] == 1) {
        BodyArt = [NSString stringWithFormat:@"Has %@, %@, %@, %@", Tattoos, FacePierce, TonguePierce, Gauges];
    }
    if ([[self.json objectForKey:@"has_drivers_license"] intValue] == 0) {
        DriversLicense = @"No Valid Drivers License";
    }
    if ([[self.json objectForKey:@"has_drivers_license"] intValue] == 1) {
        DriversLicense = @"Has Valid Drivers License";
    }
    if ([[self.json objectForKey:@"fluent_english"] intValue] == 0) {
        Language = @"";
    }
    if ([[self.json objectForKey:@"fluent_english"] intValue] == 1) {
        Language = @"English";
    }
    if ([[self.json objectForKey:@"is_veteran"] intValue] == 0) {
        Veteran = @"Not a Military Veteran";
    }
    if ([[self.json objectForKey:@"is_veteran"] intValue] == 1) {
        Veteran = @"Is a Military Veteran";
    }
    self.lblInfoBio.text = [NSString stringWithFormat:@"VISIBLE BODY ART:\n%@\nDRIVERS LICENSE:\n%@\nSPEAKS FLUENT:\n%@\nVETERAN:\n%@",BodyArt, DriversLicense, Language ,Veteran];
    self.btnBio.selected = TRUE;
    self.lblInfoBio.alpha = 0;
    if (self.btnInfo.selected == FALSE) {
        [self.btnBio setBackgroundColor:[UIColor colorWithRed:(150/255.0) green:(212/255.0) blue:(210/255.0) alpha:1]];
        self.bioDownArrow.alpha = 0;
        [self.btnInfo setBackgroundColor:[UIColor colorWithRed:(137/255.0) green:(194/255.0) blue:(193/255.0) alpha:1]];
        self.infoDownArrow.alpha = 1;
        self.cnstrntInfoBioViewHeight.constant = 500;
        [UIView animateWithDuration:.3 animations:^{
            [self.view layoutIfNeeded];
        }
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.lblInfoBio.alpha = 1;
                 [UIView animateWithDuration:.3 animations:^{
                 }];
             }
         }];
    } else {
        self.lblInfoBio.alpha = 0;
        [self.btnInfo setBackgroundColor:[UIColor colorWithRed:(150/255.0) green:(212/255.0) blue:(210/255.0) alpha:1]];
        [UIView animateWithDuration:.3 animations:^{
            [self.view layoutIfNeeded];
        }
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.infoDownArrow.alpha = 0;
                 self.cnstrntInfoBioViewHeight.constant = 0;
                 [UIView animateWithDuration:.3 animations:^{
                     [self.view layoutIfNeeded];
                 }];
             }
         }];
    }
}

- (IBAction)pressBio:(id)sender
{
    self.lblInfoBio.text = [self.json objectForKey:@"biography"];
    self.btnInfo.selected = TRUE;
    self.lblInfoBio.alpha = 0;
    if (self.btnBio.selected == FALSE) {
        [self.btnInfo setBackgroundColor:[UIColor colorWithRed:(150/255.0) green:(212/255.0) blue:(210/255.0) alpha:1]];
        self.infoDownArrow.alpha = 0;
        [self.btnBio setBackgroundColor:[UIColor colorWithRed:(137/255.0) green:(194/255.0) blue:(193/255.0) alpha:1]];
        self.bioDownArrow.alpha = 1;
        self.cnstrntInfoBioViewHeight.constant = 500;
        [UIView animateWithDuration:.3 animations:^{
            [self.view layoutIfNeeded];
        }
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.lblInfoBio.alpha = 1;
                 [UIView animateWithDuration:.3 animations:^{
                     [self.view layoutIfNeeded];}];
             }
         }];
    } else {
        [self.btnBio setBackgroundColor:[UIColor colorWithRed:(150/255.0) green:(212/255.0) blue:(210/255.0) alpha:1]];
        self.lblInfoBio.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            [self.view layoutIfNeeded];
        }
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.bioDownArrow.alpha = 0;
                 self.cnstrntInfoBioViewHeight.constant = 0;
                 [UIView animateWithDuration:.3 animations:^{
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
}

- (IBAction)pressMoreEdu:(id)sender
{
    NSString *SchoolStatus2;
    NSString *SchoolStatus3;
    if (self.btnEdu.isSelected ==TRUE){
        NSArray *educationArray = [self.json objectForKey:@"education"];
        if([educationArray count] >1) {
            NSDictionary *secondEducationItem = [educationArray objectAtIndex:1];
            if ([[secondEducationItem objectForKey:@"school_status_id"] intValue] == 1) {
                SchoolStatus2 = @"Enrolled";
            }
            if ([[secondEducationItem objectForKey:@"school_status_id"] intValue] == 2) {
                SchoolStatus2 = @"Graduated";
            }
            if ([[secondEducationItem objectForKey:@"school_status_id"] intValue] == 3) {
                SchoolStatus2 = @"Attended";
            }
            self.lblEdu2.text = [NSString stringWithFormat:@"%@: %@", SchoolStatus2,[secondEducationItem objectForKey:@"school"]];
            self.cnstrntEdu2Height.constant = 200;
            [UIView animateWithDuration:.3 animations:^{
                [self.view layoutIfNeeded];
            }
                             completion:^ (BOOL finished)
             {
                 if (finished) {
                     self.lblEdu2.alpha = 1;
                     [UIView animateWithDuration:.3 animations:^{
                     }];
                 }
             }];
        }
        if([educationArray count] >2) {
            NSDictionary *thirdEducationItem = [educationArray objectAtIndex:2];
            if ([[thirdEducationItem objectForKey:@"school_status_id"] intValue] == 1) {
                SchoolStatus2 = @"Enrolled";
            }
            if ([[thirdEducationItem objectForKey:@"school_status_id"] intValue] == 2) {
                SchoolStatus2 = @"Graduated";
            }
            if ([[thirdEducationItem objectForKey:@"school_status_id"] intValue] == 3) {
                SchoolStatus2 = @"Attended";
            }
            self.lblEdu3.text = [NSString stringWithFormat:@"%@: %@", SchoolStatus3,[thirdEducationItem objectForKey:@"school"]];
            self.cnstrntEdu3Height.constant = 200;
            [UIView animateWithDuration:.3 animations:^{
                [self.view layoutIfNeeded];
            }
                             completion:^ (BOOL finished)
             {
                 if (finished) {
                     self.lblEdu3.alpha = 1;
                     [UIView animateWithDuration:.3 animations:^{
                         [self.view layoutIfNeeded];
                     }];
                 }
             }];
        }
    } else {
        self.lblEdu2.alpha = 0;
        self.lblEdu3.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            [self.view layoutIfNeeded];
        }
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.cnstrntEdu2Height.constant = 0;
                 self.cnstrntEdu3Height.constant = 0;
                 [UIView animateWithDuration:.3 animations:^{
                     [self.view layoutIfNeeded];
                 }];
             }
         }];
    }
}

- (IBAction)pressMoreExp:(id)sender
{
    NSString *JobLength1;
    NSString *JobLength2;
    NSString *JobLength3;
    NSString *JobStatus1;
    NSString *JobStatus2;
    NSString *JobStatus3;
    if (self.btnExp.isSelected ==TRUE) {
        NSArray *experienceArray = [self.json objectForKey:@"experience"];
        if([experienceArray count] > 0) {
            NSDictionary *firstExperienceItem = [experienceArray objectAtIndex:0];
            if ([[firstExperienceItem objectForKey:@"job_length"] intValue] == 1) {
                JobLength1 = @"Under 1 Year";
            }
            if ([[firstExperienceItem objectForKey:@"job_length"] intValue] == 2) {
                JobLength1 = @"1-2 Years";
            }
            if ([[firstExperienceItem objectForKey:@"job_length"] intValue] == 3) {
                JobLength1 = @"Over 2 Years";
            }
            if ([[firstExperienceItem objectForKey:@"status"] intValue] == 1) {
                JobStatus1 = @"Current";
            }
            if ([[firstExperienceItem objectForKey:@"status"] intValue] == 2) {
                JobStatus1 = @"Previous";
            }
            self.lblExp1.text = [NSString stringWithFormat:@"%@: %@, %@ [ %@ ]", JobStatus1,[firstExperienceItem objectForKey:@"company"], [firstExperienceItem objectForKey:@"position"], JobLength1];
        }
        if([experienceArray count] > 1) {
            NSDictionary *secondExperienceItem = [experienceArray objectAtIndex:1];
            if ([[secondExperienceItem objectForKey:@"job_length"] intValue] == 1) {
                JobLength2 = @"Under 1 Year";
            }
            if ([[secondExperienceItem objectForKey:@"job_length"] intValue] == 2) {
                JobLength2 = @"1-2 Years";
            }
            if ([[secondExperienceItem objectForKey:@"job_length"] intValue] == 3) {
                JobLength2 = @"Over 2 Years";
            }
            if ([[secondExperienceItem objectForKey:@"status"] intValue] == 1) {
                JobStatus2 = @"Current";
            }
            if ([[secondExperienceItem objectForKey:@"status"] intValue] == 2) {
                JobStatus2 = @"Previous";
            }
            self.lblExp2.text = [NSString stringWithFormat:@"%@: %@, %@ [ %@ ]", JobStatus2,[secondExperienceItem objectForKey:@"company"], [secondExperienceItem objectForKey:@"position"], JobLength2];
            self.cnstrntExp2Height.constant = 200;
            [UIView animateWithDuration:.3 animations:^{
                [self.view layoutIfNeeded];
            }
                             completion:^ (BOOL finished)
             {
                 if (finished) {
                     self.lblExp2.alpha = 1;
                     [UIView animateWithDuration:.3 animations:^{
                     }];
                 }
             }];
        }
        if([experienceArray count] > 2) {
            NSDictionary *thirdExperinceItem = [experienceArray objectAtIndex:2];
            if ([[thirdExperinceItem objectForKey:@"job_length"] intValue] == 1) {
                JobLength3 = @"Under 1 Year";
            }
            if ([[thirdExperinceItem objectForKey:@"job_length"] intValue] == 2) {
                JobLength3 = @"1-2 Years";
            }
            if ([[thirdExperinceItem objectForKey:@"job_length"] intValue] == 3) {
                JobLength3 = @"Over 2 Years";
            }
            if ([[thirdExperinceItem objectForKey:@"status"] intValue] == 1) {
                JobStatus3 = @"Current";
            }
            if ([[thirdExperinceItem objectForKey:@"status"] intValue] == 2) {
                JobStatus3 = @"Previous";
            }
            self.lblExp3.text = [NSString stringWithFormat:@"%@: %@, %@ [ %@ ]", JobStatus3,[thirdExperinceItem objectForKey:@"company"], [thirdExperinceItem objectForKey:@"position"], JobLength3];
            self.cnstrntExp3Height.constant = 200;
            [UIView animateWithDuration:.3 animations:^{
                [self.view layoutIfNeeded];
            }
                             completion:^ (BOOL finished)
             {
                 if (finished) {
                     self.lblExp3.alpha = 1;
                     [UIView animateWithDuration:.3 animations:^{
                     }];
                 }
             }];
        }
    } else {
        NSArray *experienceArray = [self.json objectForKey:@"experience"];
        if([experienceArray count] > 0) {
            NSDictionary *firstExperienceItem = [experienceArray objectAtIndex:0];
            if ([[firstExperienceItem objectForKey:@"status"] intValue] == 1) {
                JobStatus1 = @"Current";
            }
            if ([[firstExperienceItem objectForKey:@"status"] intValue] == 2) {
                JobStatus1 = @"Previous";
            }
            self.lblExp1.text = [NSString stringWithFormat:@"%@: %@, %@", JobStatus1,[firstExperienceItem objectForKey:@"company"], [firstExperienceItem objectForKey:@"position"]];
        }
        self.lblExp2.alpha = 0;
        self.lblExp3.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            [self.view layoutIfNeeded];
        }
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.cnstrntExp2Height.constant = 0;
                 self.cnstrntExp3Height.constant = 0;
                 [UIView animateWithDuration:.3 animations:^{
                     [self.view layoutIfNeeded];
                 }];
             }
         }];
    }
}

- (IBAction)pressFavorite:(id)sender
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.searchID forKey:@"search_id"];
    [params setObject:self.profileID forKey:@"user_id"];
    if (self.btnFavorite.selected == NO) {
        if([params count]) {
            [manager POST:@"http://uwurk.tscserver.com/api/v1/add_favorite_employee" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"\nAdd Favorite - Json Response: \n%@", responseObject);
                    self.btnFavorite.selected = YES;
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    [self handleErrorAccessError:@"Profile Add Favorite" withError:error];
                }];
        }
    } else {
        if([params count]){
            [manager POST:@"http://uwurk.tscserver.com/api/v1/remove_favorite_employee" parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"\nRemove Favorite - Json Response: \n%@", responseObject);
                self.btnFavorite.selected = NO;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [self handleErrorAccessError:@"Profile Remove Favorite" withError:error];
            }];
        }
    }
}

- (IBAction)changeCheckBox:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
}

- (IBAction)pressContact:(id)sender
{
    ContactProfileViewController *myController = [[UIStoryboard storyboardWithName:@"Mail" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactProfileViewController"];

    [myController setParamHolder:self.paramHolder];
    [myController setSearchUserDict:self.searchedUserDict];
    [self.navigationController pushViewController:myController animated:TRUE];
}

@end
