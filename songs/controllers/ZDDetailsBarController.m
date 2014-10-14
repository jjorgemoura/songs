    //
//  ZDDetailsBarControllerViewController.m
//  songs
//
//  Created by Jorge Moura on 24/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDDetailsBarController.h"
#import "ZDBar+Factory.h"
#import "ZDProject+Factory.h"
#import "ZDSongBlock+Factory.h"
#import "UIColor+HexString.h"
#import "ZDCoreDataStack.h"

@interface ZDDetailsBarController ()

@property (weak, nonatomic) IBOutlet UILabel *theChord;
@property (weak, nonatomic) IBOutlet UILabel *theTimeSig;
@property (weak, nonatomic) IBOutlet UILabel *theBarNumber;
@property (weak, nonatomic) IBOutlet UILabel *theSongBlock;

@end



@implementation ZDDetailsBarController


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
#pragma mark - ViewController Lifecycle
//---------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([self theBar]) {
        
        //NSLog(@"DETAILSVC: ADDRESS: %@", [self description]);
        //NSLog(@"DETAILSVC: BARBUTTON: %@", [[self popoverPresentationController] barButtonItem] ? @"YES" : @"NO");
        //NSLog(@"DETAILSVC: SOURCEVIEW: %@", [[self popoverPresentationController] sourceView] ? @"YES" : @"NO");
        
    
        NSString *timeSig = [NSString stringWithFormat:@"%@/%@", [[self theBar] timeSignatureBeatCount], [[self theBar] timeSignatureNoteValue]];
        NSString *barNumber = [NSString stringWithFormat:@"Bar #%@", [[[self theBar] order] stringValue]];
        
        [[self theChord] setText:[[self theBar] chordTypeText]];
        [[self theTimeSig] setText:timeSig];
        [[self theBarNumber] setText:barNumber];
        [[self theSongBlock] setText:[[[self theBar] theSongBlock] name]];
        
        [[self theChord] setBackgroundColor:[UIColor colorWithHexString:[[[self theBar] theSongBlock] hexColor]]];
        
    }
    else {
    
        NSLog(@"The Bar is nil");
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //[self setLoaded:@"yes"];
    
    //set the finish of being loaded
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        [self setLoaded:@"yes"];
    });
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Gestures
//---------------------------------------------------------------------------------------
//- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
//
//    if ([sender state] == UIGestureRecognizerStateEnded) {
//        
//        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
//        
//        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
//        
//        if (![[self view] pointInside:[[self view] convertPoint:location fromView:[[self view] window]] withEvent:nil]) {
//
//            [self dismissViewControllerAnimated:YES completion:nil];
//            
//            //NSLog(@"There are %lu Gesture Recognizers", (unsigned long)[[[[self view] window] gestureRecognizers] count]);
//            [[[self view] window] removeGestureRecognizer:sender];
//        }
//    }
//}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Target Action
//---------------------------------------------------------------------------------------
- (IBAction)editButtonPressed:(id)sender {
   
    
    if ([[self delegate] respondsToSelector:@selector(viewController:willEditZDBar:)]) {
        
        [[self delegate] viewController:self willEditZDBar:[self theBar]];
    }
    
    
    if ([[self delegate] respondsToSelector:@selector(viewController:didEditZDBar:)]) {
        
        [[self delegate] viewController:self didEditZDBar:[self theBar]];
    }
}


- (IBAction)deleteButtonPressed:(id)sender {
    
//    
    UIAlertController *confirmationAlertBox = [UIAlertController alertControllerWithTitle:@"Delete Bar" message:@"Do you want to delete the selected bar?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //[self setTheConfirmationAlertBox:confirmationAlertBox];
    
    
    
    __weak ZDDetailsBarController *weakSelf = self;
    
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * action) {
                                                          
                                                              __strong ZDDetailsBarController *strongSelf = weakSelf;
                                                              
                                                              
                                                              //DELEGATE
                                                              if ([[strongSelf delegate] respondsToSelector:@selector(viewController:willDeleteZDBar:)]) {
                                                                  
                                                                  [[strongSelf delegate] viewController:strongSelf willDeleteZDBar:nil];
                                                              }
                                                              
                                                              //Orders
                                                              int theCurrentBarOrder = [[[strongSelf theBar] order] intValue];
                                                              
                                                              
                                                              //INSERT INTO DB - First change only the order
                                                              ZDProject *theProject = [[strongSelf theBar] theProject];
                                                              
                                                              for (ZDBar *bIterator in [theProject bars]) {
                                                                  
                                                                  //Before, do nothing
                                                                  if ([[bIterator order] intValue] <= theCurrentBarOrder) {
                                                                      
                                                                      continue;
                                                                  }
                                                                  
                                                                  //after
                                                                  if ([[bIterator order] intValue] > theCurrentBarOrder) {
                                                                      
                                                                      int newOrder = [[bIterator order] intValue] - 1;
                                                                      [bIterator setOrder:[NSNumber numberWithInt:newOrder]];
                                                                      continue;
                                                                  }
                                                              }
                                                              
                                                              
                                                              
                                                              //DELETE
                                                              NSManagedObjectContext *moc = [ZDCoreDataStack mainQueueContext];
                                                              [moc deleteObject:[strongSelf theBar]];
                                                              
                                                              
                                                              //DAVE
                                                              NSError *error = nil;
                                                              [moc save:&error];
                                                              
                                                              if(error) {
                                                                  NSLog(@"CORE DATA ERROR: Saving New Project: %@", [error debugDescription]);
                                                              }
                                                              else {
                                                                  
                                                                  NSLog(@"UPDATE: OK");
                                                              }
                                                              
                                                              
                                                              //DELEGATE
                                                              if ([[strongSelf delegate] respondsToSelector:@selector(viewController:didDeleteZDBar:)]) {
                                                                  
                                                                  [[strongSelf delegate] viewController:strongSelf didDeleteZDBar:nil];
                                                              }

//                                                              [strongSelf setTheConfirmationAlertBox:nil];
                                                                [confirmationAlertBox dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    
    
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                          
//                                                              __strong ZDDetailsBarController *strongSelf = weakSelf;
//                                                              [strongSelf setTheConfirmationAlertBox:nil];
                                                              
                                                                [confirmationAlertBox dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    

    //Add the Actions
    [confirmationAlertBox addAction:deleteAction];
    [confirmationAlertBox addAction:cancelAction];
    
    //Present VC
    [self presentViewController:confirmationAlertBox animated:YES completion:nil];
}


@end
