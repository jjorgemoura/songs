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
#import "ZDNote.h"
#import "ZDChordType.h"


@interface ZDAddInsertBarsController ()


@property (nonatomic, weak) IBOutlet UILabel *numberOfBars;


@property (nonatomic, weak) IBOutlet UIPickerView *songBlockSlider;
@property (nonatomic, strong) NSArray *songBlocksDataSource;
@property (nonatomic, strong) NSString *selectedBlock;


@property (nonatomic, weak) IBOutlet UILabel *numberOfBeats;
@property (nonatomic, weak) IBOutlet UILabel *valueOfTheBeats;
@property (weak, nonatomic) IBOutlet UIStepper *beatCounterSteper;
@property (weak, nonatomic) IBOutlet UIStepper *noteValueSteper;
@property (nonatomic) BOOL numberOfBeatsChanged;
@property (nonatomic) BOOL valueOfBeatsChanged;


@property (nonatomic, weak) IBOutlet UIPickerView *chordsSlider;
@property (nonatomic, strong) NSArray *chordNotesList;
@property (nonatomic, strong) NSArray *chordTypesList;
@property (nonatomic, strong) ZDNote *selectedChordNote;
@property (nonatomic, strong) ZDChordType *selectedChordType;


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
    
    
    
    //Load The Picker Data Source - Chords
    [self setChordNotesList:[ZDNote list]];
    [self setChordTypesList:[ZDChordType list]];
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
    
    
    
    
    //Set the Chords List Pre Selection
    if (![self selectedChordNote]) {
        
        NSNumber *cNoteNumber = [[self theSelectedZDBar] chordNote];
        ZDNote *tempNote = [[ZDNote alloc] initWithNote:[cNoteNumber intValue]];
        
        NSUInteger theListIndex = [[self chordNotesList] indexOfObject:tempNote];
        
        [[self chordsSlider] selectRow:theListIndex inComponent:0 animated:YES];
    }
    
    if (![self selectedChordType]) {
        
        NSNumber *cTypeNumber = [[self theSelectedZDBar] chordType];
        ZDChordType *tempType = [ZDChordType instanceWithID:cTypeNumber];
        
        NSUInteger theListIndex = [[self chordTypesList] indexOfObject:tempType];
        
        [[self chordsSlider] selectRow:theListIndex inComponent:1 animated:YES];
    }
    
    
    
    //Steppers - Time Signature
    [self setNumberOfBeatsChanged:NO];
    [self setValueOfBeatsChanged:NO];
    
    
    
    [[self beatCounterSteper] setValue:[[[self theSelectedZDBar] timeSignatureBeatCount] intValue]];
    [[self numberOfBeats] setText:[[[self theSelectedZDBar] timeSignatureBeatCount] stringValue]];
    
    
    switch ([[[self theSelectedZDBar] timeSignatureNoteValue] intValue]) {
        case 2:
            [[self noteValueSteper] setValue:1];
            [[self valueOfTheBeats] setText:[NSString stringWithFormat:@"%d", 2]];
            break;
        case 4:
            [[self noteValueSteper] setValue:2];
            [[self valueOfTheBeats] setText:[NSString stringWithFormat:@"%d", 4]];
            break;
        case 8:
            [[self noteValueSteper] setValue:3];
            [[self valueOfTheBeats] setText:[NSString stringWithFormat:@"%d", 8]];
            break;
        case 16:
            [[self noteValueSteper] setValue:4];
            [[self valueOfTheBeats] setText:[NSString stringWithFormat:@"%d", 16]];
            break;
        case 32:
            [[self noteValueSteper] setValue:6];
            [[self valueOfTheBeats] setText:[NSString stringWithFormat:@"%d", 32]];
            break;
        default:
            [[self noteValueSteper] setValue:2];
            [[self valueOfTheBeats] setText:[NSString stringWithFormat:@"%d", 4]];
            break;
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
    
    int result = 1;
    
    if (pickerView == [self chordsSlider]) {
        result = 2;
    }
    
    return result;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger numRows = 0;
    
    if (pickerView == [self songBlockSlider] && component == 0) {
        numRows = [[self songBlocksDataSource] count];
    }
    
    if (pickerView == [self chordsSlider] && component == 0) {
        numRows = 12;
    }
    
    if (pickerView == [self chordsSlider] && component == 1) {
        numRows = [[self chordTypesList] count];
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
    
    
    if (pickerView == [self chordsSlider] && component == 0) {
        NSString *obj = [[[self chordNotesList] objectAtIndex:row] noteText];
        as = [[NSAttributedString alloc] initWithString:obj];
    }
    
    if (pickerView == [self chordsSlider] && component == 1) {
        ZDChordType *cType = [[self chordTypesList] objectAtIndex:row];
        NSString *obj = [cType typeShort];
        as = [[NSAttributedString alloc] initWithString:obj];
    }
    
    return as;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if(pickerView == [self songBlockSlider] && component == 0) {
            
        [self setSelectedBlock:[[self songBlocksDataSource] objectAtIndex:row]];
    }
    
    
    if(pickerView == [self chordsSlider] && component == 0) {
        
        [self setSelectedChordNote:[[self chordNotesList] objectAtIndex:row]];
    }
    
    if(pickerView == [self chordsSlider] && component == 1) {
        
        [self setSelectedChordType:[[self chordTypesList] objectAtIndex:row]];
    }
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Target Action
//---------------------------------------------------------------------------------------

- (IBAction)InsertBeforeButtonPressed:(id)sender {
    
    //NSLog(@"Insert Before");
    
    [self saveBars:YES];
}


- (IBAction)InsertAfterButtonPressed:(id)sender {

    //NSLog(@"Insert After");
    
    [self saveBars:NO];
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Stepper
//---------------------------------------------------------------------------------------
- (IBAction)valueStepperChanged:(id)sender {
    
    if ([sender isKindOfClass:[UIStepper class]]) {
    
        UIStepper *myStepper = (UIStepper *)sender;
        double newNumberBars = [myStepper value];
        
        [[self numberOfBars] setText:[NSString stringWithFormat:@"%d", (int)newNumberBars]];
    }
}


- (IBAction)numberBeatsStepper:(id)sender {
    
    if ([sender isKindOfClass:[UIStepper class]]) {
        
        UIStepper *myStepper = (UIStepper *)sender;
        double newNumberBeats = [myStepper value];
        
        [[self numberOfBeats] setText:[NSString stringWithFormat:@"%d", (int)newNumberBeats]];
    }
    
    
    [self setNumberOfBeatsChanged:YES];
}


- (IBAction)beatValueStepper:(id)sender {
    
    if ([sender isKindOfClass:[UIStepper class]]) {
        
        UIStepper *myStepper = (UIStepper *)sender;
        int theStepper = (int)[myStepper value];
        
        
        switch (theStepper) {
            case 1:
                [[self valueOfTheBeats] setText:[NSString stringWithFormat:@"%d", 2]];
                break;
            case 2:
                [[self valueOfTheBeats] setText:[NSString stringWithFormat:@"%d", 4]];
                break;
            case 3:
                [[self valueOfTheBeats] setText:[NSString stringWithFormat:@"%d", 8]];
                break;
            case 4:
                [[self valueOfTheBeats] setText:[NSString stringWithFormat:@"%d", 16]];
                break;
            case 5:
                [[self valueOfTheBeats] setText:[NSString stringWithFormat:@"%d", 32]];
                break;
            default:
                [[self valueOfTheBeats] setText:[NSString stringWithFormat:@"%d", 4]];
                break;
        }
        
        
        
        [self setValueOfBeatsChanged:YES];
    }
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Private Methods
//---------------------------------------------------------------------------------------
- (void)saveBars:(BOOL)beforeTheCurrentBar {

    
    
    //VALIDATE INPUT DATA
    //Validate Project
    if (![self theSelectedZDBar]) {
        
        //project not set, return without do nothing
        return;
    }
    
    
    
    //the new Data
    NSNumber *numberOfBarsToInsert = [NSNumber numberWithInteger:[[[self numberOfBars] text] integerValue]];
    
    NSManagedObjectContext *moc = [ZDCoreDataStack mainQueueContext];
    ZDSongBlock *songBlockToSave = [ZDSongBlock objectWithName:[self selectedBlock] inContext:moc];
    
    
    
    
    //Decide the Order
    int theCurrentBarOrder = [[[self theSelectedZDBar] order] intValue];
    int newCurrentInsertOrder = 1;
    
    if (beforeTheCurrentBar) {
        
        newCurrentInsertOrder = [[[self theSelectedZDBar] order] intValue];
    }
    else {
        
        newCurrentInsertOrder = [[[self theSelectedZDBar] order] intValue] + 1;
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
        
        //NSLog(@"Bars: %d - %@", [[bIterator order] intValue], [bIterator chordTypeText]);
        
        //Before, do nothing
        if ([[bIterator order] intValue] < theCurrentBarOrder) {
            
            continue;
        }
        
        
        
        //The selected Bar
        if ([[bIterator order] intValue] == theCurrentBarOrder) {
            
            if (beforeTheCurrentBar) {
                
                //the to change
                int newOrder = [[bIterator order] intValue] + [numberOfBarsToInsert intValue];
                [bIterator setOrder:[NSNumber numberWithInt:newOrder]];
                //NSLog(@"Bars: %d - %@ - %d", [[bIterator order] intValue], [bIterator chordTypeText], newOrder);
                continue;
            }
            else {
            
                //do nothing
                continue;
            }
        }
        
        
        //after
        if ([[bIterator order] intValue] > theCurrentBarOrder) {
            
            int newOrder = [[bIterator order] intValue] + [numberOfBarsToInsert intValue];
            [bIterator setOrder:[NSNumber numberWithInt:newOrder]];
            //NSLog(@"Bars: %d - %@ - %d", [[bIterator order] intValue], [bIterator chordTypeText], newOrder);
            continue;
        }
    }
    
    
    
    //Process Time Signature
    NSNumber *nb = [[self theSelectedZDBar] timeSignatureBeatCount];
    NSNumber *vb = [[self theSelectedZDBar] timeSignatureNoteValue];
    
    
    if ([self numberOfBeatsChanged]) {
        
        nb = [NSNumber numberWithInteger:[[[self numberOfBeats] text] integerValue]];
    }
    
    if ([self valueOfBeatsChanged]) {
        
        vb = [NSNumber numberWithInteger:[[[self valueOfTheBeats] text] integerValue]];
    }
    
    
    //Process Chords
    NSNumber *newCN = [[self theSelectedZDBar] chordNote];
    NSNumber *newCT = [[self theSelectedZDBar] chordType];
    
    if ([self selectedChordNote]) {
        
        NSInteger cn = [[self selectedChordNote] note];
        newCN = [NSNumber numberWithInteger:cn];
    }
    
    if ([self selectedChordType]) {
        
        newCT = [[self selectedChordType] typeID];
    }
    
    

    //INSERT INTO DB
    ZDBar *barToSave = nil;
    
    //Now generate the new bars
    for (int i = 0; i < [numberOfBarsToInsert intValue]; i++) {
        
        //NSLog(@"i = %d", i);
        
        barToSave = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
        [barToSave setChordNote:newCN];
        [barToSave setChordType:newCT];
        [barToSave setOrder:[NSNumber numberWithInt:newCurrentInsertOrder]];
        [barToSave setSongBlock:[NSNumber numberWithInt:1]];
        [barToSave setTimeSignatureBeatCount:nb];
        [barToSave setTimeSignatureNoteValue:vb];
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
