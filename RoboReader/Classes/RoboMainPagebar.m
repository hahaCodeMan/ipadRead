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


#import "RoboMainPagebar.h"
#import "RoboConstants.h"
#import "RoboPDFModel.h"

@implementation ImagesFlags

@synthesize isRendered;
@synthesize onPageBar;

- (NSString *)description {
    return [NSString stringWithFormat:@"onPageBar = %d, isRendered = %d", onPageBar, isRendered];
}

@end

@implementation RoboMainPagebar

@synthesize pagesDict;
@synthesize renderedPages;


#define THUMB_SMALL_GAP 13.0f
#define THUMB_SMALL_HEIGHT 120.0f

#define PAGE_NUMBER_WIDTH 74.0f
#define PAGE_NUMBER_HEIGHT 22.0f

#define SLIDER_HEIGHT 40.0f
#define SCROLL_SLIDER_GAP 4.0f
#define TOP_SCROLL_GAP  16.0f


- (id)initWithFrame:(CGRect)frame
           document:(RoboDocument *)object pdfController:(RoboPDFController *)ipdfController {//    firstPage: (UIImage*) firstImage{


    if ((self = [super initWithFrame:frame])) {
        inited = NO;
        pdfController = ipdfController;
        pdfController.pagebarDelegate = self;

        maxOffsetForUpdate = 200;
        offsetCounter = 0;
        prevOffset = 0;
        currentWindowSize = 6;
        //    firstPageImage = firstImage;
        //   _pdfController = ipdfController;
        //   _pdfController.pagebarDelegate = self;

        document = object; // Retain the document object for our use

        CGRect firstPageSize = [pdfController getFirstPdfPageRect];
        previewPageWidth = THUMB_SMALL_HEIGHT * firstPageSize.size.width / firstPageSize.size.height;

        int pages = [document.pageCount intValue];

        barContentSize = CGSizeMake(pages * (previewPageWidth + THUMB_SMALL_GAP) - THUMB_SMALL_GAP * (-2 + pages / 2 + pages % 2), THUMB_SMALL_HEIGHT + 2 * SCROLL_SLIDER_GAP);

        self.autoresizesSubviews = YES;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeRedraw;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.backgroundColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];        //[self setBackgroundColor:UIColorFromRGBWithAlpha(0x333333)];
        //[self setBackgroundColor:[UIColor colorWithRed:0/255.0 green:103/255.0 blue:79/255.0 alpha:0.99]];


        trackControl = [[RoboTrackControl alloc] initWithFrame:CGRectMake(0, TOP_SCROLL_GAP - SCROLL_SLIDER_GAP, self.frame.size.width, self.frame.size.height) page:pages previewPageWidth:previewPageWidth lastPage:pages]; // Track control view
        [trackControl setContentSize:barContentSize];
        trackControl.showsVerticalScrollIndicator = NO;
        trackControl.showsHorizontalScrollIndicator = NO;
        [trackControl addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
        UITapGestureRecognizer *trackTouchUpInside = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trackViewTouchUpInside:)];
        trackTouchUpInside.numberOfTapsRequired = 1;
        [trackControl addGestureRecognizer:trackTouchUpInside];
        [self addSubview:trackControl]; // Add the track control and thumbs view
        pagebarSlider.value = [document.currentPage floatValue];
        // [self sliderValueChanged:pagebarSlider];
        [trackControl setStrokePage:[document.currentPage intValue]];
        [trackControl setDelegate:self];


        CGRect pagebarFrame = frame;
        pagebarFrame.origin.x = 0.0;
        pagebarFrame.origin.y = self.frame.size.height - SLIDER_HEIGHT;
        pagebarFrame.size.height = SLIDER_HEIGHT;
        pagebarSlider = [[UISlider alloc] initWithFrame:pagebarFrame];
        [pagebarSlider setThumbImage:[UIImage imageNamed:@"page-bg.png"] forState:UIControlStateNormal];
        [pagebarSlider setMinimumTrackImage:[UIImage imageNamed:@"progress_bar.png"] forState:UIControlStateNormal];
        [pagebarSlider setMaximumTrackImage:[UIImage imageNamed:@"progress_bar.png"] forState:UIControlStateNormal];
        [pagebarSlider setMinimumValue:1.0f];
        [pagebarSlider setMaximumValue:pages];
        [pagebarSlider setValue:[document.currentPage floatValue]];
        [pagebarSlider setContinuous:YES];
        [pagebarSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:pagebarSlider];


        CGRect numberRect = CGRectMake(0, self.frame.size.height - SLIDER_HEIGHT + (pagebarSlider.frame.size.height - PAGE_NUMBER_HEIGHT) / 2, PAGE_NUMBER_WIDTH, PAGE_NUMBER_HEIGHT);
        pageLabelView = [[UIView alloc] initWithFrame:numberRect]; // Page numbers view
        pageLabelView.autoresizesSubviews = NO;
        pageLabelView.userInteractionEnabled = NO;
        pageLabelView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        pageLabelView.backgroundColor = [UIColor clearColor];
        [self addSubview:pageLabelView];


        CGRect textRect = CGRectMake(0, 0, PAGE_NUMBER_WIDTH, PAGE_NUMBER_HEIGHT);
        pageLabel = [[UILabel alloc] initWithFrame:textRect]; // Page numbers label
        pageLabel.autoresizesSubviews = NO;
        pageLabel.autoresizingMask = UIViewAutoresizingNone;
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.backgroundColor = [UIColor clearColor];
        pageLabel.textColor = UIColorFromRGB(0xBEBEBE);
        [pageLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
        //[pageLabelView addSubview:pageLabel]; // Add label view



        CGRect barContentRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, barContentSize.width, barContentSize.height);
        CGRect controlRect = CGRectInset(barContentRect, 4.0f, 0.0f);

        CGFloat previewPageWidthWithGap = (previewPageWidth + THUMB_SMALL_GAP);

        CGFloat heightDelta = (controlRect.size.height - THUMB_SMALL_HEIGHT);

        float thumbY = (heightDelta / 2.0f);
        float thumbX = 0; // Initial X, Y

        CGRect thumbRect = CGRectMake(thumbX, thumbY, previewPageWidth, THUMB_SMALL_HEIGHT + 11);
        // pagebarImages = [[NSMutableArray alloc] init];

        thumbRect.origin.x += THUMB_SMALL_GAP;
        // first page

        // middle pages

        pagesDict = [[NSMutableDictionary alloc] init];
        renderedPages = [[NSMutableDictionary alloc] init];
        imagesFlags = [[NSMutableArray alloc] init];
        beginPage = -1;
        for (int page = 1; page <= pages; page++) // Iterate through needed thumbs
        {
            if (page > pages) page = pages; // Page

            // We need to create a new small thumb view for the page number

            // UIImageView *smallThumbView = [[UIImageView alloc] initWithFrame:thumbRect];
            CGRect textFieldRect = thumbRect;
            textFieldRect.origin.y += textFieldRect.size.height;
            textFieldRect.size.height = 10.0f;
            UITextField *currentPageTextField = [[UITextField alloc] initWithFrame:textFieldRect];
            [currentPageTextField setTextColor:UIColorFromRGB(0xCCCCCC)];
            [currentPageTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [currentPageTextField setFont:[UIFont fontWithName:@"Helvetica" size:10]];

            //UITextField *smallThumbTextLeft;
            //UITextField *smallThumbTextRight;
            //[smallThumbView setBackgroundColor:[UIColor purpleColor]];

            if (page % 2) {
                //    [smallThumbView setImage: [UIImage imageNamed:@"page_right.png"]];
                thumbRect.origin.x += previewPageWidthWithGap;
                [currentPageTextField setTextAlignment:NSTextAlignmentLeft];
                [currentPageTextField setText:[NSString stringWithFormat:@"    %i", page]];
            }
            else {
                //    [smallThumbView setImage: [UIImage imageNamed:@"page_left.png"]];
                thumbRect.origin.x += previewPageWidthWithGap - THUMB_SMALL_GAP;
                [currentPageTextField setTextAlignment:NSTextAlignmentRight];
                [currentPageTextField setText:[NSString stringWithFormat:@"%i    ", page]];
            }
            //[smallThumbView addSubview:smallThumbTextLeft];
            //  [trackControl addSubview:smallThumbView];
            [trackControl addSubview:currentPageTextField];
            //[pagebarImages addObject:smallThumbView];
            // Next thumb X position
            //  [pagesDict setValue:smallThumbView forKey:[NSString stringWithFormat:@"%d", page]];

            endPage = page;
            ImagesFlags *imageFlags = [[ImagesFlags alloc] init];
            [imagesFlags addObject:imageFlags];
        }

        [self sliderValueChanged:pagebarSlider];

        CGRect newFrame = self.frame;
        newFrame.origin.y += newFrame.size.height;
        [self setFrame:newFrame];
        self.alpha = 0.0f;

        [self start];
        /*   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];*/
    }


    return self;
}


