//
//  YJWNavigationController.m
//  asd
//
//  Created by 杨军伟 on 13-3-25.
//  Copyright (c) 2013年 yjw. All rights reserved.
//

#import "YJWNavigationController.h"

@interface YJWNavigationController ()

@end

@implementation YJWNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
