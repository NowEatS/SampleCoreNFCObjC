//
//  CreatePhoneNumberNDEFViewController.m
//  SampleNFCObjC
//
//  Created by 서태원 on 2019/11/24.
//  Copyright © 2019 NOWEAT. All rights reserved.
//

#import "CreatePhoneNumberNDEFViewController.h"
#import "WriteViewController.h"
#import "CellData.h"
#import <Masonry.h>

@interface CreatePhoneNumberNDEFViewController ()

@property (nonatomic, strong) NFCNDEFMessage *message;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation CreatePhoneNumberNDEFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.message = [NFCNDEFMessage new];
    
    [self initNavigation];
    [self initViews];
    [self.textView becomeFirstResponder];
}

// MARK: - Initialize UI
- (void)initNavigation {
    [self.view setBackgroundColor:[UIColor secondarySystemBackgroundColor]];
    
    self.navigationItem.title = @"Phone Number";
    UIBarButtonItem *buttonSave = [[UIBarButtonItem alloc] initWithTitle:@"저장"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(saveCellData)];
    [self.navigationItem setRightBarButtonItem:buttonSave];
}

- (void)initViews {
    self.textView = [UITextView new];
    [self.textView setText:@""];
    [self.textView setKeyboardType:UIKeyboardTypePhonePad];
    [self.textView.layer setCornerRadius:10];
    [self.textView setFont:[UIFont systemFontOfSize:16]];
    [self.textView setScrollEnabled:NO];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).inset(16);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).inset(16);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).inset(16);
        make.height.mas_equalTo(32);
    }];
}

// MARK: - Actions
- (void)saveCellData {
    NSString *indexOfPayload = [NSString stringWithFormat:@"tel:%@", [self.textView text]];
    NSURL *url = [NSURL URLWithString:indexOfPayload];
    NFCNDEFPayload *payload = [NFCNDEFPayload wellKnownTypeURIPayloadWithURL:url];
    
    if (payload) {
        self.message = [[NFCNDEFMessage alloc] initWithNDEFRecords:@[payload]];
    } else {
        NSLog(@"Payload 생성 실패");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    CellData *cellData = [CellData new];
    [cellData setCreatedTime:[NSDate date]];
    [cellData setMessage:self.message];
    [self.writeVC.arrayOfCellData addObject:cellData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
