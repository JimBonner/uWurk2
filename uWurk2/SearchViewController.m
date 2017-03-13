//
//  SearchViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/8/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import "SearchViewController.h"
#import "ListSelectorTableViewController.h"
#import "SearchResultsTableViewController.h"
#import "RadioButton.h"
#import "MailFoldersViewController.h"
#import "DashboardMenuTableViewController.h"
#import "FPPopoverController.h"
#import "FPPopoverView.h"
#import "FPTouchView.h"
#import "EmployerDashboardSavedSearchesViewController.h"
#import "EmployerDashboardRecentSearchesViewController.h"
#import "IntroViewController.h"
#import "EditEmployerPreferencesViewController.h"
#import "EditEmployerCompanyInfoViewController.h"
#import "EditEmployerContactInfoViewController.h"


@interface SearchViewController () <ExperienceFilterAddCollectionViewCellDelegate, ExperienceFilterExistingCollectionViewCellDelegate, EmployerDashboardSavedSearchesViewControllerProtocol, EmployerDashboardRecentSearchesViewControllerProtocol>
@property (weak, nonatomic) IBOutlet UIButton *btnIndustry;
@property (weak, nonatomic) IBOutlet UIButton *btnPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblRecentSearch;
@property (strong, nonatomic) FPPopoverController *popover;
@property (weak, nonatomic) IBOutlet UITextField *txtZip;
@property (weak, nonatomic) IBOutlet UITextField *txtHourly;
@property (weak, nonatomic) IBOutlet UIButton *btnTipped;
@property (weak, nonatomic) IBOutlet UIButton *btnHourly;
@property (weak, nonatomic) IBOutlet RadioButton *btnFullTime;
@property (weak, nonatomic) IBOutlet RadioButton *btnPartTime;
@property (weak, nonatomic) IBOutlet RadioButton *btnTemporary;
@property (weak, nonatomic) IBOutlet RadioButton *btnExpYes;
@property (weak, nonatomic) IBOutlet RadioButton *btnExpNo;
@property (weak, nonatomic) IBOutlet UIView *viewMaxHourly;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *experienceFiltersCollectionViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *experienceFiltersCollectionView;
@property (strong, nonatomic) NSMutableArray *experienceItems;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMenuNotification:)
                                                 name:@"MenuNotification"
                                               object:nil];

    
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn-contact-white-min"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(pressMail:)];
    
    self.navigationItem.rightBarButtonItem=_btn;
    
    self.experienceItems = [NSMutableArray new];
      
    UIImage *faceImage = [UIImage imageNamed:@"hamburger"];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    [face addTarget: self action: @selector(menuPress) forControlEvents: UIControlEventTouchUpInside];
    face.bounds = CGRectMake( 0, 0, faceImage.size.width, faceImage.size.height );
    [face setImage:faceImage forState:UIControlStateNormal];
    UIBarButtonItem *faceBtn = [[UIBarButtonItem alloc] initWithCustomView:face];
    
    //    [UIView animateWithDuration:0.5 animations:^(void) {
    [[self navigationItem] setLeftBarButtonItem:faceBtn];
    self.experienceFiltersCollectionView.layer.borderWidth = 2;
    self.experienceFiltersCollectionView.layer.borderColor = [UIColor grayColor].CGColor;

}
-(IBAction)menuPress{
    DashboardMenuTableViewController *controller = [[DashboardMenuTableViewController alloc] init];
    controller.menuFileName = @"employerMenu";
    
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

-(void)SelectionMade:(NSMutableDictionary *)dict {

    SearchResultsTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"employeeListID"];
    [myController setParameters:dict];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/search"];
    
    
    [self.navigationController pushViewController:myController animated:TRUE];

}

