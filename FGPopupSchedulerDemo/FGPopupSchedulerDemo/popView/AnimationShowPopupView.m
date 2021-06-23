//
//  AnimationShowPopupView.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/23.
//

#import "AnimationShowPopupView.h"

@implementation AnimationShowPopupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showPopupViewWithAnimation:(FGPopupViewAnimationBlock)block{
    NSLog(@"%s", __func__);
    [UIView animateWithDuration:2 animations:^{
        [self showPopupView];
    }];
}

@end
