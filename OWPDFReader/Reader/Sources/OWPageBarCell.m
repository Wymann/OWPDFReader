//
//  OWPageBarCell.m
//  ConpakMagazine
//
//  Created by Wyman Chen on 2017/4/13.
//  Copyright © 2017年 Conpak. All rights reserved.
//

#import "OWPageBarCell.h"
#import "ReaderThumbView.h"

@interface OWPageBarCell()

//@property (nonatomic, strong) ReaderThumbView *thumbView;

@end

@implementation OWPageBarCell

-(void)setModel:(OWSmallPaperModel *)model
{
    _model = model;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:_model.thumbView];

}

- (void)showBold:(BOOL)showBold
{
    if (showBold) {
        self.layer.borderWidth = 2.5;
        self.layer.borderColor = [UIColor greenColor].CGColor;
    } else {
        self.layer.borderWidth = 0;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