-(IBAction)receiveMenuNotification:(NSNotification*)sender{
    
    if([[sender.object objectForKey:@"ViewController"] isEqualToString:@"LogoutViewController"]) {
        [self.popover dismissPopoverAnimated:FALSE];
        [self logout];
    }
    else if([[sender.object objectForKey:@"ViewController"] isEqualToString:@"EmployerDashboardSavedSearchesViewController"]) {
        EmployerDashboardSavedSearchesViewController *myController = [[UIStoryboard storyboardWithName:@"EmployerProfile" bundle:nil] instantiateViewControllerWithIdentifier:[sender.object objectForKey:@"ViewController"]];
        myController.delegate = self;
        [self.navigationController pushViewController:myController animated:TRUE];
        [self.popover dismissPopoverAnimated:TRUE];
    }
    else if([[sender.object objectForKey:@"ViewController"] isEqualToString:@"EmployerDashboardRecentSearchesViewController"]) {
        EmployerDashboardSavedSearchesViewController *myController = [[UIStoryboard storyboardWithName:@"EmployerProfile" bundle:nil] instantiateViewControllerWithIdentifier:[sender.object objectForKey:@"ViewController"]];
        myController.delegate = self;
        [self.navigationController pushViewController:myController animated:TRUE];
        [self.popover dismissPopoverAnimated:TRUE];
    }
    else if([[sender.object objectForKey:@"ViewController"] isEqualToString:@"EmployerDashboardContactViewController"]) {
        EditEmployerContactInfoViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[sender.object objectForKey:@"ViewController"]];
//        myController.delegate = self;
        [self.navigationController pushViewController:myController animated:TRUE];
        [self.popover dismissPopoverAnimated:TRUE];
    }
    else if([[sender.object objectForKey:@"ViewController"] isEqualToString:@"EmployerDashboardCompanyInfoViewController"]) {
        EditEmployerCompanyInfoViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[sender.object objectForKey:@"ViewController"]];
//        myController.delegate = self;
        [self.navigationController pushViewController:myController animated:TRUE];
        [self.popover dismissPopoverAnimated:TRUE];
    }
    else if([[sender.object objectForKey:@"ViewController"] isEqualToString:@"EmployeeDashboardBioViewController"]) {
        EditEmployerPreferencesViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[sender.object objectForKey:@"ViewController"]];
        //myController.delegate = self;
        [self.navigationController pushViewController:myController animated:TRUE];
        [self.popover dismissPopoverAnimated:TRUE];
    }

    
}

- (IBAction)pressMail:(id)sender {
    MailFoldersViewController *myController = [[UIStoryboard storyboardWithName:@"Mail" bundle:nil] instantiateViewControllerWithIdentifier:@"MailFolders"];
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.btnHourly.isSelected)
       self.viewMaxHourly.alpha = 1;
    else
    self.viewMaxHourly.alpha = 0;
    if (self.btnExpYes.isSelected) {
    }
    [self.view layoutIfNeeded];
    [self.experienceFiltersCollectionView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)pressHourly:(id)sender {
    if (self.btnHourly.isSelected) {
        [UIView animateWithDuration:.3 animations:^{
            self.viewMaxHourly.alpha = 1;
            [self.view layoutIfNeeded];
        }];
    }
    else {
        [UIView animateWithDuration:.3 animations:^{
            self.viewMaxHourly.alpha = 0;
            [self.view layoutIfNeeded];
        }];
    }
    
}

- (IBAction)recentSearchPress:(id)sender {
}
//- (IBAction)pressExpYes:(id)sender {
//    self.cnstrntExpHeight.constant = 525;
//    [UIView animateWithDuration:.3 animations:^{
//        [self.view layoutIfNeeded];
//    }
//                     completion:^ (BOOL finished)
//     {
//         self.experienceFiltersCollectionViewHeight.constant = 200;
//         [self.view layoutIfNeeded];
//         
//         if (finished) {
//             [UIView animateWithDuration:.3 animations:^{
//                 self.viewExp.alpha = 1;
//                 [self.experienceFiltersCollectionView reloadData];
//             }];
//         }
//     }];
//}
//- (IBAction)pressExpNo:(id)sender {
//    [UIView animateWithDuration:.3 animations:^{
//        self.viewExp.alpha = 0;
//        [self.view layoutIfNeeded];
//    }
//                     completion:^ (BOOL finished)
//     {
//         if (finished) {
//             [UIView animateWithDuration:.3 animations:^{
//                 self.cnstrntExpHeight.constant = 0;
//                 [self.view layoutIfNeeded];
//             }];
//         }
//     }];
//}


