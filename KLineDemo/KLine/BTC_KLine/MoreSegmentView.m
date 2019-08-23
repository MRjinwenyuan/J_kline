//
//  MoreSegmentView.m
//  KLineDemo
//
//  Created by panqiang on 2019/8/23.
//  Copyright © 2019 www.KlineDemo.com. All rights reserved.
//

#import "MoreSegmentView.h"

static NSInteger const Y_StockChartSegmentIndicatorIndex = 3000;

@implementation MoreSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = RGB(21, 32, 54);
        self.layer.borderWidth = 1;
        self.layer.borderColor = RGB(24, 50, 102).CGColor;
        [self isYY];
        
        NSArray *titleArr = @[BTLanguage(@"1分"),BTLanguage(@"5分"),BTLanguage(@"30分"),BTLanguage(@"周线"),BTLanguage(@"1月")];
//        kWeakSelf(self);
        __block UIButton *preBtn;
        [titleArr enumerateObjectsUsingBlock:^(NSString*  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:RGB(98, 124, 158) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.titleLabel.font = BOLDSYSTEMFONT(12);
            btn.tag = Y_StockChartSegmentIndicatorIndex + 100 + idx;
            [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:title forState:UIControlStateNormal];
            [self addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self).multipliedBy(1.0f/6);
                make.height.equalTo(self);
                make.top.equalTo(self);
                if(preBtn)
                {
                    make.left.equalTo(preBtn.mas_right);
                } else {
                    make.left.equalTo(self);
                }
            }];
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(btn);
                make.top.equalTo(btn.mas_bottom);
                make.height.equalTo(@0.5);
            }];
            preBtn = btn;
        }];
//        [self addSubview:self];
        self.hidden = YES;
//        self.isShowMoreSegmentView = NO;
//        if (_isFullScreen) {
//            [self mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self).offset(5);
//                make.right.equalTo(self).offset(-5);
//                make.bottom.equalTo(self).offset(-32);
//                make.height.equalTo(@42);
//            }];
//        }
//        else{
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.right.equalTo(self).offset(-5);
                make.top.equalTo(self).offset(32-5);
                make.height.equalTo(@42);
            }];
//        }
    }
    return self;
}


-(void)buttonClicked:(UIButton*)sender{
    if (self.block){
        self.block(sender);
    }
}

@end
