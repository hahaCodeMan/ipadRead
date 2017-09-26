//
//  DWStroke.h
//  DrawTouchPointTest
//
//  Created by ethan on 11-10-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct CGPath *CGMutablePathRef;
typedef enum CGBlendMode CGBlendMode;

@interface DWStroke : NSObject {
	CGMutablePathRef	path;
	CGBlendMode			blendMode;
	CGFloat		strokeWidth;
	CGColorRef	strokeColor;
}

@property (nonatomic, readwrite)CGMutablePathRef	path;
@property (nonatomic, assign)CGBlendMode			blendMode;
@property (nonatomic, assign)CGFloat		strokeWidth;
@property (nonatomic, readwrite)CGColorRef	strokeColor;

- (void)strokeWithContext:(CGContextRef)context;

@end
