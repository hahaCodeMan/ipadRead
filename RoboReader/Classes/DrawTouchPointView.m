//
//  DrawTouchPointView.m
//  DrawTouchPointTest
//
//  Created by ethan on 11-10-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawTouchPointView.h"
#import "DWStroke.h"

@implementation DrawTouchPointView

@synthesize isEarse;
@synthesize color;
@synthesize lineWidth;
- (void)clearStroks {
	[stroks release];
	stroks = [[NSMutableArray alloc] initWithCapacity:1];
	[self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	currentPath = CGPathCreateMutable();
	DWStroke *stroke = [[DWStroke alloc] init];
	stroke.path = currentPath;
	stroke.blendMode = isEarse ? kCGBlendModeDestinationIn : kCGBlendModeNormal;
	stroke.strokeWidth = isEarse ? 20.0 : lineWidth;
	stroke.strokeColor = isEarse ? [[UIColor clearColor] CGColor] : [color CGColor];
	[stroks addObject:stroke];
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	CGPathMoveToPoint(currentPath, NULL, point.x, point.y);
	
	CGPathRelease(currentPath);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	CGPathAddLineToPoint(currentPath, NULL, point.x, point.y);
	[self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		stroks = [[NSMutableArray alloc] initWithCapacity:1];
//        UIColor *myColorHue = [[ UIColor alloc ]
//                               initWithHue: 120.0 / 360.0
//                               saturation: 0.75
//                               brightness: 0.50
//                               alpha: 0.5
//                               ];
        
        
        color=[UIColor darkTextColor];
        lineWidth = 2.0;
        //[myColorHue release];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	CGContextRef context = UIGraphicsGetCurrentContext();
	for (DWStroke *stroke in stroks) {
		[stroke strokeWithContext:context];
	}
}


- (void)dealloc {
	[stroks release];
    [super dealloc];
}


@end
