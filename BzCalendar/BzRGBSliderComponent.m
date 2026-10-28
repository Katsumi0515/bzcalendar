//
//  BzRGBSliderComponent.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/08/28.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzRGBSliderComponent.h"
#import "BzCalendar-Swift.h"

@interface BzRGBSliderComponent()
@property(nonatomic, retain) UILabel* label;
@property(nonatomic, retain) UILabel* numText;
@property(nonatomic, retain) UISlider* slider;
@end

@implementation BzRGBSliderComponent

@synthesize label;
@synthesize numText;
@synthesize slider;

-(void) sliderChanged:(id)sender {
    LOG_METHOD;
   // UISlider* sld = (UISlider*)sender;
    LOG(@"value: %f", self.slider.value);
    self.numText.text = [NSString stringWithFormat:@"%d", (int)self.slider.value];
   // [self setNeedsLayout];
}
-(void) setLabelText:(NSString*)text {
    self.label.text = text;
    [self setNeedsLayout];
}
-(void) setValue:(int)value {
    LOG_METHOD;
    self.numText.text = [NSString stringWithFormat:@"%d", value];
    self.slider.value = value;
    [self setNeedsLayout];
}
-(int) value {
    return (int)self.slider.value;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect lblRect = frame;
        lblRect.origin.x = 5;
        lblRect.origin.y = 0;
        lblRect.size.width = 20;
        UILabel* lbl = [[UILabel alloc] initWithFrame:lblRect];
        lbl.textAlignment = NSTextAlignmentRight;
        lbl.backgroundColor = [UIColor clearColor];
        self.label = lbl;
        [self addSubview:self.label];
       
        
        CGRect textRect = frame;
        textRect.origin.x = 30;
        textRect.origin.y = 0;
        textRect.size.width = 30;
        UILabel* tmpText = [[UILabel alloc] initWithFrame:textRect];
        tmpText.text = @"0";
        tmpText.textAlignment = NSTextAlignmentRight;
        tmpText.backgroundColor = [UIColor clearColor];
        self.numText = tmpText;
        [self addSubview:self.numText];
      
        
        CGRect sliderRect = frame;
        sliderRect.origin.x = 70;
        sliderRect.origin.y = 0;
        sliderRect.size.width = 240;
        UISlider* tmpSlider = [[UISlider alloc] initWithFrame:sliderRect];
        tmpSlider.minimumValue = 0;
        tmpSlider.maximumValue = 255;
        tmpSlider.value = 0;
        self.slider = tmpSlider;
        [self addSubview:self.slider];
        
        
        [self.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)addTarget:(id)target action:(SEL)action forSliderEvents:(UIControlEvents)controlEvents {
    [self.slider addTarget:target action:action forControlEvents:controlEvents];
}
@end
