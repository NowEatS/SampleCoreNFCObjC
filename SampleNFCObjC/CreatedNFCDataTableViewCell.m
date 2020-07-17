//
//  CreatedNFCDataTableViewCell.m
//  SampleNFCObjC
//
//  Created by 서태원 on 2019/11/19.
//  Copyright © 2019 NOWEAT. All rights reserved.
//

#import "CreatedNFCDataTableViewCell.h"
#import <Masonry.h>

@implementation CreatedNFCDataTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        /*
         BorderLine
         */
        self.borderLine = [UIView new];
        [self.borderLine setBackgroundColor:[UIColor systemBlueColor]];
        [self addSubview:self.borderLine];
        [self.borderLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.leading.equalTo(self.mas_leading).inset(16);
            make.trailing.equalTo(self.mas_trailing).inset(16);
            make.height.mas_equalTo(1);
        }];
        [self.borderLine setHidden:true];
        
        /*
         Type ImageView
         */
        self.typeImageView = [UIImageView new];
        [self.typeImageView setImage:[UIImage systemImageNamed:@"text.bubble"]];
        [self addSubview:self.typeImageView];
        [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).inset(16);
            make.leading.equalTo(self.mas_leading).inset(16);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(40);
        }];
        
        /*
         Stack View ( TypeNameLabel, CreatedTimeLabel )
         */
        UIStackView *stackView = [UIStackView new];
        [stackView setAxis:UILayoutConstraintAxisVertical];
        [stackView setAlignment:UIStackViewAlignmentFill];
        [stackView setDistribution:UIStackViewDistributionFill];
        [self addSubview:stackView];
        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).inset(16);
            make.leading.equalTo(self.typeImageView.mas_trailing).inset(16);
        }];
        
        self.typeNameLabel = [UILabel new];
        [self.typeNameLabel setText:@"Text"];
        [self.typeNameLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [stackView addSubview:self.typeNameLabel];
        [self.typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(stackView.mas_top);
            make.leading.equalTo(stackView.mas_leading);
            make.trailing.equalTo(stackView.mas_trailing);
        }];
        
        self.createdTimeLabel = [UILabel new];
        [self.createdTimeLabel setText:@"2020 01 01 00:00:00 AM"];
        [self.createdTimeLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightLight]];
        [stackView addSubview:self.createdTimeLabel];
        [self.createdTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.typeNameLabel.mas_bottom);
            make.leading.equalTo(stackView.mas_leading);
            make.trailing.equalTo(stackView.mas_trailing);
            make.bottom.equalTo(stackView.mas_bottom);
            make.height.mas_equalTo(16);
        }];
        
        /*
         Detail Label
         */
        self.detailLabel = [UILabel new];
        [self.detailLabel setText:@"내용내용"];
        [self.detailLabel setFont:[UIFont systemFontOfSize:17]];
        [self addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.typeImageView.mas_bottom).inset(8);
            make.top.equalTo(stackView.mas_bottom).inset(8);
            make.leading.equalTo(self.mas_leading).inset(16);
            make.trailing.equalTo(self.mas_trailing).inset(16);
            make.bottom.equalTo(self.mas_bottom).inset(8);
        }];
        
        /*
         CheckCircle
         */
        self.checkCircle = [UIImageView new];
        [self.checkCircle setImage:[UIImage systemImageNamed:@"checkmark.circle"]];
        [self.checkCircle.image imageWithTintColor:[UIColor systemGreenColor]];
        [self addSubview:self.checkCircle];
        [self.checkCircle setHidden:YES];
        [self.checkCircle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.typeImageView.mas_centerY);
            make.leading.equalTo(stackView.mas_trailing).inset(16);
            make.trailing.equalTo(self.mas_trailing).inset(8);
            make.width.mas_equalTo(32);
            make.height.mas_equalTo(32);
        }];
    }
    
    return self;
}

@end