- (IBAction)industryPress:(id)sender {
    
    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    
    [myController setParameters:nil];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/industries"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"industries"];
    [myController setSender:self.btnIndustry];
    [myController setTitle:@"Industries"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
    
}
- (IBAction)positionPress:(id)sender {
    
    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    
    [myController setParameters:@{@"industry_id":[self.btnIndustry titleForState:UIControlStateSelected]}];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/positions"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"positions"];
    [myController setSender:self.btnPosition];
    [myController setTitle:@"Positions"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
    
}
//- (IBAction)expPositionPress:(id)sender {
//    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
//    
//    
//    [myController setParameters:@{@"industry_id":[self.btnIndustry titleForState:UIControlStateSelected]}];
//    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/positions"];
//    [myController setDisplay:@"description"];
//    [myController setKey:@"id"];
//    [myController setDelegate:self];
//    [myController setJsonGroup:@"positions"];
//    [myController setSender:self.btnExpPosition];
//    [myController setTitle:@"Positions"];
//    
//    [self.navigationController pushViewController:myController animated:TRUE];
//}
//- (IBAction)addExpIndustry1:(id)sender {
//    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
//    
//    
//    [myController setParameters:nil];
//    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/industries"];
//    [myController setDisplay:@"description"];
//    [myController setKey:@"id"];
//    [myController setDelegate:self];
//    [myController setJsonGroup:@"positions"];
//    [myController setSender:self.btnAddExpIndustry1];
//    [myController setTitle:@"Positions"];
//    
//    [self.navigationController pushViewController:myController animated:TRUE];
//}
//- (IBAction)addExpIndustry2:(id)sender {
//    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
//    
//    
//    [myController setParameters:nil];
//    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/industries"];
//    [myController setDisplay:@"description"];
//    [myController setKey:@"id"];
//    [myController setDelegate:self];
//    [myController setJsonGroup:@"positions"];
//    [myController setSender:self.btnAddExpIndustry2];
//    [myController setTitle:@"Positions"];
//    
//    [self.navigationController pushViewController:myController animated:TRUE];
//}
//- (IBAction)addExpIndustry3:(id)sender {
//    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
//    
//    
//    [myController setParameters:nil];
//    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/industries"];
//    [myController setDisplay:@"description"];
//    [myController setKey:@"id"];
//    [myController setDelegate:self];
//    [myController setJsonGroup:@"positions"];
//    [myController setSender:self.btnAddExpIndustry3];
//    [myController setTitle:@"Positions"];
//    
//    [self.navigationController pushViewController:myController animated:TRUE];
//}
//- (IBAction)addExpPosition1:(id)sender {
//    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
//    
//    
//    [myController setParameters:@{@"industry_id":[self.btnAddExpIndustry1 titleForState:UIControlStateSelected]}];
//    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/positions"];
//    [myController setDisplay:@"description"];
//    [myController setKey:@"id"];
//    [myController setDelegate:self];
//    [myController setJsonGroup:@"positions"];
//    [myController setSender:self.btnAddExpPosition1];
//    [myController setTitle:@"Positions"];
//    
//    [self.navigationController pushViewController:myController animated:TRUE];
//}
//- (IBAction)addExpPosition2:(id)sender {
//    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
//    
//    
//    [myController setParameters:@{@"industry_id":[self.btnAddExpIndustry2 titleForState:UIControlStateSelected]}];
//    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/positions"];
//    [myController setDisplay:@"description"];
//    [myController setKey:@"id"];
//    [myController setDelegate:self];
//    [myController setJsonGroup:@"positions"];
//    [myController setSender:self.btnAddExpPosition2];
//    [myController setTitle:@"Positions"];
//    
//    [self.navigationController pushViewController:myController animated:TRUE];
//}
//- (IBAction)addExpPosition3:(id)sender {
//    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
//    
//    
//    [myController setParameters:@{@"industry_id":[self.btnAddExpIndustry3 titleForState:UIControlStateSelected]}];
//    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/positions"];
//    [myController setDisplay:@"description"];
//    [myController setKey:@"id"];
//    [myController setDelegate:self];
//    [myController setJsonGroup:@"positions"];
//    [myController setSender:self.btnAddExpPosition3];
//    [myController setTitle:@"Positions"];
//    
//    [self.navigationController pushViewController:myController animated:TRUE];
//}

- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}

//- (IBAction)pressOtherIndustries:(id)sender {
//    int counter = 0;
//    counter = +1;
//    if ((counter = 1)) {
//        [UIView animateWithDuration:.3 animations:^{
//            self.heightAdditionalExp1.constant = 100;
//            [self.view layoutIfNeeded];
//        }
//                         completion:^ (BOOL finished)
//         {
//             if (finished) {
//                 [UIView animateWithDuration:.3 animations:^{
//                     self.viewAddExp1.alpha = 1;
//                     [self.view layoutIfNeeded];
//                 }];
//             }
//         }];
//        
//        
//    }
//    if ((counter = 2)) {
//        [UIView animateWithDuration:.3 animations:^{
//            self.heightAdditionalExp2.constant = 100;
//            [self.view layoutIfNeeded];
//        }
//                         completion:^ (BOOL finished)
//         {
//             if (finished) {
//                 [UIView animateWithDuration:.3 animations:^{
//                     self.viewAddExp2.alpha = 1;
//                     [self.view layoutIfNeeded];
//                 }];
//             }
//         }];
//        
//        
//    }
//    if ((counter = 3)) {
//        [UIView animateWithDuration:.3 animations:^{
//            self.heightAdditionalExp3.constant = 100;
//            [self.view layoutIfNeeded];
//        }
//                         completion:^ (BOOL finished)
//         {
//             if (finished) {
//                 [UIView animateWithDuration:.3 animations:^{
//                     self.viewAddExp3.alpha = 1;
//                     [self.view layoutIfNeeded];
//                 }];
//             }
//         }];
//        
//        
//    }
//}


- (IBAction)searchPress:(id)sender {
    NSMutableDictionary *parmdic = [[NSMutableDictionary alloc]init];
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.btnHourly.selected == NO && self.btnTipped.selected == NO) {
        [Error appendString:@"\n\nWage Type"];
    }
    if (self.btnFullTime.selected == NO && self.btnPartTime.selected == NO && self.btnTemporary.selected == NO) {
        [Error appendString:@"\n\nPosition Type"];
    }
    if ([[self.txtZip text] length] != 5) {
        [Error appendString:@"\n\nZip Code"];
    }
    if (self.btnExpYes.selected == NO && self.btnExpYes.selected == NO) {
        [Error appendString:@"\n\nExperience Requirement"];
    }
    if ([[self.btnIndustry titleForState:UIControlStateNormal]isEqualToString:@"Select Industry"]) {
        [Error appendString:@"\n\nSelect Industry"];
    }
    if ([[self.btnPosition titleForState:UIControlStateNormal]isEqualToString:@"Select Position"]) {
        [Error appendString:@"\n\nSelect Position"];
    }
    if ((Error.length) > 50) {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"OOPS!"
                                                         message:Error
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
    }
    else {
        if(self.btnFullTime.isSelected) {
            [self updateParamDict:parmdic value:@"1" key:@"hours"];
        }
        else if(self.btnPartTime.isSelected) {
            [self updateParamDict:parmdic value:@"2" key:@"hours"];
        }
        // Experence
        self.btnExpNo.isSelected == TRUE ? [self updateParamDict:parmdic value:@"0" key:@"exp_required"] : [self updateParamDict:parmdic value:@"1" key:@"exp_required"];
        
        if(self.btnHourly.isSelected) {
            [self updateParamDict:parmdic value:@"1" key:@"wage_type_hourly"];
            [self updateParamDict:parmdic value:self.txtHourly.text key:@"hourly_wage"];
        }
        if (self.btnTipped.isSelected) {
            // FORCE BY ROB, field is not displaying
            [self updateParamDict:parmdic value:@"1" key:@"wage_type_tipped"];
            
        }
        
        [self updateParamDict:parmdic value:@"new" key:@"search_type"];
        
        if(self.btnFullTime.isSelected && self.btnPartTime.isSelected)
        {
            
        }
        [self updateParamDict:parmdic value:self.txtZip.text key:@"zip"];
        
        SearchResultsTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"employeeListID"];
        
        if ([[self.btnIndustry titleForState:UIControlStateSelected] length] >0){
            [parmdic setObject:[self.btnIndustry titleForState:UIControlStateSelected] forKey:@"industry"];
        }
        if ([[self.btnPosition titleForState:UIControlStateSelected] length] >0){
            [parmdic setObject:[self.btnPosition titleForState:UIControlStateSelected] forKey:@"position"];
        }
        if ([[self.btnPosition titleForState:UIControlStateSelected] length] >0){
            [parmdic setObject:[self.btnPosition titleForState:UIControlStateSelected] forKey:@"exp_positions[]"];
        }
    [myController setParameters:parmdic];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/search"];
    
    
    [self.navigationController pushViewController:myController animated:TRUE];
    
    }
}

