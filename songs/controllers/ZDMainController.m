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
#import "ZDBar+Factory.h"
#import "ZDProject+Factory.h"
#import "NSManagedObjectID+ZDString.h"
#import "UIColor+HexString.h"
#import "ZDSongBlock+Factory.h"
#import "ZDProjectDetailController.h"
#import "ZDProjectExportController.h"



@interface ZDMainController ()

//@property (nonatomic, strong) ZDProject *theProject;
@property (nonatomic, strong) NSString *theProjectID;
@property (nonatomic, strong) NSString *theProjectName;
@property (nonatomic, strong) ZDBar *selectedBar;
@property (nonatomic, strong) NSMutableDictionary *selectedMultiBarsList;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, weak) IBOutlet UIBarButtonItem* revealButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* auxRevealButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* detailsButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* exportButtonItem;

@property (nonatomic, strong) UIPopoverController *theAddPopoverController;


@property (nonatomic) int multiSelectionBarsFirstBar;
@property (nonatomic) int multiSelectionBarsLastBar;

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
        
        //I think that I don't need store the object
        NSManagedObjectID *moID = [ZDCoreDataStack managedObjectIDFromString:projectIDStored];
        
        if (moID) {
        
            NSError *error = nil;
            //ZDProject *theProject2 = (ZDProject *)[[ZDCoreDataStack mainQueueContext] objectWithID:moID];
            ZDProject *theProject = (ZDProject *)[[ZDCoreDataStack mainQueueContext] existingObjectWithID:moID error:&error];
            
            if (error) {
                NSLog(@"ERROR Checking objectID: %@", [error description]);
            }
            
            
            if (theProject) {
                
                [self setTheProjectID:projectIDStored];
                [self setTheProjectName:[theProject name]];
            }
            else {
                
                [[self revealViewController] performSelector:@selector(revealToggle:) withObject:self];
            }
        }
        else {
        
            [[self revealViewController] performSelector:@selector(revealToggle:) withObject:self];
        }
    }
    else {
        
        [[self revealViewController] performSelector:@selector(revealToggle:) withObject:self];
    }
    
    
    
    
    //LEFT BAR BUTTONS
    [[self revealButtonItem] setTarget: [self revealViewController]];
    [[self revealButtonItem] setAction: @selector( revealToggle: )];
    [[[self navigationController] navigationBar] addGestureRecognizer: [[self revealViewController] panGestureRecognizer]];
    
    
    //RIGHT BAR BUTTONS
    [[self detailsButtonItem] setTarget:self];
    [[self detailsButtonItem] setAction: @selector(detailsButtonPressed:)];

    [[self exportButtonItem] setTarget:self];
    [[self exportButtonItem] setAction: @selector(exportButtonPressed:)];
    
    
    
    
    //FetchRequest
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ZDBar"];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"theProject.name"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"theProject.name = %@", [self theProjectName]];
    [request setPredicate:predicate];
    //[request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    
    
    NSSortDescriptor *orderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *orderDescriptors = @[orderDescriptor];
    [request setSortDescriptors:orderDescriptors];
    
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:[ZDCoreDataStack mainQueueContext]
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil]];
    
    
    
    
    
    //GESTURES
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];

    //This is to delay the delegate methods of being called
    [tapGesture setDelaysTouchesBegan:YES];
    
    [tapGesture setNumberOfTapsRequired:2];
    [tapGesture setNumberOfTouchesRequired:1];
    [[self collectionView] addGestureRecognizer:tapGesture];

    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setMinimumNumberOfTouches:1];
    [[self collectionView] addGestureRecognizer:panGesture];
    
    
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    
    [longPressGesture setMinimumPressDuration:1.5];
    [longPressGesture setNumberOfTapsRequired:0];
    [longPressGesture setNumberOfTouchesRequired:1];
    [longPressGesture setAllowableMovement:3];
    [[self collectionView] addGestureRecognizer:longPressGesture];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    

    if ([self theProjectName]) {
        
        [self setTitle:[self theProjectName]];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    //Save to NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([self theProjectID]) {
        
        //NSManagedObjectID *moID = [[self theProject] objectID];
        
        //[userDefaults setObject:[moID stringRepresentation]  forKey:@"projectID"];
        [userDefaults setObject:[self theProjectID ]  forKey:@"projectID"];
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



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - UICollectionView Delegate
//---------------------------------------------------------------------------------------

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"Collection view indexpath: %li", (long)[indexPath row]);
    
    static NSString *cellIdentifier = @"MY_MAINCOLLECTION_CELL";
    
    
    ZDSongCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([indexPath section] == 0) {
        
        //clear cell
        //[cell color:[UIColor blackColor]];
        
        
        //ZDBar *theBar_old = [[[self theProject] bars] objectAtIndex:[indexPath row]];
        //NSUInteger wwww = [[[self fetchedResultsController] sections] count];
        ZDBar *theBar = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        
        
        NSString *theScaleNote = [theBar chordTypeText];
        NSString *theSongBlockText = [[theBar theSongBlock] name];
        NSNumber *beats = [theBar timeSignatureBeatCount];
        NSNumber *division = [theBar timeSignatureNoteValue];
        
        NSString *theTimeSig = [NSString stringWithFormat:@"%@/%@", beats, division];
        

        UIColor *theBlockColor = [UIColor colorWithHexString:[[theBar theSongBlock] hexColor]];
        UIColor *theBlockBorderColor = [UIColor colorWithHexString:[[theBar theSongBlock] borderHexColor]];
        
        
        [cell mainText:theScaleNote];
        [cell auxText:theTimeSig];
        [cell orderNumber:[theBar order]];
        [cell color:theBlockColor];
        [cell songBlock:theSongBlockText];
        [[cell layer] setBorderColor:[theBlockBorderColor CGColor]];
        
        
        //NSLog(@"CELL: %@ - %@ - order: %@", theScaleNote, [[theBar theSongBlock] hexColor], [[theBar order] stringValue]);
    }
    
    return cell;
}






- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {

    //NSLog(@"Step 1");
    UICollectionViewCell *theCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [[theCell backgroundView] setBackgroundColor:[UIColor whiteColor]];
}


- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
 
    //NSLog(@"Step 2");
    //the Cell
    UICollectionViewCell *theCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    //the Bar corresponding of this cell
    //ZDBar *theBar = [[[self theProject] bars] objectAtIndex:[indexPath row]];
    ZDBar *theBar = [[self fetchedResultsController] objectAtIndexPath:indexPath];

    
    //set color
    UIColor *theBlockColor = [UIColor colorWithHexString:[[theBar theSongBlock] hexColor]];
    //[[theCell contentView] setBackgroundColor:theBlockColor];
    [[theCell backgroundView] setBackgroundColor:theBlockColor];
}



- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    //NSLog(@"Step 3");
    
    if ([[collectionView cellForItemAtIndexPath:indexPath] isSelected]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

    //NSLog(@"Step 4");
    return YES;
}






- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    //NSLog(@"Step 5");
    //the Cell
    UICollectionViewCell *theCell = [collectionView cellForItemAtIndexPath:indexPath];
    [[theCell layer] setBorderColor:[[UIColor colorWithHexString:@"#f7f7f7"] CGColor]];
    
    
    //ZDBar *theBar = [[[self theProject] bars] objectAtIndex:[indexPath row]];
    ZDBar *theBar = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self setSelectedBar:theBar];
    [self setSelectedIndexPath:indexPath];
    
    
    
    //the first version was a modal, now is a popover
    //[self performSegueWithIdentifier:@"details_bar" sender:self];
    
    if (!theCell) {
        //do nothing. Double clic bug
        return;
    }
    
    [self performSegueWithIdentifier:@"details_bar" sender:theCell];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

    //NSLog(@"Step 6");
    //the Cell
    UICollectionViewCell *theCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    //the Bar corresponding of this cell
    ZDBar *theBar = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
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
        //ZDProject *theProject2 = (ZDProject *)[[ZDCoreDataStack mainQueueContext] objectWithID:moID];

        NSError *error = nil;
        ZDProject *theProject = (ZDProject *)[[ZDCoreDataStack mainQueueContext] existingObjectWithID:moID error:&error];
        
        if (error) {
            NSLog(@"ERROR Checking objectID: %@", [error description]);
        }
        
        
        if (theProject) {
            
            [self setTheProjectID:projectID];
            [self setTheProjectName:[theProject name]];
            [self performFetch];
        }
        else {
            
            [[self revealViewController] performSelector:@selector(revealToggle:) withObject:self];
        }
    }
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Target Action Buttons
//---------------------------------------------------------------------------------------
- (IBAction)detailsButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"projectdetail_button" sender:sender];
}


