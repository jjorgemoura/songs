//
//  ZDCoreDataTableVC.m
//  songs
//
//  Created by Jorge Moura on 07/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDCoreDataTableVC.h"


@interface ZDCoreDataTableVC ()


@end




@implementation ZDCoreDataTableVC



#pragma mark - Fetching

- (void)performFetch
{
    
    if([self fetchedResultsController]) {
        
        //fetchResultcontroller is OK
        
        //check if FRC contain a predicate
        if([[[self fetchedResultsController] fetchRequest] predicate]) {
            
            //LOG
            if([self debug]) {
                NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
            }
        }
        else {
            
            //LOG
            if([self debug]) {
                
                NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
            }
        }
        
        
        NSError *error;
        BOOL success = [[self fetchedResultsController] performFetch:&error];
        
        if (!success) {
            
            NSLog(@"[%@ %@] performFetch: failed", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        }
        
        if (error) {
            
            NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
        }
    }
    else {
        
        if (self.debug) {
            
            NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        }
    }
    
    //Reload TableData
    [[self tableView] reloadData];
}



#pragma mark - Getters + Setters
- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    
    if (newfrc != oldfrc) {
        
        //Update iVar
        _fetchedResultsController = newfrc;
        [newfrc setDelegate:self];
        
        
        //Update Title of Table View Controller
        if(![self title] || [[self title] isEqualToString:[[[oldfrc fetchRequest] entity] name]]) {
            //true if title is not set or title is equals to old fr name
            
            if(![self navigationController] || [[self navigationItem] title]) {
                //true if no navigation controller is present or if present, the nav item doest have title
                
                //Update Title
                [self setTitle: [[[newfrc fetchRequest] entity] name]];
            }
        }
        
        
        //Se new FetchRequest is OK, do fetchrequest
        if(newfrc) {
            
            if([self debug]) {
                
                NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
                
            }
            
            [self performFetch];
            
        } else {
            if ([self debug]) {
                
                NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            }
            
            [[self tableView] reloadData];
        }
    }
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSInteger sections = [[[self fetchedResultsController] sections] count];
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if ([[[self fetchedResultsController] sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
        rows = [sectionInfo numberOfObjects];
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    //NSString *sss =[[[[self fetchedResultsController] sections] objectAtIndex:section] name];
    //NSObject *xxx = [[[self fetchedResultsController] sections] objectAtIndex:section];
    
	return [[[[self fetchedResultsController] sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [[self fetchedResultsController] sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[self fetchedResultsController] sectionIndexTitles];
}




#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] endUpdates];
}





@end
