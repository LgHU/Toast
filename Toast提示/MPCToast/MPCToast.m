//
//  MPCToast.m
//  Toast提示
//
//  Created by LG on 2017/12/8.
//  Copyright © 2017年 my. All rights reserved.
//

#import "MPCToast.h"

static const CGFloat Default_max_w = 180;
static const CGFloat Default_min_w = 100;
static const CGFloat Default_min_h = 24;
static const CGFloat Default_Display_Duration = 1.5;
static const CGFloat Default_Font_Size = 15.0;
static const CGFloat Default_min_Font_Size = 10.0;
static const CGFloat Default_max_Font_Size = 22.0;
static const CGFloat Default_View_Radius = 8.0;
static const CGFloat Default_bg_Alpha = 0.8;
static NSString * const Default_text = @"  ";

@interface MPCToast ()

@property (nonatomic, assign) CGFloat toastRadius;
@property (nonatomic, assign) CGFloat toastDuration;
@property (nonatomic, strong) UIColor *toastBGColor;
@property (nonatomic, strong) UIColor *toastTextColor;
@property (nonatomic, assign) CGFloat toastFontSize;

@property (nonatomic, assign) CGFloat  topMargin;
@property (nonatomic, assign) CGFloat  bottomMargin;

//展示提示的父视图
@property (nonatomic, strong) UIView *showView;
//提示视图的背景视图（会占据整个showView)达到遮盖的目的
@property (nonatomic, strong) UIView *backgroundView;
//当前正在展示的内容视图
@property (nonatomic, strong) UIView *contentView;

//默认文字提示的父视图
@property (nonatomic, strong) UIButton *defaultContentView;
//默认文字提示视图
@property (nonatomic, strong) UILabel *msgLabel;

@property (nonatomic, assign) BOOL backgroundViewEnable;
@property (nonatomic, strong) UIColor *backgroundViewColor;


@end

@implementation MPCToast

#pragma mark - Inherit

+ (instancetype)sharedInstance {
    static MPCToast *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    [self defaultContentUI];
    [self defaultConfig];
}

//TODO:默认文本展示视图
- (void)defaultContentUI {
    if (!self.defaultContentView) {
        CGSize textSize = CGSizeMake(Default_max_w, Default_min_h);
        self.defaultContentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
        self.defaultContentView.layer.cornerRadius = Default_View_Radius;
        self.defaultContentView.layer.masksToBounds = YES;
        self.defaultContentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:Default_bg_Alpha];
        [self.defaultContentView addTarget:self action:@selector(hideAnimation) forControlEvents:UIControlEventTouchUpInside];
        self.defaultContentView.alpha = 0;
        self.msgLabel = [[UILabel alloc] initWithFrame:self.defaultContentView.bounds];
        self.msgLabel.numberOfLines = 0;
        self.msgLabel.backgroundColor = [UIColor clearColor];
        self.msgLabel.text = Default_text;
        self.msgLabel.textColor = [UIColor whiteColor];
        self.msgLabel.textAlignment = NSTextAlignmentCenter;
        self.msgLabel.font = [UIFont boldSystemFontOfSize:Default_Font_Size];
        [self.defaultContentView addSubview:self.msgLabel];
    }
    
    if(self.contentView != self.defaultContentView) {
        [self.contentView removeFromSuperview];
        self.contentView = self.defaultContentView;
    }
}

- (void)defaultConfig {
    self.toastRadius = Default_View_Radius;
    self.showView = [UIApplication sharedApplication].keyWindow;
    self.toastBGColor = [[UIColor blackColor] colorWithAlphaComponent:Default_bg_Alpha];
    self.toastTextColor = [UIColor whiteColor];
    self.toastDuration = Default_Display_Duration;
    self.toastFontSize = Default_Font_Size;
    self.backgroundViewEnable = NO;
    self.backgroundViewColor = [UIColor clearColor];
}


#pragma mark - Public

