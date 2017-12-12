//
//  MPCToast.h
//  Toast提示
//
//  Created by LG on 2017/12/8.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPCToast : UIView
/*
 * MPCToast说明：主要用于展示Toast提示，
              ①默认keywindow上展示视图，展示的位置默认是视图中间位置，如果设置了 topMargin和bottomMargin，则会根据设置展示
              ②展示在特定的view上展示，展示的位置默认为视图的中间，如果设置了 topMargin和bottomMargin，则会根据设置展示
 
 注意：展示自定义视图的时候，自定义视图的尺寸需要设置好。
 */

//一些基本属性设置,设置一次只对一次有效，视图展示过之后会恢复默认(调用过showXXX方法之后会重置默认属性)

//设置背景是否展示 ，默认 enable = NO
+ (void)setCoverBackgroundEnable:(BOOL)enable;
//设置背景色 ，默认 color = [UIColor clearColor]
+ (void)setCoverBackgroundColor:(UIColor*)color;

//***************************************************************
//展示默认文本视图
//***************************************************************
+ (void)showWithText:(NSString *)text;
+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset;
+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset;

//***************************************************************
//展示默认文本视图，指定展示时间
//***************************************************************
+ (void)showWithText:(NSString *)text duration:(CGFloat)duration;
+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration;
+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;

//***************************************************************
//展示默认文本视图在‘指定的视图上’
//***************************************************************
+ (void)showWithText:(NSString *)text inView:(UIView *)view;
+ (void)showWithText:(NSString *)text inView:(UIView *)view topOffset:(CGFloat)topOffset;
+ (void)showWithText:(NSString *)text inView:(UIView *)view bottomOffset:(CGFloat)bottomOffset;

//***************************************************************
//展示默认文本视图在‘指定的视图上’，指定展示时间
//***************************************************************
+ (void)showWithText:(NSString *)text inView:(UIView *)view duration:(CGFloat)duration;
+ (void)showWithText:(NSString *)text inView:(UIView *)view topOffset:(CGFloat)topOffset duration:(CGFloat)duration;
+ (void)showWithText:(NSString *)text inView:(UIView *)view bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;

//***************************************************************
//展示自定义视图
//***************************************************************
+ (void)showWithContentView:(UIView *)content;
+ (void)showWithContentView:(UIView *)content topOffset:(CGFloat)topOffset;
+ (void)showWithContentView:(UIView *)content bottomOffset:(CGFloat)bottomOffset;

//***************************************************************
//展示自定义视图，指定展示时间
//***************************************************************
+ (void)showWithContentView:(UIView *)content duration:(CGFloat)duration;
+ (void)showWithContentView:(UIView *)content bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;
+ (void)showWithContentView:(UIView *)content topOffset:(CGFloat)topOffset duration:(CGFloat)duration;

//***************************************************************
//展示自定义视图在‘指定的视图上’
//***************************************************************
+ (void)showWithContentView:(UIView *)content inView:(UIView *)view;
+ (void)showWithContentView:(UIView *)content inView:(UIView *)view topMargin:(CGFloat)topMargin;
+ (void)showWithContentView:(UIView *)content inView:(UIView *)view bottomMargin:(CGFloat)bottomMargin;

//***************************************************************
//展示自定义视图在‘指定的视图上’，指定展示时间
//***************************************************************
+ (void)showWithContentView:(UIView *)content inView:(UIView *)view duration:(CGFloat)duration;
+ (void)showWithContentView:(UIView *)content inView:(UIView *)view topMargin:(CGFloat)topMargin duration:(CGFloat)duration;
+ (void)showWithContentView:(UIView *)content inView:(UIView *)view bottomMargin:(CGFloat)bottomMargin duration:(CGFloat)duration;

@end
