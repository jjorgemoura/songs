//
//  ZDNewProjectController.m
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDNewProjectController.h"
#import "ZDCoreDataStack.h"
#import "ZDProject+Factory.h"
#import "ZDBar+Factory.h"
#import "NSManagedObjectID+ZDString.h"

@interface ZDNewProjectController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem* revealButtonItem;

@property (weak, nonatomic) IBOutlet UITextField *projectTextName;
@property (weak, nonatomic) IBOutlet UITextField *bandTextName;
@property (weak, nonatomic) IBOutlet UITextField *composerTextName;
@property (weak, nonatomic) IBOutlet UITextField *lyricsTextName;
@property (weak, nonatomic) IBOutlet UITextField *yearIntName;
@property (weak, nonatomic) IBOutlet UITextField *bpmIntName;
@property (weak, nonatomic) IBOutlet UITextField *keyTextName;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)save:(id)sender;

@end


@implementation ZDNewProjectController


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
#pragma mark - Target Action
//---------------------------------------------------------------------------------------
- (IBAction)save:(id)sender {
    
    BOOL toSave = YES;
    
    if(![[self projectTextName] text]) {
    
        //projectTextName cannot be null
        toSave = NO;
    }
    
    
    //SAVE
    if (toSave) {
        
        NSString *pName = [[self projectTextName] text];
        NSString *pBand = nil;
        NSString *pComposer = nil;
        NSString *pLyrics = nil;
        NSNumber *pYear = nil;
        NSString *pKey = nil;
        NSNumber *pBPM = nil;
        NSNumber *pCreateOn = [NSNumber numberWithInt:1];

        
        //Validate
        pBand = ([[self bandTextName] text]) ? [[self bandTextName] text] : nil ;
        pComposer = ([[self composerTextName] text]) ? [[self composerTextName] text] : nil ;
        pLyrics = ([[self lyricsTextName] text]) ? [[self lyricsTextName] text] : nil ;
        pKey = ([[self keyTextName] text]) ? [[self keyTextName] text] : nil ;
        pYear = ([[self yearIntName] text]) ? [NSNumber numberWithInt:[[[self yearIntName] text] intValue]] : nil ;
        pBPM = ([[self bpmIntName] text]) ? [NSNumber numberWithInt:[[[self bpmIntName] text] intValue]] : nil ;
        
        
        
        
        //Call Delegate
        if ([[self delegate] respondsToSelector:@selector(viewController:willSaveZDProject:)]) {
        
            [[self delegate] viewController:self willSaveZDProject:pName];
        }
        
        
        
        
        
        
        //Save
        __block NSString *objID = nil;
        __block NSString *theMessage = nil;
        
        NSManagedObjectContext *moc = [ZDCoreDataStack mainQueueContext];
        
        
        [moc performBlockAndWait:^{
            
            ZDProject *newProject = [NSEntityDescription insertNewObjectForEntityForName:[ZDProject entityName] inManagedObjectContext:moc];
            [newProject setName:pName];
            [newProject setBand:pBand];
            [newProject setComposer:pComposer];
            [newProject setLyricsBy:pLyrics];
            [newProject setYear:pYear];
            [newProject setBpm:pBPM];
            [newProject setKey:pKey];
            [newProject setCreateOn:pCreateOn];
            [newProject setCreateDate:[NSDate date]];
            
            
            
            NSArray *theSet = [ZDBar defaultBars:moc];
            for (ZDBar *b in theSet) {
                
                [newProject addBarsObject:b];
            }
            
            
            
            
            NSError *error = nil;
            [moc save:&error];
            
            if(error) {
                NSLog(@"CORE DATA ERROR: Saving New Project: %@", [error debugDescription]);
                theMessage = @"ERROR Saving New Project.";
            }
            else {
            
                theMessage = @"OK";
                objID = [[newProject objectID] stringRepresentation];
            }
            
        }];
        
        
        //Call Delegate
        if ([[self delegate] respondsToSelector:@selector(viewController:didSaveZDProjectWithID:andMessage:)]) {
            
            [[self delegate] viewController:self didSaveZDProjectWithID:objID andMessage:theMessage];
        }
        
    }
    
}

@end