//TODO:设置背景是否展示 ，默认 enable = NO
+ (void)setCoverBackgroundEnable:(BOOL)enable {
    MPCToast *toast = [MPCToast sharedInstance];
    toast.backgroundViewEnable = enable;
}

//TODO:设置背景色 ，默认 color = [[UIColor lightGrayColor] colorWithAlphaComponent:.5]
+ (void)setCoverBackgroundColor:(UIColor*)color {
    MPCToast *toast = [MPCToast sharedInstance];
    toast.backgroundViewColor = color;
}

- (void(^)(void))show {
    return ^(){
        [self showToast];
        [self defaultConfig];
    };
}

//*************************************************************************
//TODO:简单展示文本
//*************************************************************************
+ (void)showWithText:(NSString *)text {
    [[self class]showWithText:text duration:Default_Display_Duration];
}

//TODO:简单展示文本，设置特定的时间
+ (void)showWithText:(NSString *)text duration:(CGFloat)duration {
    [[self class]showWithText:text topOffset:0 duration:duration];
}

//*************************************************************************
//TODO:默认展示文本，设置特定位置
//*************************************************************************
+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset {
    [[self class]showWithText:text topOffset:topOffset duration:Default_Display_Duration];
}

+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration {
    [[self class]showWithText:text inView:nil topOffset:topOffset duration:duration];
}

//*************************************************************************
//TODO:默认展示文本，设置特定位置
//*************************************************************************
+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset {
    [[self class]showWithText:text bottomOffset:bottomOffset duration:Default_Display_Duration];
}

+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration {
    [[self class]showWithText:text inView:nil bottomOffset:bottomOffset duration:duration];
}

//*************************************************************************
//TODO:默认展示文本，指定特定父视图
//*************************************************************************
+ (void)showWithText:(NSString *)text inView:(UIView *)view {
    [[self class]showWithText:text inView:view duration:Default_Display_Duration];
}

+ (void)showWithText:(NSString *)text inView:(UIView *)view duration:(CGFloat)duration {
    [[self class]showWithText:text inView:view topOffset:0 bottomOffset:0 duration:duration];
}

//*************************************************************************
//TODO:默认展示文本，指定特定父视图和位置
//*************************************************************************
+ (void)showWithText:(NSString *)text inView:(UIView *)view topOffset:(CGFloat)topOffset {
    [[self class]showWithText:text inView:view topOffset:topOffset duration:Default_Display_Duration];
}

+ (void)showWithText:(NSString *)text inView:(UIView *)view topOffset:(CGFloat)topOffset duration:(CGFloat)duration {
    [[self class]showWithText:text inView:view topOffset:topOffset bottomOffset:0 duration:duration];
}

//*************************************************************************
//TODO:默认展示文本，指定特定父视图和位置
//*************************************************************************
+ (void)showWithText:(NSString *)text inView:(UIView*)view bottomOffset:(CGFloat)bottomOffset  {
    [[self class]showWithText:text inView:view bottomOffset:bottomOffset duration:Default_Display_Duration];
}

+ (void)showWithText:(NSString *)text inView:(UIView*)view bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration {
    [[self class]showWithText:text inView:view topOffset:0 bottomOffset:bottomOffset duration:duration];
}

//*************************************************************************
//TODO:展示自定义视图
//*************************************************************************
+ (void)showWithContentView:(UIView *)content {
    [MPCToast showWithContentView:content duration:Default_Display_Duration];
}

+ (void)showWithContentView:(UIView *)content duration:(CGFloat)duration {
    [MPCToast showWithContentView:content topOffset:0 duration:duration];
}

//*************************************************************************
//TODO:展示自定义视图，指定特定位置
//*************************************************************************
+ (void)showWithContentView:(UIView *)content topOffset:(CGFloat)topOffset {
    [MPCToast showWithContentView:content topOffset:topOffset duration:Default_Display_Duration];
}

