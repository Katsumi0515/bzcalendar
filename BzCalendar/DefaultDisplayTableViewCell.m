//
//  DefaultDisplayTableViewCell.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/01/31.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "DefaultDisplayTableViewCell.h"


@implementation DefaultDisplayTableViewCell

@synthesize displayMode;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


@end