- (void)pagebarImageLoadingComplete:(UIImage *)pageBarImage page:(int)page {
    if (inited) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *key = [NSString stringWithFormat:@"%d", page];
            if ([renderedPages valueForKey:key] == nil) {

                CGRect barContentRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, barContentSize.width, barContentSize.height);
                CGRect controlRect = CGRectInset(barContentRect, 4.0f, 0.0f);
                CGFloat heightDelta = (controlRect.size.height - THUMB_SMALL_HEIGHT);

                float thumbY = (heightDelta / 2.0f);
                float thumbX = (page - 1) * (previewPageWidth + THUMB_SMALL_GAP) - THUMB_SMALL_GAP * (-2 + page / 2 + page % 2);// Initial X, Y

                CGRect thumbRect = CGRectMake(thumbX, thumbY, previewPageWidth, THUMB_SMALL_HEIGHT);

                UIImageView *thumbView = [[UIImageView alloc] initWithFrame:thumbRect];

                [thumbView setImage:pageBarImage];

                [renderedPages setObject:thumbView forKey:key];
                ((ImagesFlags *) imagesFlags[page - 1]).isRendered = YES;

                UIView *previousThumbView = [pagesDict objectForKey:key];
                if (previousThumbView != nil) {
                    [pagesDict removeObjectForKey:key];
                    [pagesDict setObject:thumbView forKey:key];

                    if ([previousThumbView superview] != nil) {
                        if ([self onScreen:page]) {
                            thumbView.alpha = 0;
                            [trackControl addSubview:thumbView];
                            [UIView animateWithDuration:0.3 delay:0.0
                                                options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                             animations:^(void) {
                                                 thumbView.alpha = 1.0f;
                                             }
                                             completion:^(BOOL f) {
                                                 thumbView.alpha = 1.0f;
                                                 [previousThumbView removeFromSuperview];
                                             }
                            ];
                        } else {
                            [trackControl addSubview:thumbView];
                        }
                    }
                }
            }

        });
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {


    if ([keyPath isEqualToString:@"contentOffset"] && !sliderValueChanged) {
        UIScrollView *trackScroll = (UIScrollView *) object;

        float ratio = 0.0;
        if (barContentSize.width != self.bounds.size.width)
            ratio = trackScroll.contentOffset.x / (barContentSize.width - self.bounds.size.width);

        float pagebarOffset;
        if (ratio > 0.0 && ratio < 1.0)
            pagebarOffset = ([document.pageCount floatValue]) * ratio;
        else if (ratio >= 1.0)
            pagebarOffset = [document.pageCount floatValue];
        else if (ratio <= 0.0)
            pagebarOffset = 1.0f;
        else pagebarOffset = 0;


        //set slider text and position
        float currentPage = 1.0f;
        if (pagebarSlider.maximumValue != pagebarSlider.minimumValue)
            currentPage = pagebarOffset * (pagebarSlider.maximumValue / (pagebarSlider.maximumValue - pagebarSlider.minimumValue));
        if (currentPage > [document.pageCount floatValue])
            currentPage = [document.pageCount floatValue];
        //currentSliderPage = currentPage;

        float sliderRatio = 0;
        if((pagebarSlider.maximumValue - pagebarSlider.minimumValue)!=0)
            sliderRatio=(pagebarOffset - pagebarSlider.minimumValue) / (pagebarSlider.maximumValue - pagebarSlider.minimumValue);
        if (sliderRatio < 0)
            sliderRatio = 0;
        if (sliderRatio > 1)
            sliderRatio = 1;

        CGRect pageLabelViewRect = CGRectMake((self.bounds.size.width - PAGE_NUMBER_WIDTH) * sliderRatio, self.frame.size.height - SLIDER_HEIGHT + (pagebarSlider.frame.size.height - PAGE_NUMBER_HEIGHT) / 2, PAGE_NUMBER_WIDTH, PAGE_NUMBER_HEIGHT);
        [pageLabelView setFrame:pageLabelViewRect];

        int labelPage = currentPage;
        if (labelPage < 1)
            labelPage = 1;

        [pageLabel setText:[NSString stringWithFormat:@"%i / %i", labelPage, [document.pageCount intValue]]];

        [pagebarSlider setValue:pagebarOffset animated:NO];


    }
}


