//
//  ZDAddInsertBarsController.m
//  songs
//
//  Created by Jorge Moura on 08/08/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDAddInsertBarsController.h"
#import "ZDBar+Factory.h"
#import "ZDSongBlock+Factory.h"
#import "ZDCoreDataStack.h"


@interface ZDAddInsertBarsController ()


@property (nonatomic, weak) IBOutlet UILabel *numberOfBars;
@property (nonatomic, weak) IBOutlet UIPickerView *songBlockSlider;

@property (nonatomic, strong) NSArray *songBlocksDataSource;
@property (nonatomic, strong) NSString *selectedBlock;

@end



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
    
    
    
    //Load the Picker Data Source
    NSError *error = nil;
    NSManagedObjectContext *moc = [ZDCoreDataStack mainQueueContext];
    NSArray *songBlocksList = [ZDSongBlock allEntitiesNames:moc withError:&error];
    [self setSongBlocksDataSource:songBlocksList];
    
    
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
            
            //Call its delegate
            if ([[self delegate] respondsToSelector:@selector(viewControllerXBarsDidCancel:)]) {
                
                [[self delegate] viewControllerXBarsDidCancel:self];
            }
            
            
            //NSLog(@"There are %lu Gesture Recognizers", (unsigned long)[[[[self view] window] gestureRecognizers] count]);
            [[[self view] window] removeGestureRecognizer:sender];
        }
    }
}




//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - PickerView Datasource
//---------------------------------------------------------------------------------------

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger numRows = 0;
    
    if (component == 0) {
        numRows = [[self songBlocksDataSource] count];
    }
    
    return numRows;
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - PickerView Delegate
//---------------------------------------------------------------------------------------
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSAttributedString *as = nil;
    
    
    if (component == 0) {
        NSString *obj = [[self songBlocksDataSource] objectAtIndex:row];
        as = [[NSAttributedString alloc] initWithString:obj];
    }
    
    return as;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if(pickerView == [self songBlockSlider]) {
        
        if (component == 0) {
            
            [self setSelectedBlock:[[self songBlocksDataSource] objectAtIndex:row]];
        }
    }
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Target Action
//---------------------------------------------------------------------------------------

- (IBAction)InsertBeforeButtonPressed:(id)sender {
    
    NSLog(@"Insert Before");
    

    //the new Data
    NSNumber *numberOfBarsToInsert = [NSNumber numberWithInteger:[[[self numberOfBars] text] integerValue]];
    
    NSManagedObjectContext *moc = [ZDCoreDataStack mainQueueContext];
    ZDSongBlock *songBlockToSave = [ZDSongBlock objectWithName:[self selectedBlock] inContext:moc];
    
    NSLog(@"name: %@", [songBlockToSave name]);
    
    
    //delegate before
    if ([[self delegate] respondsToSelector:@selector(viewController:willInsertXBars:ofType:beforeTheCurrentBar:)]) {
        
        [[self delegate] viewController:self willInsertXBars:numberOfBarsToInsert ofType:songBlockToSave beforeTheCurrentBar:YES];
    }
    
    
    
    
    
    //delegate after
    if ([[self delegate] respondsToSelector:@selector(viewController:didInsertXBars:ofType:beforeTheCurrentBar:)]) {
        
        [[self delegate] viewController:self didInsertXBars:numberOfBarsToInsert ofType:songBlockToSave beforeTheCurrentBar:YES];
    }
   
    
}


- (IBAction)InsertAfterButtonPressed:(id)sender {

    NSLog(@"Insert After");
    
    //the new Data
    NSNumber *numberOfBarsToInsert = [NSNumber numberWithInteger:[[[self numberOfBars] text] integerValue]];
    
    NSManagedObjectContext *moc = [ZDCoreDataStack mainQueueContext];
    ZDSongBlock *songBlockToSave = [ZDSongBlock objectWithName:[self selectedBlock] inContext:moc];
    
    
    
    
    
    //delegate before
    if ([[self delegate] respondsToSelector:@selector(viewController:willInsertXBars:ofType:beforeTheCurrentBar:)]) {
        
         [[self delegate] viewController:self willInsertXBars:numberOfBarsToInsert ofType:songBlockToSave beforeTheCurrentBar:NO];
    }
    
    
    
    
    
    //delegate after    
    if ([[self delegate] respondsToSelector:@selector(viewController:didInsertXBars:ofType:beforeTheCurrentBar:)]) {
        
         [[self delegate] viewController:self didInsertXBars:numberOfBarsToInsert ofType:songBlockToSave beforeTheCurrentBar:NO];
    }
    
    
}

- (IBAction)valueStepperChanged:(id)sender {
    
    if ([sender isKindOfClass:[UIStepper class]]) {
    
        UIStepper *myStepper = (UIStepper *)sender;
        double newNumberBars = [myStepper value];
        
        [[self numberOfBars] setText:[NSString stringWithFormat:@"%d", (int)newNumberBars]];
    }
    
    
}


@end
