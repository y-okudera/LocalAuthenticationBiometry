//
//  ViewController.m
//  LocalAuthenticationBiometry
//
//  Created by Yuki Okudera on 2019/11/08.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

#import "ViewController.h"
#import "Biometry.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *authResultLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)tappedAuthButton:(UIButton *)sender {
    [Biometry auth:^(BOOL success,  NSError * _Nullable error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.authResultLabel.text = @"認証完了";
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self checkLAError:error];
            });
        }
    }];
}

- (void)checkLAError:(NSError *)error {
    
    NSLog(@"ERROR:%@", error);
    
    switch (error.code) {
        case LAErrorAuthenticationFailed:
            NSLog(@"生体認証失敗");
            NSLog(@"Authentication was not successful, because user failed to provide valid credentials.");
            [self showErrorAlert:@"生体認証に失敗しました。\nログイン画面で、ID・パスワードを入力してログインしてください。"];
            self.authResultLabel.text = @"認証失敗";
            return;
        case LAErrorUserCancel:
            NSLog(@"「キャンセルボタン」をタップ");
            NSLog(@"Authentication was canceled by user (e.g. tapped Cancel button).");
            return;
        case LAErrorUserFallback:
            NSLog(@"「パスワードを入力」ボタンをタップ");
            NSLog(@"Authentication was canceled, because the user tapped the fallback button (Enter Password).");
            [self showErrorAlert:@"デバイスのパスコード入力では、アプリにログインできません。\nログイン画面で、ID・パスワードを入力してログインしてください。"];
            self.authResultLabel.text = @"認証失敗";
            return;
        case LAErrorSystemCancel:
            NSLog(@"Authentication was canceled by system (e.g. another application went to foreground).");
            return;
        case LAErrorPasscodeNotSet:
            NSLog(@"生体情報は登録されているが、デバイスのパスコードがOFFになっている");
            NSLog(@"Authentication could not start, because passcode is not set on the device.");
            [self showErrorAlert:@"デバイスのパスコードがOFFになっているため、生体認証でログインできません。"];
            self.authResultLabel.text = @"認証失敗";
            return;
        case LAErrorAppCancel:
            NSLog(@"Authentication was canceled by application (e.g. invalidate was called while authentication was in progress).");
            return;
        case LAErrorInvalidContext:
            NSLog(@"LAContext passed to this call has been previously invalidated.");
            [self showErrorAlert:@"生体情報が既に無効になっています。再度お試しください。"];
            self.authResultLabel.text = @"認証失敗";
            return;
        case LAErrorBiometryNotAvailable:
            NSLog(@"Authentication could not start, because biometry is not available on the device.");
            [self showErrorAlert:@"お使いのデバイスは生体認証でログインできません。"];
            self.authResultLabel.text = @"認証失敗";
            return;
        case LAErrorBiometryNotEnrolled:
            NSLog(@"生体情報が登録されていない");
            NSLog(@"Authentication could not start, because biometry has no enrolled identities.");
            [self showErrorAlert:@"生体情報が登録されていません。\n設定アプリから生体情報を登録してください。"];
            self.authResultLabel.text = @"認証失敗";
            return;
        case LAErrorBiometryLockout:
            NSLog(@"生体認証をたくさん失敗したため、ロックアウト中");
            NSLog(@"Authentication was not successful, because there were too many failed biometry attempts and biometry is now locked. Passcode is required to unlock biometry, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite.");
            [self showErrorAlert:@"失敗した生体認証の試行が多すぎて生体認証がロックされました。\n生体認証のロックを解除するには、パスコードが必要です。"];
            self.authResultLabel.text = @"認証失敗";
            return;
        case LAErrorNotInteractive:
            NSLog(@"Authentication failed, because it would require showing UI which has been forbidden by using interactionNotAllowed property.");
            [self showErrorAlert:@"認証処理中はバックグラウンドへ移動しないでください。"];
            self.authResultLabel.text = @"認証失敗";
            return;
            
        default:
            break;
    }
}

- (void)showErrorAlert:(NSString *)message {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"エラー" message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}
@end