- (void)sliderValueChanged:(UISlider *)sender {

    sliderValueChanged = YES;

    CGPoint offset = trackControl.contentOffset;
    [trackControl setContentOffset:offset animated:NO];

    float documentPage = [document.pageCount floatValue];

    int page = sender.value;
    if (page < 1)
        page = 1;
    if (page > documentPage)
        page = documentPage;

    double ratio = 0;
    if (sender.maximumValue != sender.minimumValue)
        ratio = (sender.value - sender.minimumValue) / (sender.maximumValue - sender.minimumValue);

    if (ratio < 0)
        ratio = 0;
    if (ratio > 1)
        ratio = 1;

    CGRect pageLabelViewRect = CGRectMake((self.bounds.size.width - PAGE_NUMBER_WIDTH) * ratio, self.frame.size.height - SLIDER_HEIGHT + (pagebarSlider.frame.size.height - PAGE_NUMBER_HEIGHT) / 2, PAGE_NUMBER_WIDTH, PAGE_NUMBER_HEIGHT);
    [pageLabelView setFrame:pageLabelViewRect];

    [pageLabel setText:[NSString stringWithFormat:@"%i / %i", page, [document.pageCount intValue]]];

    [trackControl setContentOffset:CGPointMake((barContentSize.width - self.bounds.size.width) * ratio, 0)];

    sliderValueChanged = NO;
}


