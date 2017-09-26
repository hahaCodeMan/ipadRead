//
//  NewPaintListViewController.m
//  MobileOffice1
//
//  Created by shizheng on 13-11-27.
//
//

#import "NewPaintListViewController.h"
#import "CustomMosaicDatasource.h"
#import "NewOfficeCell.h"
#import "MosaicData.h"
//#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RoboDemoController.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "XMLParser.h"
#import "MasterViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "JSBadgeView.h"
#define DOCUMENTS_FOLDER1 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/PDFFile/"]
#define DOCUMENTS_FOLDER2 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/XML/"]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/PDFFistPage/"]
#define DOCUMENTS_FOLDER3 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/NEWXML/"]
@interface NewPaintListViewController ()

@end

@implementation NewPaintListViewController

#pragma mark TreeView Delegate methods




- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 70;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 2 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if(self.mm1 && self.mm1.count>0)
    {
    for(int i = 0 ; i<self.mm1.count;i++)
    {
        if ([item isEqual:self.mm1[i]]) {
            return YES;
        }
    }
    }
    else
    {
        if ([item isEqual:self.expanded]) {
            return YES;
        }
    }
   
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else if (treeNodeInfo.treeDepthLevel >= 1) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);//UIColorFromRGB(0xD1EEFC);
    }
//    } else if (treeNodeInfo.treeDepthLevel >= 2) {
//        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
//    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    
    NSInteger numberOfChildren = [treeNodeInfo.children count];
    if(treeNodeInfo.treeDepthLevel == 0)
    {
        int a = treeNodeInfo.positionInSiblings;
        int b = a;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.detailTextLabel.text = @"";
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of children %d", numberOfChildren];
    
    cell.textLabel.text = ((RADataObject *)item).name;
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (treeNodeInfo.treeDepthLevel == 0 | treeNodeInfo.treeDepthLevel == 1) {
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = @"";
    }
    if(treeNodeInfo.treeDepthLevel == 2)
    {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d个议题", numberOfChildren];
    }
    if(treeNodeInfo.treeDepthLevel == 3)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d个文件", numberOfChildren];
    }
    if (treeNodeInfo.treeDepthLevel == 4) {
        
        UITapGestureRecognizer *tapRecognizerWeibo=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doIt:)];
        cell.textLabel.text = [NSString stringWithFormat:@"文件：%@", [((RADataObject *)item).name componentsSeparatedByString:@"**"][0]];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.detailTextLabel.text = [((RADataObject *)item).name componentsSeparatedByString:@"**"][1];
        cell.userInteractionEnabled=YES;
        //cell.imageView.image=[UIImage imageNamed:@"document"];
        //cell.imageView.frame=CGRectMake(170, cell.imageView.frame.origin.y, cell.imageView.frame.size.width, cell.imageView.frame.size.height);
        [cell addGestureRecognizer:tapRecognizerWeibo];
    }
    
    if(treeNodeInfo.treeDepthLevel == 0)
    {
        if(btnarray.count < self.data.count)
        {
        UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_backButton setFrame:CGRectMake(480, 20, 56, 30)];
        //NSString *imagename = [((TreeNode *)array[i]).attributeDict objectForKey:@"tilte"];
       // NSString *imagename = @"最新文件";
        _backButton.frame=CGRectMake(0, 0, 554, 70);
        
        [_backButton setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateSelected];
        [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0,350,0,0)];
         //_backButton.backgroundColor=[UIColor redColor];
        _backButton.tag = treeNodeInfo.positionInSiblings;
        [cell.contentView addSubview:_backButton];
        [_backButton addTarget:self action:@selector(newclick:) forControlEvents:UIControlEventTouchUpInside];
        [btnarray addObject:_backButton];
        }
        else
            [cell.contentView addSubview:(UIButton *)btnarray[treeNodeInfo.positionInSiblings]];
    }

    return cell;
}

- (void)doIt:(UITapGestureRecognizer *)gesture
{
    UITableViewCell *label = (UITableViewCell *)gesture.view;
    NSString *password = @"";
    
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:[label.detailTextLabel.text componentsSeparatedByString:@"."][0] ofType:@"pdf"];
    NSString *filePath = [DOCUMENTS_FOLDER1 stringByAppendingPathComponent:label.detailTextLabel.text];
    //assert(filePath != nil);
    
    RoboDocument *document = [RoboDocument withDocumentFilePath:filePath password:password];
    
    if (document != nil) {
        RoboViewController *roboViewController = [[RoboViewController alloc] initWithRoboDocument:document small_document:nil];
        
        roboViewController.delegate = self;
        
        
        //    [root release];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [self presentModalViewController:roboViewController animated:YES];
        //
        [roboViewController release];
        //  [self.navigationController pushViewController:roboViewController animated:YES];
        
        
    }

}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}

