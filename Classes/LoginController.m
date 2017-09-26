//
//  LoginController.m
//  MobileOffice
//
//  Created by 刘 文浩 on 12-8-4.
//  Copyright (c) 2012年 刘 文浩. All rights reserved.
//

#import "LoginController.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "TreeNode.h"
#import "XMLParser.h"
#import "ALAlertBanner.h"
#import "NewPaintListViewController.h"
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define DOCUMENTS_FOLDER1 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/PDFFile/"]
#define DOCUMENTS_FOLDER2 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/XML/"]
#define DOCUMENTS_FOLDER3 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/NEWXML/"]
@interface LoginController ()

@end

@implementation LoginController

@synthesize userName, userPwd;
@synthesize loginView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearTextFieldContent)
                                                     name:@"NT_ClearLoginData"
                                                   object:nil];
       
        NSString *dirName3=@"XML";
        NSString *imageDir3 = [NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, dirName3];
        BOOL isDir3 = NO;
        NSFileManager *fileManager3 = [NSFileManager defaultManager];
        BOOL existed3 = [fileManager3 fileExistsAtPath:imageDir3 isDirectory:&isDir3];
        if ( !(isDir3 == YES && existed3 == YES) )
        {
            [fileManager3 createDirectoryAtPath:imageDir3 withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *dirName2=@"PDFFile";
        NSString *imageDir2 = [NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, dirName2];
        BOOL isDir2 = NO;
        NSFileManager *fileManager2 = [NSFileManager defaultManager];
        BOOL existed2 = [fileManager2 fileExistsAtPath:imageDir2 isDirectory:&isDir2];
        if ( !(isDir2 == YES && existed2 == YES) )
        {
            [fileManager2 createDirectoryAtPath:imageDir2 withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *dirName=@"PaintImages";
        NSString *imageDir = [NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, dirName];
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *dirName1=@"PDFFistPage";
        NSString *imageDir1 = [NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, dirName1];
        BOOL isDir1 = NO;
        NSFileManager *fileManager1 = [NSFileManager defaultManager];
        BOOL existed1 = [fileManager1 fileExistsAtPath:imageDir1 isDirectory:&isDir1];
        if ( !(isDir1 == YES && existed1 == YES) )
        {
            [fileManager1 createDirectoryAtPath:imageDir1 withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *dirName5=@"NEWXML";
        NSString *imageDir5 = [NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, dirName5];
        BOOL isDir5 = NO;
        NSFileManager *fileManager5 = [NSFileManager defaultManager];
        BOOL existed5 = [fileManager5 fileExistsAtPath:imageDir5 isDirectory:&isDir5];
        if ( !(isDir5 == YES && existed5 == YES) )
        {
            [fileManager5 createDirectoryAtPath:imageDir5 withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
       
    }
    return self;
}

- (void) dealloc
{
    [self releaseOutlets];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NT_ClearLoginData" object:nil];
    [super dealloc];
}

- (void) releaseOutlets
{
    self.loginView = nil;
    userName = nil;
    userPwd=nil;
}

- (void)viewDidLoad
{
    
//#ifdef TEST
    
    //userName.text = @"rdh";//@"倪毅";//@"admin";////@"钟云伟";
    //userPwd.text = @"123456";//@"8515847585158475";//@"adminsfj";//
//#else
    //userName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
//#endif
    
    //
    //[userName becomeFirstResponder];
    //userName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    [super viewDidLoad];
    
    NSString *lousername = [[NSUserDefaults standardUserDefaults] objectForKey:@"person"];
    if(lousername && lousername.length>0)
    {
        self.userName.enabled = FALSE;
        self.userName.text = lousername;
    }
    else
    {
        self.userName.enabled = YES;
        self.userName.text = @"";
    }
    
    // Do any additional setup after loading the view from its nib.
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSArray *array1 = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:@""];
    NSArray *array2 = [[NSBundle mainBundle] pathsForResourcesOfType:@"xml" inDirectory:@""];
    NSLog(@"%d",[array count]);
    for(int i = 0 ; i<array2.count;i++)
    {
        [array addObject:array2[i]];
    }
    for(int i = 0 ; i<array1.count;i++)
    {
        [array addObject:array1[i]];
    }
    //int m=0;
    for(int i = 0; i<array.count;i++)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSFileManager*fileManager =[NSFileManager defaultManager];
            NSError*error;
            
            NSArray *a = [((NSString *)array[i]) componentsSeparatedByString:@"/"];
            NSString *padfname = a[a.count-1];
            NSString *padfPath = [DOCUMENTS_FOLDER1 stringByAppendingPathComponent:padfname];
            BOOL suc = NO;
            if([fileManager fileExistsAtPath:padfPath]== NO){
                NSArray *b = [padfname componentsSeparatedByString:@"."];
                NSString *pdfname = b[0];
                NSString *pdftype = b[1];
                if([pdftype isEqualToString:@"xml"])
                    padfPath = [DOCUMENTS_FOLDER2 stringByAppendingPathComponent:padfname];
                NSString*resourcePath =[[NSBundle mainBundle] pathForResource:pdfname ofType:pdftype];
                suc = [fileManager copyItemAtPath:resourcePath toPath:padfPath error:&error];
            }
            
            if (suc) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    label.text = [NSString stringWithFormat:@"%@",padfname];
                });
            } 
        });
    }

