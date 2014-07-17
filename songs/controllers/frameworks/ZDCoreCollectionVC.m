//
//  ZDCoreCollectionVC.m
//  songs
//
//  Created by Jorge Moura on 16/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDCoreCollectionVC.h"


@interface ZDCoreCollectionVC ()


@end



@implementation ZDCoreCollectionVC


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
    [[self collectionView] reloadData];
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
            
            [[self collectionView] reloadData];
        }
    }
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger rows = 0;
    
    if ([[[self fetchedResultsController] sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
        rows = [sectionInfo numberOfObjects];
    }
    return rows;
}



#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    //[[self collectionView] beginUpdates];
    if ([self debug]) {
        NSLog(@"ZDCORECOLLECTION: controllerWillChangeContent");
    }
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    if ([self debug]) {
        NSLog(@"ZDCORECOLLECTION: didchangeSection:atIndex:forChangeType");
    }
    
//    switch(type)
//    {
//        case NSFetchedResultsChangeInsert:
//            [[self collectionView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [[self collectionView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

    if ([self debug]) {
        NSLog(@"ZDCORECOLLECTION: controller:didChangeObject:atIndexPath:forChangeType:newIndexPath");
    }
    
//    switch(type)
//    {
//        case NSFetchedResultsChangeInsert:
//            [[self collectionView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [[self collectionView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            [[self collectionView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [[self collectionView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [[self collectionView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    if ([self debug]) {
        NSLog(@"ZDCORECOLLECTION: controllerDidChangeContent");
    }
    
    //[[self collectionView] endUpdates];
}

@end
