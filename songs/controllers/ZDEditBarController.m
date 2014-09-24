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
//#import "ZDProject+Factory.h"


@interface ZDEditBarController ()


@property (nonatomic, weak) IBOutlet UIPickerView *songBlockSlider;
@property (nonatomic, strong) NSArray *songBlocksDataSource;
@property (nonatomic, strong) NSString *selectedBlock;




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
