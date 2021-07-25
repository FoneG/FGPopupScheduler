//
//  AnimationShowPopupView.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/23.
//

#import "AnimationShowPopupView.h"
#import "Uitl.h"

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
    [[Uitl findCurrentShowingViewController].view addSubview:self];
    [UIView animateWithDuration:2 animations:^{
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        NSLog(@"animateWithDuration");
    } completion:^(BOOL finished) {
        block();
    }];
}


- (void)dismissWithAnimation:(FGPopupViewAnimationBlock)block{
    [UIView animateWithDuration:2 animations:^{
        self.frame =CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
        [self removeFromSuperview];
    }];
    
}

- (void)dismissPopupViewWithAnimation:(FGPopupViewAnimationBlock)block{
    [self dismissWithAnimation:block];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissPopupViewWithAnimation:^{
        NSLog(@"dismissPopupViewWithAnimation callBlock");
    }];
}
@end
