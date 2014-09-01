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
#import "ZDDetailsBarController.h"


@interface ZDMainController ()

@property (nonatomic, strong) ZDProject *theProject;
@property (nonatomic, strong) ZDBar *selectedBar;

@property (nonatomic, weak) IBOutlet UIBarButtonItem* revealButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* auxRevealButtonItem;

@property (nonatomic, strong) ZDAddInsertBarsController *addInsertPopoverVC;
@property (nonatomic, strong) UIPopoverController *theAddPopoverController;



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
    
    
    //[[self auxRevealButtonItem] setTarget: [self revealViewController]];
    //[[self auxRevealButtonItem] setAction: @selector( rightRevealToggle: )];

    
    
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
    
    
    
    
    
    //GESTURES
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];

    //This is to delay the delegate methods of being called
    [tapGesture setDelaysTouchesBegan:YES];
    
    [tapGesture setNumberOfTapsRequired:2];
    //[tapGesture setNumberOfTouchesRequired:1];
    //[[self collectionView] addGestureRecognizer:tapGesture];

    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setMinimumNumberOfTouches:1];
    //[[self collectionView] addGestureRecognizer:panGesture];
    
    
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    
    [longPressGesture setMinimumPressDuration:1.5];
    [longPressGesture setNumberOfTapsRequired:0];
    [longPressGesture setNumberOfTouchesRequired:1];
    [longPressGesture setAllowableMovement:2];
    [[self collectionView] addGestureRecognizer:longPressGesture];
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
    
    
    
    //Gestures
    [[self collectionView] gestureRecognizers];
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
#pragma mark - UICollectionView Delegate
//---------------------------------------------------------------------------------------

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"Collection view indexpath: %li", (long)[indexPath row]);
    
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
        [[cell layer] setBorderColor:[theBlockBorderColor CGColor]];
    }
    
    return cell;
}





- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *theCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [[theCell contentView] setBackgroundColor:[UIColor whiteColor]];
    
    //NSLog(@"row: %li and section: %li", (long)indexPath.row, (long)indexPath.section);
}


- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {

    //the Cell
    UICollectionViewCell *theCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    //the Bar corresponding of this cell
    ZDBar *theBar = [[[self theProject] bars] objectAtIndex:[indexPath row]];

    //set color
    UIColor *theBlockColor = [UIColor colorWithHexString:[[theBar theSongBlock] hexColor]];
    [[theCell contentView] setBackgroundColor:theBlockColor];
}



- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}






- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    //the Cell
    UICollectionViewCell *theCell = [collectionView cellForItemAtIndexPath:indexPath];
    [[theCell layer] setBorderColor:[[UIColor colorWithHexString:@"#f7f7f7"] CGColor]];
    
    ZDBar *theBar = [[[self theProject] bars] objectAtIndex:[indexPath row]];
    [self setSelectedBar:theBar];
    
    [self performSegueWithIdentifier:@"details_bar" sender:self];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

    //the Cell
    UICollectionViewCell *theCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    //the Bar corresponding of this cell
    ZDBar *theBar = [[[self theProject] bars] objectAtIndex:[indexPath row]];
    
    UIColor *theBlockBorderColor = [UIColor colorWithHexString:[[theBar theSongBlock] borderHexColor]];
    [[theCell layer] setBorderColor:[theBlockBorderColor CGColor]];
}





- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {

    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {

    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
}




//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Main
//---------------------------------------------------------------------------------------
- (void)changeProjectToProjectWithID:(NSString *)projectID {

    if(projectID) {
    
        NSManagedObjectID *moID = [ZDCoreDataStack managedObjectIDFromString:projectID];
        ZDProject *theProject = (ZDProject *)[[ZDCoreDataStack mainQueueContext] objectWithID:moID];
        [self setTheProject:theProject];
        
        [[self collectionView] reloadData];
    }

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
    
    
    if([[segue identifier] isEqualToString:@"details_bar"]) {
       
        ZDDetailsBarController *nextVC = [segue destinationViewController];
        [nextVC setTheBar:[self selectedBar]];
        [nextVC setDelegate:self];
    }


    if([[segue identifier] isEqualToString:@"addinsert_bar"]) {
        
        ZDAddInsertBarsController *nextVC = [segue destinationViewController];
        [self setAddInsertPopoverVC:nextVC];
        [nextVC setDelegate:self];
        
    
        
        [self setTheAddPopoverController:[[UIPopoverController alloc] initWithContentViewController:nextVC]];
        
        [[self theAddPopoverController] setPopoverContentSize:CGSizeMake(300.0, 300.0) animated:YES];
        [[self theAddPopoverController] presentPopoverFromRect:[(UICollectionViewCell *)sender frame] inView:[self collectionView] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    }
    
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Gestures
//---------------------------------------------------------------------------------------
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    NSLog(@"handleTapGesture");
    
    if ([sender state] == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        //Do Whatever You want on Began of Gesture
    }
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        //Do Whatever You want on End of Gesture
    }
    
    if ([sender state] == UIGestureRecognizerStateCancelled){
        NSLog(@"UIGestureRecognizerStateCancelled.");
        //Do Whatever You want on Began of Gesture
    }
    
    if ([sender state] == UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
        //Do Whatever You want on End of Gesture
    }
    
    if ([sender state] == UIGestureRecognizerStateFailed){
        NSLog(@"UIGestureRecognizerStateFailed.");
        //Do Whatever You want on Began of Gesture
    }
    
    if ([sender state] == UIGestureRecognizerStatePossible) {
        NSLog(@"UIGestureRecognizerStatePossible");
        //Do Whatever You want on End of Gesture
    }
    
    if ([sender state] == UIGestureRecognizerStateRecognized){
        NSLog(@"UIGestureRecognizerStateRecognized.");
        //Do Whatever You want on Began of Gesture
    }
    
    
    
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    
    NSLog(@"handlePanGesture");
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
    
    NSLog(@"handleLongPressGesture");

    
    if ([sender state] != UIGestureRecognizerStateBegan) {
        return;
    }
    
//    if ([sender state] == UIGestureRecognizerStateBegan){
//        NSLog(@"UIGestureRecognizerStateBegan.");
//        //Do Whatever You want on Began of Gesture
//    }
//    
//    if ([sender state] == UIGestureRecognizerStateEnded) {
//        NSLog(@"UIGestureRecognizerStateEnded");
//        //Do Whatever You want on End of Gesture
//    }
    
    
    
    
    CGPoint p = [sender locationInView:[self collectionView]];
    NSIndexPath *indexPath = [[self collectionView] indexPathForItemAtPoint:p];
    
    //NSLog(@"row: %li and section: %li", (long)indexPath.row, (long)indexPath.section);
    
    
    if (indexPath == nil){
        
        NSLog(@"Couldn't find index path");
    }
    else {

        // get the cell at indexPath (the one you long pressed)
        UICollectionViewCell *cell = [[self collectionView] cellForItemAtIndexPath:indexPath];

        
        //ZDSongCollectionViewCell *xxx = (ZDSongCollectionViewCell *)cell;
        //NSString *yyyt = [xxx description];

        
        // do stuff with the cell
        [self performSegueWithIdentifier:@"addinsert_bar" sender:cell];
    }
    
}





//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - ZDDetailsBarControllerDelegate
//---------------------------------------------------------------------------------------
- (void)viewControllerDidCancel:(ZDDetailsBarController *)viewController {

    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(ZDDetailsBarController *)viewController didSaveZDBar:(ZDBar *)bar {

    [viewController dismissViewControllerAnimated:YES completion:nil];
}


@end
