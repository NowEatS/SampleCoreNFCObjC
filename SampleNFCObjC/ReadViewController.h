//
//  ReadViewController.h
//  SampleNFCObjC
//
//  Created by 서태원 on 2019/11/07.
//  Copyright © 2019 NOWEAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreNFC/CoreNFC.h>
@class CellData;

@interface ReadViewController : UIViewController <NFCNDEFReaderSessionDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<NFCNDEFMessage *> *detectedMessages;
@property (nonatomic, strong) NSMutableArray<CellData *> *arrayOfCellData;
@property (nonatomic, strong) NSUserDefaults *defaults;

@end
