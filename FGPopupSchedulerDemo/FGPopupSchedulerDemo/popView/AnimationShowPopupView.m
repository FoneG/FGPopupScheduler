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
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:2 animations:^{
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        NSLog(@"animateWithDuration");
    } completion:^(BOOL finished) {
        block();
    }];
}

@end
