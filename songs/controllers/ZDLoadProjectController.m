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
    
    //
    [[self revealButtonItem] setTarget: [self revealViewController]];
    [[self revealButtonItem] setAction: @selector( revealToggle: )];
    [[[self navigationController] navigationBar] addGestureRecognizer: [[self revealViewController] panGestureRecognizer]];
    
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ZDProject"];
    //NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"name = "];
    //[request setPredicate:thePredicate];
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
    static NSString *CellIdentifier = @"MY_PROJECT_LOAD";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    // Configure the cell...
    if(!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MY_PROJECT_LOAD"];
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
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    
    
    
    
    
    
    NSLog(@"Project Loaded: %@", [theProject name]);
    
    
    //Call Delegate
    if ([[self delegate] respondsToSelector:@selector(viewController:didLoadZDProjectWithID:)]) {

        [[self delegate] viewController:self didLoadZDProjectWithID:[[theProject objectID] stringRepresentation]];
    }
    
}

@end
