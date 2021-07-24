//
//  ConditionsPopView.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/23.
//

#import "ConditionsPopView.h"
#import "UIView+Category.h"
#import "Uitl.h"

@implementation ConditionsPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)canRegisterFirstPopupViewResponder{
    BOOL touch = [[Uitl findCurrentShowingViewController] isKindOfClass:NSClassFromString(@"BlueViewController")];
    return touch;
}

- (FGPopupViewUntriggeredBehavior)popupViewUntriggeredBehavior{
    return self.UntriggeredBehavior;
}

@end
