//
//  MasterViewController.m
//  RoboReader
//
//  Created by shizheng on 13-12-20.
//
//

#import "MasterViewController.h"

#import "TreeNode.h"
#import "XMLParser.h"
#import "progressCell.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#define DELETE_DONE 1
#define DOCUMENTS_FOLDER2 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/XML/"]
#define DOCUMENTS_FOLDER3 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/NEWXML/"]
@interface MasterViewController () {
    NSMutableArray *toDownloadFiles;
    NSMutableArray *toDownloadFiles1;
    int begin;
    int end;
    IBOutlet UILabel *pagelabel;
}
@end

@implementation MasterViewController

-(BOOL)shouldAutorotate {
    
    return YES;
    
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation == UIInterfaceOrientationMaskPortrait)
    {
        return YES;
    }
	return NO;
}

-(NSUInteger)supportedInterfaceOrientations {
    
    return (UIInterfaceOrientationMaskPortrait);
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
        begin = 0;
        //end = 10;
        self.array = [NSMutableArray arrayWithCapacity:0];
        
//        NSString *urlstr = @"http://oa.risencn.com:2580/hyzl/public/getHyzlXml.action";
//        self.lastdate = @"";
//        NSFileManager*fileManager1 =[NSFileManager defaultManager];
//        
//        NSString *strPathXml = [DOCUMENTS_FOLDER2 stringByAppendingPathComponent:@"default.xml"];
//        
//        if([fileManager1 fileExistsAtPath:strPathXml]== YES){
//            NSData *defaultdata = [[NSData alloc] initWithContentsOfFile:strPathXml];
//            TreeNode *node = [[XMLParser sharedInstance] parseXMLFromData:defaultdata];
//            
//            NSString *timestr = [node objectForKey:@"time"].leafvalue;
//            self.lastdate=timestr;
//            
//            if(timestr && timestr.length > 0)
//                urlstr = [NSString stringWithFormat:@"%@?date=%@",urlstr,timestr];
//            
//        }
//        
//        if([self checknet])
//            [self initdata:urlstr];
//        else
//        {
//            
//            UIAlertView *myalert = [[UIAlertView alloc]
//                                    initWithTitle:NSLocalizedString(@"网络连接失败", @"网络连接失败")
//                                    message:NSLocalizedString(@"网络连接失败，请检查网络", nil)
//                                    delegate:self
//                                    cancelButtonTitle:NSLocalizedString(@"确定", @"确定")
//                                    otherButtonTitles:nil];
//            
//            [myalert show];
//            
//            //[myalert release];
//        }
        
       
    }
    return self;
}

