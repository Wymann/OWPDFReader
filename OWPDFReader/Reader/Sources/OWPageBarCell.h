//
//  OWPageBarCell.h
//  ConpakMagazine
//
//  Created by Wyman Chen on 2017/4/13.
//  Copyright © 2017年 Conpak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OWSmallPaperModel.h"

@interface OWPageBarCell : UICollectionViewCell

@property (nonatomic, strong) OWSmallPaperModel *model;

- (void)showBold:(BOOL)showBold;

@end
