//
//  TDProgressView.m
//  TDLoaderView.iOS
//
//  Created by tindle on 15/8/6.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import "TDProgressView.h"
#import "ScreenUtil.h"
#import "TDProgressCircleView.h"

#define VIEW_SIZE 100
#define PROGRESS_SIZE 40

@interface TDProgressView ()

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) TDProgressCircleView *progressView;

@end

@implementation TDProgressView

#pragma mark - Public Method

- (id)initWithStatus:(NSString *)status{
    debugMethod();
    self = [super init];
    if (self) {
        self.status = status;
    }
    return self;
}

- (void)setWithStatus:(NSString *)status{
    self.status = status;
}

- (void)create{
    
}

- (void)show{
    debugMethod();
    [self initViews];
    
    [self validateLayout];
}

- (void)dismiss{
    
}

- (CGSize)getSize{
    return CGSizeMake(VIEW_SIZE, VIEW_SIZE);
}

- (void)setProgressStatus:(NSString *)status{
    self.status = status;
}

# pragma mark - Setup Views

- (void)initViews{
    
    if (!_progressView) {
        _progressView = [[TDProgressCircleView alloc] initWithFrame:CGRectZero];
        _progressView.strokeThickness = 2.5;
        _progressView.strokeColor = [UIColor blackColor];
        _progressView.radius = 20;
        [_progressView sizeToFit];
        [self addSubview:_progressView];
    }
    
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.adjustsFontSizeToFitWidth = YES;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _statusLabel.numberOfLines = 1;
        _statusLabel.adjustsFontSizeToFitWidth      = NO;
        _statusLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        [self addSubview:_statusLabel];
        
         _statusLabel.textColor = [UIColor blackColor];
    }
}

# pragma mark - Validate Layout

- (void)validateLayout{
    
    CGFloat height = [self layoutHeight];
    
    self.transform = CGAffineTransformIdentity;
    self.frame = CGRectMake(0, 0, VIEW_SIZE, height);
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat offsetX = (VIEW_SIZE - PROGRESS_SIZE)/2;
    CGFloat offsetY = (VIEW_SIZE - PROGRESS_SIZE)/2;
    
    if (_status) {
        offsetY -= 5;
        self.statusLabel.text = _status;
    }else{
        offsetY += 5;
    }
    
    _progressView.frame = CGRectMake(offsetX+5, offsetY, PROGRESS_SIZE, PROGRESS_SIZE);
    [self setRectForLabel:self.statusLabel];
}

# pragma mark - Calculate Height

- (CGFloat)layoutHeight{
    debugMethod();
    CGFloat height = VIEW_SIZE;
    return height;
}

-(void)setRectForLabel:(UILabel *)lable{
    
    if (!lable) {
        return;
    }
    
    CGFloat stringWidth = 0.0f;
    CGFloat stringHeight = 0.0f;
    CGRect labelRect = CGRectZero;
    
    NSString *string = lable.text;
    
    if(string) {
        CGSize constraintSize = CGSizeMake(200.0f, 300.0f);
        CGRect stringRect;
        if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
            stringRect = [string boundingRectWithSize:constraintSize
                                              options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                           attributes:@{NSFontAttributeName: lable.font}
                                              context:NULL];
        } else {
            CGSize stringSize;
            if ([string respondsToSelector:@selector(sizeWithAttributes:)]){
                stringSize = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:lable.font.fontName size:lable.font.pointSize]}];
            }
            stringRect = CGRectMake(0.0f, 0.0f, stringSize.width, stringSize.height);
        }
        stringWidth = stringRect.size.width;
        stringHeight = ceil(CGRectGetHeight(stringRect));
        
        CGFloat labelRectY = CGRectGetMaxY(self.progressView.frame);
        labelRect = CGRectMake(0.0f, labelRectY+5, VIEW_SIZE, stringHeight);
        
        
        lable.frame = labelRect;
    }else{
        
    }
}


# pragma mark - Actions

# pragma mark - Others

@end