//-(BOOL)checknet
//{
//    BOOL isExistenceNetwork = YES;
//    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable:
//            isExistenceNetwork=NO;
//            //   NSLog(@"没有网络");
//            break;
//        case ReachableViaWWAN:
//            isExistenceNetwork=YES;
//            //   NSLog(@"正在使用3G网络");
//            break;
//        case ReachableViaWiFi:
//            isExistenceNetwork=YES;
//            //  NSLog(@"正在使用wifi网络");
//            break;
//    }
////    if (!isExistenceNetwork) {
//      
////        return;
////    }
//    return isExistenceNetwork;
//}
//
//-(void)initdata:(NSString *)url1
//{
//    NSURL *url= [NSURL URLWithString:[url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    ASIFormDataRequest *asi=[[ASIFormDataRequest alloc]initWithURL:url];
//    [asi setStringEncoding:NSUTF8StringEncoding];
//    [asi setTimeOutSeconds:20];
//    //[asi setDelegate:self];
//    [asi startSynchronous];
//    
//    NSData *data  = [asi responseData]; 
//    [asi release];
//    TreeNode *root = [[XMLParser sharedInstance] parseXMLFromData:data];
//    
//    NSString *meeting = [root objectForKey:@"meeting"].leafvalue;
//    NSString *channel = [root objectForKey:@"channel"].leafvalue;
//    NSString *time = [root objectForKey:@"time"].leafvalue;
//   
//
//    
//    if(![time isEqualToString:self.lastdate])
//    {
//        
//        NSString *filePath = [DOCUMENTS_FOLDER3 stringByAppendingPathComponent:@"default.xml"];    //在document下创建文件
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
//        
//        //将下载的数据，写入文件中
//        [data writeToFile:filePath atomically:YES];
//        
//    }
//    else
//    {
//        UIAlertView* myAlert = [[UIAlertView alloc]
//                                initWithTitle:@""
//                                message:@"您的数据是最新的!"
//                                delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        myAlert.delegate = self;
//        [myAlert show];
//    }
//    
//    if(![time isEqualToString:self.lastdate])
//    {
//        NSURL *url1= [NSURL URLWithString:[channel stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
//        NSError *error1 = nil;
//        NSData   *data1 = [NSURLConnection sendSynchronousRequest:request1
//                                            returningResponse:nil
//                                                        error:&error1];
//        NSString *filePath1 = [DOCUMENTS_FOLDER3 stringByAppendingPathComponent:@"channel.xml"];
//        NSFileManager *fileManager1 = [NSFileManager defaultManager];
//        [fileManager1 createFileAtPath:filePath1 contents:nil attributes:nil];
//        
//        //将下载的数据，写入文件中
//        [data1 writeToFile:filePath1 atomically:YES];
//
//    
//        NSURL *url2= [NSURL URLWithString:[meeting stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
//        NSError *error2 = nil;
//        NSData   *data2 = [NSURLConnection sendSynchronousRequest:request2
//                                            returningResponse:nil
//                                                        error:&error2];
//        NSString *filePath2 = [DOCUMENTS_FOLDER3 stringByAppendingPathComponent:@"meeting.xml"];
//        NSFileManager *fileManager2 = [NSFileManager defaultManager];
//        [fileManager2 createFileAtPath:filePath2 contents:nil attributes:nil];
//        
//        //将下载的数据，写入文件中
//        [data2 writeToFile:filePath2 atomically:YES];
//    }
//
//    
//}



- (void)viewDidLoad
{
    [super viewDidLoad];
    

    NSString *channelXml = [DOCUMENTS_FOLDER3 stringByAppendingPathComponent:@"channel.xml"];
    NSData *channeldata = [[NSData alloc] initWithContentsOfFile:channelXml];
    //        NSString *mmmmmmm = [[NSString alloc] initWithData:persondata encoding:NSUTF8StringEncoding];
    //            NSLog(@"%@",mmmmmmm);
    

    TreeNode *node = [[XMLParser sharedInstance] parseXMLFromData:channeldata];

    
    toDownloadFiles = [[NSMutableArray alloc] init];
    toDownloadFiles1 = [[NSMutableArray alloc] init];
    NSMutableArray *ar = [node objectsForKey:@"file"];
    for(int i = 0; i< ar.count;i++)
    {
        TreeNode *tnode = ar[i];
        NSString *update = [tnode.attributeDict objectForKey:@"update"];
        if(update && update.length >0 && [update isEqualToString:@"true"])
        {
            [self.array addObject:tnode];
        }
    }
    [channeldata release];

    [self nextpage];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 20)];
        view1.backgroundColor=[UIColor blackColor];
        [self.view addSubview:view1];
        [view1 release];
    }
}

