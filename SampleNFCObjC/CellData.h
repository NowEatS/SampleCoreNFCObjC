//
//  CellData.h
//  SampleNFCObjC
//
//  Created by 서태원 on 2019/11/20.
//  Copyright © 2019 NOWEAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreNFC/CoreNFC.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellData : NSObject

@property (strong, nonatomic) NSDate *createdTime;
@property (strong, nonatomic) NFCNDEFMessage *message;

@end

NS_ASSUME_NONNULL_END
