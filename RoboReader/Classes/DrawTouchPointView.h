//
//  DrawTouchPointView.h
//  DrawTouchPointTest
//
//  Created by ethan on 11-10-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DrawTouchPointView : UIView {
	NSMutableArray *stroks;
	//weak
	CGMutablePathRef currentPath;
	BOOL isEarse;
    UIColor *color;
    float lineWidth;
}

@property(nonatomic, assign) BOOL isEarse;
@property(nonatomic, retain) UIColor *color;
@property (nonatomic,assign)float lineWidth;
- (void)clearStroks;

@end
