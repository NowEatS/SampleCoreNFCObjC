//
//  DetailViewController.h
//  SampleNFCObjC
//
//  Created by 서태원 on 2019/11/19.
//  Copyright © 2019 NOWEAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreNFC/CoreNFC.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NFCNDEFMessage *message;

@end

NS_ASSUME_NONNULL_END
