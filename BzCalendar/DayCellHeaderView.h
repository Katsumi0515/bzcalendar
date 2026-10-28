//
//  DayCellHeaderView.h
//  GSystemT0
//
//  Created by 小林 活水 on 11/02/11.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayCellHeaderView : UIView {

}
- (void) setTextColor:(UIColor *)color;
- (void) setDayString:(NSString *)str;
- (void) setOptionString:(NSString *)str;
- (void) setHeadarFont:(UIFont*) headerFont;

@end
