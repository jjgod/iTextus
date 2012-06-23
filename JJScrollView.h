//
//  JJScrollView.h
//  iTextus
//
//  Created by Jiang Jiang on 3/27/12.
//

#import <UIKit/UIKit.h>
#import "JJTextView.h"
#import "JJBook.h"

@interface JJScrollView : UIScrollView <UIScrollViewDelegate> {
    NSMutableArray *views;
    JJBook *book;
    NSDictionary *textAttributes;
}

@property (assign) JJBook *book;
@property (readonly) NSDictionary *textAttributes;

- (void) populateViews;
- (JJTextView *) loadTextView: (NSInteger) pageNum;

@end
