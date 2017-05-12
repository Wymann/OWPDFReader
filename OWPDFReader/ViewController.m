//
//  ViewController.m
//  OWPDFReader
//
//  Created by Wyman Chen on 2017/5/12.
//  Copyright © 2017年 Conpak. All rights reserved.
//

#import "ViewController.h"
#import "ReaderDocument.h"
#import "ReaderViewController.h"

#define filePath [[NSBundle mainBundle] pathForResource:@"Flask" ofType:@"pdf"]

@interface ViewController ()<ReaderViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goToPdfreaderVC:(id)sender {
    ReaderDocument *doc = [[ReaderDocument alloc] initWithFilePath:filePath password:nil];
    //[doc.bookmarks addIndex:3];这里需要同个这个方法恢复该PDF文件的书签
    ReaderViewController *rvc = [[ReaderViewController alloc] initWithReaderDocument:doc];
    rvc.delegate = self;
    [self presentViewController:rvc animated:YES completion:nil];
}

#pragma mark - ReaderViewControllerDelegate
- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
