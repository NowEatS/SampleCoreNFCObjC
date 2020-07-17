//
//  DetailViewController.m
//  SampleNFCObjC
//
//  Created by 서태원 on 2019/11/19.
//  Copyright © 2019 NOWEAT. All rights reserved.
//

#import "DetailViewController.h"
#import <Masonry/Masonry.h>

@interface DetailViewController ()
@property (nonatomic, strong) UITextView *textView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {

    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    
    self.textView = [[UITextView alloc] init];
    [self.view addSubview:self.textView];
    NFCNDEFPayload *payload = self.message.records.firstObject;
    
    NSString *indexOfPayload = [NSString new];
    if (payload.typeNameFormat == NFCTypeNameFormatNFCWellKnown) {
        if ([payload wellKnownTypeURIPayload]) {
            indexOfPayload = [[payload wellKnownTypeURIPayload] absoluteString];
            if ([indexOfPayload containsString:@"tel:"]) {
                indexOfPayload = [indexOfPayload substringFromIndex:4];
            }
        } else {
            NSLocale *locale = [NSLocale currentLocale];
            indexOfPayload = [payload wellKnownTypeTextPayloadWithLocale:&locale];
        }
    }
    
    self.textView.text = indexOfPayload;
    [self.textView setEditable:NO];
    [self.textView setFont:[UIFont systemFontOfSize:16]];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).inset(32);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).inset(16);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).inset(16);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
    NSLog(@"%@",self.message.records.firstObject);
}
@end
