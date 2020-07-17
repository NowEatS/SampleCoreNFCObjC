//
//  DetectedNFCDataTableViewCell.h
//  SampleNFCObjC
//
//  Created by 서태원 on 2019/11/18.
//  Copyright © 2019 NOWEAT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetectedNFCDataTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *savedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *borderLine;

@end

NS_ASSUME_NONNULL_END
