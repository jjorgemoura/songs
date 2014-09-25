//
//  ZDEditBarController.m
//  songs
//
//  Created by Jorge Moura on 19/09/2014.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDEditBarController.h"
#import "ZDBar+Factory.h"
#import "ZDSongBlock+Factory.h"
#import "ZDCoreDataStack.h"
#import "ZDNote.h"
#import "ZDChordType.h"


@interface ZDEditBarController ()


@property (nonatomic, weak) IBOutlet UILabel *numberOfBeats;
@property (nonatomic, weak) IBOutlet UILabel *valueOfTheBeats;
@property (weak, nonatomic) IBOutlet UIStepper *beatCounterSteper;
@property (weak, nonatomic) IBOutlet UIStepper *noteValueSteper;

@property (nonatomic) BOOL numberOfBeatsChanged;
@property (nonatomic) BOOL valueOfBeatsChanged;



@property (nonatomic, weak) IBOutlet UIPickerView *songBlockSlider;
@property (nonatomic, strong) NSArray *songBlocksDataSource;
@property (nonatomic, strong) NSString *selectedBlock;



@property (nonatomic, weak) IBOutlet UIPickerView *chordsSlider;
@property (nonatomic, strong) NSArray *chordNotesList;
@property (nonatomic, strong) NSArray *chordTypesList;
@property (nonatomic, strong) ZDNote *selectedChordNote;
@property (nonatomic, strong) ZDChordType *selectedChordType;

@end



@implementation ZDEditBarController



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Controller Lifecycle
//---------------------------------------------------------------------------------------
- (void)viewDidLoad {
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    
    //Set default Block Selection
    if (![self selectedBlock]) {
        
        [self setSelectedBlock:[[[self theSelectedZDBar] theSongBlock] name]];
        
        NSUInteger theSelIndex = [[self songBlocksDataSource] indexOfObject:[[[self theSelectedZDBar] theSongBlock] name]];
        
        [[self songBlockSlider] selectRow:theSelIndex inComponent:0 animated:YES];
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
    
    
    
    
    //Steppers
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
    

    
    if (pickerView == [self songBlockSlider] && component == 0) {
        NSString *obj = [[self songBlocksDataSource] objectAtIndex:row];
        as = [[NSAttributedString alloc] initWithString:obj];
    }

    
    if (pickerView == [self chordsSlider] && component == 0) {
        NSString *obj = [[[self chordNotesList] objectAtIndex:row] noteText];
        as = [[NSAttributedString alloc] initWithString:obj];
    }
    
    if (pickerView == [self chordsSlider] && component == 1) {
        ZDChordType *cType = [[self chordTypesList] objectAtIndex:row];
        NSString *obj = [cType type];
        as = [[NSAttributedString alloc] initWithString:obj];
    }
    
    
    
    return as;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if(pickerView == [self songBlockSlider] && component == 0) {
            
        [self setSelectedBlock:[[self songBlocksDataSource] objectAtIndex:row]];
    }
    
    
    if(pickerView == [self chordsSlider] && component == 0) {
        
    }

    if(pickerView == [self chordsSlider] && component == 1) {
        
    }
}




//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Stepper
//---------------------------------------------------------------------------------------

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
#pragma mark - Target Action
//---------------------------------------------------------------------------------------

- (IBAction)cancelButtonPressed:(id)sender {
    
    if ([[self delegate] respondsToSelector:@selector(viewControllerEditBarCancel:)]) {
        
        [[self delegate] viewControllerEditBarCancel:self];
    }
}


- (IBAction)saveButtonPressed:(id)sender {

    //CALL the delegate
    if ([[self delegate] respondsToSelector:@selector(viewController:willEditBar:)]) {
        
        [[self delegate] viewController:self willEditBar:nil];
    }

    
    //some vars
    NSManagedObjectContext *moc = [ZDCoreDataStack mainQueueContext];
    
    
    
    
    //EDIT INTO DB
    //BLOCK
    if ([[[[self theSelectedZDBar] theSongBlock] name] isEqualToString:[self selectedBlock]]) {
        
        //do nothing
    }
    else {
    
        
        ZDSongBlock *songBlockToSave = [ZDSongBlock objectWithName:[self selectedBlock] inContext:moc];
        
        [[self theSelectedZDBar] setTheSongBlock:songBlockToSave];
    }
    
    
    
    //TIME SIGNATURE
    if ([self numberOfBeatsChanged]) {

        NSNumber *nb = [NSNumber numberWithInteger:[[[self numberOfBeats] text] integerValue]];
        [[self theSelectedZDBar] setTimeSignatureBeatCount:nb];
    }
    
    if ([self valueOfBeatsChanged]) {
    
        NSNumber *vb = [NSNumber numberWithInteger:[[[self valueOfTheBeats] text] integerValue]];
        [[self theSelectedZDBar] setTimeSignatureNoteValue:vb];
    }
    
    
    
    
    NSError *error = nil;
    [moc save:&error];
    
    if(error) {
        NSLog(@"CORE DATA ERROR: Saving New Project: %@", [error debugDescription]);
    }
    else {
        
        NSLog(@"UPDATE: OK");
    }
    
    
    
    
    
    
    
    
    
    //CALL the delegate
    if ([[self delegate] respondsToSelector:@selector(viewController:didEditBar:)]) {
        
        [[self delegate] viewController:self didEditBar:nil];
    }
}





@end
