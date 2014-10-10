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
@property (nonatomic, weak) IBOutlet UIImageView *bandImageView;


- (void)searchImageForBand:(NSString *)band andSong:(NSString *)song;
- (void)downloadImageForBand:(NSString *)theURL;

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
        
        [self setTitle:[self songProjectName]];
    }
    else {
    
        [self setTitle:@"Project Details"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[self labelNumber1] setText:nil];
    [[self labelNumber2] setText:nil];
    [[self labelNumber3] setText:nil];
    [[self labelNumber4] setText:nil];
    [[self labelNumber5] setText:nil];
    [[self labelNumber6] setText:nil];
    
    
    //Start Image Search and Download
    [self searchImageForBand:[self bandName] andSong:[self songProjectName]];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    
    //int lineFilled = 0;
    BOOL line2Fill = NO;
    BOOL line3Fill = NO;
    BOOL line4Fill = NO;
    BOOL line5Fill = NO;
    
    BOOL line6Control = NO;

    
    NSString *line1Text = nil;
    NSString *line2Text = nil;
    NSString *line3Text = nil;
    NSString *line4Text = nil;
    NSString *line5Text = nil;
    NSString *line6Text = nil;
    
    //LINE 1
    if ([self year]) {
        if (![[self year] isEqualToString:@"0"]) {

            line1Text = [NSString stringWithFormat:@"%@ (%@)", [self songProjectName], [self year]];
        }
        else {
            line1Text = [NSString stringWithFormat:@"%@", [self songProjectName]];
        }
    }
    else {
    
        line1Text = [NSString stringWithFormat:@"%@", [self songProjectName]];
    }
    
    
    
    
    //LINE 2
    if ([self bandName]) {
        
        line2Text = [NSString stringWithFormat:@"%@", [self bandName]];
        line2Fill = YES;
    }
    
    //LINE 3
    if ([self composerName]) {

        line3Fill = YES;
        if ([self lyricsByName]) {
            
            line3Text = [NSString stringWithFormat:@"Composer: %@ / Lyrics by: %@", [self composerName], [self lyricsByName]];
        }
        else {
            line3Text = [NSString stringWithFormat:@"Composer: %@", [self composerName]];
        }
    }
    else {
    
        if ([self lyricsByName]) {
        
            line3Fill = YES;
            line3Text = [NSString stringWithFormat:@"Lyrics by: %@", [self lyricsByName]];
        }
    }
    
    //LINE 4
    if ([self songKey]) {
        
        line4Fill = YES;
        if ([self bpm]) {
            if (![[self bpm] isEqualToString:@"0"]) {
            
                line4Text = [NSString stringWithFormat:@"Key: %@ / Bpm: %@", [self songKey], [self bpm]];
            }
            else {
                line4Text = [NSString stringWithFormat:@"Key: %@", [self songKey]];
            }
        }
        else {
            line4Text = [NSString stringWithFormat:@"Key: %@", [self songKey]];
        }
    }
    else {
        
        if ([self bpm]) {
            if (![[self bpm] isEqualToString:@"0"]) {
                line4Fill = YES;
                line4Text = [NSString stringWithFormat:@"Bpm by: %@", [self bpm]];
            }
        }
    }
    
    //LINE 5
    if ([self timeSignature]) {
        
        line5Text = [NSString stringWithFormat:@"%@", [self timeSignature]];
        line5Fill = YES;
    }
    
    //LINE6
    line6Text = [NSString stringWithFormat:@"Number of Bars: %@", [self numberBars]];
    
    
    
    //Fills
    [[self labelNumber1] setText:line1Text];

    
    if (line2Fill) {
        [[self labelNumber2] setText:line2Text];
    }
    else if (line3Fill) {
    
        [[self labelNumber2] setText:line3Text];
    }
    else if (line4Fill) {
    
        [[self labelNumber2] setText:line4Text];
    }
    else if (line5Fill) {
    
        [[self labelNumber2] setText:line5Text];
    }
    else {
        [[self labelNumber2] setText:line6Text];
        line6Control = YES;
    }
        
    
    if (line3Fill) {
        [[self labelNumber3] setText:line3Text];
    }
    else if (line4Fill) {
        
        [[self labelNumber3] setText:line4Text];
    }
    else if (line5Fill) {
        
        [[self labelNumber3] setText:line5Text];
    }
    else if (!line6Control) {
        
        [[self labelNumber3] setText:line6Text];
        line6Control = YES;
    }
    
    
    if (line4Fill) {
        [[self labelNumber4] setText:line4Text];
    }
    else if (line5Fill) {
        
        [[self labelNumber4] setText:line5Text];
    }
    else if (!line6Control) {
        
        [[self labelNumber4] setText:line6Text];
        line6Control = YES;
    }
    
    
    if (line5Fill) {
        [[self labelNumber5] setText:line5Text];
    }
    else if (!line6Control) {
        
        [[self labelNumber5] setText:line6Text];
        line6Control = YES;
    }
    
    
    if (!line6Control) {
        
        [[self labelNumber6] setText:line6Text];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Methods
//---------------------------------------------------------------------------------------
- (void)searchImageForBand:(NSString *)band andSong:(NSString *)song {

    
    //1 - Decide the Search Sentence
    NSString *theSearchString = nil;
    
    if(band) {
    
        theSearchString = [[NSString stringWithFormat:@"%@ %@", band, song] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else {
    
        theSearchString = [[NSString stringWithFormat:@"%@", song] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    //theSearchString = [NSString stringWithFormat:@"Beatles"];
    
    
    
    //2 - Decide the URL
    NSString *theURL = [NSString stringWithFormat:GOOGLE_API_URL, GOOGLE_API_KEY, GOOGLE_CX_KEY, theSearchString];
    //NSLog(@"THE URL TO GOOGLE: %@", theURL);
    
    
    
    //3 - Define the NSURL
    NSURL *url = [NSURL URLWithString:theURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    //4 - THE URLSESSION
    NSURLSession *session = [NSURLSession sharedSession];
    
    //BOOL yyy = [NSThread isMainThread];
    //NSLog(@"%@", yyy ? @"THIS IS THE MAIN THREAD" : @"THIS IS NOT THE MAIN THREAD");
    
    
    //5 - The Download Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                        
                                          if (error) {
                                              NSLog(@"GOOGLE IMAGES DOWNLOAD: %@", [error description]);
                                          }
                                          else {
                                              
//                                              BOOL yyy = [NSThread isMainThread];
//                                              NSLog(@"%@", yyy ? @"THIS IS THE MAIN THREAD" : @"THIS IS NOT THE MAIN THREAD");
//                                              NSLog(@"DATA: %@", [data description]);
//                                              NSLog(@"RESPONSE: %@", [response description]);
                                              
                                              
                                              
                                              //PROCESS JSON
                                              NSError *errorJSON = nil;
                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorJSON];
                                              
                                              if (errorJSON) {
                                                  
                                                  NSLog(@"JSON PARSER ERROR");
                                              }
                                              else {
                                              
                                                  NSString *theImageURLToDownload = nil;
                                                  //theImageURLToDownload = @"http://coolalbumreview.com/wp-content/uploads/2010/11/The+Cure+cure1.jpg";
                                        
                                                  
                                                  NSArray *items = [responseDictionary objectForKey:@"items"];
                                                  
                                                  //NSLog(@"COUNT = %lu", (unsigned long)[items count]);
                                                  if([items count] == 0) {
                                                      
                                                      NSLog(@"This song has no images");
                                                      
                                                  }
                                                  else {
                                                  
                                                      NSDictionary *firstItem = [items objectAtIndex:0];
                                                      theImageURLToDownload = [firstItem objectForKey:@"link"];
                                                  
                                                      //CALL THE DOWNLOAD
                                                      dispatch_async(dispatch_get_main_queue(), ^() {
                                              
                                                          [self downloadImageForBand:theImageURLToDownload];
                                                      });
                                                  }
                                              }
                                          }
                                      }];
    
    //6 - Start the Download
    //[downloadTask setde];
    [dataTask resume];
    
    

}


- (void)downloadImageForBand:(NSString *)theURL {

//    NSLog(@"XXXXXXXXXX: downloadImageForBand");
//    BOOL yyy = [NSThread isMainThread];
//    NSLog(@"%@", yyy ? @"THIS IS THE MAIN THREAD" : @"THIS IS NOT THE MAIN THREAD");
    
    
    //1 - Decide the URL
    NSURL *url = [NSURL URLWithString:theURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    //2 - THE URLSESSION
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    //3 - Download Task
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request
                                                            completionHandler:
                                              ^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                  
                                                  if (error) {
                                                      NSLog(@"GOOGLE IMAGES DOWNLOAD: %@", [error description]);
                                                  }
                                                  else {
                                                      
                                                      
//                                                      BOOL yyy = [NSThread isMainThread];
//                                                      NSLog(@"%@", yyy ? @"THIS IS THE MAIN THREAD" : @"THIS IS NOT THE MAIN THREAD");
                                                      
                                                      //LOCAL DIRECTORY
                                                      //NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                                                      
                                                      //NSLog(@"DOCUMENTS PATH: %@", documentsPath);
                                                      //NSLog(@"TEMP LOCATION PATH: %@", [location path]);
                                                      //NSLog(@"FILENAME: %@", [response suggestedFilename]);
                                                      //NSLog(@"RESPONSE: %@", [response description]);
                                                      
                                                      //SAVE LOCALY
                                                      //NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:documentsPath];
                                                      //NSURL *documentURL = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                      //[[NSFileManager defaultManager] moveItemAtURL:location toURL:documentURL error:nil];
                                                      
                                                      
                                                      //CREATE IMAGE
                                                      NSData *imageData = [NSData dataWithContentsOfURL:location];
                                                      UIImage *theImage = [UIImage imageWithData:imageData];
                                                      
                                                      
                                                      //LOAD IMAGE
                                                      dispatch_async(dispatch_get_main_queue(), ^() {
                                                      
                                                          
                                                          [[self bandImageView] setImage:theImage];
                                                      });
                                                      
                                                  }
                                              }];
    
    
    //4 - Start the Download
    //[downloadTask setde];
    [downloadTask resume];
}




//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - NSURLSessionDelegate
//---------------------------------------------------------------------------------------
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {

    NSLog(@"NSURLSessionDelegate: 1");
}


- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential)) completionHandler {


    NSLog(@"NSURLSessionDelegate: 2");
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {

    NSLog(@"NSURLSessionDelegate: 3");
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - NSURLSessionTaskDelegate
//---------------------------------------------------------------------------------------
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

        NSLog(@"NSURLSessionTaskDelegate: 1");
}


- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,
                             NSURLCredential *credential))completionHandler {

        NSLog(@"NSURLSessionTaskDelegate: 2");
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {

        NSLog(@"NSURLSessionTaskDelegate: 3");
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler {


        NSLog(@"NSURLSessionTaskDelegate: 4");
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler {


        NSLog(@"NSURLSessionTaskDelegate: 5");
}




//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - NSURLSessionDownloadDelegate
//---------------------------------------------------------------------------------------
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {

    NSLog(@"NSURLSessionDownloadDelegate: 1");

}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {

    NSLog(@"NSURLSessionDownloadDelegate: 2");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {

    NSLog(@"NSURLSessionDownloadDelegate: 3");
}




@end