-(void)inittreetable
{
  
    self.data = [NSMutableArray arrayWithCapacity:0];
    self.data1 = [NSMutableArray arrayWithCapacity:0];
    [self.data removeAllObjects];
    [self.data1 removeAllObjects];
    [self.treeView removeFromSuperview];
    self.treeView = nil;
    for(int t = 0; t < self.baseNode.children.count; t++)
    {
        NSMutableArray *arr00=[NSMutableArray arrayWithCapacity:0];
        [self.data1 addObject:arr00];
    }
    for(int i = 0; i<self.baseNode.children.count; i++)//时间
    {
        TreeNode *treenode = self.baseNode.children[i];
        NSString *name = [treenode.attributeDict objectForKey:@"dataDis"];
        NSMutableArray *arr0=[NSMutableArray arrayWithCapacity:0];
        
        for(int j=0; j<treenode.children.count; j++)//上下无
        {
            TreeNode *treenode1 = treenode.children[j];
            //NSString *title = [treenode1.attributeDict objectForKey:@"title"];
            NSString *name = [treenode1.attributeDict objectForKey:@"timeDis"];
            NSMutableArray *arr1=[NSMutableArray arrayWithCapacity:0];
            for(int k=0; k<treenode1.children.count; k++)//会议
            {
                TreeNode *treenode2 = treenode1.children[k];
                NSString *mettingNo = [treenode2.attributeDict objectForKey:@"mettingNo"];
                NSString *meetingName = [treenode2.attributeDict objectForKey:@"meetingName"];
                NSString *name = [NSString stringWithFormat:@"%@、 %@",mettingNo,meetingName];
                NSMutableArray *arr2=[NSMutableArray arrayWithCapacity:0];
                for(int l=0; l<treenode2.children.count; l++)//议题
                {
                    
                    TreeNode *treenode3 = treenode2.children[l];
                    NSString *topicNo = [treenode3.attributeDict objectForKey:@"topicNo"];
                    NSString *title = [treenode3.attributeDict objectForKey:@"title"];
                    NSString *name = [NSString stringWithFormat:@"%@. %@",topicNo,title];
                    NSMutableArray *arr3=[NSMutableArray arrayWithCapacity:0];

                    for(int m=0;m<treenode3.children.count;m++)//文件
                    {
                        TreeNode *treenode4 = treenode3.children[m];
                        NSString *strf=[NSString stringWithFormat:@"%@**%@",[treenode4.attributeDict objectForKey:@"fileName"],[treenode4.attributeDict objectForKey:@"fileNameOg"]];
                        RADataObject *r5 = [RADataObject dataObjectWithName:strf children:nil];
                        self.mm = r5;
                        [((NSMutableArray *)self.data1[i]) addObject:r5];
                        [arr3 addObject:r5];
                    }
                    RADataObject *r4 = [RADataObject dataObjectWithName:name children:arr3];
                    
                    [((NSMutableArray *)self.data1[i]) addObject:r4];
                    [arr2 addObject:r4];
                }
                RADataObject *r3 = [RADataObject dataObjectWithName:name children:arr2];
                [((NSMutableArray *)self.data1[i]) addObject:r3];
                [arr1 addObject:r3];
            }
            RADataObject *r2 = [RADataObject dataObjectWithName:name children:arr1];
            [((NSMutableArray *)self.data1[i]) addObject:r2];
            [arr0 addObject:r2];
        }
        RADataObject *r1 = [RADataObject dataObjectWithName:name children:arr0];
        [self.data addObject:r1];
    }
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.frame];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    //[treeView reloadData];
    //[treeView expandRowForItem:self.mm withRowAnimation:RATreeViewRowAnimationLeft]; //expands Row
    [treeView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
    
    self.treeView = treeView;
    //self.treeView.e = NO;
    [treeView release];
    [self.treeView reloadData];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.treeView.frame = CGRectMake(20, 63, 554, 906);
    }
    else
        self.treeView.frame = CGRectMake(20, 63, 554, 926);
    self.treeView.backgroundColor=[UIColor whiteColor];
    [rightview addSubview:self.treeView];
}
-(IBAction)newclick:(UIButton *)sender
{
    int p = sender.tag;
    
    self.mm1 = [NSMutableArray arrayWithCapacity:0];
    [self.mm1 removeAllObjects];
    if(!sender.selected)
    {
        
        for(int j = 0; j<btnarray.count; j++)
        {
            ((UIButton *)btnarray[j]).selected = NO;
        }
        sender.selected=YES;
        for(int i = 0; i<((NSMutableArray *)self.data1[p]).count;i++)
        {
       // NSMutableArray *b = ((NSMutableArray *)self.data1[p])[i];
            RADataObject *a = ((NSMutableArray *)self.data1[p])[i];
            if(a.children.count <= 0)
                [self.mm1 addObject:a];
        }
    }
    else
    {
        sender.selected=NO;
    }

    [self.treeView reloadData];
    
}
-(void)relodeview1
{
    NSString *meetingXml = [DOCUMENTS_FOLDER2 stringByAppendingPathComponent:@"meeting.xml"];
    NSData *meetingdata = [[NSData alloc] initWithContentsOfFile:meetingXml];
    
    
    self.baseNode = [[XMLParser sharedInstance] parseXMLFromData:meetingdata];
    [meetingdata release];
    //[self inittreetable];
    
    NSString *channelXml = [DOCUMENTS_FOLDER2 stringByAppendingPathComponent:@"channel.xml"];
    NSData *channeldata = [[NSData alloc] initWithContentsOfFile:channelXml];
    
    
    self.chanelNode = [[XMLParser sharedInstance] parseXMLFromData:channeldata];
    [channeldata release];
    
    [self creatchannelScroll];
    [btnarray removeAllObjects];
    [_table reloadData];
    
    [self creatScrollview];
    
}
-(void)relodeview:(NSNotification*) notification
{
    [self relodeview1];
    [self inittreetable];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodeview:) name:@"RELODEVIEW" object:nil];
        
        controllarray = [[NSMutableArray alloc] init];
        
        btnarray = [[NSMutableArray alloc] init];
        
    }
    return self;
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
- (void)dealloc
{
    [btnarray release];
	[_table release];
	[_scrollview release];
    [rightview release];
    [controllarray release];
    [listbutton release];
    [imagebutton release];
    self.baseNode = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self relodeview1];
    [self creatScrollview];
    _scrollview.hidden=YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 20)];
        view1.backgroundColor=[UIColor blackColor];
        [self.view addSubview:view1];
        [view1 release];
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)findchannel:(NSString *)channelname
{
    NSMutableArray *array = [self.chanelNode objectsForKey:@"channel"];
    
    for(int i = 0; i< array.count;i++)
    {
        TreeNode *node = array[i];
        NSString *cn = [node.attributeDict objectForKey:@"tilte"];
        if([cn isEqualToString:channelname])
        {
            self.cus = node;
            break;
        }
    }
    if([channelname isEqualToString:@"会议日程"])
    {
        if(!self.treeView)
            [self inittreetable];
        listbutton.hidden=YES;
        imagebutton.hidden=YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)listclick:(id)sender
{
    _table.hidden=NO;
    _scrollview.hidden=YES;
    

}

-(IBAction)mapclick:(id)sender
{
    _table.hidden=YES;
    _scrollview.hidden=NO;
    

}

-(UIImage *) createJPGsFromPDF:(NSString *)fromPDFName
{
    UIImage *image = nil;
    if (fromPDFName == nil || [fromPDFName isEqualToString:@""]) {
        return nil;
    }
    NSString* fromPDFName1 = [DOCUMENTS_FOLDER1 stringByAppendingPathComponent:fromPDFName];
    
    //CFURLRef audioFileURL = (CFURLRef)[NSURL fileURLWithPath:fromPDFName1];
    
    
    CFURLRef pdfURL = (CFURLRef)[NSURL fileURLWithPath:fromPDFName1];    
    //NSString *documentsDir = [paths objectAtIndex:0];
    
    CGPDFDocumentRef fromPDFDoc = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    //CFRelease(pdfURL);
    // Get Total Pages
    //int pages = CGPDFDocumentGetNumberOfPages(fromPDFDoc);
    
    // Create Folder for store under "Documents/"
//    NSError *error = nil;
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
//    NSString *folderPath = [documentsDir stringByAppendingPathComponent:[fromPDFName stringByDeletingPathExtension]];
//    [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
//    [fileManager release];
    
    int i = 1;
    for (i = 1; i <= 1; i++) {
        CGPDFPageRef pageRef = CGPDFDocumentGetPage(fromPDFDoc, i);
        CGPDFPageRetain(pageRef);
        
        // determine the size of the PDF page
        CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFMediaBox);
        
        // renders its content.
        UIGraphicsBeginImageContext(pageRect.size);
        
        CGContextRef imgContext = UIGraphicsGetCurrentContext();
        CGContextSaveGState(imgContext);
        CGContextTranslateCTM(imgContext, 0.0, pageRect.size.height);
        CGContextScaleCTM(imgContext, 1.0, -1.0);
        CGContextSetInterpolationQuality(imgContext, kCGInterpolationDefault);
        CGContextSetRenderingIntent(imgContext, kCGRenderingIntentDefault);
        CGContextDrawPDFPage(imgContext, pageRef);
        CGContextRestoreGState(imgContext);
        
        //PDF Page to image
        UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        //Release current source page
        CGPDFPageRelease(pageRef);
        
        // Store IMG
        NSString *strh = [fromPDFName componentsSeparatedByString:@"."][0];
        NSString *imgname = [NSString stringWithFormat:@"%@.jpg", strh];
        NSString *imgPath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:imgname];
        [UIImageJPEGRepresentation(tempImage, 1.0) writeToFile:imgPath atomically:YES];
        image = tempImage;
    }
    
    CGPDFDocumentRelease(fromPDFDoc);
    
    return image;
}


