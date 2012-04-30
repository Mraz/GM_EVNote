//
//  CustomCell.m
//  EvernoteSample
//
//  Created by Moon Jiyoun on 12. 3. 14..
//  Copyright (c) 2012년 Greenmonster, Inc. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize backView, nameLabel, createLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        backView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib
{
    nameLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    
    createLabel.font = [UIFont systemFontOfSize:12.0f];
    createLabel.textColor = [UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    // Highlighted - 빨간색
    // Normal - 투명
//    [backView setBackgroundColor:highlighted ? [UIColor blueColor] : [UIColor clearColor]];
}

@end
