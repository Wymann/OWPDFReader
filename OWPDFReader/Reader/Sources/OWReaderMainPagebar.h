//
//  OWReaderMainPagebar.h
//  ConpakMagazine
//
//  Created by Wyman Chen on 2017/4/17.
//  Copyright © 2017年 Conpak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderDocument.h"

@class OWReaderMainPagebar;

@protocol OWReaderMainPagebarDelegate <NSObject>

- (void)didSelectedOWReaderMainPagebar:(OWReaderMainPagebar *)readerMainPagebar atIndex:(NSInteger) index;

@end

@interface OWReaderMainPagebar : UIView

@property (nonatomic, weak) id <OWReaderMainPagebarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame document:(ReaderDocument *)object currentPage:(NSInteger)currentPage;

- (void)hidePagebar;
- (void)showPagebar;
- (void)setPage:(NSInteger)page;

@end
