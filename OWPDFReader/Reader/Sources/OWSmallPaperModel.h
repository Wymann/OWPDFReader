//
//  OWSmallPaperModel.h
//  ConpakMagazine
//
//  Created by Wyman Chen on 2017/4/17.
//  Copyright © 2017年 Conpak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReaderThumbView.h"

@interface OWSmallPaperModel : NSObject

@property (nonatomic, strong) ReaderThumbView *thumbView;
@property (nonatomic) NSInteger page;

@end
