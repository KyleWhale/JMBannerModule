//
//  HTHomeBannerConfig.m
//  Cartoon
//
//  Created by James on 2023/4/28.
//

#import "HTHomeBannerConfig.h"

@interface HTHomeBannerConfig()

@property (strong,nonatomic) NSString *className;

@end

@implementation HTHomeBannerConfig

-(void)registerCellClassName:(NSString *)andClassName {
    
    self.className = andClassName;
}

-(WMZBannerParam *)getWMZHomeBannerParam {
    
    int activeDistanceSet = 300;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        activeDistanceSet = 500;
    }
    
    typeof(self) __weak weakSelf = self;
    WMZBannerParam *param =
    BannerParam()
   //自定义视图必传
   .wMyCellClassNameSet(self.className)
   .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
              //自定义视图
       
       if ([weakSelf.dataSource respondsToSelector:@selector(collectionView:cellForRow:model:bgImageView:dataArr:)]) {
           return [weakSelf.dataSource collectionView:collectionView cellForRow:indexPath model:model bgImageView:bgImageView dataArr:dataArr];
       }
       return UICollectionViewCell.new;
   })
   .wFrameSet(self.frame)
   .wDataSet([self getData])
   //关闭pageControl
   .wHideBannerControlSet(YES)
   //开启缩放
   .wScaleSet(YES)
   //自定义item的大小
   .wItemSizeSet(self.itemSize)
   //固定移动的距离
   .wContentOffsetXSet(0.5)
    //循环
    .wRepeatSet(YES)
    /// 自动循环
    .wAutoScrollSet(self.autoScroll)
   //整体左右间距  设置为size.width的一半 让最后一个可以居中
   .wSectionInsetSet(self.sectionInset)
   //间距
   .wLineSpacingSet(self.LineSpacing)
    .wZindexSet(YES)
    /// 垂直缩放
    .wActiveDistanceSet(activeDistanceSet)
    .wScaleFactorSet(0.8)
    .wAlphaSet(0.75)
    .wEventClickSet(^(id anyID, NSInteger index) {
        NSLog(@"点击 %@ %ld",anyID,index);
        
        if ([weakSelf.delegate respondsToSelector:@selector(homeBannerDidSelect:)]) {
            return [weakSelf.delegate homeBannerDidSelect:index];
        }
        
    })
    .wEventCenterClickSet(^(id anyID, NSInteger index,BOOL isCenter,UICollectionViewCell *cell) {
        NSLog(@"判断居中点击");
    })
    .wEventScrollEndSet(^(id anyID, NSInteger index,BOOL isCenter,UICollectionViewCell *cell) {
        NSLog(@"滚动结束");
        
        if ([weakSelf.delegate respondsToSelector:@selector(homeBannerScrollEnd:)]) {
            return [weakSelf.delegate homeBannerScrollEnd:index];
        }
    })
   ;
    
   return param;
}

- (NSArray*)getData{
    
    if ([self.dataSource respondsToSelector:@selector(dataSource)]) {
        return [self.dataSource dataSource];
    }
    
    
    return @[];
}

@end
