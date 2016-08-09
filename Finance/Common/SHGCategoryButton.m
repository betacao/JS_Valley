//
//  SHGCategoryButton.m
//  Finance
//
//  Created by changxicao on 16/4/11.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCategoryButton.h"

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

@implementation SHGCategoryButton


@end


@interface SHGHorizontalTitleImageView()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;

@end

@implementation SHGHorizontalTitleImageView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.label = [[UILabel alloc] init];
        self.label.textColor = kMainActionColor;
        self.label.font = kMainActionFont;
        [self sd_addSubviews:@[self.imageView, self.label]];

        self.imageView.sd_layout
        .leftSpaceToView(self, 0.0f)
        .centerYEqualToView(self)
        .widthIs(0.0f)
        .heightIs(0.0f);

        self.label.sd_layout
        .leftSpaceToView(self.imageView, 0.0f)
        .centerYEqualToView(self)
        .heightIs(ceilf(self.label.font.lineHeight));
        [self.label setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];

        [self setupAutoWidthWithRightView:self.label rightMargin:0.0f];
        [self setupAutoHeightWithBottomViewsArray:@[self.imageView, self.label] bottomMargin:0.0f];
    }
    return self;
}

- (void)addImage:(UIImage *)image
{
    self.imageView.image = image;
    self.imageView.sd_resetLayout
    .leftSpaceToView(self, 0.0f)
    .centerYEqualToView(self)
    .widthIs(image.size.width)
    .heightIs(image.size.height);
}

- (void)addTitle:(NSString *)title
{
    self.label.text = title;
    self.label.sd_resetLayout
    .leftSpaceToView(self.imageView, self.margin)
    .centerYEqualToView(self)
    .heightIs(ceilf(self.label.font.lineHeight));
}

- (void)addTitleWithDictionary:(NSDictionary *)dictionary
{
    NSString *text = [dictionary objectForKey:@"text"];
    UIFont *font = [dictionary objectForKey:NSFontAttributeName];
    UIColor *color = [dictionary objectForKey:NSForegroundColorAttributeName];

    self.label.text = text;
    self.label.font = font;
    self.label.textColor = color;

    self.label.sd_resetLayout
    .leftSpaceToView(self.imageView, self.margin)
    .centerYEqualToView(self)
    .heightIs(ceilf(self.label.font.lineHeight));
}

- (void)setMargin:(CGFloat)margin
{
    _margin = margin;
    self.label.sd_resetLayout
    .leftSpaceToView(self.imageView, self.margin)
    .centerYEqualToView(self)
    .heightIs(ceilf(self.label.font.lineHeight));
}

- (void)target:(id)target addSeletor:(SEL)selector
{
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        [self removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:(selector)];
    [self addGestureRecognizer:recognizer];
}

- (void)setEnlargeEdge:(CGFloat) size
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}

@end