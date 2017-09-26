//
//  DWStroke.m
//  DrawTouchPointTest
//
//  Created by ethan on 11-10-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DWStroke.h"

@implementation DWStroke

@synthesize path;
@synthesize blendMode;
@synthesize strokeWidth;
@synthesize strokeColor;

- (void)setPath:(CGMutablePathRef)aPath {
	if (path != aPath) {
		CGPathRelease(path);
		path = aPath;
		CGPathRetain(aPath);
	}
}

- (void)setStrokeColor:(CGColorRef)aColor {
	if (strokeColor != aColor) {
		CGColorRelease(strokeColor);
		strokeColor = CGColorRetain(aColor);
	}
}

- (void)dealloc {
	CGPathRelease(path);
	CGColorRelease(strokeColor);
	[super dealloc];
}

- (void)strokeWithContext:(CGContextRef)context {
	CGContextSetStrokeColorWithColor(context, strokeColor);
	CGContextSetLineWidth(context, strokeWidth);
	CGContextSetBlendMode(context, blendMode);
	CGContextBeginPath(context);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
}

@end
