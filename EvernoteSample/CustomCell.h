//
//  CustomCell.h
//  EvernoteSample
//
//  Created by Moon Jiyoun on 12. 3. 14..
//  Copyright (c) 2012년 Greenmonster, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
{
    IBOutlet UIView *backView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *createLabel;
}

@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *createLabel;

@end
