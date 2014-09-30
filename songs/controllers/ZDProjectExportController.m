//
//  ZDProjectExportController.m
//  songs
//
//  Created by Jorge Moura on 26/09/2014.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDProjectExportController.h"
#import "ZDProject+Factory.h"
#import "ZDBar+Factory.h"
#import "ZDSongBlock+Factory.h"


@interface ZDProjectExportController ()

@property (weak, nonatomic) IBOutlet UIImageView *emailImageView;

- (NSString *)bodyTextFromProject;

@end



@implementation ZDProjectExportController




//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Controller Lifecycle
//---------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Target/Action
//---------------------------------------------------------------------------------------
- (IBAction)exportByEmailButtonPressed:(id)sender {
    
    
    if(![MFMailComposeViewController canSendMail]) {
    
        NSLog(@"WARNING: This device cannot send emails.");
        return;
    }
    
    if (![self theSelectedZDProject]) {
        
        return;
    }
    
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];

    
    NSString *theSubject = [NSString stringWithFormat:@"Songz: %@", [[self theSelectedZDProject] name]];
    NSString *theBody = [self bodyTextFromProject];
    
    
    [mailController setMailComposeDelegate:self];
    [mailController setSubject:theSubject];
    
    [mailController setMessageBody:theBody isHTML:YES];
    [mailController setToRecipients:nil];
    
    
    mailController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:mailController animated:YES completion:NULL];
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - MFMailComposeViewControllerDelegate
//---------------------------------------------------------------------------------------

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    BOOL sendDelegateSignal = NO;
    
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            sendDelegateSignal = YES;
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            sendDelegateSignal = YES;
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
    if (sendDelegateSignal) {
        
        if ([[self delegate] respondsToSelector:@selector(viewControllerExportFinished:)]) {
            
            [[self delegate] viewControllerExportFinished:self];
        }
    }
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Private
//---------------------------------------------------------------------------------------
- (NSString *)bodyTextFromProject {

    //NSString *result = nil;

    
    NSMutableString *body = [NSMutableString string];
    
    // add HTML before the link here with line breaks (\n)
    
    [body appendString:@"<h1>SongZ</h1>\n"];
    [body appendString:@" \n"];
    [body appendString:@"<div> \n"];
    [body appendString:@" \n"];
    [body appendString:@" <h2>Project: "];
    [body appendString:[[self theSelectedZDProject] name]];
    [body appendString:@" </h2>\n"];
    [body appendString:@" \n"];
    [body appendString:@" <h3>Band: \n"];
    [body appendString:[[self theSelectedZDProject] band]];
    [body appendString:@" </h3>\n"];
//    [body appendString:@" \n"];
//    [body appendString:@" \n"];
//    [body appendString:@" \n"];
//    [body appendString:@" \n"];
//    [body appendString:@" \n"];
//    [body appendString:@" \n"];
//    [body appendString:@" \n"];
//    [body appendString:@" \n"];
//    [body appendString:@" \n"];
//    [body appendString:@" \n"];
    [body appendString:@"</div>\n"];
    [body appendString:@" \n"];
    [body appendString:@"<div>\n"];
    [body appendString:@" <h2>Song Structure</h2>\n"];
    [body appendString:@" \n"];
    
    
    for (ZDBar *theBar in [[self theSelectedZDProject] bars]) {
        
        [body appendString:@" Chord: "];
        [body appendString:[theBar chordTypeText]];
        [body appendString:@" "];
        [body appendString:@" | "];
    }

    [body appendString:@"\n"];
    [body appendString:@"</div>\n"];
    
    
    NSLog(@"%@", body);

    
    return [NSString stringWithString:body];
}


@end