-(void)creatchannelScroll
{
    if(channelscrollview)
    {
        [channelscrollview removeFromSuperview];
        [channelscrollview release];
        channelscrollview = nil;
    }
    channelscrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 170, 732)];
    channelscrollview.backgroundColor=[UIColor clearColor];
    channelscrollview.delegate=self;
    if(self.numberdir)
        [self.numberdir removeAllObjects];
    
    self.numberdir = [NSMutableDictionary dictionaryWithCapacity:0];
    
    
    NSMutableArray *array = [self.chanelNode objectsForKey:@"channel"];
    float x = 15.0;
    float y = 7.0;
    for(int i = 0; i<array.count; i++)
    {
        UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(x, y, 160, 72)];
        //NSString *imagename = [((TreeNode *)array[i]).attributeDict objectForKey:@"tilte"];
        NSString *imagename = [((TreeNode *)array[i]).attributeDict objectForKey:@"tilte"];
        if(i==0)
            [self findchannel:imagename];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imagename]];
        if(!image)
            image = [UIImage imageNamed:@"最新文件"];
        [_backButton setBackgroundImage:image forState:UIControlStateNormal];
        [_backButton setBackgroundImage:image forState:UIControlStateSelected];
        _backButton.tag = i+1;
        
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:_backButton alignment:JSBadgeViewAlignmentTopLeft];
        [self.numberdir setObject:badgeView forKey:imagename];
        [badgeView release];
        int k = 0;
        badgeView.hidden=NO;
        if(![imagename isEqualToString:@"会议日程"] && ((TreeNode *)array[i]).children.count > 0)
        {
            
            TreeNode *noke = (TreeNode *)array[i];
            for(int j = 0; j<noke.children.count; j++)
            {
                TreeNode *nn = noke.children[j];
                if(![[NSUserDefaults standardUserDefaults] objectForKey:[nn.attributeDict objectForKey:@"fileName"]])
                {
                    k++;
                }
            }
            if(k == 0)
                badgeView.hidden=YES;
            badgeView.badgeText = [NSString stringWithFormat:@"%d", k];

        }
        else
        {
            badgeView.hidden=YES;
        }
        
        
        if(i==0)
        {
            _backButton.selected = YES;
            self.topLabel.text = imagename;
        }
        [channelscrollview addSubview:_backButton];
        [_backButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(x+56, y+25, 104.0, 21.0)];
        lable.backgroundColor=[UIColor clearColor];
        lable.text = imagename;
        lable.font=[UIFont systemFontOfSize:20];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        lable.tag = i+11;
        if(i == 0)
            lable.textColor = [UIColor colorWithRed:0/255.0 green:103/255.0 blue:79/255.0 alpha:1.0];
        [channelscrollview addSubview:lable];
        [lable release];
        
        y+=80;
        
        
    }
    [channelscrollview setContentSize:CGSizeMake(170, y)];
    [self.leftview addSubview:channelscrollview];
}

