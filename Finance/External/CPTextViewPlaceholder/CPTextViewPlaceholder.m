#import "CPTextViewPlaceholder.h"

@interface CPTextViewPlaceholder ()

@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation CPTextViewPlaceholder

CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
#else
    [_placeHolderLabel release]; _placeHolderLabel = nil;
    [_placeholderColor release]; _placeholderColor = nil;
    [_placeholder release]; _placeholder = nil;
    [super dealloc];
#endif
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    if (!self.placeholder){
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor){
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) ){
        
        self.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        if (!self.placeholder){
            [self setPlaceholder:@""];
        }

        if (!self.placeholderColor){
            [self setPlaceholderColor:[UIColor lightGrayColor]];
        }
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }

    [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION animations:^{
        if([[self text] length] == 0)
        {
            [[self viewWithTag:999] setAlpha:1];

        }
        else
        {
            [[self viewWithTag:999] setAlpha:0];
        }
    }];
    NSLog(@"contentOffset = %@",[NSValue valueWithCGPoint:self.contentOffset]);
    NSLog(@"contentInset = %@",[NSValue valueWithUIEdgeInsets:self.contentInset]);
    
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if( [[self placeholder] length] > 0 )
    {
        if (_placeHolderLabel == nil )
        {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(MarginFactor(6.0f), 8.0f ,self.bounds.size.width - 16,0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
}

@end