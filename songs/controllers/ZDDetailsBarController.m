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

@interface ZDDetailsBarController ()

@property (weak, nonatomic) IBOutlet UILabel *theChord;
@property (weak, nonatomic) IBOutlet UILabel *theTimeSig;
@property (weak, nonatomic) IBOutlet UILabel *theBarNumber;
@property (weak, nonatomic) IBOutlet UILabel *theChordBKColor;
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
        
        [[self theChord] setText:[[self theBar] chordType]];
        [[self theTimeSig] setText:timeSig];
        [[self theBarNumber] setText:barNumber];
        [[self theChordBKColor] setBackgroundColor:[UIColor colorWithHexString:[[[self theBar] theSongBlock] color]]];
        [[self theSongBlock] setText:[[[self theBar] theSongBlock] name]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setCancelsTouchesInView:NO]; //So the user can still interact with controls in the modal view
    [[[self view] window] addGestureRecognizer:recognizer];
    
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
- (IBAction)saveButtonPressed:(id)sender {
   
    
    if ([[self delegate] respondsToSelector:@selector(viewController:willSaveZDBar:)]) {
        
        [[self delegate] viewController:self willSaveZDBar:nil];
    }
    
    
    
    
    
    
    
    
    
    
    
    
    if ([[self delegate] respondsToSelector:@selector(viewController:didSaveZDBar:)]) {
        
        [[self delegate] viewController:self didSaveZDBar:nil];
    }
    
    
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    if ([[self delegate] respondsToSelector:@selector(viewControllerDidCancel:)]) {
        
        [[self delegate] viewControllerDidCancel:self];
    }
    
}


@end