-(void)creatScrollview
{
    for(int i = 0; i<controllarray.count;i++)
    {
        UIView *v=(UIView *)[controllarray objectAtIndex:i];
        [v removeFromSuperview];
    }
    [controllarray removeAllObjects];
    int count = self.cus.children.count;
    float x = 0;
    float y = 5;
    for(int i = 0; i<count;i++)
    {
        
        
        
        TreeNode *aModule=self.cus.children[i];
        UIImage *a = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString * nn = [[aModule.attributeDict objectForKey:@"fileNameOg"] componentsSeparatedByString:@"."][0];
        NSString *str = [NSString stringWithFormat:@"%@.jpg",nn];
        NSString *filePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:str];
        if(![fileManager fileExistsAtPath:filePath]) //如果不存在
        {
            a = [self createJPGsFromPDF:[NSString stringWithFormat:@"%@", [aModule.attributeDict objectForKey:@"fileNameOg"]]];
        }
        else
            a = [UIImage imageWithContentsOfFile:filePath];
        
        
        UIImageView *_imageview = [[UIImageView alloc] initWithImage:a];
        
        //UIImageView * imgvPhoto = [UIImageView alloc] init];
        //添加边框
        CALayer * layer = [_imageview layer];
        layer.borderColor = [[UIColor whiteColor] CGColor];
        layer.borderWidth = 2.0f;

        _imageview.layer.shadowColor = [UIColor blackColor].CGColor;
        _imageview.layer.shadowOffset = CGSizeMake(1, 1);
        _imageview.layer.shadowOpacity = 0.5;   
        _imageview.layer.shadowRadius = 2.0;
        //添加两个边阴影
        _imageview.layer.shadowColor = [UIColor blackColor].CGColor;
        _imageview.layer.shadowOffset = CGSizeMake(4, 4);
        _imageview.layer.shadowOpacity = 0.5;
        _imageview.layer.shadowRadius = 2.0;
        
//        CALayer * layer = [_imgvPhoto layer];
//        layer.borderColor = [[UIColor whiteColor] CGColor];
//        layer.borderWidth = 5.0f;
//        //添加四个边阴影
//        _imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
//        _imgvPhoto.layer.shadowOffset = CGSizeMake(0, 0);
//        _imgvPhoto.layer.shadowOpacity = 0.5;
//        _imgvPhoto.layer.shadowRadius = 10.0;给iamgeview添加阴影 < wbr > 和边框
//        //添加两个边阴影
//        _imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
//        _imgvPhoto.layer.shadowOffset = CGSizeMake(4, 4);
//        _imgvPhoto.layer.shadowOpacity = 0.5;   
//        _imgvPhoto.layer.shadowRadius = 2.0;
        
        
        y = 5 + i/3 * 241;
        x = 0 + i%3 * 185;
        _imageview.frame = CGRectMake(x, y, 177, 233);

        
        [_scrollview addSubview:_imageview];
        [controllarray addObject:_imageview];
        
        [_imageview release];
        
        UIButton *btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btnCommit.tag = 1000+i;
        
        [btnCommit setFrame:CGRectMake(x+2, y, 175, 233)];
        
       
        
        [btnCommit setBackgroundImage:[UIImage imageNamed:@"block_list_title_bg1"] forState:UIControlStateNormal];
        
        [btnCommit setBackgroundImage:[UIImage imageNamed:@"block_list_title_bg1"] forState:UIControlStateHighlighted];
        
        [btnCommit addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
        [controllarray addObject:btnCommit];
        [_scrollview addSubview:btnCommit];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x+1, y+233-63, 175, 70)];
        label.numberOfLines = 3;
        label.backgroundColor=[UIColor clearColor];
        label.text = [aModule.attributeDict objectForKey:@"fileName"];
        if(![[NSUserDefaults standardUserDefaults] objectForKey:[aModule.attributeDict objectForKey:@"fileName"]])
            label.textColor=[UIColor blackColor];
        else
            label.textColor=[UIColor grayColor];
        label.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeTailTruncation;
        label.font=[UIFont boldSystemFontOfSize:14];
        label.textAlignment = UITextAlignmentCenter;
        [controllarray addObject:label];
        [_scrollview addSubview:label];
        
        
    }
    [_scrollview setContentSize:CGSizeMake(555.0, y+233+5)];
    NSLog(@"%d",_scrollview.subviews.count);
}

