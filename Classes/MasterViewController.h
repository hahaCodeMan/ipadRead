//
//  MasterViewController.h
//  RoboReader
//
//  Created by shizheng on 13-12-20.
//
//

#import <UIKit/UIKit.h>
#import "progressCell.h"
#import "ASIFormDataRequest.h"
@class DetailViewController;

@interface MasterViewController :UIViewController <progressCellDelegate,UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>

@property (nonatomic,retain)IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *array;
@property (nonatomic, retain) NSString *lastdate;
@end