//    NSString *urlstr = @"http://oa.risencn.com:2580/hyzl/public/getHyzlXml.action";
//    self.lastdate = @"";
//    NSFileManager*fileManager1 =[NSFileManager defaultManager];
//      
//    NSString *strPathXml = [DOCUMENTS_FOLDER2 stringByAppendingPathComponent:@"default.xml"];
//    
//    if([fileManager1 fileExistsAtPath:strPathXml]== YES){
//        NSData *defaultdata = [[NSData alloc] initWithContentsOfFile:strPathXml];
//        TreeNode *node = [[XMLParser sharedInstance] parseXMLFromData:defaultdata];
//        
//        NSString *timestr = [node objectForKey:@"time"].leafvalue;
//        self.lastdate=timestr;
//        if(timestr && timestr.length > 0)
//            urlstr = [NSString stringWithFormat:@"%@?date=%@",urlstr,timestr];
//
//    }
//    [self initdata:urlstr flag:YES];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 20)];
        view1.backgroundColor=[UIColor blackColor];
        [self.view addSubview:view1];
        [view1 release];
    }
}


- (BOOL)dateFromString:(NSString *)dateString otherdatestr:(NSString *)other
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *otherDate= [dateFormatter1 dateFromString:other];
    [dateFormatter1 release];
    return [destDate isEqualToDate:otherDate];
}