-(void)commit:(UIButton *)sender
{
    TreeNode *aModule=self.cus.children[sender.tag-1000];
    NSString *fileName = [aModule.attributeDict objectForKey:@"fileName"];
    
    NSString *unitName = [aModule.attributeDict objectForKey:@"fileNameOg"];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:fileName])
    {
        [[NSUserDefaults standardUserDefaults] setValue:fileName forKey:fileName];
        JSBadgeView *jb = [self.numberdir objectForKey:[self.cus.attributeDict objectForKey:@"tilte"]];
        int x = jb.badgeText.intValue-1;
        jb.badgeText = [NSString stringWithFormat:@"%d", x];
        if(x<=0)
            jb.hidden=YES;
    }
    
    
    
    NSString *password = @"";
    
    NSString *filePath = [DOCUMENTS_FOLDER1 stringByAppendingPathComponent:unitName];
    
    
    //assert(filePath != nil);
    
    RoboDocument *document = [RoboDocument withDocumentFilePath:filePath password:password];
    
    if (document != nil) {
        RoboViewController *roboViewController = [[RoboViewController alloc] initWithRoboDocument:document small_document:nil];
        
        roboViewController.delegate = self;
        
        
        //    [root release];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [self presentModalViewController:roboViewController animated:YES];
        //
        [roboViewController release];
        //  [self.navigationController pushViewController:roboViewController animated:YES];
        
        
    }
    
