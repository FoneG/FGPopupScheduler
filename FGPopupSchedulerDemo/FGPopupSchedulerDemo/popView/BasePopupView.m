//
//  BasePopView.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/23.
//

#import "BasePopupView.h"

@implementation BasePopupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithDescrption:(NSString *)des scheduler:(nonnull FGPopupScheduler *)scheduler
{
    self = [super initWithFrame:CGRectMake(0, 0, 200, 300)];
    if (self) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
        self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2].CGColor;
        self.layer.shadowRadius = 4;
        self.layer.shadowOpacity = 1;
        self.layer.shadowOffset = CGSizeMake(0,1);
        self.layer.cornerRadius = 4;
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.text = des;
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        _scheduler = scheduler;
    }
    return self;
}

- (void)showPopupView{
    NSLog(@"%s", __func__);
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismissPopupView{
    NSLog(@"%s", __func__);
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchCallBack) {
        self.touchCallBack();
    }else{
        [self dismissPopupView];
    }
}

@end