- (void)dealloc {

    //pdfController.stop = YES;
    _delegate = nil;


    [trackTimer invalidate];

    trackTimer = nil;

    pagebarSlider = nil;

    [trackControl removeObserver:self forKeyPath:@"contentOffset"];
    trackControl = nil;

    pageLabel = nil;

    pageLabelView = nil;

    document = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [pagesDict removeAllObjects];
    pagesDict = nil;

}

- (void)layoutSubviews {

    CGRect trackRect = trackControl.frame;
    trackRect.size.width = self.bounds.size.width;
    [trackControl setFrame:trackRect];

    CGRect sliderFrame = pagebarSlider.frame;
    sliderFrame.size.width = self.bounds.size.width;
    [pagebarSlider setFrame:sliderFrame];

}


- (void)hidePagebar {

    [UIView animateWithDuration:0.1 delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) {
                         CGRect newFrame = self.frame;
                         newFrame.origin.y += newFrame.size.height;
                         [self setFrame:newFrame];
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                     }
    ];

}


- (void)showPagebar {
    offsetCounter = maxOffsetForUpdate;
    pagebarSlider.value = [document.currentPage floatValue];
    [self sliderValueChanged:pagebarSlider];
    [trackControl setStrokePage:[document.currentPage intValue]];
    [UIView animateWithDuration:0.1 delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) {
                         self.alpha = 1.0f;
                         CGRect newFrame = self.frame;
                         newFrame.origin.y -= newFrame.size.height;
                         [self setFrame:newFrame];
                     }
                     completion:NULL
    ];

}