//    MosaicData *aModule=(MosaicData *)[[self.cus mosaicElements] objectAtIndex:sender.tag-1000];
//    if(![[NSUserDefaults standardUserDefaults] objectForKey:aModule.title])
//        [[NSUserDefaults standardUserDefaults] setValue:aModule.title forKey:aModule.title];
    //int a = 0;
    
    //    RootViewController *root = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil path:[NSString stringWithFormat:@"%@.pdf", aModule.title]];
    //    [self presentModalViewController:root animated:YES];
    //    [root release];
    
    
//    NSString *password = @"";
//    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:aModule.title ofType:@"pdf"];
//    
//    //assert(filePath != nil);
//    
//    RoboDocument *document = [RoboDocument withDocumentFilePath:filePath password:password];
//    
//    if (document != nil) {
//        RoboViewController *roboViewController = [[RoboViewController alloc] initWithRoboDocument:document small_document:nil];
//        
//        roboViewController.delegate = self;
//        
//        
//        //    [root release];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//        [self presentModalViewController:roboViewController animated:YES];
//        [roboViewController release];
        //
        //  [self.navigationController pushViewController:roboViewController animated:YES];
        
        
    //}

}

-(IBAction)ButtonClick:(UIButton *)sender
{
    if(!sender.selected)
    {
        
    
    UIButton *button;
    UILabel  *label;
        NSLog(@"%d",channelscrollview.subviews.count);
    for(int i = 0; i<channelscrollview.subviews.count; i++)
    {
        UIView *view = [channelscrollview.subviews objectAtIndex:i];
        if(view.tag>0 && view.tag < 10)
        {
            ((UIButton *)view).selected = NO;
        }
        
        if(view.tag > 10 && view.tag <100)
        {
            ((UILabel *)view).textColor = [UIColor whiteColor];
        }
        if(sender.tag == view.tag)
        {
            button = (UIButton *)view;
        }
        if(view.tag == (sender.tag+10))
        {
            label = (UILabel *)view;
        }
    }
        if([label.text isEqualToString:@"会议日程"])
        {
            //[self inittreetable];
//            if(self.data && self.data.count > 0)
//            {
//                self.treeView.hidden=NO;
//                [self.treeView removeFromSuperview];
//                [rightview addSubview:self.treeView];
//                //_table.hidden=YES;
//            }
//            else
//                [self inittreetable];
//            listbutton.hidden=YES;
//            imagebutton.hidden=YES;
            self.treeView.hidden=NO;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                self.treeView.frame = CGRectMake(20, 63, 554, 906);
            }
            else
                self.treeView.frame = CGRectMake(20, 63, 554, 926);
        }
        else
        {
            listbutton.hidden=NO;
            imagebutton.hidden=NO;
            //[self.treeView removeFromSuperview];
            self.treeView.hidden=YES;
        }
    button.selected = YES;
    label.textColor = [UIColor colorWithRed:0/255.0 green:103/255.0 blue:79/255.0 alpha:1.0];
    self.topLabel.text = label.text;
    
    [self findchannel:label.text];
    [self creatScrollview];
    //_scrollview.hidden=YES;
    [_table reloadData];

    }
    

}

