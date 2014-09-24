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
    
        NSString *timeSig = [NSString stringWithFormat:@"%@/%@", [[self theBar] timeSignatureBeatCount], [[self theBar] timeSignatureNoteValue]];
        NSString *barNumber = [NSString stringWithFormat:@"Bar #%@", [[[self theBar] order] stringValue]];
        
        [[self theChord] setText:[[self theBar] chordTypeText]];
        [[self theTimeSig] setText:timeSig];
        [[self theBarNumber] setText:barNumber];
        [[self theSongBlock] setText:[[[self theBar] theSongBlock] name]];
        
        [[self theChord] setBackgroundColor:[UIColor colorWithHexString:[[[self theBar] theSongBlock] hexColor]]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setCancelsTouchesInView:NO]; //So the user can still interact with controls in the modal view
    //[[[self view] window] addGestureRecognizer:recognizer];
    
}

- (void)viewWillDisappear:(BOOL)animated {

    //REMOVE ALL GESTURES
    NSArray * gesturesList = [[[self view] window] gestureRecognizers];
    NSLog(@"SIZE OF GESTURES LIST: %lu", (unsigned long)[gesturesList count]);
    
    for (UIGestureRecognizer *x in gesturesList) {
        
        NSLog(@"The Gesture: %@", [x description]);
        if ([x isKindOfClass:[UITapGestureRecognizer class]]) {
            
            [[[self view] window] removeGestureRecognizer:x];
        }
    }
    
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
- (void)handleTapBehind:(UITapGestureRecognizer *)sender {

    if ([sender state] == UIGestureRecognizerStateEnded) {
        
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        
        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
        
        if (![[self view] pointInside:[[self view] convertPoint:location fromView:[[self view] window]] withEvent:nil]) {

            [self dismissViewControllerAnimated:YES completion:nil];
            
            NSLog(@"There are %lu Gesture Recognizers", (unsigned long)[[[[self view] window] gestureRecognizers] count]);
            [[[self view] window] removeGestureRecognizer:sender];
        }
    }
}



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
    
//    UIAlertView *confirmationBox = [[UIAlertView alloc] initWithTitle:@"Delete Bar"
//                                                              message:@"Do you want to delete the selected bar?"
//                                                             delegate:self
//                                                    cancelButtonTitle:@"Cancel"
//                                                    otherButtonTitles:@"Delete", nil];
    //[confirmationBox show];
    
    
    
    UIAlertController *confirmationAlertBox = [UIAlertController alertControllerWithTitle:@"Delete Bar" message:@"Do you want to delete the selected bar?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * action) {
                                                          
                                                              //DELEGATE
                                                              if ([[self delegate] respondsToSelector:@selector(viewController:willDeleteZDBar:)]) {
                                                                  
                                                                  [[self delegate] viewController:self willDeleteZDBar:[self theBar]];
                                                              }
                                                              
                                                              //Orders
                                                              int theCurrentBarOrder = [[[self theBar] order] intValue];
                                                              
                                                              
                                                              //INSERT INTO DB - First change only the order
                                                              ZDProject *theProject = [[self theBar] theProject];
                                                              
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
                                                              [moc deleteObject:[self theBar]];
                                                              
                                                              
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
                                                              if ([[self delegate] respondsToSelector:@selector(viewController:didDeleteZDBar:)]) {
                                                                  
                                                                  [[self delegate] viewController:self didDeleteZDBar:nil];
                                                              }
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                          
                                                          }];
    
    [confirmationAlertBox addAction:deleteAction];
    [confirmationAlertBox addAction:cancelAction];
    
    
    [self presentViewController:confirmationAlertBox animated:YES completion:nil];
    
}


@end
