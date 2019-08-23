//
//  IndicatorSegmentView.m
//  KLineDemo
//
//  Created by panqiang on 2019/8/22.
//  Copyright © 2019 www.KlineDemo.com. All rights reserved.
//
static NSInteger const Y_StockChartSegmentIndicatorIndex = 3000;

#import "IndicatorSegmentView.h"

@implementation IndicatorSegmentView

 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = RGB(24, 50, 102).CGColor;
        self.backgroundColor = RGB(21, 32, 54);
        [self isYY];
        NSArray *titleArr = @[BTLanguage(@"主图"),@"MA",@"EMA",@"BOLL",BTLanguage(@""),BTLanguage(@"副图"),@"MACD",@"KDJ",@"RSI",@"WR",BTLanguage(@"")];
        __block UIButton *preBtn;
//        kWeakSelf(self);
        [titleArr enumerateObjectsUsingBlock:^(NSString*  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:RGB(98, 124, 158) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.titleLabel.font = BOLDSYSTEMFONT(12);
            if (idx == 0 || idx == 5) {
                btn.tag = Y_StockChartSegmentIndicatorIndex;
            }else{
                btn.tag = Y_StockChartSegmentIndicatorIndex + idx;
            }
            [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:title forState:UIControlStateNormal];
            if (idx == 4 || idx == 10) {
                [btn setImage:IMAGE_NAMED(@"line_see") forState:UIControlStateNormal];
                [btn setImage:IMAGE_NAMED(@"line_seeNot") forState:UIControlStateSelected];
            }else{
                [btn setTitle:title forState:UIControlStateNormal];
            }
            [self addSubview:btn];
            if (idx < 5){
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(self).multipliedBy(1.0f/6);
                    make.height.equalTo(@36);
                    make.top.equalTo(self);
                    if (idx == 4) {
                        make.right.equalTo(self);
                    }
                    else{
                        if(preBtn)
                        {
                            make.left.equalTo(preBtn.mas_right);
                        } else {
                            make.left.equalTo(self);
                        }
                    }
                    
                }];
            }
            else{
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(self).multipliedBy(1.0f/6);
                    make.height.equalTo(@36);
                    make.top.equalTo(self).offset(36);
                    if (idx == 10) {
                        make.right.equalTo(self);
                    }
                    else{
                        if(preBtn && (idx != 5))
                        {
                            make.left.equalTo(preBtn.mas_right);
                        } else {
                            make.left.equalTo(self);
                        }
                    }
                    
                }];
            }
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
//        if (_isFullScreen) {
//            [self mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self).offset(5);
//                make.right.equalTo(self).offset(-5);
//                make.bottom.equalTo(self).offset(-32);
//                make.height.equalTo(@72);
//            }];
//        }
//        else{
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.right.equalTo(self).offset(-5);
                make.top.equalTo(self).offset(32-5);
                make.height.equalTo(@72);
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