-(IBAction)quit:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%d",[[self.cus mosaicElements] count]);
    int a =self.cus.children.count;
    return a;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    NewOfficeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        NSArray* allObjects = [[NSBundle mainBundle] loadNibNamed:@"NewOfficeCell" owner:self options:nil];
        cell = [allObjects objectAtIndex:0];
    }
    

    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:247.0 / 255.0 green:201.0 / 255.0 blue:88.0 / 255.0 alpha:1.0f];
    TreeNode *aModule=self.cus.children[row];
    if([[NSUserDefaults standardUserDefaults] objectForKey:[aModule.attributeDict objectForKey:@"fileName"]])
        cell.titleLabel.textColor=[UIColor grayColor];
    else
        cell.titleLabel.textColor=[UIColor blackColor];
    NSString *a = [aModule.attributeDict objectForKey:@"fileName"];
    NSString *b = [aModule.attributeDict objectForKey:@"pushTime"];
    NSString *c = [aModule.attributeDict objectForKey:@"unitName"];

    cell.titleLabel.text = a;
    //cell.titleLabel.text = pItem.title;
    cell.timeLabel.text = b;
    [cell.timeLabel setCenter:CGPointMake(cell.timeLabel.center.x+150.0, cell.timeLabel.center.y)];
    cell.fromLabel.text = c;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    TreeNode *aModule=self.cus.children[indexPath.row];
    NSString *fileName = [aModule.attributeDict objectForKey:@"fileName"];
    
    NSString *unitName = [aModule.attributeDict objectForKey:@"fileNameOg"];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:fileName])
    {
        
        [[NSUserDefaults standardUserDefaults] setValue:fileName forKey:fileName];
       
        JSBadgeView *jb = [self.numberdir objectForKey:[self.cus.attributeDict objectForKey:@"tilte"]];
        int x = jb.badgeText.intValue-1;
        jb.badgeText = [NSString stringWithFormat:@"%d", x];
        if(x<=0)
            jb.hidden=YES;

    }

    
    
    NSString *password = @"";
    
    NSString *filePath = [DOCUMENTS_FOLDER1 stringByAppendingPathComponent:unitName];

    
    //assert(filePath != nil);
    
    RoboDocument *document = [RoboDocument withDocumentFilePath:filePath password:password];
    
    if (document != nil) {
        RoboViewController *roboViewController = [[RoboViewController alloc] initWithRoboDocument:document small_document:nil];
        
        roboViewController.delegate = self;
        
        
        //    [root release];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [self presentModalViewController:roboViewController animated:YES];
//
        [roboViewController release];
     //  [self.navigationController pushViewController:roboViewController animated:YES];
        
        
    }

   
}
- (void)dismissRoboViewController:(RoboViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];

    
    //[self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)downloadclick {
  
    [self havedownload];
       


}



-(BOOL)checknet
{
    BOOL isExistenceNetwork = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=NO;
            //   NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=YES;
            //   NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=YES;
            //  NSLog(@"正在使用wifi网络");
            break;
    }
    //    if (!isExistenceNetwork) {
    
    //        return;
    //    }
    return isExistenceNetwork;
}



-(void)havedownload
{
    
   
    
    NSString *urlstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ips"];//@"http://oa.risencn.com:2580/hyzl/public/getHyzlXml.action";
    if(urlstr && urlstr.length > 0)
    {
        urlstr = [NSString stringWithFormat:@"http://%@/hyzl/public/getHyzlXml.action",[[NSUserDefaults standardUserDefaults] objectForKey:@"ips"]];
    }
    else
        urlstr = @"http://oa.risencn.com:2580/hyzl/public/getHyzlXml.action";
    self.lastdate = @"";
    NSFileManager*fileManager1 =[NSFileManager defaultManager];
    
    NSString *strPathXml = [DOCUMENTS_FOLDER2 stringByAppendingPathComponent:@"default.xml"];
    
    if([fileManager1 fileExistsAtPath:strPathXml]== YES){
        NSData *defaultdata = [[NSData alloc] initWithContentsOfFile:strPathXml];
        TreeNode *node = [[XMLParser sharedInstance] parseXMLFromData:defaultdata];
        
        NSString *timestr = [node objectForKey:@"time"].leafvalue;
        self.lastdate=timestr;
        
        if(timestr && timestr.length > 0)
            urlstr = [NSString stringWithFormat:@"%@?date=%@",urlstr,timestr];
        [self initdata:urlstr];
        
    }
}



