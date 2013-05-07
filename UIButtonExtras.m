#import "UIButtonExtras.h"
#import <objc/runtime.h>

@implementation UIButton(Property)

static char UIB_PROPERTY_KEY;

@dynamic cColor;


-(void)setCColor:(NSObject *)property
{
  objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSObject*)cColor
{
  return (NSObject*)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}


@end
