//
//  WriteViewController.m
//  SampleNFCObjC
//
//  Created by 서태원 on 2019/11/15.
//  Copyright © 2019 NOWEAT. All rights reserved.
//

#import "WriteViewController.h"
#import "CreateTextNDEFViewController.h"
#import "CreateWebllinkNDEFViewController.h"
#import "CreatePhoneNumberNDEFViewController.h"
#import "CreatedNFCDataTableViewCell.h"
#import "CellData.h"
#import <Masonry.h>

@interface WriteViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *buttonNFCWriting;

@property (strong, nonatomic) UIBarButtonItem *buttonAddNewNFCData;
@property (strong, nonatomic) UIBarButtonItem *buttonDeleteAllNFCData;
@property (strong, nonatomic) UIBarButtonItem *buttonLockNFCTag;

@property (nonatomic, strong) NFCNDEFReaderSession *session NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong) NFCNDEFMessage *ndefMessage;

@end

@implementation WriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.arrayOfCellData = [[NSUserDefaults standardUserDefaults] objectForKey:@"CreatedMessagesCellData"];
    self.arrayOfCellData = [NSMutableArray new];
    
    [self initNavigation];
    [self initControl];
    
//    if (@available(iOS 13.0, *)) {
//    } else {
//        [self.buttonStartWriting setEnabled:false];
//        [self.textView setText:@"NFC 쓰기 기능을 사용하려면 iOS13 이상으로 업데이트해주시기 바랍니다."];
//        [self.textView setEditable:false];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.ndefMessage = nil;
    [self.buttonNFCWriting setBackgroundColor:[UIColor systemGrayColor]];
    [self.buttonNFCWriting setEnabled:NO];
    [self.tableView reloadData];
}

// MARK: - Inintialize UI Views
- (void)initNavigation {
    self.navigationItem.title = @"NFC Writing";
    // RightBarButtonItems
    self.buttonAddNewNFCData = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(openActionSheetCreateNewNDEFMessage)];

    self.buttonDeleteAllNFCData = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"trash"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(deleteAllNFCData)];
    NSArray *rightBarButtonItems = @[self.buttonAddNewNFCData, self.buttonDeleteAllNFCData];
    [self.navigationItem setRightBarButtonItems:rightBarButtonItems];
    
    // LeftBarButtonItems
    self.buttonLockNFCTag = [UIBarButtonItem new];
    [self.buttonLockNFCTag setImage:[UIImage systemImageNamed:@"lock"]];
    [self.navigationItem setLeftBarButtonItem:self.buttonLockNFCTag];
}

- (void)initControl {
    // Start Writing Button
    self.buttonNFCWriting = [UIButton new];
    [self.view addSubview:self.buttonNFCWriting];
    [self.buttonNFCWriting setEnabled:NO];
    [self.buttonNFCWriting setTitle:@"Write" forState:UIControlStateNormal];
    [self.buttonNFCWriting.titleLabel setFont:[UIFont systemFontOfSize:32 weight:UIFontWeightLight]];
    [self.buttonNFCWriting.layer setCornerRadius:10.0];
    [self.buttonNFCWriting addTarget:self action:@selector(beginWriting) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonNFCWriting setBackgroundColor:[UIColor systemGrayColor]];
    [self.buttonNFCWriting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).inset(40);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).inset(40);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).inset(16);
        make.height.mas_equalTo(48);
    }];
    
    // TableView
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView setBounces:YES];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.buttonNFCWriting.mas_top).inset(16);
    }];
}

// MARK: - Actions
- (void)beginWriting {

//    if (@available(iOS 13.0, *)) {
        if (![NFCNDEFReaderSession readingAvailable]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"NFC 스캔을 지원하지 않습니다."
                                                                                     message:@"이 기기는 NFC 태그 스캔을 지원하지 않습니다."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil]];
            [self presentViewController:alertController animated:true completion:nil];
            return;
        }
        
        self.session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:nil invalidateAfterFirstRead:false];
        [self.session setAlertMessage:@"iPhone을 NFC 태그에 가까이 대주세요."];
        [self.session beginSession];
//    } else {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"NFC 쓰기를 지원하지 않습니다."
//                                                                                 message:@"이 기기는 NFC 태그 쓰기를 지원하지 않습니다."
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
//                                                            style:UIAlertActionStyleDefault
//                                                          handler:nil]];
//        [self presentViewController:alertController animated:true completion:nil];
//        return;
//    }
}

- (void)deleteAllNFCData {
    if (self.arrayOfCellData.count > 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                                 message:@"저장한 NFC 데이터를 모두 삭제하시겠습니까?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"삭제"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
            [self.arrayOfCellData removeAllObjects];
            [self.tableView reloadData];
        }];
        [deleteAction setValue:[UIColor systemRedColor] forKey:@"titleTextColor"];
        [alertController addAction:deleteAction];
        [alertController addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)openActionSheetCreateNewNDEFMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"새로운 NFC NDEF Message 생성하기"
                                                                             message:@"생성할 NDEF Type을 선택해주세요."
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Text"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        CreateTextNDEFViewController *nextVC = [CreateTextNDEFViewController new];
        [nextVC setWriteVC:self];
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:nextVC];
        [naviController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:naviController animated:YES completion:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"WebLink"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        CreateWebllinkNDEFViewController *nextVC = [CreateWebllinkNDEFViewController new];
        [nextVC setWriteVC:self];
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:nextVC];
        [naviController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:naviController animated:YES completion:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Telephone Number"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        CreatePhoneNumberNDEFViewController *nextVC = [CreatePhoneNumberNDEFViewController new];
        [nextVC setWriteVC:self];
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:nextVC];
        [naviController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:naviController animated:YES completion:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}


