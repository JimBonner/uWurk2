//
//  EmployeeViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 8/31/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import "EmployeeViewController.h"
#import "DashboardMenuTableViewController.h"
#import "FPPopoverController.h"
#import "FPPopoverView.h"
#import "FPTouchView.h"
#import "ARCMacros.h"
#import "MailFoldersViewController.h"
#import "UrlImageRequest.h"
#import "IntroViewController.h"

@interface EmployeeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAgeWage;
@property (strong, nonatomic) FPPopoverController *popover;
@property (weak, nonatomic) IBOutlet UILabel *lblExp1;
@property (weak, nonatomic) IBOutlet UILabel *lblExp2;
@property (weak, nonatomic) IBOutlet UILabel *lblExp3;
@property (weak, nonatomic) IBOutlet UILabel *lblEdu1;
@property (weak, nonatomic) IBOutlet UILabel *lblEdu2;
@property (weak, nonatomic) IBOutlet UILabel *lblEdu3;
@property (weak, nonatomic) IBOutlet UIButton *btnBio;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntInfoBioViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntExp1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntExp2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntExp3Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntEdu2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntEdu3Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntExpWholeHeight;
@property (weak, nonatomic) IBOutlet UIView *viewExpWhole;
@property (weak, nonatomic) IBOutlet UIButton *btnEdu;
@property (weak, nonatomic) IBOutlet UIButton *btnExp;
@property (weak, nonatomic) IBOutlet UILabel *lblInfoBio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntInfoBio;
@property (weak, nonatomic) IBOutlet UIButton *btnMail;
@property (weak, nonatomic) IBOutlet UIImageView *userImages;
@property (weak, nonatomic) IBOutlet UIImageView *bioDownArrow;
@property (weak, nonatomic) IBOutlet UIImageView *infoDownArrow;
@property (weak, nonatomic) IBOutlet UIButton *imageProfileDog;

@end

@implementation EmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMenuNotification:)
                                                 name:@"MenuNotification"
                                               object:nil];
    UIBarButtonItem *btnMail=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn-contact-white-min"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(pressMail:)];
    UIBarButtonItem *btnRef=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav-referral-black-min"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(pressRef:)];
    
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnMail, btnRef, nil];


    
}