+ (void)showWithContentView:(UIView *)content topOffset:(CGFloat)topOffset duration:(CGFloat)duration {
    [MPCToast showWithContentView:content inView:nil topMargin:topOffset bottomMargin:0 duration:duration];
}

//*************************************************************************
//TODO:展示自定义视图，指定特定位置
//*************************************************************************
+ (void)showWithContentView:(UIView *)content bottomOffset:(CGFloat)bottomOffset {
    [MPCToast showWithContentView:content bottomOffset:bottomOffset duration:Default_Display_Duration];
}

+ (void)showWithContentView:(UIView *)content bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration {
    [MPCToast showWithContentView:content inView:nil topMargin:0 bottomMargin:bottomOffset duration:duration];
}

//*************************************************************************
//TODO:展示自定义视图，指定特定父视图
//*************************************************************************
+ (void)showWithContentView:(UIView *)content inView:(UIView *)view {
    [MPCToast showWithContentView:content inView:view duration:Default_Display_Duration];
}

+ (void)showWithContentView:(UIView *)content inView:(UIView *)view duration:(CGFloat)duration {
    [MPCToast showWithContentView:content inView:view topMargin:0 bottomMargin:0 duration:duration];
}

//*************************************************************************
//TODO:展示自定义视图，指定特定父视图和特定位置
//*************************************************************************
+ (void)showWithContentView:(UIView *)content inView:(UIView *)view topMargin:(CGFloat)topMargin {
    [MPCToast showWithContentView:content inView:view topMargin:topMargin bottomMargin:0 duration:Default_Display_Duration];
}

+ (void)showWithContentView:(UIView *)content inView:(UIView *)view topMargin:(CGFloat)topMargin duration:(CGFloat)duration {
    [MPCToast showWithContentView:content inView:view topMargin:topMargin bottomMargin:0 duration:duration];
}

//*************************************************************************
//TODO:展示自定义视图，指定特定父视图和特定位置
//*************************************************************************
+ (void)showWithContentView:(UIView *)content inView:(UIView *)view bottomMargin:(CGFloat)bottomMargin {
    [MPCToast showWithContentView:content inView:view topMargin:0 bottomMargin:bottomMargin duration:Default_Display_Duration];
}

+ (void)showWithContentView:(UIView *)content inView:(UIView *)view bottomMargin:(CGFloat)bottomMargin duration:(CGFloat)duration {
    [MPCToast showWithContentView:content inView:view topMargin:0 bottomMargin:bottomMargin duration:duration];
}

//*************************************************************************
//TODO:文本Toast基类展示方法
//*************************************************************************
+ (void)showWithText:(NSString *)text inView:(UIView *)view topOffset:(CGFloat)topOffset bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration {
    MPCToast *toast = [MPCToast sharedInstance];
    [toast defaultContentUI];
    [toast setText:text];
    if (view && [view isKindOfClass:[UIView class]]) {
        toast.showView = view;
    }
    
    if (topOffset != 0 ) {
        [toast setTopMargin:topOffset];
    }
    
    if (bottomOffset != 0) {
        [toast setBottomMargin:bottomOffset];
    }
    
    [toast setToastDuration:duration];
    toast.show();
}

//*************************************************************************
//TODO:自定义视图基类展示方法
//*************************************************************************
+ (void)showWithContentView:(UIView*)content inView:(UIView*)view topMargin:(CGFloat)topMargin bottomMargin:(CGFloat)bottomMargin duration:(CGFloat)duration{
    NSParameterAssert([content isKindOfClass:[UIView class]]);
    [[MPCToast sharedInstance] hideAnimationComplete:^{
        MPCToast *toast = [MPCToast sharedInstance];
        toast.contentView = content;
        if (view && [view isKindOfClass:[UIView class]]) {
            toast.showView = view;
        }
        
        if (topMargin != 0) {
            toast.topMargin = topMargin;
        }
        
        if (bottomMargin != 0) {
            toast.bottomMargin = bottomMargin;
        }
        toast.toastDuration = duration;
        toast.show();
    }];
}

