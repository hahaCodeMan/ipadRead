//
//  SGdownloader.m
//  downloadManager
//
//  Created by saturngod on 11/7/12.
//

#import "SGdownloader.h"
#define DOCUMENTS_FOLDER1 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/PDFFile/"]
@interface SGdownloader()
@property (nonatomic,assign) float receiveBytes;
@property (nonatomic,assign) float exceptedBytes;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSURLRequest *request;
@property (nonatomic,strong) NSURLConnection *connection;

//for block
@property (nonatomic,strong) SGDownloadProgressBlock progressDownloadBlock;
@property (nonatomic,strong) SGDowloadFinished progressFinishBlock;
@property (nonatomic,strong) SGDownloadFailBlock progressFailBlock;

@end

@implementation SGdownloader
@synthesize receiveData = _receiveData;
@synthesize request = _request;
@synthesize connection = _connection;
@synthesize downloadedPercentage = _downloadedPercentage;
@synthesize receiveBytes;
@synthesize exceptedBytes;
@synthesize progress = _progress;
@synthesize progressFailBlock = _progressFailBlock;
@synthesize progressDownloadBlock = _progressDownloadBlock;
@synthesize progressFinishBlock = _progressFinishBlock;
@synthesize delegate = _delegate;
@synthesize name;

-(id)initWithURL:(NSURL *)fileURL timeout:(NSInteger)timeout{
    
    
    self = [super init];
    
    if(self)
    {
        self.receiveBytes = 0;
        self.exceptedBytes = 0;
        _receiveData = [[NSMutableData alloc] initWithLength:0];
        _downloadedPercentage = 0.0f;
        self.request = [[NSURLRequest alloc] initWithURL:fileURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:timeout];
    
        
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        

        
    }
    
    return self;
}

#pragma mark - NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receiveData appendData:data];
    
    NSInteger len = [data length];
    
    NSLog(@"%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
    receiveBytes = receiveBytes + len;
    
    if(exceptedBytes>0 && exceptedBytes != NSURLResponseUnknownLength) {
        _progress = ((receiveBytes/(float)exceptedBytes) * 100)/100;
        _downloadedPercentage = _progress * 100;
        
        if([_delegate respondsToSelector:@selector(SGDownloadProgress:Percentage:)])
        {
            [_delegate SGDownloadProgress:_progress Percentage:_downloadedPercentage];
        }
        else {
            if(_progressDownloadBlock) {
                _progressDownloadBlock(_progress,_downloadedPercentage);
            }
        }
    }
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //return back error
    if([_delegate respondsToSelector:@selector(SGDownloadFail:)])
    {
        [_delegate SGDownloadFail:error];
    }
    else {
        if(_progressFailBlock) {
            _progressFailBlock(error);
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpResponse =(NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        NSLog([dictionary description]);
        NSLog(@"%d",[httpResponse statusCode]);
    }
    
    if([httpResponse statusCode] == 200)
    {
    name = [response suggestedFilename];
    exceptedBytes = [response expectedContentLength];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.connection = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"mp3 path=%@",documentsDirectory);
    NSString *filePath = [DOCUMENTS_FOLDER1 stringByAppendingPathComponent:name];//mp3Name:你要保存的文件名称，包括文件类型。如果你知道文件类型的话，可以指定文件类型；如果事先不知道文件类型，可以在- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response中获取要下载的文件类型
    
    //在document下创建文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    NSLog(@"mp3 path=%@",filePath);
    //将下载的数据，写入文件中
    [_receiveData writeToFile:filePath atomically:YES];
    if([_delegate respondsToSelector:@selector(SGDownloadFinished:)])
    {
        [_delegate SGDownloadFinished:_receiveData];
    }
    else {
        if(_progressFinishBlock) {
            _progressFinishBlock(_receiveData);
        }
    }
}

#pragma mark - properties
-(void)startWithDelegate:(id<SGdownloaderDelegate>)delegate {
    _delegate = delegate;
    if(self.connection) {
        [self.connection start];
        _progressDownloadBlock= nil;
        _progressFinishBlock = nil;
        _progressFailBlock = nil;
    }
}
-(void)startWithDownloading:(SGDownloadProgressBlock)progressBlock onFinished:(SGDowloadFinished)finishedBlock onFail:(SGDownloadFailBlock)failBlock {
    if(self.connection) {
        [self.connection start];
        _delegate = nil; //clear delegate
        _progressDownloadBlock = [progressBlock copy];
        _progressFinishBlock = [finishedBlock copy];
        _progressFailBlock = [failBlock copy];
    }
    
}
-(void)cancel {
    if(self.connection) {
        [self.connection cancel];
    }
}
@end
