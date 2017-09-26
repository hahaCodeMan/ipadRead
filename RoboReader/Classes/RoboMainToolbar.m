//
// Copyright (c) 2013 RoboReader ( http://brainfaq.ru/roboreader )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "RoboMainToolbar.h"
#import "RoboConstants.h"

@implementation RoboMainToolbar


#define TITLE_Y 8.0f
#define TITLE_X 12.0f
#define TITLE_HEIGHT 28.0f



#define BUTTON_X 0.0f
#define BUTTON_Y 0.0f
#define DONE_BUTTON_WIDTH 44.0f


@synthesize delegate;


- (id)initWithFrame:(CGRect)frame {


    return [self initWithFrame:frame title:nil];
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {


    if ((self = [super initWithFrame:frame])) {

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        CGFloat titleX = TITLE_X;
        CGFloat titleWidth = (self.bounds.size.width - (titleX * 2.0f));

        //UIImageView *toolbarImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024.0f, frame.size.height)];
        UIImageView *toolbarImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024.0f, 50)];
        //[toolbarImg setImage:[UIImage imageNamed:@"nav_bar_plashka.png"]];
        toolbarImg.backgroundColor=[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
        [self addSubview:toolbarImg];


        CGRect titleRect = CGRectMake(titleX, TITLE_Y, titleWidth, TITLE_HEIGHT);

        theTitleLabel = [[UILabel alloc] initWithFrame:titleRect];

        theTitleLabel.text = title; // Toolbar title
        theTitleLabel.textAlignment = NSTextAlignmentCenter;
        theTitleLabel.font = [UIFont systemFontOfSize:20.0f];
        theTitleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        theTitleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        theTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        theTitleLabel.backgroundColor = [UIColor clearColor];
        theTitleLabel.adjustsFontSizeToFitWidth = YES;
        //[self addSubview:theTitleLabel];

        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.tag=1000;
        doneButton.frame = CGRectMake(BUTTON_X, BUTTON_Y, DONE_BUTTON_WIDTH, READER_TOOLBAR_HEIGHT);

        [doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchDown];

        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake((READER_TOOLBAR_HEIGHT - 18) / 2, (READER_TOOLBAR_HEIGHT - 18) / 2, 13, 18)];
        [backImage setImage:[UIImage imageNamed:@"back_button.png"]];
        [doneButton addSubview:backImage];

        doneButton.autoresizingMask = UIViewAutoresizingNone;

        [self addSubview:doneButton];
        
        
        //阅读
        UIButton *yuedubutton = [UIButton buttonWithType:UIButtonTypeCustom];
        yuedubutton.tag = 1001;
        yuedubutton.frame = CGRectMake(BUTTON_X+250, (READER_TOOLBAR_HEIGHT - 18) / 2, 32.0, 32.0);
        [yuedubutton setImage:[UIImage imageNamed:@"yuedu_A"] forState:UIControlStateNormal];
        [yuedubutton setImage:[UIImage imageNamed:@"yuedu_B"] forState:UIControlStateSelected]; 
        [yuedubutton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:yuedubutton];
        
        //编辑
        UIButton *bianjibutton = [UIButton buttonWithType:UIButtonTypeCustom];
        bianjibutton.tag = 1002;
        bianjibutton.frame = CGRectMake(BUTTON_X+250+64, (READER_TOOLBAR_HEIGHT - 18) / 2, 32.0, 32.0);
        [bianjibutton setImage:[UIImage imageNamed:@"bianji_A"] forState:UIControlStateNormal];
        [bianjibutton setImage:[UIImage imageNamed:@"bianji_B"] forState:UIControlStateSelected];
        [bianjibutton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bianjibutton];
        
        //标记
        UIButton *boldbutton = [UIButton buttonWithType:UIButtonTypeCustom];
         boldbutton.tag = 1003;
        boldbutton.frame = CGRectMake(BUTTON_X+250+64+64, (READER_TOOLBAR_HEIGHT - 18) / 2, 32.0, 32.0);
        [boldbutton setImage:[UIImage imageNamed:@"bold_A"] forState:UIControlStateNormal];
        [boldbutton setImage:[UIImage imageNamed:@"bold_B"] forState:UIControlStateSelected];
        [boldbutton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:boldbutton];
        
        //橡皮
        UIButton *eraserbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        eraserbutton.tag = 1004;
        eraserbutton.frame = CGRectMake(BUTTON_X+250+64+64+64, (READER_TOOLBAR_HEIGHT - 18) / 2, 32.0, 32.0);
        [eraserbutton setImage:[UIImage imageNamed:@"Eraser_A"] forState:UIControlStateNormal];
        [eraserbutton setImage:[UIImage imageNamed:@"Eraser_B"] forState:UIControlStateSelected];
        [eraserbutton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:eraserbutton];
        
        //保存
        UIButton *savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        savebutton.tag = 1005;
        savebutton.frame = CGRectMake(BUTTON_X+250+64+64+64+64, (READER_TOOLBAR_HEIGHT - 18) / 2, 32.0, 32.0);
        [savebutton setImage:[UIImage imageNamed:@"baocun_A"] forState:UIControlStateNormal];
        [savebutton setImage:[UIImage imageNamed:@"baocun_B"] forState:UIControlStateSelected];
        [savebutton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:savebutton];
        
        
        //保存
        UIButton *deletebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        deletebutton.tag = 1100;
        deletebutton.frame = CGRectMake(BUTTON_X+250+64+64+64+64+130, (READER_TOOLBAR_HEIGHT - 38) / 2, 80.0, 50.0);
        deletebutton.titleLabel.font=[UIFont boldSystemFontOfSize:18];
        [deletebutton setTitle:@"还原文档" forState:UIControlStateNormal];
        [deletebutton setTitle:@"还原文档" forState:UIControlStateSelected];
        deletebutton.titleLabel.textColor=[UIColor whiteColor];
        [deletebutton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deletebutton];
        
//        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake((READER_TOOLBAR_HEIGHT - 18) / 2, (READER_TOOLBAR_HEIGHT - 18) / 2, 13, 18)];
//        [backImage setImage:[UIImage imageNamed:@"back_button.png"]];
//        [doneButton addSubview:backImage];
//        
//        doneButton.autoresizingMask = UIViewAutoresizingNone;
//        
//        [self addSubview:doneButton];
        

        CGRect newFrame = self.frame;
        newFrame.origin.y -= newFrame.size.height;
        [self setFrame:newFrame];
        self.alpha = 0.0f;
        self.hidden = YES;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
                {
                    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 768, 20)];
                    view1.backgroundColor=[UIColor blackColor];
                    [self addSubview:view1];
                    view1 =nil;
                   //[view1 release];
            }

    }

    return self;
}