- (void)trackViewTouchUpInside:(UITapGestureRecognizer *)recognizer {

    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        CGPoint point = [recognizer locationInView:recognizer.view];

        int page = 0;

        while (point.x > (page * (previewPageWidth + THUMB_SMALL_GAP) - THUMB_SMALL_GAP * (-1 + page / 2 + page % 2)))
            page++;

        if (page < 1)
            page = 1;

        if (page > [document.pageCount intValue])
            page = [document.pageCount intValue];

        [_delegate openPage:page];

        [trackControl setStrokePage:page];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    offsetCounter += fabsf(scrollView.contentOffset.x - prevOffset);
    prevOffset = scrollView.contentOffset.x;
    if (offsetCounter > maxOffsetForUpdate) {
        [self updateFirstAndLastPagesOnScreen2:scrollView.contentOffset.x withRemoving:NO];
        offsetCounter = 0;
    }
}


- (void)updateFirstAndLastPagesOnScreen2:(float)offset withRemoving:(BOOL)withRemoving {
    if (inited) {
        int newBeginPage = floor((offset - previewPageWidth) / (THUMB_SMALL_GAP / 2 + previewPageWidth)) + 1;
        int newEndPage = floor((offset + 1024) / (THUMB_SMALL_GAP / 2 + previewPageWidth)) + 2;

        newBeginPage -= currentWindowSize;
        newEndPage += currentWindowSize;

        if (newBeginPage < 1) newBeginPage = 1;
        if (newBeginPage > [document.pageCount intValue]) newBeginPage = [document.pageCount intValue];
        if (newEndPage < 1) newEndPage = 1;
        if (newEndPage > [document.pageCount intValue]) newEndPage = [document.pageCount intValue];

        if (beginPage != newBeginPage || endPage != newEndPage || withRemoving) {
            beginPage = newBeginPage;
            endPage = newEndPage;
            int i;

            //    if (withRemoving) {
            for (i = 1; i < beginPage; i++) {
                //disappear
                [self deleteSmallPageView:i];
            }
            for (i = endPage + 1; i <= [document.pageCount intValue]; i++) {
                [self deleteSmallPageView:i];
            }
            //    }
            for (i = beginPage; i <= endPage; i++) {
                [self initSmallPageView:i];
            }
        }
    }

}

- (void)initSmallPageView:(int)page {
    NSString *key = [NSString stringWithFormat:@"%d", page];

    UIImageView *smallThumbView = [pagesDict valueForKey:key];
    if (smallThumbView == nil) {
        if ([renderedPages objectForKey:key] != nil) {
            smallThumbView = [renderedPages objectForKey:key];
            ((ImagesFlags *) imagesFlags[page - 1]).onPageBar = YES;
        } else {
            CGRect barContentRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, barContentSize.width, barContentSize.height);
            CGRect controlRect = CGRectInset(barContentRect, 4.0f, 0.0f);
            CGFloat heightDelta = (controlRect.size.height - THUMB_SMALL_HEIGHT);

            float thumbY = (heightDelta / 2.0f);
            float thumbX = (page - 1) * (previewPageWidth + THUMB_SMALL_GAP) - THUMB_SMALL_GAP * (-2 + page / 2 + page % 2);// Initial X, Y

            CGRect thumbRect = CGRectMake(thumbX, thumbY, previewPageWidth, THUMB_SMALL_HEIGHT + 11);

            // We need to create a new small thumb view for the page number

            smallThumbView = [[UIImageView alloc] initWithFrame:thumbRect];
            if (page % 2) {
                //smallThumbText = [[UITextField alloc] initWithFrame:CGRectMake(thumbRect.origin.x, THUMB_SMALL_HEIGHT, 20, 20)];
                [smallThumbView setImage:[UIImage imageNamed:@"page_right"]];
            }
            else {
                [smallThumbView setImage:[UIImage imageNamed:@"page_left"]];
            }
            [pdfController addGettingPageBarImageToQueue:page];
        }
        [pagesDict setValue:smallThumbView forKey:key];
        ((ImagesFlags *) imagesFlags[page - 1]).onPageBar = YES;
    } else {
        if ([renderedPages objectForKey:key] == nil) {
            [pdfController addGettingPageBarImageToQueue:page];
        }
    }
    if ([smallThumbView superview] == nil)
        [trackControl addSubview:smallThumbView];
}