// MARK: - NFCDEFReaderSessionDelegate
- (void)readerSessionDidBecomeActive:(NFCNDEFReaderSession *)session {

}

- (void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages {
    
}

- (void)readerSession:(NFCNDEFReaderSession *)session didDetectTags:(NSArray<__kindof id<NFCNDEFTag>> *)tags  API_AVAILABLE(ios(13.0)) {
    if (tags.count >1 ) {
        session.alertMessage = @"More than 1 tags found. Please present only 1 tag.";
        return;
    }
    
    // Yoou connect to the desired tag.
    id tag = tags.firstObject;
    [self.session connectToTag:tag completionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            [self.session restartPolling];
            return;
        }
        
        // You then query the NDEF status of tag.
        [tag queryNDEFStatusWithCompletionHandler:^(NFCNDEFStatus status, NSUInteger capacity, NSError * _Nullable error) {
            if (error != nil) {
                [session invalidateSessionWithErrorMessage:@"Fail to determine NDEF status. Please try again."];
                return;
            }
            
            if (status == NFCNDEFStatusReadOnly) {
                [session invalidateSessionWithErrorMessage:@"Tag is not writable."];
            } else if (status == NFCNDEFStatusReadWrite) {
                if (self.ndefMessage.length > capacity) {
                    [session invalidateSessionWithErrorMessage:[NSString stringWithFormat:@"Tag capacity is too small. Minimum size requirement is %lu bytes.", self.ndefMessage.length]];
                    return;
                }
                
                // When a tag is read-writable and has sufficient capacity,
                // write an NDEF message to in.
                [tag writeNDEF:self.ndefMessage completionHandler:^(NSError * _Nullable error) {
                    if (error != nil) {
                        [session invalidateSessionWithErrorMessage:@"Update tag failed. Please try again."];
                    } else {
                        session.alertMessage = @"Update success!";
                        [session invalidateSession];
                    }
                }];
            } else {
                [session invalidateSessionWithErrorMessage:@"Tag is not NDEF formatted."];
            }
        }];
    }];
}

- (void)readerSession:(nonnull NFCNDEFReaderSession *)session didInvalidateWithError:(nonnull NSError *)error {
    if (error.code == NFCReaderSessionInvalidationErrorUserCanceled) {
        NSLog(@"User Canceled");
        return;
    }
}


// MARK: - TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfCellData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreatedNFCDataTableViewCell *cell = [[CreatedNFCDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CreatedNFCDataCell"];
    
    if (indexPath.row != 0)
        [cell.borderLine setHidden:false];
    
    CellData *cellData = self.arrayOfCellData[indexPath.row];
    NFCNDEFMessage *message = cellData.message;
    NFCNDEFPayload *payload = message.records.firstObject;
    
    NSString *indexOfPayload = [NSString new];
    if (payload.typeNameFormat == NFCTypeNameFormatNFCWellKnown) {
        if ([payload wellKnownTypeURIPayload]) {
            indexOfPayload = [[payload wellKnownTypeURIPayload] absoluteString];
            if (([[indexOfPayload substringToIndex:4] containsString:@"http"])) {
                [cell.typeNameLabel setText:@"WebLink"];
                [cell.typeImageView setImage:[UIImage systemImageNamed:@"globe"]];
            } else if ([indexOfPayload containsString:@"tel:"]) {
                [cell.typeNameLabel setText:@"Telephone Number"];
                [cell.typeImageView setImage:[UIImage systemImageNamed:@"phone.circle"]];
                indexOfPayload = [indexOfPayload substringFromIndex:4];
            }
        } else {
            NSLocale *locale = [NSLocale currentLocale];
            indexOfPayload = [payload wellKnownTypeTextPayloadWithLocale:&locale];
        }
    }
    
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"YYYY MM dd hh:mm:ss a"];
//    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [cell.createdTimeLabel setText:[dateFormat stringFromDate:cellData.createdTime]];
    
    [cell.detailLabel setText:indexOfPayload];
    if (cell.isSelected == YES)
        [cell.checkCircle setHidden:NO];
    else
        [cell setSelected:NO];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CreatedNFCDataTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.isSelected) {
        [cell setIsSelected:NO];
        [cell.checkCircle setHidden:YES];
        self.ndefMessage = nil;
        [self.buttonNFCWriting setBackgroundColor:[UIColor systemGrayColor]];
        [self.buttonNFCWriting setEnabled:NO];
    } else {
        [cell setIsSelected:YES];
        [cell.checkCircle setHidden:NO];
        for (CreatedNFCDataTableViewCell *otherCells in tableView.visibleCells) {
            if (otherCells.isSelected == YES && otherCells != cell) {
                [otherCells setIsSelected:NO];
                [otherCells.checkCircle setHidden:YES];
            }
        }
        self.ndefMessage = self.arrayOfCellData[indexPath.row].message;
        [self.buttonNFCWriting setBackgroundColor:[UIColor systemBlueColor]];
        [self.buttonNFCWriting setEnabled:YES];
    }
    
    
}

@end