-(void)nextpage
{
    end=begin+7;
    if(end > self.array.count)
        end=self.array.count;
    [toDownloadFiles removeAllObjects];
    [toDownloadFiles1 removeAllObjects];
    for(int i = begin; i<end; i++)
    {
        TreeNode *tnode = self.array[i];
        NSString *update = [tnode.attributeDict objectForKey:@"update"];
        if(update && update.length >0 && [update isEqualToString:@"true"])
        {
            [toDownloadFiles addObject:[tnode.attributeDict objectForKey:@"url"]];
            [toDownloadFiles1 addObject:[tnode.attributeDict objectForKey:@"fileName"]];
        }
    }
    if(toDownloadFiles.count > 0)
        [self.tableView reloadData];
    else
    {
        NSString *defaultXml = [DOCUMENTS_FOLDER3 stringByAppendingPathComponent:@"default.xml"];
        NSData *defaultdata = [[NSData alloc] initWithContentsOfFile:defaultXml];
        if(defaultdata)
        {
        NSString *filePath1 = [DOCUMENTS_FOLDER2 stringByAppendingPathComponent:@"default.xml"];
        NSFileManager *fileManager1 = [NSFileManager defaultManager];
        [fileManager1 createFileAtPath:filePath1 contents:nil attributes:nil];
       
        //将下载的数据，写入文件中
        [defaultdata writeToFile:filePath1 atomically:YES];
        
        [fileManager1 removeItemAtPath:defaultXml error:nil];
        }
        
        NSString *chaXml = [DOCUMENTS_FOLDER3 stringByAppendingPathComponent:@"channel.xml"];
        NSData *chadata = [[NSData alloc] initWithContentsOfFile:chaXml];
        if(chadata)
        {
        NSString *filePath2 = [DOCUMENTS_FOLDER2 stringByAppendingPathComponent:@"channel.xml"];
        NSFileManager *fileManager2 = [NSFileManager defaultManager];
        [fileManager2 createFileAtPath:filePath2 contents:nil attributes:nil];
        
        //将下载的数据，写入文件中
        [chadata writeToFile:filePath2 atomically:YES];
        
        [fileManager2 removeItemAtPath:chaXml error:nil];
        }
        
        
        
        NSString *meetingXml = [DOCUMENTS_FOLDER3 stringByAppendingPathComponent:@"meeting.xml"];
        NSData *meetingdata = [[NSData alloc] initWithContentsOfFile:meetingXml];
        if(meetingdata)
        {
        NSString *filePath3 = [DOCUMENTS_FOLDER2 stringByAppendingPathComponent:@"meeting.xml"];
        NSFileManager *fileManager3 = [NSFileManager defaultManager];
        [fileManager3 createFileAtPath:filePath3 contents:nil attributes:nil];
        
        //将下载的数据，写入文件中
        [meetingdata writeToFile:filePath3 atomically:YES];
        
        [fileManager3 removeItemAtPath:meetingXml error:nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RELODEVIEW" object:nil userInfo:nil];
            UIAlertView* myAlert = [[UIAlertView alloc]
                                    initWithTitle:@"文件更新结束"
                                    message:@"文件更新结束,请结束更新!"
                                    delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            myAlert.delegate = self;
            [myAlert show];
        //[self dismissModalViewControllerAnimated:YES];
        }
    }
        
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0)
        [self dismissModalViewControllerAnimated:YES];
    [alertView release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}





#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [toDownloadFiles count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    progressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
     cell = [[progressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier downloadURL:[NSURL URLWithString:[toDownloadFiles objectAtIndex:indexPath.row]] filename:[toDownloadFiles1 objectAtIndex:indexPath.row]];
        
        [cell startWithDelegate:self];
   // }
    
    //cell.textLabel.text = [toDownloadFiles1 objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
}


#pragma mark - progressCell
-(void)progressCellDownloadProgress:(float)progress Percentage:(NSInteger)percentage ProgressCell:(progressCell *)cell{
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%d %%",percentage];
    
}
-(void)progressCellDownloadFinished:(NSData*)fileData ProgressCell:(progressCell *)cell{
    
    if(0) {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        [toDownloadFiles removeObjectAtIndex:indexPath.row];
        cell.delegate = nil;
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        cell=nil;
        begin++;
        if(begin >= end)
        {
            //end=begin+10;
            
            pagelabel.text=[NSString stringWithFormat:@"%d",begin/1];
            [self nextpage];
        }
    }
    else {
        begin++;
        if(begin >= end)
        {
            //end=begin+10;
            
            pagelabel.text=[NSString stringWithFormat:@"%d",begin/10];
            [self nextpage];
        }
            //[self dismissModalViewControllerAnimated:YES];
        //cell.textLabel.text = @"Finished";
    }
}
-(void)progressCellDownloadFail:(NSError*)error ProgressCell:(progressCell *)cell{
    int a = 0;
}
-(void)dealloc
{
    toDownloadFiles=nil;
    toDownloadFiles1 = nil;
    self.tableView=nil;
    [super dealloc];
}

-(IBAction)backgroundclick:(id)sender
{
    UIAlertView* myAlert = [[UIAlertView alloc]
                            initWithTitle:@"警告"
                            message:@"您是否确定取消更新?"
                            delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    myAlert.delegate = self;
    [myAlert show];

    //[self dismissModalViewControllerAnimated:YES];
}
@end
