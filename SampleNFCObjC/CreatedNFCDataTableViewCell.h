//
//  CreatedNFCDataTableViewCell.h
//  SampleNFCObjC
//
//  Created by 서태원 on 2019/11/19.
//  Copyright © 2019 NOWEAT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreatedNFCDataTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *typeImageView;
@property (strong, nonatomic) UILabel *typeNameLabel;
@property (strong, nonatomic) UILabel *createdTimeLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIView *borderLine;
@property (strong, nonatomic) UIImageView *checkCircle;

@property BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