#pragma mark - Private Methods

- (void)setText:(NSString*)text {
    if (self.toastFontSize < Default_min_Font_Size) {
        self.toastFontSize = Default_min_Font_Size;
    }else if (self.toastFontSize > Default_max_Font_Size) {
        self.toastFontSize = Default_max_Font_Size;
    }
    
    self.msgLabel.font = [UIFont boldSystemFontOfSize:self.toastFontSize];
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(Default_max_w, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName : self.msgLabel.font}
                                         context:nil].size;
    CGSize viewSize = CGSizeMake(MIN(Default_max_w, MAX(Default_min_w, ceil(textSize.width))) + 30, ceil(textSize.height) + 20);
    self.contentView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    self.contentView.layer.cornerRadius = self.toastRadius;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = self.toastBGColor;
    self.msgLabel.frame = CGRectMake(0, 0, viewSize.width - 30, viewSize.height - 20);
    self.msgLabel.center = CGPointMake(viewSize.width/2, viewSize.height/2);
    self.msgLabel.text = text;
    self.msgLabel.textColor = self.toastTextColor;
}

- (CGFloat)toastDuration {
    if (_toastDuration <= 0.0f) { return NSIntegerMax; }
    return _toastDuration;
}

-(void)showAnimation {
    if (self.contentView.alpha > 0.8) self.contentView.alpha = 0.8;
    if (self.backgroundView.alpha > 0.8) self.backgroundView.alpha = 0.8;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 1.0;
        self.backgroundView.alpha = 1.0;
    }];
}

-(void)hideAnimationComplete:(void(^)(void))complete{
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 0.0;
        self.backgroundView.alpha = 0.0;
    } completion:^(BOOL finished){
        if (finished) { [self dismissToastComplete:complete]; }
    }];
}

-(void)hideAnimation{
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 0.0;
        self.backgroundView.alpha = 0.0;
    } completion:^(BOOL finished){
        if (finished) { [self dismissToastComplete:nil]; }
    }];
}

-(void)dismissToastComplete:(void(^)(void))complete {
    [self.contentView removeFromSuperview];
    [self.backgroundView removeFromSuperview];
    if (complete) {
        complete();
    }
}

- (void)showToast {
    [self showInView:self.showView withCenterPosition:[self showWithCenter]];
}

- (CGPoint)showWithCenter {
    CGSize showViewSize = self.showView.frame.size;
    CGPoint center = CGPointMake(showViewSize.width / 2., showViewSize.height / 2.);
    self.autoresizingMask = UIViewAutoresizingNone;
    
    if (self.topMargin) {
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        CGFloat center_y = self.topMargin + self.contentView.bounds.size.height/2;
        self.topMargin = 0.0;
        return CGPointMake(self.showView.frame.size.width/2., center_y);
    }
    if (self.bottomMargin) {
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        CGFloat center_y = self.showView.frame.size.height - self.bottomMargin - self.contentView.bounds.size.height/2;
        self.bottomMargin = 0.0;
        return CGPointMake(self.showView.frame.size.width/2., center_y);
    }
    return center;
}

- (void)showInView:(UIView *)view withCenterPosition:(CGPoint)center {
    if (self.contentView.superview != view){
        [self.contentView removeFromSuperview];
        [view addSubview:self.contentView];
    }
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView.backgroundColor = self.backgroundViewColor;
    self.backgroundView.hidden = !self.backgroundViewEnable;
    self.backgroundView.frame = view.bounds;
    [view insertSubview:self.backgroundView belowSubview:self.contentView];
    
    self.contentView.center = center;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self showAnimation];
    if (self.toastDuration < 0) return;
    if (self.toastDuration == 0) self.toastDuration = Default_Display_Duration;
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.toastDuration];
}

#pragma mark - Getter

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]init];
    }
    
    return _backgroundView;
}

@end
