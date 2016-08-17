
#import  "UIView+Additions.h"

@implementation UIView (TTCategory)

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

@end