- (IBAction)exportButtonPressed:(id)sender {

    [self performSegueWithIdentifier:@"projectexport_button" sender:sender];
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
        
        
        //to work as a popover
        if ([nextVC respondsToSelector:@selector(popoverPresentationController)]) {
            
            //THIS IS iOS 8 CODE
            nextVC.modalPresentationStyle = UIModalPresentationPopover;
            [nextVC setPreferredContentSize:CGSizeMake(325.0,325.0)];
            
            UIPopoverPresentationController *popoverPresentation = nextVC.popoverPresentationController;
            [popoverPresentation setSourceView:[self collectionView]];
            [popoverPresentation setSourceRect:[(UICollectionViewCell *)sender frame]];
            [popoverPresentation setPermittedArrowDirections:(UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight)];
            [popoverPresentation setDelegate:self];
            
            [self presentViewController:nextVC animated:YES completion:nil];
            
        } else {
            //THIS IS IOS 7- CODE
            //fix or turn around to fix a problem with the popover content size
            [nextVC setPreferredContentSize:CGSizeMake(325.0, 325.0)];
            
            //instanciate and set Property
            [self setTheAddPopoverController:[[UIPopoverController alloc] initWithContentViewController:nextVC]];
            
            [[self theAddPopoverController] setPopoverContentSize:CGSizeMake(325.0, 325.0) animated:YES];
            [[self theAddPopoverController] presentPopoverFromRect:[(UICollectionViewCell *)sender frame] inView:[self collectionView] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    
    
    if([[segue identifier] isEqualToString:@"edit_bar"]) {
        
        ZDEditBarController *nextVC = [segue destinationViewController];
        [nextVC setTheSelectedZDBar:[self selectedBar]];
        [nextVC setDelegate:self];
        
        
        //to work as a popover
        if ([nextVC respondsToSelector:@selector(popoverPresentationController)]) {
            
            //THIS IS iOS 8 CODE
            nextVC.modalPresentationStyle = UIModalPresentationPopover;
            [nextVC setPreferredContentSize:CGSizeMake(325.0, 525.0)];
            
            UIPopoverPresentationController *popoverPresentation = nextVC.popoverPresentationController;
            [popoverPresentation setSourceView:[self collectionView]];
            [popoverPresentation setSourceRect:[(UICollectionViewCell *)sender frame]];
            [popoverPresentation setPermittedArrowDirections:(UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight)];
            
            [self presentViewController:nextVC animated:YES completion:nil];
            
        } else {
            //THIS IS IOS 7- CODE
            //fix or turn around to fix a problem with the popover content size
            [nextVC setPreferredContentSize:CGSizeMake(325.0, 525.0)];
            
            //instanciate and set Property
            [self setTheAddPopoverController:[[UIPopoverController alloc] initWithContentViewController:nextVC]];
            
            [[self theAddPopoverController] setPopoverContentSize:CGSizeMake(325.0, 525.0) animated:YES];
            [[self theAddPopoverController] presentPopoverFromRect:[(UICollectionViewCell *)sender frame] inView:[self collectionView] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }


    if([[segue identifier] isEqualToString:@"addinsert_bar"]) {
        
        ZDAddInsertBarsController *nextVC = [segue destinationViewController];
        //[self setAddInsertPopoverVC:nextVC];
        [nextVC setDelegate:self];
        [nextVC setTheSelectedZDBar:[self selectedBar]];
        
        
        
        
        if ([nextVC respondsToSelector:@selector(popoverPresentationController)]) {
            
            //THIS IS iOS 8 CODE
            nextVC.modalPresentationStyle = UIModalPresentationPopover;
            [nextVC setPreferredContentSize:CGSizeMake(325.0, 600.0)];
            
            UIPopoverPresentationController *popoverPresentation = nextVC.popoverPresentationController;
            [popoverPresentation setSourceView:[self collectionView]];
            [popoverPresentation setSourceRect:[(UICollectionViewCell *)sender frame]];
            [popoverPresentation setPermittedArrowDirections:(UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight)];
            
            [self presentViewController:nextVC animated:YES completion:nil];
            
        } else {
            //THIS IS IOS 7- CODE
            //existing code...
            
            //fix or turn around to fix a problem with the popover content size
            [nextVC setPreferredContentSize:CGSizeMake(325.0, 600.0)];
            
            
            
            //instanciate and set Property
            [self setTheAddPopoverController:[[UIPopoverController alloc] initWithContentViewController:nextVC]];
            
            [[self theAddPopoverController] setPopoverContentSize:CGSizeMake(325.0, 600.0) animated:YES];
            [[self theAddPopoverController] presentPopoverFromRect:[(UICollectionViewCell *)sender frame] inView:[self collectionView] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    
    if([[segue identifier] isEqualToString:@"projectdetail_button"]) {
        
        ZDProject *theProject = nil;
        
        if ([self selectedBar]) {
            
            theProject = [[self selectedBar] theProject];
        }
        else {
        
            //NSIndexPath *ip = [NSIndexPath indexPathWithIndex:0.0];
            ZDBar *tempBar = [[[self fetchedResultsController] fetchedObjects] objectAtIndex:0];
            //ZDBar *tempBar = [[self fetchedResultsController] objectAtIndexPath:ip];
            theProject = [tempBar theProject];
        }
        
        
        ZDProjectDetailController *nextVC = [segue destinationViewController];
        [nextVC setSongProjectName:[theProject name]];
        [nextVC setBandName:[theProject band]];
        [nextVC setComposerName:[theProject composer]];
        [nextVC setLyricsByName:[theProject lyricsBy]];
        [nextVC setYear:[[theProject year] stringValue]];
        [nextVC setBpm:[[theProject bpm] stringValue]];
        [nextVC setSongKey:[theProject key]];
        [nextVC setNumberBars:[NSString stringWithFormat:@"%lu", (unsigned long)[[theProject bars] count]]];
        [nextVC setTimeSignature:nil];
        
        
        //to work as a popover
        if ([nextVC respondsToSelector:@selector(popoverPresentationController)]) {
            
            //THIS IS iOS 8 CODE
            nextVC.modalPresentationStyle = UIModalPresentationPopover;
            [nextVC setPreferredContentSize:CGSizeMake(325.0, 450.0)];
            
            UIPopoverPresentationController *popoverPresentation = nextVC.popoverPresentationController;
            [popoverPresentation setBarButtonItem:[self detailsButtonItem]];
            //[popoverPresentation setSourceView:[self collectionView]];
            //[popoverPresentation setSourceRect:[(UIBarButtonItem *)sender ]];
            [popoverPresentation setPermittedArrowDirections:(UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight | UIPopoverArrowDirectionUp)];
            
            [self presentViewController:nextVC animated:YES completion:nil];
            
        } else {
            //THIS IS IOS 7- CODE
            //fix or turn around to fix a problem with the popover content size
            [nextVC setPreferredContentSize:CGSizeMake(325.0, 450.0)];
            
            //instanciate and set Property
            [self setTheAddPopoverController:[[UIPopoverController alloc] initWithContentViewController:nextVC]];
            
            [[self theAddPopoverController] setPopoverContentSize:CGSizeMake(325.0, 450.0) animated:YES];
            //[[self theAddPopoverController] presentPopoverFromRect:[(UICollectionViewCell *)sender frame] inView:[self collectionView] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    

    if([[segue identifier] isEqualToString:@"edit_multiple_bars"]) {
        
//        ZDProject *theProject = nil;
//        
//        if ([self selectedBar]) {
//            
//            theProject = [[self selectedBar] theProject];
//        }
//        else {
//            
//            ZDBar *tempBar = [[[self fetchedResultsController] fetchedObjects] objectAtIndex:0];
//            theProject = [tempBar theProject];
//        }
        
        
        ZDMultipleSelectionController *nextVC = [segue destinationViewController];
        [nextVC setTheBarsList:[[self selectedMultiBarsList] allValues]];
        [nextVC setDelegate:self];
        
        
        
        //to work as a popover
        if ([nextVC respondsToSelector:@selector(popoverPresentationController)]) {
            
            //THIS IS iOS 8 CODE
            nextVC.modalPresentationStyle = UIModalPresentationPopover;
            [nextVC setPreferredContentSize:CGSizeMake(325.0, 325.0)];
            
            UIPopoverPresentationController *popoverPresentation = nextVC.popoverPresentationController;
            [popoverPresentation setSourceView:[self collectionView]];
            [popoverPresentation setSourceRect:[(UICollectionViewCell *)sender frame]];
            [popoverPresentation setPermittedArrowDirections:(UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight)];
            
            [self presentViewController:nextVC animated:YES completion:nil];
            
        } else {
            //THIS IS IOS 7- CODE
            //fix or turn around to fix a problem with the popover content size
            [nextVC setPreferredContentSize:CGSizeMake(325.0, 325.0)];
            
            //instanciate and set Property
            [self setTheAddPopoverController:[[UIPopoverController alloc] initWithContentViewController:nextVC]];
            
            [[self theAddPopoverController] setPopoverContentSize:CGSizeMake(325.0, 325.0) animated:YES];
            //[[self theAddPopoverController] presentPopoverFromRect:[(UICollectionViewCell *)sender frame] inView:[self collectionView] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    
    
    
    if([[segue identifier] isEqualToString:@"projectexport_button"]) {
        
        ZDProjectExportController *nextVC = [segue destinationViewController];
        if ([self selectedBar]) {
            
            [nextVC setTheSelectedZDProject:[[self selectedBar] theProject]];
        }
        else {
            
            ZDBar *tempBar = [[[self fetchedResultsController] fetchedObjects] objectAtIndex:0];
            [nextVC setTheSelectedZDProject:[tempBar theProject]];
        }
        
        
        //to work as a popover
        if ([nextVC respondsToSelector:@selector(popoverPresentationController)]) {
            
            //THIS IS iOS 8 CODE
            nextVC.modalPresentationStyle = UIModalPresentationPopover;
            [nextVC setPreferredContentSize:CGSizeMake(325.0, 325.0)];
            
            UIPopoverPresentationController *popoverPresentation = nextVC.popoverPresentationController;
            [popoverPresentation setBarButtonItem:[self exportButtonItem]];
            //[popoverPresentation setSourceView:[self collectionView]];
            //[popoverPresentation setSourceRect:[(UIBarButtonItem *)sender ]];
            [popoverPresentation setPermittedArrowDirections:(UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight | UIPopoverArrowDirectionUp)];
            
            [self presentViewController:nextVC animated:YES completion:nil];
            
        } else {
            //THIS IS IOS 7- CODE
            //fix or turn around to fix a problem with the popover content size
            [nextVC setPreferredContentSize:CGSizeMake(325.0, 325.0)];
            
            //instanciate and set Property
            [self setTheAddPopoverController:[[UIPopoverController alloc] initWithContentViewController:nextVC]];
            
            [[self theAddPopoverController] setPopoverContentSize:CGSizeMake(325.0, 325.0) animated:YES];
            //[[self theAddPopoverController] presentPopoverFromRect:[(UICollectionViewCell *)sender frame] inView:[self collectionView] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Gestures
//---------------------------------------------------------------------------------------
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    NSLog(@"handleTapGesture");
    
//    if ([sender state] == UIGestureRecognizerStateBegan){
//        NSLog(@"UIGestureRecognizerStateBegan.");
//        //Do Whatever You want on Began of Gesture
//    }
//    
//    if ([sender state] == UIGestureRecognizerStateEnded) {
//        NSLog(@"UIGestureRecognizerStateEnded");
//        //Do Whatever You want on End of Gesture
//    }
//    
//    if ([sender state] == UIGestureRecognizerStateCancelled){
//        NSLog(@"UIGestureRecognizerStateCancelled.");
//        //Do Whatever You want on Began of Gesture
//    }
//    
//    if ([sender state] == UIGestureRecognizerStateChanged) {
//        NSLog(@"UIGestureRecognizerStateChanged");
//        //Do Whatever You want on End of Gesture
//    }
//    
//    if ([sender state] == UIGestureRecognizerStateFailed){
//        NSLog(@"UIGestureRecognizerStateFailed.");
//        //Do Whatever You want on Began of Gesture
//    }
//    
//    if ([sender state] == UIGestureRecognizerStatePossible) {
//        NSLog(@"UIGestureRecognizerStatePossible");
//        //Do Whatever You want on End of Gesture
//    }
//    
//    if ([sender state] == UIGestureRecognizerStateRecognized){
//        NSLog(@"UIGestureRecognizerStateRecognized.");
//        //Do Whatever You want on Began of Gesture
//    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    
    NSLog(@"handlePanGesture");
    BOOL ended = NO;
    
    
    
    CGPoint p = [sender locationInView:[self collectionView]];
    NSIndexPath *indexPath = [[self collectionView] indexPathForItemAtPoint:p];
    
    if (indexPath == nil){
        
        //NSLog(@"Couldn't find index path");
    }
    else {
        
        //This is to save the selected bar.
        ZDBar *theBar = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        
        
        if ([sender state] == UIGestureRecognizerStateBegan) {
            NSLog(@"handlePanBegin");
            [self setSelectedMultiBarsList:[[NSMutableDictionary alloc] init]];
            [self setMultiSelectionBarsFirstBar:[[theBar order] intValue]];
            [self setMultiSelectionBarsLastBar:0];
        }
        
        if ([sender state] == UIGestureRecognizerStateChanged) {
            NSLog(@"handlePan Changed");
        }
        
        if ([sender state] == UIGestureRecognizerStateEnded) {
            NSLog(@"handlePan Ended");
            ended = YES;
            [self setMultiSelectionBarsLastBar:[[theBar order] intValue]];
            
            
            if ([self multiSelectionBarsLastBar] < [self multiSelectionBarsFirstBar]) {
                
                int tempInt = [self multiSelectionBarsFirstBar];
                [self setMultiSelectionBarsFirstBar:[self multiSelectionBarsLastBar]];
                [self setMultiSelectionBarsLastBar:tempInt];
            }
        }
        
        
        
        //check if already exists in Dic
//        if ([[self selectedMultiBarsList] objectForKey: [theBar order] ] == nil) {
//            
//            [[self selectedMultiBarsList] setObject:theBar forKey:[theBar order]];
//            [self setSelectedIndexPath:indexPath];
//            [self setSelectedBar:theBar];
//        }
        //legacy
        [self setSelectedIndexPath:indexPath];
        [self setSelectedBar:theBar];
        
        
        
        //DECISION
        //if ended, go forward
        if (ended) {
            
            //If only select 1 (the first and last bar are the same), do nothing
            if ([self multiSelectionBarsFirstBar]  == [self multiSelectionBarsLastBar]) {
                return;
            }
            
            
            
            //add only now to the selected Dic.
            ZDProject *theProject = [theBar theProject];
            
            for (ZDBar *x in [theProject bars]) {
                
                if ([[x order] intValue] >= [self multiSelectionBarsFirstBar] && [[x order] intValue] <= [self multiSelectionBarsLastBar]) {
                    
                    [[self selectedMultiBarsList] setObject:x forKey:[x order]];
                }
            }
            
            
            
            //check if exists jumps in the lines. For ex, the selected bars qt is diferent of the number between theFrom order to the toOrder
//            NSArray *AllTheKeys = [[self selectedMultiBarsList] allKeys];
//            
//            int minBarOrder = [(NSNumber *)[AllTheKeys objectAtIndex:0] intValue];
//            int maxBarOrder = [(NSNumber *)[AllTheKeys objectAtIndex:0] intValue];
//            
//            for (NSNumber *x in AllTheKeys) {
//                
//                ZDBar *xBar = [[self selectedMultiBarsList] objectForKey:x];
//                
//                if ([[xBar order] intValue] <= minBarOrder) {
//                    minBarOrder = [[xBar order] intValue];
//                }
//            
//                if ([[xBar order] intValue] >= maxBarOrder) {
//                    maxBarOrder = [[xBar order] intValue];
//                }
//            }
//            
//            
//            if (maxBarOrder - minBarOrder + 1 != (int)[[self selectedMultiBarsList] count]) {
//                
//                NSLog(@"The multibar Selection contains jumps.");
//                return;
//            }
            
            
            
            // get the cell at indexPath (the one you long pressed)
            UICollectionViewCell *cell = [[self collectionView] cellForItemAtIndexPath:indexPath];
            
            // do stuff with the cell
            [self performSegueWithIdentifier:@"edit_multiple_bars" sender:cell];
        }
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
    
    NSLog(@"handleLongPressGesture");

    if ([sender state] != UIGestureRecognizerStateBegan) {
        return;
    }
    
    
    CGPoint p = [sender locationInView:[self collectionView]];
    NSIndexPath *indexPath = [[self collectionView] indexPathForItemAtPoint:p];
    
    //NSLog(@"row: %li and section: %li", (long)indexPath.row, (long)indexPath.section);
    
    
    if (indexPath == nil){
        
        NSLog(@"Couldn't find index path");
    }
    else {
     
        //This is to save the selected bar.
        //ZDBar *theBar = [[[self theProject] bars] objectAtIndex:[indexPath row]];
        ZDBar *theBar = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [self setSelectedBar:theBar];
        [self setSelectedIndexPath:indexPath];

        
        
        
        // get the cell at indexPath (the one you long pressed)
        UICollectionViewCell *cell = [[self collectionView] cellForItemAtIndexPath:indexPath];

        // do stuff with the cell
        [self performSegueWithIdentifier:@"addinsert_bar" sender:cell];
    }
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - UIPopoverPresentationControllerDelegate
//---------------------------------------------------------------------------------------
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {

    
    if ([popoverPresentationController presentedViewController]) {
        
        if ([[popoverPresentationController presentedViewController] isKindOfClass:[ZDDetailsBarController class]]) {
            
            ZDDetailsBarController *x = (ZDDetailsBarController *)[popoverPresentationController presentedViewController];
            
            if ([x theConfirmationAlertBox]) {
                
                //The AlertBox is Active.
                return NO;
            }
//            [x dismissViewControllerAnimated:YES completion:nil];
//            NSLog(@"%@", [popoverPresentationController description]);
        }
    }
    
    
//    if ([popoverPresentationController presentingViewController]) {
//        
//        if ([[popoverPresentationController presentingViewController] isKindOfClass:[ZDDetailsBarController class]]) {
//
//            ZDDetailsBarController *x = (ZDDetailsBarController *)[popoverPresentationController presentingViewController];
//            NSLog(@"Is here");
//        }
//    }
    

    
    return YES;
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - ZDDetailsBarControllerDelegate
//---------------------------------------------------------------------------------------
- (void)viewController:(ZDDetailsBarController *)viewController willDeleteZDBar:(ZDBar *)bar {


}

- (void)viewController:(ZDDetailsBarController *)viewController didDeleteZDBar:(ZDBar *)bar {


    if ([self respondsToSelector:@selector(popoverPresentationController)]) {
        
        //iOS 8
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        
        //iOS 7
        [[self theAddPopoverController] dismissPopoverAnimated:YES];
        [self setTheAddPopoverController:nil];
    }
    
    
    [self setSelectedBar:nil];
    [self setSelectedIndexPath:nil];
    [self performFetch];
}


- (void)viewController:(ZDDetailsBarController *)viewController willEditZDBar:(ZDBar *)bar {

}

- (void)viewController:(ZDDetailsBarController *)viewController didEditZDBar:(ZDBar *)bar {
    
    //Close the popover
    if ([self respondsToSelector:@selector(popoverPresentationController)]) {
        
        //iOS 8
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        
        //iOS 7
        [[self theAddPopoverController] dismissPopoverAnimated:YES];
        [self setTheAddPopoverController:nil];
    }
    
    
    
    
    
    //Execute the new (edit) popover

    // get the cell at indexPath (the one you long pressed)
    UICollectionViewCell *cell = [[self collectionView] cellForItemAtIndexPath:[self selectedIndexPath]];
    
    // do stuff with the cell
    [self performSegueWithIdentifier:@"edit_bar" sender:cell];
    
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - ZDAddInsertsBarsDelegate
//---------------------------------------------------------------------------------------
- (void)viewControllerXBarsDidCancel:(ZDAddInsertBarsController *)viewController {
    

}

- (void)viewController:(ZDAddInsertBarsController *)viewController willInsertXBars:(NSNumber *)barsQuantity ofType:(ZDSongBlock *)barBlockType beforeTheCurrentBar:(BOOL)before {


    
}

- (void)viewController:(ZDAddInsertBarsController *)viewController didInsertXBars:(NSNumber *)barsQuantity ofType:(ZDSongBlock *)barBlockType beforeTheCurrentBar:(BOOL)before {

    //[[self collectionView] reloadData];
    
    
    
    if ([self respondsToSelector:@selector(popoverPresentationController)]) {
    
        //iOS 8
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
    
        //iOS 7
        [[self theAddPopoverController] dismissPopoverAnimated:YES];
        [self setTheAddPopoverController:nil];
    }
    
    
    [self setSelectedBar:nil];
    [self setSelectedIndexPath:nil];
    [self performFetch];
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - ZDEditBarDelegate
//---------------------------------------------------------------------------------------
- (void)viewControllerEditBarCancel:(ZDEditBarController *)viewController {

    if ([self respondsToSelector:@selector(popoverPresentationController)]) {
        
        //iOS 8
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        
        //iOS 7
        [[self theAddPopoverController] dismissPopoverAnimated:YES];
        [self setTheAddPopoverController:nil];
    }
}

- (void)viewController:(ZDEditBarController *)viewController willEditBar:(ZDBar *)bar {

}

- (void)viewController:(ZDEditBarController *)viewController didEditBar:(ZDBar *)bar {
 
    if ([self respondsToSelector:@selector(popoverPresentationController)]) {
        
        //iOS 8
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        
        //iOS 7
        [[self theAddPopoverController] dismissPopoverAnimated:YES];
        [self setTheAddPopoverController:nil];
    }
    
    [self performFetch];
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - ZDProjectExportControllerDelegate
//---------------------------------------------------------------------------------------
- (void)viewControllerExportFinished:(ZDProjectExportController *)viewController {

    if ([self respondsToSelector:@selector(popoverPresentationController)]) {
        
        //iOS 8
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        
        //iOS 7
        [[self theAddPopoverController] dismissPopoverAnimated:YES];
        [self setTheAddPopoverController:nil];
    }
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - ZDMultipleSelectionsController Delegate
//---------------------------------------------------------------------------------------
- (void)viewControllerDidDeleteZDBars:(ZDMultipleSelectionController *)viewController {


    if ([self respondsToSelector:@selector(popoverPresentationController)]) {
        
        //iOS 8
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        
        //iOS 7
        [[self theAddPopoverController] dismissPopoverAnimated:YES];
        [self setTheAddPopoverController:nil];
    }
    
    [self performFetch];
}




@end
