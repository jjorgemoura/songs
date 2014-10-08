//
//  ZDMultipleSelectionController.m
//  songs
//
//  Created by Jorge Moura on 07/10/2014.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDMultipleSelectionController.h"
#import "ZDBar+Factory.h"
#import "ZDProject+Factory.h"
#import "ZDSongBlock+Factory.h"
#import "ZDCoreDataStack.h"
#import "UIColor+HexString.h"


@interface ZDMultipleSelectionController ()
@property (weak, nonatomic) IBOutlet UILabel *fromChordLabel;
@property (weak, nonatomic) IBOutlet UILabel *toChordLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *toOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromBlockLabel;
@property (weak, nonatomic) IBOutlet UILabel *toBlockLabel;


@property (nonatomic) int minOrderToDelete;
@property (nonatomic) int maxOrderToDelete;

@end



@implementation ZDMultipleSelectionController


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - ViewController Lifecycle
//---------------------------------------------------------------------------------------
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSString *fromChord = @"";
    NSString *toChord = @"";
    int minOrder = 0;
    int maxOrder = 0;
    UIColor *minChordColor = nil;
    UIColor *maxChordColor = nil;
    NSString *fromBlock = @"";
    NSString *toBlock = @"";
    
    
    if ([self theBarsList]) {
        
        minOrder = [[(ZDBar *)[[self theBarsList] objectAtIndex:0] order] intValue];
        maxOrder = [[(ZDBar *)[[self theBarsList] objectAtIndex:0] order] intValue];
        
        
        for (ZDBar *x in [self theBarsList]) {
            
            if ([[x order] intValue] <= minOrder) {
                
                minOrder = [[x order] intValue];
                fromChord = [x chordTypeText];
                minChordColor = [UIColor colorWithHexString:[[x theSongBlock] hexColor]];
                fromBlock = [[x theSongBlock] name];
                [self setMinOrderToDelete:[[x order] intValue]];
            }
            
            
            if ([[x order] intValue] >= maxOrder) {
                
                maxOrder = [[x order] intValue];
                toChord = [x chordTypeText];
                maxChordColor = [UIColor colorWithHexString:[[x theSongBlock] hexColor]];
                toBlock = [[x theSongBlock] name];
                [self setMaxOrderToDelete:[[x order] intValue]];
            }
        }
    }
    
    
    //set the labels
    [[self fromChordLabel] setText:fromChord];
    [[self fromChordLabel] setBackgroundColor:minChordColor];
    [[self fromOrderLabel] setText:[NSString stringWithFormat:@"Bar #%d", minOrder]];
    [[self fromBlockLabel] setText:fromBlock];
    
    
    [[self toChordLabel] setText:toChord];
    [[self toChordLabel] setBackgroundColor:maxChordColor];
    [[self toOrderLabel] setText:[NSString stringWithFormat:@"Bar #%d", maxOrder]];
    [[self toBlockLabel] setText:toBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Target Action
//---------------------------------------------------------------------------------------
- (IBAction)deleteButtonPressed:(id)sender {
    
    UIAlertController *confirmationAlertBox = [UIAlertController alertControllerWithTitle:@"Delete Bars" message:@"Do you want to delete the selected bars?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             //DELEGATE
                                                             if ([[self delegate] respondsToSelector:@selector(viewControllerWillDeleteZDBars:)]) {
                                                                 
                                                                 [[self delegate] viewControllerWillDeleteZDBars:self];
                                                             }
                                                             
                                                             
                                                             
                                                             //Orders
                                                             //Check properties
                                                             int numberBarsToDelete = (int)[[self theBarsList] count];
                                                             
                                                             
                                                             //INSERT INTO DB - First change only the order
                                                             ZDProject *theProject = [(ZDBar *)[[self theBarsList] objectAtIndex:0] theProject];
                                                             
                                                             for (ZDBar *bIterator in [theProject bars]) {
                                                                 
                                                                 //Before, do nothing
                                                                 if ([[bIterator order] intValue] <= [self maxOrderToDelete]) {
                                                                     
                                                                     continue;
                                                                 }
                                                                 
                                                                 //after
                                                                 if ([[bIterator order] intValue] > [self maxOrderToDelete]) {
                                                                     
                                                                     int newOrder = [[bIterator order] intValue] - numberBarsToDelete;
                                                                     [bIterator setOrder:[NSNumber numberWithInt:newOrder]];
                                                                     continue;
                                                                 }
                                                             }
                                                             
                                                             
                                                             
                                                             
                                                             
                                                             //DELETE
                                                             NSManagedObjectContext *moc = [ZDCoreDataStack mainQueueContext];
                                                             
                                                             for (ZDBar *x in [self theBarsList]) {
                                                                 
                                                                 [moc deleteObject:x];
                                                             }
                                                             
                                                             
                                                             //DAVE
                                                             NSError *error = nil;
                                                             [moc save:&error];
                                                             
                                                             if(error) {
                                                                 NSLog(@"CORE DATA ERROR: Deleting/Updating Multiple Bars: %@", [error debugDescription]);
                                                             }
                                                             else {
                                                                 
                                                                 NSLog(@"DELETE BARS: OK");
                                                             }
                                                             
                                                             
                                                             //DELEGATE
                                                             if ([[self delegate] respondsToSelector:@selector(viewControllerDidDeleteZDBars:)]) {
                                                                 
                                                                 [[self delegate] viewControllerDidDeleteZDBars:self];
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
