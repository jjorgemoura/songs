//
//  ZDDetailsBarControllerViewController.m
//  songs
//
//  Created by Jorge Moura on 24/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDDetailsBarController.h"
#import "ZDBar+Factory.h"
#import "ZDProject+Factory.h"
#import "ZDSongBlock+Factory.h"
#import "UIColor+HexString.h"

@interface ZDDetailsBarController ()

@property (weak, nonatomic) IBOutlet UILabel *theChord;
@property (weak, nonatomic) IBOutlet UILabel *theTimeSig;
@property (weak, nonatomic) IBOutlet UILabel *theBarNumber;
@property (weak, nonatomic) IBOutlet UILabel *theChordBKColor;
@property (weak, nonatomic) IBOutlet UILabel *theSongBlock;

@end



@implementation ZDDetailsBarController


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
    
    if([self theBar]) {
    
        NSString *timeSig = [NSString stringWithFormat:@"%@/%@", [[self theBar] timeSignatureBeatCount], [[self theBar] timeSignatureNoteValue]];
        NSString *barNumber = [NSString stringWithFormat:@"Bar #%@", [[[self theBar] order] stringValue]];
        
        [[self theChord] setText:[[self theBar] chordType]];
        [[self theTimeSig] setText:timeSig];
        [[self theBarNumber] setText:barNumber];
        [[self theChordBKColor] setBackgroundColor:[UIColor colorWithHexString:[[[self theBar] theSongBlock] color]]];
        [[self theSongBlock] setText:[[[self theBar] theSongBlock] name]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Target Action
//---------------------------------------------------------------------------------------
- (IBAction)saveButtonPressed:(id)sender {
    
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    
}


@end