-(void)initdata:(NSString *)url1 flag:(BOOL)fl
{
    NSURL *url= [NSURL URLWithString:[url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if(fl)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    ASIFormDataRequest *asi=[[ASIFormDataRequest alloc]initWithURL:url];
    [asi setStringEncoding:NSUTF8StringEncoding];
    [asi setTimeOutSeconds:20];
    [asi setDelegate:self];
    [asi startAsynchronous];

}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    //
    NSData *data=[request responseData];
    NSString *mmmmmmm = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",mmmmmmm);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    TreeNode *root = [[XMLParser sharedInstance] parseXMLFromData:data];
    
    NSString *meeting = [root objectForKey:@"meeting"].leafvalue;
    NSString *channel = [root objectForKey:@"channel"].leafvalue;
    NSString *time = [root objectForKey:@"time"].leafvalue;
    NSString *date = [root objectForKey:@"date"].leafvalue;
    //NSString *channel = [root objectForKey:@"date"].leafvalue;
    NSString *filename = @"";
    if(time && time.length > 0 && meeting && channel && meeting.length > 0 && channel.length > 0)
    {
        filename = @"default.xml";
    }
    else if(channel && channel.length > 0)
    {
        filename = @"channel.xml";
    }
    
    if(date && date.length > 0 )
    {
        filename = @"meeting.xml";
    }
    if(![time isEqualToString:self.lastdate])
    {
        
        NSString *filePath = [DOCUMENTS_FOLDER2 stringByAppendingPathComponent:filename];    //在document下创建文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    //将下载的数据，写入文件中
        [data writeToFile:filePath atomically:YES];
    }
    
    if (request)
        
    {
        
        [request release];
        request.delegate=nil;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if(![time isEqualToString:self.lastdate] && meeting && channel && meeting.length > 0 && channel.length > 0)
    {
        [self initdata:meeting flag:NO];
        [self initdata:channel flag:NO];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request;
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (request)
        
    {
        
        [request release];
        request.delegate=nil;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSTimeInterval _secondsToShow = 2.0;
    NSTimeInterval _showAnimationDuration = 0.25;
    NSTimeInterval _hideAnimationDuration = 0.2;
    
    ALAlertBannerPosition position = ALAlertBannerPositionTop;
    ALAlertBannerStyle randomStyle = ALAlertBannerStyleFailure;
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view style:randomStyle position:position title:@"" subtitle:@"网络无响应？" tappedBlock:^(ALAlertBanner *alertBanner) {
        NSLog(@"tapped!");
        [alertBanner hide];
    }];
    banner.secondsToShow = _secondsToShow;
    banner.showAnimationDuration = _showAnimationDuration;
    banner.hideAnimationDuration = _hideAnimationDuration;
    [banner show];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
        
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

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

- (IBAction) loginBtn_click:(id)sender
{
    NSString *lousername = [[NSUserDefaults standardUserDefaults] objectForKey:@"person"];
    NSString *userpsw = [[NSUserDefaults standardUserDefaults] objectForKey:@"userpsw"];
    if(lousername && lousername.length > 0)
    {
        if([self.userPwd.text isEqualToString:userpsw])
        {
            userPwd.text = @"";
            NewPaintListViewController* pAnnouncementController = [[NewPaintListViewController alloc] initWithNibName:@"NewPaintListViewController" bundle:nil];
            
            [self presentModalViewController:pAnnouncementController animated:YES];
            [pAnnouncementController release];
        }
        else
        {
            userPwd.text = @"";
            UIAlertView *myalert = [[UIAlertView alloc]
                                    initWithTitle:@"登陆失败"                                   message:@"密码错误"
                                    delegate:nil
                                    cancelButtonTitle:@"重新输入"
                                    otherButtonTitles:nil];
            
            [myalert show];
            [myalert release];
        }
    }
    else
    {
        if(userPwd.text.length > 0 && userName.text.length > 0)
        {
             [[NSUserDefaults standardUserDefaults] setValue:userName.text forKey:@"person"];
             [[NSUserDefaults standardUserDefaults] setValue:userPwd.text forKey:@"userpsw"];
                NewPaintListViewController* pAnnouncementController = [[NewPaintListViewController alloc] initWithNibName:@"NewPaintListViewController" bundle:nil];
            
            [self presentModalViewController:pAnnouncementController animated:YES];
            [pAnnouncementController release];
        }
        else
        {
            UIAlertView *myalert = [[UIAlertView alloc]
                                    initWithTitle:@"注册失败"                                   message:@"用户名密码不能为空"
                                    delegate:nil
                                    cancelButtonTitle:@"重新输入"
                                    otherButtonTitles:nil];
            
            [myalert show];
            [myalert release];
        }
    }
    
//    if ([[UserManager sharedUserManager] doLoginWithBlock:userName.text userPwd:userPwd.text])
//    {
//        [[ContactsManager sharedContacts] getContacts];
//        IndexViewController *index = [[IndexViewController alloc] initWithNibName:@"IndexView_iPad" bundle:nil];
//        //BookselfViewController *index = [[BookselfViewController alloc] initWithNibName:@"BookselfViewController" bundle:nil];
//        
//        [self.navigationController pushViewController:index animated:YES];
//        doRelease(index);
//        
//        //userName.text = @"";
//        userPwd.text = @"";
//        
//        [[NSUserDefaults standardUserDefaults] setObject:userName.text forKey:@"userName"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    else
//    {
//        showAlertViewWithTime(5.0, @"提示", @"\n\n登陆失败", nil, nil);
//    }
   
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //[self.loginView setContentOffset:CGPointMake(0, 220) animated:YES];
    return YES;
}

- (void) keyboardWillHide:(NSNotification*) notification
{
    //[self.loginView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void) clearTextFieldContent
{
    //userName.text = @"";
    userPwd.text = @"";
}

-(IBAction)hiddencleck:(id)sender
{
    if(self.hiddenview.hidden)
    {
        self.hiddenview.hidden=NO;
    }
    else
    {
        self.hiddenview.hidden=YES;
    }
}

-(IBAction)ipclick:(id)sender
{
    if([self.hiddenpswtxt.text isEqualToString:@"zjrdadmin"])
    {
    if(self.hiddentxt.text.length > 0)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ips"];
        [[NSUserDefaults standardUserDefaults] setValue:self.hiddentxt.text forKey:@"ips"];
        self.hiddenview.hidden=YES;
    }
    else
    {
        self.hiddenview.hidden=YES;
        UIAlertView *myalert = [[UIAlertView alloc]
                                initWithTitle:@"失败"
                                message:@"ip不能为空"
                                delegate:nil
                                cancelButtonTitle:@"重新输入"
                                otherButtonTitles:nil];
        
        [myalert show];
        [myalert release];
    }
    }
    else
    {
        self.hiddenview.hidden=YES;
        UIAlertView *myalert = [[UIAlertView alloc]
                                initWithTitle:@"失败"
                                message:@"密码不正确"
                                delegate:nil
                                cancelButtonTitle:@"重新输入"
                                otherButtonTitles:nil];
        
        [myalert show];
        [myalert release];
    }

    
}

@end
