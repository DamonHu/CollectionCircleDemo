//
//  HomeCaseCell.h
//  JianLiXiu
//
//  Created by shuni on 2017/5/15.
//  Copyright © 2017年 damon. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kJLXWidthScale              [UIScreen mainScreen].bounds.size.width/375.0/2.0       //以6/6s为准宽度缩小系数
#define kJLXHeightScale             [UIScreen mainScreen].bounds.size.height/667.0/2.0      //高度缩小系数
#define kJLXBackgroundColor         [UIColor colorWithRed:253.0/255.0 green:242.0/255.0 blue:236.0/255.0 alpha:1.0]     //背景颜色-米黄
#define JLXScreenSize               [UIScreen mainScreen].bounds.size                       //屏幕大小
#define JLXScreenOrigin             [UIScreen mainScreen].bounds.origin                     //屏幕起点

@interface HomeCaseCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *coverImgView;


@end