#pragma mark Collection View Methods

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return [self.experienceItems count] + 1;
//}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if(indexPath.row < [self.experienceItems count]) {
//        
//        ExperienceFilterExistingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExperienceFilterCellExisting" forIndexPath:indexPath];
//        if (!cell) {
//            cell = [[ExperienceFilterExistingCollectionViewCell alloc] init];
//        }
//        ExperienceFilterItem *item = [self.experienceItems objectAtIndex:indexPath.row];
//        cell.delegate = self;
//        cell.backgroundColor = [UIColor greenColor];
//        cell.layer.cornerRadius = 5.0f;
//        cell.filterName.text = item.jobDesc;
//        cell.experienceID = item.jobID;
//        //[cell addDropShadowWithColor:[UIColor KNGDropShadowGray]];
//        return cell;
//    }
//    else {
//        ExperienceFilterAddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExperienceFilterCellAdd" forIndexPath:indexPath];
//        if (!cell) {
//            cell = [[ExperienceFilterAddCollectionViewCell alloc] init];
//        }
//        cell.delegate = self;
//        cell.backgroundColor = [UIColor whiteColor];
//        cell.layer.cornerRadius = 5.0f;
//        //[cell addDropShadowWithColor:[UIColor KNGDropShadowGray]];
//        return cell;
//    }
//}

