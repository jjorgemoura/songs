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
- (NSString *)returnFormattedStringWithPrefixFromString:(NSString *)theString toSize:(int)size;
- (NSDictionary *)barsInDictionary:(NSArray *)barsList;
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

    NSMutableString *body = [NSMutableString string];

    NSString *currentBlock = @"none";
    
    
    //Order the Bars
    NSDictionary *barsDic = [self barsInDictionary:[[[self theSelectedZDProject] bars] array]];
    
    
    
    // add HTML before the link here with line breaks (\n)
    
    [body appendString:@"<h3>SongZ</h3>\n"];
    [body appendString:@" \n"];
    [body appendString:@"<div> \n"];
    [body appendString:@" \n"];
    [body appendString:@" <h5>Project: "];
    [body appendString:[[self theSelectedZDProject] name]];
    
    if ([[self theSelectedZDProject] band]) {

        [body appendString:@" <br>\n"];
        [body appendString:@" Band: \n"];
        [body appendString:[[self theSelectedZDProject] band]];
    }
    
    if ([[self theSelectedZDProject] key]) {
        if (![[[self theSelectedZDProject] key] isEqualToString:@""]) {
            [body appendString:@" <br>\n"];
            [body appendString:@" Key: \n"];
            [body appendString:[[self theSelectedZDProject] key]];
        }
    }
    
    if ([[self theSelectedZDProject] year]) {
        if (![[[self theSelectedZDProject] year] intValue] == 0) {
            [body appendString:@" <br>\n"];
            [body appendString:@" Year: \n"];
            [body appendString:[[[self theSelectedZDProject] year] stringValue]];
        }
    }
    
    [body appendString:@" </h5>\n"];

    
    [body appendString:@"</div>\n"];
    [body appendString:@" \n"];
    [body appendString:@"<div>\n"];
    [body appendString:@" <h5>Song Structure</h5>\n"];
    
    
    
    for (int i = 1; i <= [barsDic count]; i++) {
    
        ZDBar *theBar = [barsDic objectForKey:[NSNumber numberWithInt:i]];
        
      
        if ([[[theBar theSongBlock] name] isEqualToString:currentBlock]) {
            
            [body appendString:@" "];
            [body appendString:[theBar chordTypeText]];
            [body appendString:@" | "];

        }
        else {
        
            if (![currentBlock isEqualToString:@"none"]) {
                [body appendString:@"</p>"];
            }
            
            [body appendString:@" \n"];
            [body appendString:@"<p>"];
            //[body appendString:[[theBar theSongBlock] name]];
            [body appendString:[self returnFormattedStringWithPrefixFromString:[[theBar theSongBlock] name] toSize:10]];
            [body appendString:@": | "];
            [body appendString:[theBar chordTypeText]];
            [body appendString:@" | "];
            
            currentBlock = [[theBar theSongBlock] name];
        }
    }
    
    [body appendString:@"</p>"];
    //[body appendString:@"\n"];
    [body appendString:@"</div>\n"];
    
    
    //NSLog(@"%@", body);

    
    return [NSString stringWithString:body];
}


- (NSString *)returnFormattedStringWithPrefixFromString:(NSString *)theString toSize:(int)size {

    NSString *x = theString;
    
    while ([x length] < size) {
        
        
        x = [x stringByAppendingString:@" "];
    }
    
    return x;
}



- (NSDictionary *)barsInDictionary:(NSArray *)barsList {

    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithCapacity:[barsList count]];

    
    for (ZDBar *x in barsList) {
        
        [mDic setObject:x forKey:[x order]];
    }

    return mDic;
}




@end









