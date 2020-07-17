//
//  WriteViewController.h
//  SampleNFCObjC
//
//  Created by 서태원 on 2019/11/15.
//  Copyright © 2019 NOWEAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreNFC/CoreNFC.h>
@class CellData;

NS_ASSUME_NONNULL_BEGIN

@interface WriteViewController : UIViewController <NFCNDEFReaderSessionDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<CellData *> *arrayOfCellData;

@end

NS_ASSUME_NONNULL_END
