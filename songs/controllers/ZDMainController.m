//
//  ZDMainController.m
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDMainController.h"
#import "ZDSongCollectionViewCell.h"
#import "ZDCoreDataStack.h"


@interface ZDMainController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem* revealButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* auxRevealButtonItem;

//@property (nonatomic, weak) IBOutlet UICollectionView *mainCollectionView;

@end



@implementation ZDMainController

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Constructor
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
#pragma mark - Controll
//---------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //
    [[self revealButtonItem] setTarget: [self revealViewController]];
    [[self revealButtonItem] setAction: @selector( revealToggle: )];
    [[[self navigationController] navigationBar] addGestureRecognizer: [[self revealViewController] panGestureRecognizer]];
    
    
    [[self auxRevealButtonItem] setTarget: [self revealViewController]];
    [[self auxRevealButtonItem] setAction: @selector( rightRevealToggle: )];
    //[[[self navigationController] navigationBar] addGestureRecognizer: [[self revealViewController] panGestureRecognizer]];
    
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ZDBar"];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"theProject.name"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"theProject.name = 'High'"];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order"
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
#pragma mark - UICollectionView Data Source
//---------------------------------------------------------------------------------------
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    
//    NSInteger result = 15;
//    
//    if (section == 0) {
//        
//        
//    }
//    
//    
//    //NSLog(@"num cell %i for section %i", result, section);
//    return result;
//}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"MY_MAINCOLLECTION_HEADER";
//    
//    
//    return headerView;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Collection view indexpath: %li", (long)[indexPath row]);
    
    static NSString *cellIdentifier = @"MY_MAINCOLLECTION_CELL";
    
    
    ZDSongCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([indexPath section] == 0) {
        
        NSString *theScaleNote = @"Em";
        NSString *theTimeSig = @"4/4";
        [cell mainText:theScaleNote];
        [cell auxText:theTimeSig];
    }
    
    return cell;
}






@end
