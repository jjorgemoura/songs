//
//  ZDSettingsController.m
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDSettingsController.h"

@interface ZDSettingsController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem* revealButtonItem;

@end



@implementation ZDSettingsController


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



@end