- (IBAction)pressRef:(id)sender {
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferralProgram"];
    [self.navigationController pushViewController:myController animated:TRUE];
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *SchoolStatus1;
    NSString *JobStatus1;
    NSString *TipWork;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthday = [dateFormatter dateFromString:[self.appDelegate.user objectForKey:@"birthdate"]];
    NSDate *now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:birthday toDate:now options:0];
    NSInteger age = [ageComponents year];
    self.lblName.text = [NSString stringWithFormat:@"%@ %@",[self.appDelegate.user objectForKey:@"first_name"], [self.appDelegate.user objectForKey:@"last_name"]];
    
    id tp = [self.appDelegate.user objectForKey:@"tipped_position"];
    if ([tp intValue] == 1 ){
        
    }
    if ([[self.appDelegate.user objectForKey:@"tipped_position"] intValue] == 1) {
        TipWork = @"or Tips";
    } else {
        TipWork = @"";
    }
    if ([[self.appDelegate.user objectForKey:@"num_logins"]intValue] == 1) {
        UIImage *image = [UIImage imageNamed: @"Sit Back Relax-min"];
        [self.imageProfileDog setImage:image forState:UIControlStateNormal];
    }
    self.lblAgeWage.text = [NSString stringWithFormat:@"Age: %ld  |  $%@/hr %@",(long)age, [self.appDelegate.user objectForKey:@"hourly_wage"], TipWork];
    
    NSArray *experienceArray = [self.appDelegate.user objectForKey:@"experience"];
    if([experienceArray count] >0) {
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
        self.cnstrntExpWholeHeight.constant = 0;
        self.cnstrntExp1Height.constant = 0;
        self.lblExp1.alpha = 0;
        self.viewExpWhole.alpha = 0;
    }

    NSArray *educationArray = [self.appDelegate.user objectForKey:@"education"];
    if([educationArray count] >0) {
        NSDictionary *firstEducationItem = [educationArray objectAtIndex:0];
        if ([[firstEducationItem objectForKey:@"school_status_id"]  intValue] == 1) {
            SchoolStatus1 = @"Enrolled";
        }
        if ([[firstEducationItem objectForKey:@"school_status_id"]  intValue] == 2) {
            SchoolStatus1 = @"Graduated";
        }
        if ([[firstEducationItem objectForKey:@"school_status_id"]  intValue] == 3) {
            SchoolStatus1 = @"Attended";
        }
        self.lblEdu1.text = [NSString stringWithFormat:@"%@: %@", SchoolStatus1,[firstEducationItem objectForKey:@"school"]];
    }
    if ([self.appDelegate.user objectForKey:@"biography"] == (id)[NSNull null] || [[self.appDelegate.user objectForKey:@"biography"]length] == 0 ) {
        [self.btnBio setBackgroundColor:[UIColor colorWithRed:(254/255.0) green:(219/255.0) blue:(86/255.0) alpha:1]];
        [self.btnBio setTitle:@"ADD BIO" forState:UIControlStateNormal];
        [self.btnBio setTitle:@"ADD BIO" forState:UIControlStateHighlighted];
        [self.btnBio setTitle:@"ADD BIO" forState:UIControlStateSelected];
    }
    if([experienceArray count] ==0) {
        self.btnExp.alpha = 0;
    }
    if([educationArray count] <=1) {
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
    self.bioDownArrow.alpha = 0;
    self.infoDownArrow.alpha = 0;
    self.lblExp2.alpha = 0;
    self.lblExp3.alpha = 0;
    self.lblInfoBio.alpha = 0;
    self.cnstrntInfoBio.constant = 500;
    
    UIImage *faceImage = [UIImage imageNamed:@"hamburger"];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    [face addTarget: self action: @selector(menuPress) forControlEvents: UIControlEventTouchUpInside];
    face.bounds = CGRectMake( 0, 0, faceImage.size.width, faceImage.size.height );
    [face setImage:faceImage forState:UIControlStateNormal];
    UIBarButtonItem *faceBtn = [[UIBarButtonItem alloc] initWithCustomView:face];
    
    //    [UIView animateWithDuration:0.5 animations:^(void) {
    [[self navigationItem] setLeftBarButtonItem:faceBtn];
//    // Do any additional setup after loading the view.
//    NSString *bio = [self.appDelegate.user objectForKey:@"biography"];
//    if (self.cnstrntButtonToInfo.constant == 3){
//    [self.btnBio setTitle:@"ADD BIO" forState:UIControlStateNormal];
//        check for bio
//    }
    
//    [self.userImages setDelay:3]; // Delay between transitions
//    [self.userImages setTransitionDuration:1]; // Transition duration
//    [self.userImages setTransitionType:KASlideShowTransitionSlide]; // Choose a transition type (fade or slide)
//    [self.userImages setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
//  //  [self.userImages addImagesFromResources:@[@"test_1.jpeg",@"test_2.jpeg",@"test_3.jpeg"]]; // Add images from resources
//    [self.userImages addGesture:KASlideShowGestureTap]; // Gesture to go previous/next directly on
    
    NSArray *photoArray = [[self.appDelegate user] objectForKey:@"photos"];
    for(NSDictionary *photoDict in photoArray) {
        if([[photoDict objectForKey:@"for_profile"] intValue] == 1) {
            NSURL *photoURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://uwurk.tscserver.com%@",[photoDict objectForKey:@"url"]]];
            
            UrlImageRequest *photoRequest = [[UrlImageRequest alloc]initWithURL:photoURL];
            
            [photoRequest startWithCompletion:^(UIImage *newImage, NSError *error) {
                if(newImage) {
                    [self.userImages setImage:newImage];
                }
            }];
        }
    }

    [self.view layoutIfNeeded];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pressEditProfile:(id)sender {
    UITableViewController *myController = [[UIStoryboard storyboardWithName:@"EmployeeProfile" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileEditStep1"];
    [self.navigationController pushViewController:myController animated:YES];
}
- (IBAction)pressInfo:(id)sender {
    NSString *BodyArt;
    NSString *DriversLicense;
    NSString *Language;
    NSString *Veteran;
    NSString *Tattoos;
    NSString *FacePierce;
    NSString *TonguePierce;
    NSString *Gauges;
    if ([[self.appDelegate.user objectForKey:@"has_body_art"]  intValue] == 0) {
        BodyArt = @"No Body Art";
    }
    if ([[self.appDelegate.user objectForKey:@"has_tattoo"]  intValue] == 0) {
        Tattoos = @"";
    }
    if ([[self.appDelegate.user objectForKey:@"has_tattoo"]  intValue] == 1) {
        Tattoos = @"Tattoos";
    }
    if ([[self.appDelegate.user objectForKey:@"has_facial_piercing"]  intValue] == 0) {
        FacePierce = @"";
    }
    if ([[self.appDelegate.user objectForKey:@"has_facial_piercing"]  intValue] == 1) {
        FacePierce = @"Facial Piercings";
    }
    if ([[self.appDelegate.user objectForKey:@"has_tongue_piercing"]  intValue] == 0) {
        TonguePierce = @"";
    }
    if ([[self.appDelegate.user objectForKey:@"has_tongue_piercing"]  intValue] == 1) {
        TonguePierce = @"Tongue Piercing";
    }
    if ([[self.appDelegate.user objectForKey:@"has_ear_gauge"]  intValue] == 0) {
        Gauges = @"";
    }
    if ([[self.appDelegate.user objectForKey:@"has_ear_gauge"]  intValue] == 1) {
        Gauges = @"Gauges";
    }
    if ([[self.appDelegate.user objectForKey:@"has_body_art"]  intValue] == 1) {
        BodyArt = [NSString stringWithFormat:@"Has %@, %@, %@, %@", Tattoos, FacePierce, TonguePierce, Gauges];
    }
    if ([[self.appDelegate.user objectForKey:@"has_drivers_license"]  intValue] == 0) {
        DriversLicense = @"No Valid Drivers License";
    }
    if ([[self.appDelegate.user objectForKey:@"has_drivers_license"]  intValue] == 1) {
        DriversLicense = @"Has Valid Drivers License";
    }
    if ([[self.appDelegate.user objectForKey:@"fluent_english"]  intValue] == 0) {
        Language = @"";
    }
    if ([[self.appDelegate.user objectForKey:@"fluent_english"]  intValue] == 1) {
        Language = @"English";
    }
    if ([[self.appDelegate.user objectForKey:@"is_veteran"]  intValue] == 0) {
        Veteran = @"Not a Military Veteran";
    }
    if ([[self.appDelegate.user objectForKey:@"is_veteran"]  intValue] == 1) {
        Veteran = @"Is a Military Veteran";
    }
    self.lblInfoBio.text = [NSString stringWithFormat:@"VISIBLE BODY ART:\n%@\n\nDRIVERS LICENSE:\n%@\n\nSPEAKS FLUENT:\n%@\n\nVETERAN:\n%@",BodyArt, DriversLicense, Language ,Veteran];
    self.btnBio.selected = TRUE;
    self.lblInfoBio.alpha = 0;
    if (self.btnInfo.selected == FALSE) {
        [self.btnInfo setBackgroundColor:[UIColor colorWithRed:(137/255.0) green:(194/255.0) blue:(193/255.0) alpha:1]];
        [self.btnBio setBackgroundColor:[UIColor colorWithRed:(150/255.0) green:(212/255.0) blue:(210/255.0) alpha:1]];
        self.bioDownArrow.alpha = 0;
        self.infoDownArrow.alpha = 1;
        self.cnstrntInfoBioViewHeight.constant = 500;
        [UIView animateWithDuration:.3 animations:^{
            [self.view layoutIfNeeded];
        }
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.lblInfoBio.alpha = 1;
                 }];
             }
         }];
    }
    else {
        [self.btnInfo setBackgroundColor:[UIColor colorWithRed:(150/255.0) green:(212/255.0) blue:(210/255.0) alpha:1]];
        self.lblInfoBio.alpha = 0;
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
- (IBAction)pressBio:(id)sender {
    if ([self.appDelegate.user objectForKey:@"biography"] == (id)[NSNull null] || [[self.appDelegate.user objectForKey:@"biography"]length] == 0 ) {
        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditMyBio"];
        [self.navigationController pushViewController:myController animated:TRUE];
    }
    else {
    self.lblInfoBio.text = [self.appDelegate.user objectForKey:@"biography"];
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
                 [UIView animateWithDuration:.3 animations:^{
                     self.lblInfoBio.alpha = 1;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    else {
        [self.btnBio setBackgroundColor:[UIColor colorWithRed:(150/255.0) green:(212/255.0) blue:(210/255.0) alpha:1]];
    [UIView animateWithDuration:.3 animations:^{
        self.lblInfoBio.alpha = 0;
        [self.view layoutIfNeeded];
    }
    completion:^ (BOOL finished)
        {
            if (finished) {
                self.cnstrntInfoBioViewHeight.constant = 0;
                [UIView animateWithDuration:.3 animations:^{
                    self.bioDownArrow.alpha = 0;
                    [self.view layoutIfNeeded];}];
            }
        }];
    }
    }
}
- (IBAction)pressMoreEdu:(id)sender {
    NSString *SchoolStatus2;
    NSString *SchoolStatus3;
    if (self.btnEdu.isSelected ==TRUE){
    NSArray *educationArray = [self.appDelegate.user objectForKey:@"education"];
    if([educationArray count] >1) {
        NSDictionary *secondEducationItem = [educationArray objectAtIndex:1];
        if ([[secondEducationItem objectForKey:@"school_status_id"]  intValue] == 1) {
            SchoolStatus2 = @"Enrolled";
        }
        if ([[secondEducationItem objectForKey:@"school_status_id"]  intValue] == 2) {
            SchoolStatus2 = @"Graduated";
        }
        if ([[secondEducationItem objectForKey:@"school_status_id"]  intValue] == 3) {
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
        if ([[thirdEducationItem objectForKey:@"school_status_id"]  intValue] == 1) {
            SchoolStatus2 = @"Enrolled";
        }
        if ([[thirdEducationItem objectForKey:@"school_status_id"]  intValue] == 2) {
            SchoolStatus2 = @"Graduated";
        }
        if ([[thirdEducationItem objectForKey:@"school_status_id"]  intValue] == 3) {
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
    }
    else{
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

- (IBAction)pressMoreExp:(id)sender {
    NSString *JobLength1;
    NSString *JobLength2;
    NSString *JobLength3;
    NSString *JobStatus1;
    NSString *JobStatus2;
    NSString *JobStatus3;
    if (self.btnExp.isSelected ==TRUE) {
        NSArray *experienceArray = [self.appDelegate.user objectForKey:@"experience"];
        if([experienceArray count] >0) {
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
                self.cnstrntExp1Height.constant = 200;
                [UIView animateWithDuration:.3 animations:^{
                    [self.view layoutIfNeeded];
                }
                                 completion:^ (BOOL finished)
                 {
                     if (finished) {
                         self.lblExp1.alpha = 1;
                         [UIView animateWithDuration:.3 animations:^{
                         }];
                     }
                 }];
        }
    if([experienceArray count] >1) {
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
    if([experienceArray count] >2) {
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
    }
    else{
        NSArray *experienceArray = [self.appDelegate.user objectForKey:@"experience"];
        if([experienceArray count] >0) {
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

- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}

- (IBAction)pressReferral:(id)sender {
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"WhatDoIDoView"];
    [self.navigationController pushViewController:myController animated:YES];
}

-(IBAction)menuPress{
    DashboardMenuTableViewController *controller = [[DashboardMenuTableViewController alloc] init];
    controller.menuFileName = @"employeeMenu";
    
    //our popover
    self.popover = [[FPPopoverController alloc] initWithViewController:controller];
    self.popover.contentSize = CGSizeMake(200,360);
    self.popover.border = FALSE;
    //popover.tint = FPPopoverWhiteTint;
    controller.delegateNavigationController = self.navigationController;
    
    //the popover will be presented from the okButton view
    UIView *targetView = (UIView*)[self.navigationItem.leftBarButtonItem performSelector:@selector(view)];
    [self.popover presentPopoverFromView:targetView];
}

-(IBAction)receiveMenuNotification:(NSNotification*)sender{
    
    if([[sender.object objectForKey:@"ViewController"] isEqualToString:@"LogoutViewController"]) {
        [self logout];
    }
    else {
        UIViewController *myController = [[UIStoryboard storyboardWithName:@"EmployeeProfile" bundle:nil] instantiateViewControllerWithIdentifier:[sender.object objectForKey:@"ViewController"]];
        [self.navigationController pushViewController:myController animated:TRUE];
    }
    [self.popover dismissPopoverAnimated:TRUE];
}

- (IBAction)pressMail:(id)sender {
    MailFoldersViewController *myController = [[UIStoryboard storyboardWithName:@"Mail" bundle:nil] instantiateViewControllerWithIdentifier:@"MailFolders"];
    [self.navigationController pushViewController:myController animated:TRUE];
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