//- (void)removeExperience:(NSString*)experienceID{
//    
//    for(int i=0; i < [self.experienceItems count]; ++i){
//        ExperienceFilterItem *item = [self.experienceItems objectAtIndex:i];
//        if([item.jobID isEqualToString:experienceID]) {
//            [self.experienceItems removeObjectAtIndex:i];
//            break;
//        }
//    }
//    [self.experienceFiltersCollectionView reloadData];
//}


//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.row >= [self.experienceItems count]) {
//        ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
//        
//        [myController setParameters:@{@"industry_id":[self.btnIndustry titleForState:UIControlStateSelected]}];
//        [myController setUrl:@"http://uwurk.tscserver.com/api/v1/positions"];
//        [myController setDisplay:@"description"];
//        [myController setKey:@"id"];
//        [myController setDelegate:self];
//        [myController setJsonGroup:@"positions"];
//        [myController setSender:self.btnPosition];
//        [myController setTitle:@"Positions"];
//        myController.collectionViewArray = self.experienceItems;
//        
//        [self.navigationController pushViewController:myController animated:TRUE];
//    }
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 30);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 20, 10, 20);
}



@end

@interface ExperienceFilterAddCollectionViewCell()

@end

@implementation ExperienceFilterAddCollectionViewCell



@end

@interface ExperienceFilterExistingCollectionViewCell()

@end

@implementation ExperienceFilterExistingCollectionViewCell
- (IBAction)btnRemovePress:(id)sender {
    [self.delegate removeExperience:self.experienceID];
}

@end

@interface ExperienceFilterItem()
@end
@implementation ExperienceFilterItem
@end



