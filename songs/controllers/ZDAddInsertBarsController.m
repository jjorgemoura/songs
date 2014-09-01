//
//  ZDAddInsertBarsController.m
//  songs
//
//  Created by Jorge Moura on 08/08/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDAddInsertBarsController.h"

@implementation ZDAddInsertBarsController


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
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    //The gesture about touching outside
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setCancelsTouchesInView:NO]; //So the user can still interact with controls in the modal view
    [[[self view] window] addGestureRecognizer:recognizer];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    //REMOVE ALL GESTURES
    NSArray * gesturesList = [[[self view] window] gestureRecognizers];
    //NSLog(@"SIZE OF GESTURES LIST: %lu", (unsigned long)[gesturesList count]);
    
    for (UIGestureRecognizer *x in gesturesList) {
        
        //NSLog(@"The Gesture: %@", [x description]);
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
            //[fs.popoverController dismissPopoverAnimated:TRUE];
            //[self popovo]
            
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
    
    
    
    
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    
}



@end
