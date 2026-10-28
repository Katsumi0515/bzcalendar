//
//  BzRGBSliderComponent.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/08/28.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BzRGBSliderComponent : UIView {
    UILabel* label;
    UILabel* numText;
    UISlider* slider;
}

-(void) setLabelText:(NSString*)text;
-(void) setValue:(int)value;
-(int) value;
- (void)addTarget:(id)target action:(SEL)action forSliderEvents:(UIControlEvents)controlEvents;

@end
