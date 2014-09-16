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
#import "ZDProject+Factory.h"


@interface ZDAddInsertBarsController ()


@property (nonatomic, weak) IBOutlet UILabel *numberOfBars;
@property (nonatomic, weak) IBOutlet UIPickerView *songBlockSlider;

@property (nonatomic, strong) NSArray *songBlocksDataSource;
@property (nonatomic, strong) NSString *selectedBlock;


- (void)saveBars:(BOOL)beforeTheCurrentBar;

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
    //[[[self view] window] addGestureRecognizer:recognizer];
    
    
    
    //Set default Block Selection
    if (![self selectedBlock]) {
        [self setSelectedBlock:[[self songBlocksDataSource] objectAtIndex:0]];
    }
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
    
    [self saveBars:YES];
}


- (IBAction)InsertAfterButtonPressed:(id)sender {

    NSLog(@"Insert After");
    
    [self saveBars:NO];
}

- (IBAction)valueStepperChanged:(id)sender {
    
    if ([sender isKindOfClass:[UIStepper class]]) {
    
        UIStepper *myStepper = (UIStepper *)sender;
        double newNumberBars = [myStepper value];
        
        [[self numberOfBars] setText:[NSString stringWithFormat:@"%d", (int)newNumberBars]];
    }
    
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Private Methods
//---------------------------------------------------------------------------------------
- (void)saveBars:(BOOL)beforeTheCurrentBar {

    
    
    //the new Data
    NSNumber *numberOfBarsToInsert = [NSNumber numberWithInteger:[[[self numberOfBars] text] integerValue]];
    
    NSManagedObjectContext *moc = [ZDCoreDataStack mainQueueContext];
    ZDSongBlock *songBlockToSave = [ZDSongBlock objectWithName:[self selectedBlock] inContext:moc];
    
    
    
    
    //VALIDATE INPUT DATA
    //Validate Project
    if (![self theSelectedZDBar]) {
        
        //project not set, return without do nothing
        return;
    }
    
    
    
    
    
    
    
    
    //DELEGATE WILL
    if (beforeTheCurrentBar) {
        
        if ([[self delegate] respondsToSelector:@selector(viewController:willInsertXBars:ofType:beforeTheCurrentBar:)]) {
            
            [[self delegate] viewController:self willInsertXBars:numberOfBarsToInsert ofType:songBlockToSave beforeTheCurrentBar:YES];
        }
    }
    else {
    
        if ([[self delegate] respondsToSelector:@selector(viewController:willInsertXBars:ofType:beforeTheCurrentBar:)]) {
            
            [[self delegate] viewController:self willInsertXBars:numberOfBarsToInsert ofType:songBlockToSave beforeTheCurrentBar:NO];
        }
    }
    
    
    
    
    //INSERT INTO DB - First change only the order
    ZDProject *theProject = [[self theSelectedZDBar] theProject];
    
    for (ZDBar *bIterator in [theProject bars]) {
        
        //Before, do nothing
        if ([[bIterator order] intValue] < [[[self theSelectedZDBar] order] intValue]) {
            
            continue;
        }
        
        
        
        //The selected Bar
        if ([[bIterator order] intValue] == [[[self theSelectedZDBar] order] intValue]) {
            
            if (beforeTheCurrentBar) {
                
                //the to change
                int newOrder = [[bIterator order] intValue] + [numberOfBarsToInsert intValue];
                [bIterator setOrder:[NSNumber numberWithInt:newOrder]];
            }
            else {
            
                //do nothing
                continue;
            }
        }
        
        
        //after
        if ([[bIterator order] intValue] > [[[self theSelectedZDBar] order] intValue]) {
            
            int newOrder = [[bIterator order] intValue] + [numberOfBarsToInsert intValue];
            [bIterator setOrder:[NSNumber numberWithInt:newOrder]];
        }
    }
    
    
    
    

    //INSERT INTO DB
    ZDBar *barToSave = nil;
    
    //decide the order
    int newCurrentInsertOrder = 1;
    
    
    if (beforeTheCurrentBar) {
        
        newCurrentInsertOrder = [[[self theSelectedZDBar] order] intValue];
    }
    else {
        
        newCurrentInsertOrder = [[[self theSelectedZDBar] order] intValue] + 1;
    }
    
    
    
    
    //Now generate the new bars
    for (int i = 0; i < [numberOfBarsToInsert intValue]; i++) {
        
        NSLog(@"i = %d", i);
        
        
        barToSave = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
        [barToSave setChordType:[[self theSelectedZDBar] chordType]];
        [barToSave setChordNote:[[self theSelectedZDBar] chordNote]];
        [barToSave setOrder:[NSNumber numberWithInt:newCurrentInsertOrder]];
        [barToSave setSongBlock:[NSNumber numberWithInt:1]];
        [barToSave setTimeSignatureBeatCount:[[self theSelectedZDBar] timeSignatureBeatCount]];
        [barToSave setTimeSignatureNoteValue:[[self theSelectedZDBar] timeSignatureNoteValue]];
        [barToSave setTheSongBlock:songBlockToSave];
        
        
        //add bar to project
        [theProject addBarsObject:barToSave];
        
        
        //update next order
        newCurrentInsertOrder++;
    }
    
    
    
    NSError *error = nil;
    [moc save:&error];
    
    if(error) {
        NSLog(@"CORE DATA ERROR: Saving New Project: %@", [error debugDescription]);
    }
    else {
        
        NSLog(@"UPDATE: OK");
    }

    
    
    
    
    
    //DELEGATE DID
    if (beforeTheCurrentBar) {
       
        if ([[self delegate] respondsToSelector:@selector(viewController:didInsertXBars:ofType:beforeTheCurrentBar:)]) {
            
            [[self delegate] viewController:self didInsertXBars:numberOfBarsToInsert ofType:songBlockToSave beforeTheCurrentBar:YES];
        }
    }
    else {
        
        if ([[self delegate] respondsToSelector:@selector(viewController:didInsertXBars:ofType:beforeTheCurrentBar:)]) {
            
            [[self delegate] viewController:self didInsertXBars:numberOfBarsToInsert ofType:songBlockToSave beforeTheCurrentBar:NO];
        }
    }
    
    
}


@end
