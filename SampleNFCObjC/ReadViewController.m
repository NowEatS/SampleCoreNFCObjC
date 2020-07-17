//
//  ReadViewController.m
//  SampleNFCObjC
//
//  Created by 서태원 on 2019/11/07.
//  Copyright © 2019 NOWEAT. All rights reserved.
//

#import "ReadViewController.h"
#import "DetectedNFCDataTableViewCell.h"
#import "DetailViewController.h"
#import "CellData.h"

@interface ReadViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonStartScanning;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NFCNDEFReaderSession *session NS_AVAILABLE_IOS(11.0);
@property NFCNDEFMessage *ndefMessage;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayOfCellData = [NSMutableArray new];
//    self.defaults = [NSUserDefaults standardUserDefaults];
//    if (![self.defaults objectForKey:@"DetectedMessagesCellData"])
//        [self.defaults setObject:self.arrayOfCellData forKey:@"DetectedMessagesCellData"];
//    NSArray *defaultArray = [self.defaults objectForKey:@"DetectedMessagesCellData"];
//    [self.arrayOfCellData addObjectsFromArray:defaultArray];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [self.tapGestureRecognizer addTarget:self action:@selector(hideKeyboard)];
}

// MARK: - Actions
- (IBAction)beginScanning:(id)sender {
    // NFC 사용 가능 기기인지 판별.
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
}

- (IBAction)deleteAllReadData:(id)sender {
    if (self.arrayOfCellData.count > 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                                 message:@"저장한 NFC 데이터를 모두 삭제하시겠습니까?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"삭제"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
            [self.detectedMessages removeAllObjects];
            [self.arrayOfCellData removeAllObjects];
            [self.tableView reloadData];
        }];
        [deleteAction setValue:[UIColor systemRedColor] forKey:@"titleTextColor"];
        [alertController addAction:deleteAction];
        [alertController addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

// MARK: - NFCNDEFReaderSessionDelegate
- (void)readerSessionDidBecomeActive:(NFCNDEFReaderSession *)session {

}

- (void)readerSession:(nonnull NFCNDEFReaderSession *)session didDetectNDEFs:(nonnull NSArray<NFCNDEFMessage *> *)messages {
    NSLog(@"Count of Message : %lu", (messages.count));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (messages.count == 1 ) {
            CellData *cellData = [CellData new];
            [cellData setMessage:messages[0]];
            [cellData setCreatedTime:[NSDate date]];
            [self.arrayOfCellData addObject:cellData];
            NFCNDEFMessage *message = messages[0];
            for (NFCNDEFPayload *payload in [message records]) {
                NSLog(@"%@", [payload wellKnownTypeURIPayload]);
            }
//            NSArray *array = [NSArray arrayWithArray:self.arrayOfCellData];
//            [self.defaults setObject:array forKey:@"DetectedMessagesCellData"];
//            [self.defaults synchronize];
        }
//        NSLog(@"%@", self.detectedMessages);
        
        [self.tableView reloadData];
    });
    
    [session invalidateSession];
//    for (NFCNDEFMessage *message in messages) {
//        for (NFCNDEFPayload *payload in message.records) {
//            NSLog(@"Payload: %@", payload);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.logView.text = [NSString stringWithFormat:
//                                     @"[Identifier]: %@(%@)\n"
//                                     @"[Type]: %@(%@)\n"
//                                     @"[Format]: %d\n"
//                                     @"[Payload]: %@(%@)\n",
//                                     payload.identifier, [[NSString alloc] initWithData:payload.identifier encoding:NSASCIIStringEncoding],
//                                     payload.type, [[NSString alloc] initWithData:payload.type encoding:NSASCIIStringEncoding],
//                                     payload.typeNameFormat,
//                                     payload.payload, [[NSString alloc] initWithData:payload.payload encoding:NSASCIIStringEncoding]
//                                     ];
//                NSLog(@"Payload = %@", [[NSString alloc] initWithData:payload.payload encoding:NSASCIIStringEncoding]);
//            });
//        }
//    }
}

- (void)readerSession:(nonnull NFCNDEFReaderSession *)session didInvalidateWithError:(nonnull NSError *)error {
    if (error.code == NFCReaderSessionInvalidationErrorUserCanceled) {
        NSLog(@"User Canceled");
        return;
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//    });
}

// MARK: - Private Method
//- (void)hideKeyboard {
//    [self.logView resignFirstResponder];
//}

// MARK: - TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfCellData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetectedNFCDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetectedNFCDataCell" forIndexPath:indexPath];
    
    if (indexPath.row != 0)
        [cell.borderLine setHidden:false];
    
    CellData *cellData = self.arrayOfCellData[indexPath.row];
    NFCNDEFMessage *message = cellData.message;
    NFCNDEFPayload *payload = message.records.firstObject;
    
    NSString *indexOfPayload = [NSString new];
    if (payload.typeNameFormat == NFCTypeNameFormatNFCWellKnown) {
        if ([payload wellKnownTypeURIPayload]) {
            indexOfPayload = [[payload wellKnownTypeURIPayload] absoluteString];
            if ([[indexOfPayload substringToIndex:4] containsString:@"http"]) {
                [cell.typeNameLabel setText:@"WebLink"];
                [cell.typeImage setImage:[UIImage systemImageNamed:@"globe"]];
            } else if ([indexOfPayload containsString:@"tel"]) {
                [cell.typeNameLabel setText:@"Telephone Number"];
                [cell.typeImage setImage:[UIImage systemImageNamed:@"phone.circle"]];
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
    [cell.savedDateLabel setText:[dateFormat stringFromDate:cellData.createdTime]];
    
    [cell.detailLabel setText:indexOfPayload];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailVC = [DetailViewController new];
    detailVC.message = self.arrayOfCellData[indexPath.row].message;
    
    DetectedNFCDataTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [detailVC.navigationItem setTitle:cell.typeNameLabel.text];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}

@end
