//
//  ZDLoadProjectController.m
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDLoadProjectController.h"
#import "ZDCoreDataStack.h"
#import "ZDProject+Factory.h"
#import "NSManagedObjectID+ZDString.h"
#import "ZDLoadTableViewCell.h"


@interface ZDLoadProjectController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem* revealButtonItem;

@end



@implementation ZDLoadProjectController


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
    
    
    //Force/Set the height of each cell in order to remove the warning in iOS8
    [[self tableView] setRowHeight:44];
    
    
    //
    [[self revealButtonItem] setTarget: [self revealViewController]];
    [[self revealButtonItem] setAction: @selector( revealToggle: )];
    [[[self navigationController] navigationBar] addGestureRecognizer: [[self revealViewController] panGestureRecognizer]];
    
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ZDProject"];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                ascending:YES]]];
    
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:[ZDCoreDataStack mainQueueContext]
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Table view data source
//---------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MY_PROJECT_LOAD";
    
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ZDLoadTableViewCell *cell = (ZDLoadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    
    
    
    // Configure the cell...
    if(!cell) {
        
        cell = [[ZDLoadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MY_PROJECT_LOAD"];
    }
    
    
    // Configure the cell...
    ZDProject *theProject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    NSString *sss = nil;
    if([theProject band]) {
    
        sss = [NSString stringWithFormat:@"%@ (%@)", [theProject name], [theProject band]];
    }
    else {
        sss = [NSString stringWithFormat:@"%@", [theProject name]];
    }
    
    [[cell textLabel] setText:sss];
    
    
    //special features fo SWTableCell
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:@"Delete"];
    
    [cell setDelegate:self];
    [cell setRightUtilityButtons:rightUtilityButtons];
    
    return cell;
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - SWTableCell Delegate
//---------------------------------------------------------------------------------------
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            // Delete button is pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            
            //select the project to delete
            ZDProject *theProject = [[self fetchedResultsController] objectAtIndexPath:cellIndexPath];
            NSString *theProjectID = [[theProject objectID] stringRepresentation];
            
            
            //delete
            NSError *error = nil;
            NSManagedObjectContext *moc = [ZDCoreDataStack mainQueueContext];
            [moc deleteObject:theProject];
            
            //SAVE
            [moc save:&error];
            
            if(error) {
                NSLog(@"CORE DATA ERROR: Deleting a Project: %@", [error debugDescription]);
            }
            else {
                NSLog(@"DELETE: OK");
            }


            //update UI
            //[[self tableView] deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            
            //test if the deleted project is the one selected
            //Call Delegate
            if([[self delegate] respondsToSelector:@selector(viewController:didDeleteZDProjectWithID:)]){
                
                [[self delegate] viewController:self didDeleteZDProjectWithID:theProjectID];
            }
            
            
            
            
            break;
        }
        default:
            break;
    }
}




//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - TableView Delegate
//---------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZDProject *theProject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    
    //Call Delegate
    if([[self delegate] respondsToSelector:@selector(viewController:willLoadZDProject:andProjectID:)]){
        
        [[self delegate] viewController:self willLoadZDProject:[theProject name] andProjectID:[[theProject objectID] stringRepresentation]];
    }
    
    
    
    
    
    //Call Delegate
    if ([[self delegate] respondsToSelector:@selector(viewController:didLoadZDProjectWithID:)]) {

        [[self delegate] viewController:self didLoadZDProjectWithID:[[theProject objectID] stringRepresentation]];
    }
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(self.editing) {
        
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}




@end
