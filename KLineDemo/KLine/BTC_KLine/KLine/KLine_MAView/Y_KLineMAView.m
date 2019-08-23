//
//  Y_KLineMAView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/2.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineMAView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"
#import "Y_KLineModel.h"
@interface Y_KLineMAView ()

@property (strong, nonatomic) UILabel *MA7Label;

@property (strong, nonatomic) UILabel *MA30Label;

@property (strong, nonatomic) UILabel *MA5Label;

@property (strong, nonatomic) UILabel *MA10Label;

@property (strong, nonatomic) UILabel *dateDescLabel;

@property (strong, nonatomic) UILabel *openDescLabel;

@property (strong, nonatomic) UILabel *closeDescLabel;

@property (strong, nonatomic) UILabel *highDescLabel;

@property (strong, nonatomic) UILabel *lowDescLabel;

@property (strong, nonatomic) UILabel *openLabel;

@property (strong, nonatomic) UILabel *closeLabel;

@property (strong, nonatomic) UILabel *highLabel;

@property (strong, nonatomic) UILabel *lowLabel;

@end

@implementation Y_KLineMAView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _MA7Label = [self private_createLabel];
        _MA30Label = [self private_createLabel];
        
        _MA7Label.textColor = [UIColor ma7Color];
        _MA30Label.textColor = [UIColor ma30Color];
        _MA5Label.textColor = [UIColor ma7Color];
        _MA10Label.textColor = [UIColor ma30Color];
        _openLabel.textColor = [UIColor assistTextColor];
        _highLabel.textColor = [UIColor assistTextColor];
        _lowLabel.textColor = [UIColor assistTextColor];
        _closeLabel.textColor = [UIColor assistTextColor];
        _openLabel.font = [UIFont fontWithName:@"ArialMT" size:11];
        _highLabel.font = [UIFont fontWithName:@"ArialMT" size:11];
        _lowLabel.font = [UIFont fontWithName:@"ArialMT" size:11];
        _closeLabel.font = [UIFont fontWithName:@"ArialMT" size:11];
        
        self.backgroundColor = [UIColor clearColor];
        
        [_MA7Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);

        }];
 
        
        [_MA30Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_MA7Label.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

+(instancetype)view
{
    Y_KLineMAView *MAView = [[Y_KLineMAView alloc]init];

    return MAView;
}
-(void)maProfileWithModel:(Y_KLineModel *)model
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.Date.doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    _dateDescLabel.text = [@" " stringByAppendingString: dateStr];
    
 
 
    _MA7Label.text = [NSString stringWithFormat:@" MA7：%@",[CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.MA7.doubleValue  afterPoint:model.coin]];
    _MA30Label.text = [NSString stringWithFormat:@" MA30：%@",[CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.MA30.doubleValue  afterPoint:model.coin]];
 
}
- (UILabel *)private_createLabel
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = RGB(241, 241, 241);
    [self addSubview:label];
    return label;
}
@end
