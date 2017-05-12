//
//  OWReaderMainPagebar.m
//  ConpakMagazine
//
//  Created by Wyman Chen on 2017/4/17.
//  Copyright © 2017年 Conpak. All rights reserved.
//

#import "OWReaderMainPagebar.h"
#import "OWPageBarCell.h"
#import "ReaderThumbRequest.h"
#import "ReaderThumbCache.h"
#import "ReaderThumbView.h"
#import "OWSmallPaperModel.h"

#define THUMB_GAP 15.0f
#define THUMB_WIDTH 96.0f
#define THUMB_HEIGHT 126.0f
#define NUMBAR_HEIGHT 30.0f

@interface OWReaderMainPagebar()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ReaderDocument *document;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIView *boldView;

@end

@implementation OWReaderMainPagebar
{
    NSInteger currentP;
}

- (instancetype)initWithFrame:(CGRect)frame document:(ReaderDocument *)object currentPage:(NSInteger)currentPage
{
    self = [super initWithFrame:frame];
    if (self) {
        currentP = currentPage;
        self.backgroundColor = [UIColor colorWithWhite:0.94f alpha:0.94f];
        _document = object;
        [self initData];
        [self setLineView];
        [self setCollectionView];
        [self setPageLabel];
        [self setBoldView];
    }
    return self;
}

- (void)initData
{
    _dataArray = [NSMutableArray array];
    
    NSInteger thumbs = [_document.pageCount integerValue];
    
    for (NSInteger thumb = 1; thumb <= thumbs; thumb++) // Iterate through needed thumbs
    {
        NSURL *fileURL = _document.fileURL; NSString *guid = _document.guid; NSString *phrase = _document.password;
        
        ReaderThumbView *ThumbView = [[ReaderThumbView alloc] initWithFrame:CGRectMake(0, 0, THUMB_WIDTH, THUMB_HEIGHT)];
        CGSize size = CGSizeMake(THUMB_WIDTH, THUMB_HEIGHT);
        ReaderThumbRequest *thumbRequest = [ReaderThumbRequest newForView:ThumbView fileURL:fileURL password:phrase guid:guid page:thumb size:size];
        UIImage *image = [[ReaderThumbCache sharedInstance] thumbRequest:thumbRequest priority:YES];
        if ([image isKindOfClass:[UIImage class]]) [ThumbView showImage:image];
        OWSmallPaperModel *model = [[OWSmallPaperModel alloc] init];
        model.thumbView = ThumbView;
        model.page = thumb;
        [_dataArray addObject:model];
    }
    
}

- (void)setLineView
{
    CGRect lineRect = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1.0);
    UIView *line = [[UIView alloc] initWithFrame:lineRect];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
}

- (void)setCollectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置每个item的大小，
        flowLayout.itemSize = CGSizeMake(THUMB_WIDTH, THUMB_HEIGHT);
        //    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        // 设置列的最小间距
        flowLayout.minimumInteritemSpacing = THUMB_GAP;
        // 设置最小行间距
        //flowLayout.minimumLineSpacing = THUMB_GAP;
        // 设置布局的内边距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5.0, 0, 5.0);
        // 滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect collectionFrame = CGRectMake(0, (CGRectGetHeight(self.frame) - NUMBAR_HEIGHT - THUMB_HEIGHT) / 2, CGRectGetWidth(self.frame), THUMB_HEIGHT);
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:flowLayout];
        // 如果未设置背景颜色是黑色设置背景颜色
        _collectionView.backgroundColor = [UIColor clearColor];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
        [_collectionView registerClass:[OWPageBarCell class] forCellWithReuseIdentifier:@"OWPageBarCell"];
        
        [self addSubview:_collectionView];
    }
}

- (void)setPageLabel
{
    CGRect pageLabelFrame = CGRectMake(0, CGRectGetHeight(self.frame) - NUMBAR_HEIGHT, CGRectGetWidth(self.frame), NUMBAR_HEIGHT);
    _pageLabel = [[UILabel alloc] initWithFrame:pageLabelFrame];
    _pageLabel.font = [UIFont systemFontOfSize:16.0f];
    _pageLabel.textColor = [UIColor blackColor];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_pageLabel];
    [self setPage:currentP];
}

- (void)setPage:(NSInteger)page
{
    currentP = page;
    _pageLabel.text = [NSString stringWithFormat:@"%ld / %ld",page, [_document.pageCount integerValue]];
    
    CGRect boldFrame = CGRectMake((THUMB_WIDTH + THUMB_GAP - 5.0) * (page - 1) + 5.0, 0, THUMB_WIDTH, THUMB_HEIGHT);
    _boldView.frame = boldFrame;
    
    [_collectionView scrollRectToVisible:boldFrame animated:YES];
}

- (void)setBoldView
{
    _boldView = [[UIView alloc] init];
    _boldView.backgroundColor = [UIColor clearColor];
    _boldView.layer.borderColor = [UIColor greenColor].CGColor;
    _boldView.layer.borderWidth = 2.5;
    [_collectionView addSubview:_boldView];
}

- (void)hidePagebar
{
    if (self.hidden == NO) // Only if visible
    {
        [UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             self.hidden = YES;
         }
         ];
    }
}

- (void)showPagebar
{
    if (self.hidden == YES) // Only if hidden
    {
        //[self updatePagebarViews]; // Update views first
        
        [UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.hidden = NO;
             self.alpha = 1.0f;
         }
                         completion:NULL
         ];
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
// 返回分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

// 每个分区多少个item
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"OWPageBarCell";
    OWPageBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(THUMB_WIDTH, THUMB_HEIGHT);
}

//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return THUMB_GAP;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return THUMB_GAP;
//}

// 点击图片的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate) {
        [self setPage:indexPath.row + 1];
        [self.delegate didSelectedOWReaderMainPagebar:self atIndex:indexPath.row + 1];
    }
    //[self clickAtPage:indexPath.row + 1];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
