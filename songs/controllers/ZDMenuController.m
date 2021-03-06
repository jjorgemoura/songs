//
//  ZDMenuController.m
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDMenuController.h"
#import "ZDMainController.h"


@interface ZDMenuController ()

@property (nonatomic, copy) NSString *theProjectID;

@end


@implementation ZDMenuController


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Contructor
//---------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Controller Lifecycle
//---------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Segue StoryBoard
//---------------------------------------------------------------------------------------

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    // configure the segue.
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {

        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        SWRevealViewController* rvc = [self revealViewController];
 
        
        if([[segue identifier] isEqualToString:@"menu_create"]) {

            ZDNewProjectController *nextVC = [segue destinationViewController];
            [nextVC setDelegate:self];
            //[[segue destinationViewController] setDelegate:self];
        }
        
        if([[segue identifier] isEqualToString:@"menu_load"]) {
            
            ZDLoadProjectController *nextVC = [segue destinationViewController];
            [nextVC setDelegate:self];
        }
        
        if([[segue identifier] isEqualToString:@"menu_main"]) {
            
            ZDMainController *nextVC = [segue destinationViewController];
            [nextVC changeProjectToProjectWithID:[self theProjectID]];
        }
        
        if([[segue identifier] isEqualToString:@"menu_settings"]) {
            //NSLog(@"SEGUE: menu_settings");
        }
        
        
 
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
     
                UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc ];
                [rvc pushFrontViewController:nc animated:YES];
            };
    }
}




//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - TableView DataSource
//---------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"no_Cell";
    
    switch (indexPath.row)
    {
        case 0:
            cellIdentifier = @"MY_MENUMAIN_CELL";
            break;
            
        case 1:
            cellIdentifier = @"MY_MENUNEW_CELL";
            break;
            
        case 2:
            cellIdentifier = @"MY_MENULOAD_CELL";
            break;
            
        case 3:
            cellIdentifier = @"MY_MENUSETTINGS_CELL";
            break;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    return cell;
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - ZDNewProjectController Delegate
//---------------------------------------------------------------------------------------
- (void)viewController:(ZDNewProjectController *)viewController willSaveZDProject:(NSString *)projectName {
    
    //NSLog(@"New Project will Save");
}

- (void)viewController:(ZDNewProjectController *)viewController didSaveZDProjectWithID:(NSString *)projectID andMessage:(NSString *)message {
    
    //NSLog(@"New Project did Save");
    
    
    
    
    //Save into NSUserDefault
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (projectID) {
    
        [userDefaults setObject:projectID  forKey:@"projectID"];
        //[userDefaults synchronize];
        
        //set local param
        [self setTheProjectID:projectID];
    }
    
    
    
    //Perform Segue
    [self performSegueWithIdentifier:@"menu_main" sender:self];
    
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - ZDLoadProjectControllerDelegate Delegate
//---------------------------------------------------------------------------------------
- (void)viewController:(ZDLoadProjectController *)viewController didLoadZDProjectWithID:(NSString *)projectID {

    //NSLog(@"Load Project did load");
    
    //Save into NSUserDefault
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (projectID) {
        
        [userDefaults setObject:projectID  forKey:@"projectID"];
        //[userDefaults synchronize];
        
        //set local param
        [self setTheProjectID:projectID];
    }
    
    
    
    //Perform Segue
    [self performSegueWithIdentifier:@"menu_main" sender:self];
}


- (void)viewController:(ZDLoadProjectController *)viewController didDeleteZDProjectWithID:(NSString *)projectID {

    
    if (!projectID) {
        
        return;
    }

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *projectIDStored = [userDefaults objectForKey:@"projectID"];
    
    if (projectIDStored) {
     
        if ([projectID isEqualToString:projectIDStored]) {
            
            //delete from NSUserDefaults
            [userDefaults setObject:nil  forKey:@"projectID"];
        }
    }
}



@end




