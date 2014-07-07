//
//  ZDCoreDataTableVC.h
//  songs
//
//  Created by Jorge Moura on 07/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDCoreDataTableVC : UITableViewController <NSFetchedResultsControllerDelegate>



// The controller (this class fetches nothing if this is not set).
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

// Set to YES to get some debugging output in the console.
@property BOOL debug;



// Causes the fetchedResultsController to refetch the data.
// Almost certainly never need to call this.
// The NSFetchedResultsController class observes the context
//  (so if the objects in the context change, you do not need to call performFetch
//   since the NSFetchedResultsController will notice and update the table automatically).
// This will also automatically be called if you change the fetchedResultsController @property.
- (void)performFetch;


@end
