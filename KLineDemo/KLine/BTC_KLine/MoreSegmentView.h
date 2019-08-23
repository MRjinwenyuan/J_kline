//
//  MoreSegmentView.h
//  KLineDemo
//
//  Created by panqiang on 2019/8/23.
//  Copyright © 2019 www.KlineDemo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoreSegmentView : UIView
@property (copy, nonatomic) void (^block)(UIButton* btn);

@end

NS_ASSUME_NONNULL_END
