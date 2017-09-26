//
//  NewPaintListViewController.h
//  MobileOffice1
//
//  Created by shizheng on 13-11-27.
//
//

#import <UIKit/UIKit.h>
#import "MosaicViewDatasourceProtocol.h"
#import "CustomMosaicDatasource.h"
#import "RoboReader.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "TreeNode.h" 
#import "MasterViewController.h"
@interface NewPaintListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MosaicViewDatasourceProtocol,RoboViewControllerDelegate,RATreeViewDelegate, RATreeViewDataSource,UIScrollViewDelegate>
{
    IBOutlet UITableView *_table;
    IBOutlet UIScrollView *_scrollview;
    IBOutlet UIView *rightview;
    NSMutableArray *controllarray;
    //TreeNode *baseNode;
    
    IBOutlet UIButton *listbutton;
    IBOutlet UIButton *imagebutton;
    
    IBOutlet UIScrollView *channelscrollview;
    
    NSMutableArray *btnarray;
}
@property (nonatomic,retain) IBOutlet UIView *leftview;
@property (nonatomic,retain) IBOutlet UILabel *topLabel;
@property (strong) id <MosaicViewDatasourceProtocol> datasource;
@property (nonatomic ,retain) TreeNode *cus;
@property (nonatomic,retain) UIImage *_imageo;

@property (retain, nonatomic) NSMutableArray *data;
@property (retain, nonatomic) NSMutableArray *data1;
@property (retain, nonatomic) id expanded;
@property (retain, nonatomic) RATreeView *treeView;
@property (retain, nonatomic) TreeNode *baseNode;
@property (retain, nonatomic) TreeNode *chanelNode;
@property (retain ,nonatomic) RADataObject *mm;
@property (retain ,nonatomic) NSMutableArray *mm1;
@property (retain,nonatomic) MasterViewController *mcontrol;
@property (retain,nonatomic) NSString *lastdate;
@property (retain,nonatomic) NSMutableDictionary *numberdir;
@end