- (void)dealloc {


    theTitleLabel = nil;

}


- (void)hideToolbar {

    if (self.hidden == NO) {
        [UIView animateWithDuration:0.1 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void) {
                             CGRect newFrame = self.frame;
                             newFrame.origin.y -= newFrame.size.height;
                             [self setFrame:newFrame];
                             self.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             self.hidden = YES;
                         }
        ];
    }
}

- (void)showToolbar {


    if (self.hidden == YES) {
        [UIView animateWithDuration:0.1 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void) {
                             self.hidden = NO;
                             self.alpha = 1.0f;
                             CGRect newFrame = self.frame;
                             newFrame.origin.y += newFrame.size.height;
                             [self setFrame:newFrame];
                         }
                         completion:NULL
        ];
    }
}




- (void)doneButtonTapped:(UIButton *)button {

    UIButton *last = nil;
    for(int i = 0; i < self.subviews.count; i++)
    {
        UIView *cn = self.subviews[i];
        if(cn.tag > 1000 && cn.tag<=1005)
        {
             if(((UIButton *)cn).selected)
                 last = (UIButton *)cn;
            
            ((UIButton *)cn).selected = NO;
           
        }
    }
    button.selected=YES;
    [delegate dismissButtonTapped:button lasttag:last];
}


@end
