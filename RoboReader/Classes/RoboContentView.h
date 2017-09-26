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

#import <UIKit/UIKit.h>
#import "DrawTouchPointView.h"
@protocol RoboContentViewDelegate <NSObject>

@optional

- (void)getZoomedPages:(int)pageNum isLands:(BOOL)isLands zoomIn:(BOOL)zoomIn;

@end

@interface RoboContentView : UIView <UIScrollViewDelegate> {
@private

    UIScrollView *theScrollView;
    BOOL _isLandscape;

    UIImageView *theContentViewImagePDF;
    UIImageView *theContentViewImage2PDF;
    

    UITextField *pageNumberTextField;
    UITextField *pageNumberTextField2;

    UIView *theContainerView;
    BOOL noTiledLayer;
    int pageNumber;

    BOOL flag1Loaded;
    BOOL flag2Loaded;
    
    UIImageView *paintview;
    
    NSString *pdfguid;

}


//- (id)initWithFrame:(CGRect)frame page:(NSUInteger)page orientation:(BOOL)isLandscape;
- (id)initWithFrame:(CGRect)frame page:(NSUInteger)page orientation:(BOOL)isLandscape pdfguid:(NSString *)guid iamgenum:(int)imagenum;

- (void)pageContentLoadingComplete:(UIImage *)pageBarImage rightSide:(BOOL)rightSide zoomed:(BOOL)zoomed;
- (void)updataScroll;
- (void)savePaintImage:(DrawTouchPointView *)topaintview pagenume:(int)num;
- (void)showimage:(int)num;
@property(nonatomic, unsafe_unretained, readwrite) id <RoboContentViewDelegate> delegate;


@end