-(void)initdata:(NSString *)url1
{
    
    //NSURL *url= [NSURL URLWithString:[url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURL *url= [NSURL URLWithString:[url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
    
    
    ASIFormDataRequest *asi=[[ASIFormDataRequest alloc]initWithURL:url];
    [asi setStringEncoding:NSUTF8StringEncoding];
    [asi setTimeOutSeconds:10];
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
    
    
    if(time && time.length >0)
    {
    if(![time isEqualToString:self.lastdate])
    {
        
        NSString *filePath = [DOCUMENTS_FOLDER3 stringByAppendingPathComponent:@"default.xml"];    //在document下创建文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        
        //将下载的数据，写入文件中
        [data writeToFile:filePath atomically:YES];
        
        NSURL *url1= [NSURL URLWithString:[channel stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
        NSError *error1 = nil;
        NSData   *data1 = [NSURLConnection sendSynchronousRequest:request1
                                                returningResponse:nil
                                                            error:&error1];
        NSString *filePath1 = [DOCUMENTS_FOLDER3 stringByAppendingPathComponent:@"channel.xml"];
        NSFileManager *fileManager1 = [NSFileManager defaultManager];
        [fileManager1 createFileAtPath:filePath1 contents:nil attributes:nil];
        
        //将下载的数据，写入文件中
        [data1 writeToFile:filePath1 atomically:YES];
        
        
        NSURL *url2= [NSURL URLWithString:[meeting stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
        NSError *error2 = nil;
        NSData   *data2 = [NSURLConnection sendSynchronousRequest:request2
                                                returningResponse:nil
                                                            error:&error2];
        NSString *filePath2 = [DOCUMENTS_FOLDER3 stringByAppendingPathComponent:@"meeting.xml"];
        NSFileManager *fileManager2 = [NSFileManager defaultManager];
        [fileManager2 createFileAtPath:filePath2 contents:nil attributes:nil];
        
        //将下载的数据，写入文件中
        [data2 writeToFile:filePath2 atomically:YES];
        UIAlertView* myAlert = [[UIAlertView alloc]
                                initWithTitle:@""
                                message:@"您有新的数据需要更新!"
                                delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        myAlert.delegate = self;
        [myAlert show];
        
        
    }
    else
    {
        UIAlertView* myAlert = [[UIAlertView alloc]
                                initWithTitle:@""
                                message:@"您的数据是最新的!"
                                delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        myAlert.delegate = nil;
        [myAlert show];
        [myAlert release];
    }
    
    }
    else
    {
        UIAlertView *myalert = [[UIAlertView alloc]
                                initWithTitle:@""
                                message:@"配置文件错误，更新失败"
                                delegate:nil
                                cancelButtonTitle:NSLocalizedString(@"确定", @"确定")
                                otherButtonTitles:nil];
        
        [myalert show];
        
        [myalert release];


    }
    
    if (request)
        
    {
        
        [request release];
        request.delegate=nil;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}


-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0)
    {
        MasterViewController *document = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
        //self.mcontrol = document;
        
        //[self.view addSubview:self.mcontrol.view];
        
        
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:document animated:YES completion:nil];
        
        //[self presentModalViewController:document animated:YES];
        //
        [document release];
    }
        
    [alertView release];
}

- (void)requestFailed:(ASIHTTPRequest *)request;
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    UIAlertView *myalert = [[UIAlertView alloc]
                            initWithTitle:NSLocalizedString(@"网络连接失败", @"网络连接失败")
                            message:NSLocalizedString(@"网络连接失败，请检查网络", nil)
                            delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"确定", @"确定")
                            otherButtonTitles:nil];
    
    [myalert show];
    
    [myalert release];
    if (request)
        
    {
        
        [request release];
        request.delegate=nil;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
       
}
//-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
////    if(buttonIndex == 0)
////        [self dismissModalViewControllerAnimated:YES];
//    [alertView release];
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    
}
@end