- (void)deleteSmallPageView:(int)i {
    NSString *key = [NSString stringWithFormat:@"%d", i];
    UIView *previousThumbView = [pagesDict objectForKey:key];
    if (previousThumbView != nil) {
        ((ImagesFlags *) imagesFlags[i - 1]).onPageBar = NO;
        [previousThumbView removeFromSuperview];
        [pagesDict removeObjectForKey:key];
    }
    UIImageView *renderedView = [renderedPages objectForKey:key];
    if (renderedView != nil) {
        ((ImagesFlags *) imagesFlags[i - 1]).isRendered = NO;
        [renderedView removeFromSuperview];
        [renderedPages removeObjectForKey:key];
    }
}

- (void)clearImageCache {
    [self updateFirstAndLastPagesOnScreen2:trackControl.contentOffset.x withRemoving:YES];
    for (int i = 1; i < beginPage; i++) {
        NSString *key = [NSString stringWithFormat:@"%d", i];
        UIImageView *previousThumbView = [pagesDict objectForKey:key];
        if (previousThumbView != nil) {
            ((ImagesFlags *) imagesFlags[i - 1]).onPageBar = NO;
            [previousThumbView removeFromSuperview];
            [pagesDict removeObjectForKey:key];
        }
        UIImageView *renderedView = [renderedPages objectForKey:key];
        if (renderedView != nil) {
            ((ImagesFlags *) imagesFlags[i - 1]).isRendered = NO;
            [renderedView removeFromSuperview];
            [renderedPages removeObjectForKey:key];
        }
    }
    for (int i = endPage + 1; i <= [document.pageCount intValue]; i++) {
        NSString *key = [NSString stringWithFormat:@"%d", i];
        UIView *previousThumbView = [pagesDict objectForKey:key];
        if (previousThumbView != nil) {
            ((ImagesFlags *) imagesFlags[i - 1]).onPageBar = NO;
            [previousThumbView removeFromSuperview];
            [pagesDict removeObjectForKey:key];
        }
        UIImageView *renderedView = [renderedPages objectForKey:key];
        if (renderedView != nil) {
            ((ImagesFlags *) imagesFlags[i - 1]).isRendered = NO;
            [renderedView removeFromSuperview];
            [renderedPages removeObjectForKey:key];
        }
    }
}

- (BOOL)isNeedLoad:(int)i {
    /*  NSString* key = [NSString stringWithFormat:@"%d", i];
     
     if ([[renderedPages allKeys] containsObject:key]) return NO;// already rendered
     if ([[pagesDict allKeys] containsObject:key]) return YES;// not rendered and on pagebar
     if ([self allPagesOnScreenRendered]) return YES;// not rendered and not on pagebar, but all important pages loaded*/

    if (((ImagesFlags *) imagesFlags[i - 1]).isRendered) return NO;// already rendered
    if (((ImagesFlags *) imagesFlags[i - 1]).onPageBar) return YES;// not rendered and on pagebar

    return NO;
    //  if ([self allPagesOnScreenRendered] && flagMemoryIsOK) return YES;// not rendered and not on pagebar, all important pages loaded, and memOK

    //  return NO;// not rendered and not on pagebar and low memory
}

