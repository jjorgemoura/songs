//
//  ZDNewProjectController.m
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDNewProjectController.h"

@interface ZDNewProjectController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem* revealButtonItem;

@property (weak, nonatomic) IBOutlet UITextField *projectTextName;
@property (weak, nonatomic) IBOutlet UITextField *bandTextName;
@property (weak, nonatomic) IBOutlet UITextField *composerTextName;
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
    
    NSLog(@"SAVE Button");
    BOOL toSave = YES;
    
    if(![self projectTextName]) {
    
        //projectTextName cannot be null
        toSave = NO;
        //[[self projectTextName] setBorderStyle:<#(UITextBorderStyle)#>];
    }
    
    
    //SAVE
    if (toSave) {
        
        //Check if....
    }
    
    
}

@end
