//
//  ZDMainController.m
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDMainController.h"
#import "ZDSongCollectionViewCell.h"
#import "ZDCoreDataStack.h"
#import "ZDBar.h"
#import "ZDProject+Factory.h"
#import "NSManagedObjectID+ZDString.h"
#import "UIColor+HexString.h"
#import "ZDSongBlock+Factory.h"


@interface ZDMainController ()

@property (nonatomic, strong) ZDProject *theProject;

@property (nonatomic, weak) IBOutlet UIBarButtonItem* revealButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* auxRevealButtonItem;

//@property (nonatomic, weak) IBOutlet UICollectionView *mainCollectionView;

@end



@implementation ZDMainController

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Constructor
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
#pragma mark - Controll
//---------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Backgrounf color
    [[self collectionView] setBackgroundColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    
    
    
    
    
    //Prepare Default Scale
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *projectIDStored = [userDefaults objectForKey:@"projectID"];
    
    if (projectIDStored) {
        
        NSManagedObjectID *moID = [ZDCoreDataStack managedObjectIDFromString:projectIDStored];
        ZDProject *theProject = (ZDProject *)[[ZDCoreDataStack mainQueueContext] objectWithID:moID];
        [self setTheProject:theProject];
    }
    else {
        
        [[self revealViewController] performSelector:@selector(revealToggle:) withObject:self];
    }
    
    
    
    
    //
    [[self revealButtonItem] setTarget: [self revealViewController]];
    [[self revealButtonItem] setAction: @selector( revealToggle: )];
    [[[self navigationController] navigationBar] addGestureRecognizer: [[self revealViewController] panGestureRecognizer]];
    
    
    [[self auxRevealButtonItem] setTarget: [self revealViewController]];
    [[self auxRevealButtonItem] setAction: @selector( rightRevealToggle: )];
    
    
    
    
    //FetchRequest
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ZDBar"];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"theProject.name"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"theProject.name = %@", [[self theProject] name]];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order"
                                                                ascending:YES]]];
    
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:[ZDCoreDataStack mainQueueContext]
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil]];
    
    
}


- (void)viewWillAppear:(BOOL)animated {

    if ([self theProject]) {
        
        [self setTitle:[[self theProject] name]];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    
    //Save to NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([self theProject]) {
        
        NSManagedObjectID *moID = [[self theProject] objectID];
        
        [userDefaults setObject:[moID stringRepresentation]  forKey:@"projectID"];
        //[userDefaults synchronize];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - UICollectionView Data Source / Delegate
//---------------------------------------------------------------------------------------

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"MY_MAINCOLLECTION_HEADER";
//    
//    
//    return headerView;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Collection view indexpath: %li", (long)[indexPath row]);
    
    static NSString *cellIdentifier = @"MY_MAINCOLLECTION_CELL";
    
    
    ZDSongCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([indexPath section] == 0) {
        
        ZDBar *theBar = [[[self theProject] bars] objectAtIndex:[indexPath row]];
        
        NSString *theScaleNote = [theBar chordType];
        NSNumber *beats = [theBar timeSignatureBeatCount];
        NSNumber *division = [theBar timeSignatureNoteValue];
        
        NSString *theTimeSig = [NSString stringWithFormat:@"%@/%@", beats, division];
        

        UIColor *theBlockColor = [UIColor colorWithHexString:[[theBar theSongBlock] hexColor]];
        UIColor *theBlockBorderColor = [UIColor colorWithHexString:[[theBar theSongBlock] borderHexColor]];
        
        
        [cell mainText:theScaleNote];
        [cell auxText:theTimeSig];
        [cell color:theBlockColor];
        [cell borderColor:theBlockBorderColor];
    }
    
    return cell;
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Main
//---------------------------------------------------------------------------------------
- (void)changeProjectToProjectWithID:(NSString *)projectID {


    NSManagedObjectID *moID = [ZDCoreDataStack managedObjectIDFromString:projectID];
    ZDProject *theProject = (ZDProject *)[[ZDCoreDataStack mainQueueContext] objectWithID:moID];
    [self setTheProject:theProject];
    
    [[self collectionView] reloadData];
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Segue Navigation
//---------------------------------------------------------------------------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"menu_main"]) {
        NSLog(@"SEGUE: menu_main");
    }
    

    
    
//    // configure the segue.
//    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
//        
//        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
//        SWRevealViewController* rvc = [self revealViewController];
//        
//        
//        if([[segue identifier] isEqualToString:@"menu_create"]) {
//            
//            ZDNewProjectController *nextVC = [segue destinationViewController];
//            [nextVC setDelegate:self];
//            //[[segue destinationViewController] setDelegate:self];
//        }
//        
//        if([[segue identifier] isEqualToString:@"menu_main"]) {
//            
//            ZDMainController *nextVC = [segue destinationViewController];
//            [nextVC changeProjectToProjectWithID:[self theProjectID]];
//        }
//        
//        
//        
//        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
//            
//            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc ];
//            [rvc pushFrontViewController:nc animated:YES];
//        };
//    }
}


@end
