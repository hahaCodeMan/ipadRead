//
//  progressCell.m
//  downloadManager
//
//  Created by Htain Lin Shwe on 11/7/12.
//  Copyright (c) 2012 Edenpod. All rights reserved.
//

#import "progressCell.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
@interface progressCell()
@property (nonatomic, strong) SGdownloader* download;
@property (nonatomic, strong) MDRadialProgressView* progressV;
@end
@implementation progressCell
@synthesize downloadedData = _downloadedData;
@synthesize download = _download;
@synthesize progressV = _progressV;
@synthesize delegate = _delegate;
@synthesize downloadURL = _downloadURL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier downloadURL:(NSURL*)url filename:(NSString *)file{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //_progressV = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        
        
        MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
        newTheme.completedColor = [UIColor colorWithRed:90/255.0 green:212/255.0 blue:39/255.0 alpha:1.0];
        newTheme.incompletedColor = [UIColor colorWithRed:164/255.0 green:231/255.0 blue:134/255.0 alpha:1.0];
        newTheme.centerColor = [UIColor clearColor];
        newTheme.centerColor = [UIColor colorWithRed:224/255.0 green:248/255.0 blue:216/255.0 alpha:1.0];
        newTheme.sliceDividerHidden = YES;
        newTheme.labelColor = [UIColor blackColor];
        newTheme.labelShadowColor = [UIColor whiteColor];
        CGRect frame = CGRectMake(0, 0, 50, 50);
        _progressV = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme];
        _progressV.progressTotal = 100;
        //_progressV.progressCounter = 1;
        
        
        self.textLabel.text = file;
        self.accessoryView = _progressV;
        _downloadedData = nil;
        _downloadURL = url;
        _download = [[SGdownloader alloc] initWithURL:url timeout:12000];
        
    }
    return self;
    
}

-(void)startWithDelegate:(id<progressCellDelegate>)delegate
{
    _delegate = delegate;
    [_download startWithDelegate:self];
}

-(void)cancelDelegate:(id<progressCellDelegate>)delegate
{
    _delegate = delegate;
    [_download cancel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - DownloadProcess
-(void)SGDownloadProgress:(float)progress Percentage:(NSInteger)percentage {
    
    _progressV.progressCounter = percentage;
    
    if([_delegate respondsToSelector:@selector(progressCellDownloadProgress:Percentage:ProgressCell:)]) {
        [_delegate progressCellDownloadProgress:progress Percentage:percentage ProgressCell:self];
    }
    
}
-(void)SGDownloadFinished:(NSData*)fileData {

    _downloadedData = fileData;
    
    if([_delegate respondsToSelector:@selector(progressCellDownloadFinished:ProgressCell:)])
    {
        [_delegate progressCellDownloadFinished:fileData ProgressCell:self];
    }
    
}
-(void)SGDownloadFail:(NSError*)error {

    if([_delegate respondsToSelector:@selector(progressCellDownloadFail:ProgressCell:)])
    {
        [_delegate progressCellDownloadFail:error ProgressCell:self];
    }
    
}
@end
