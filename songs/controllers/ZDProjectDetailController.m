//
//  ZDProjectDetailController.m
//  songs
//
//  Created by Jorge Moura on 26/09/2014.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDProjectDetailController.h"

@interface ZDProjectDetailController ()

@property (nonatomic, weak) IBOutlet UILabel *labelNumber1;
@property (nonatomic, weak) IBOutlet UILabel *labelNumber2;
@property (nonatomic, weak) IBOutlet UILabel *labelNumber3;
@property (nonatomic, weak) IBOutlet UILabel *labelNumber4;
@property (nonatomic, weak) IBOutlet UILabel *labelNumber5;
@property (nonatomic, weak) IBOutlet UILabel *labelNumber6;



@end




@implementation ZDProjectDetailController




//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Controller Lifecycle
//---------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self songProjectName]) {
        
        [self setTitle:@"zsdfasdfasdf"];
    }
    else {
    
        [self setTitle:@"Project Details"];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[self labelNumber1] setText:nil];
    [[self labelNumber2] setText:nil];
    [[self labelNumber3] setText:nil];
    [[self labelNumber4] setText:nil];
    [[self labelNumber5] setText:nil];
    [[self labelNumber6] setText:nil];
}

- (void)viewDidAppear:(BOOL)animated {

    
    if ([self songProjectName]) {
        
        [[self labelNumber1] setText:[self songProjectName]];
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