- (BOOL)allPagesOnScreenRendered {

    for (int i = MAX(beginPage, 1); i <= endPage; i++) {
        if (!((ImagesFlags *) imagesFlags[i - 1]).isRendered) return NO;
    }

    return YES;
}

- (void)didReceiveMemoryWarning {
    [self clearImageCache];
}

- (BOOL)onScreen:(int)i {
    int onScreenBeginPage = floor((trackControl.contentOffset.x - previewPageWidth) / (THUMB_SMALL_GAP / 2 + previewPageWidth)) + 1;
    int onScreenEndPage = floor((trackControl.contentOffset.x + 1024) / (THUMB_SMALL_GAP / 2 + previewPageWidth)) + 2;

    if (onScreenBeginPage <= i <= onScreenEndPage) return YES;
    else return NO;
}

- (void)reset {
    inited = NO;
    beginPage = 0;
    endPage = 0;
    for (int i = 1; i <= [document.pageCount intValue]; i++) {
        NSString *key = [NSString stringWithFormat:@"%d", i];
        UIImageView *renderedView = [renderedPages objectForKey:key];
        if (renderedView != nil) {
            ((ImagesFlags *) imagesFlags[i - 1]).isRendered = NO;
            [renderedView removeFromSuperview];
            [renderedPages removeObjectForKey:key];
        }
        [self deleteSmallPageView:i];
    }
}

- (void)start {
    inited = YES;
    [self updateFirstAndLastPagesOnScreen2:trackControl.contentOffset.x withRemoving:YES];
}

@end


@implementation RoboTrackControl

@synthesize value = _value;


- (id)initWithFrame:(CGRect)frame page:(int)page previewPageWidth:(float)previewWidth lastPage:(int)lPage {


    if ((self = [super initWithFrame:frame])) {
        self.autoresizesSubviews = NO;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeRedraw;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.backgroundColor = [UIColor clearColor];

        previewPageWidth = previewWidth;
        lastPage = lPage;

        strokeTrackImage = [[UIImageView alloc] init];
        [self addSubview:strokeTrackImage];
        [strokeTrackImage setImage:[UIImage imageNamed:@"Stroke2px.png"]];

    }

    return self;
}


- (void)setStrokePage:(int)page {

    if (page == 0)
        page = 1;

    float pageOffset;
    CGRect orangeOffset;
    if (page == 1 || (page == lastPage && !(lastPage % 2))) {
        pageOffset = page * (previewPageWidth + THUMB_SMALL_GAP) - THUMB_SMALL_GAP * (-1 + page / 2 + page % 2);
        // first or last page and odd number of pages in pdf
        if (page == 1)
            orangeOffset = CGRectMake(THUMB_SMALL_GAP - 6, 0, previewPageWidth + 12, THUMB_SMALL_HEIGHT + 8);
        else
            orangeOffset = CGRectMake(pageOffset - previewPageWidth - 6, 0, previewPageWidth + 12, THUMB_SMALL_HEIGHT + 8);
        [strokeTrackImage setImage:[UIImage imageNamed:@"Stroke2px_single.png"]];
        [strokeTrackImage setFrame:orangeOffset];

    }
    else {
        // not first and not last
        if (page % 2) {
            pageOffset = page * (previewPageWidth + THUMB_SMALL_GAP) - THUMB_SMALL_GAP * (-1 + page / 2 + page % 2);
            orangeOffset = CGRectMake(pageOffset - 2 * previewPageWidth - 6, 0, previewPageWidth * 2 + 12, THUMB_SMALL_HEIGHT + 8);
            [strokeTrackImage setImage:[UIImage imageNamed:@"Stroke2px.png"]];
            [strokeTrackImage setFrame:orangeOffset];
        }
        else [self setStrokePage:(page + 1)];

    }
}

- (void)dealloc {


}

@end