//
//  ViewController.m
//  VDText
//
//  Created by Harwyn T'an on 2019/12/13.
//  Copyright © 2019 vvard3n. All rights reserved.
//

#import "ViewController.h"
#import "VDText/VDText.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VDTextEditor *textEditor = [[VDTextEditor alloc] initWithFrame:CGRectMake(20, 200, 300, 300)];
    [self.view addSubview:textEditor];
    
    
    VDTextView *textView = [[VDTextView alloc] initWithFrame:CGRectMake(20, 600, 300, 300)];
    [self.view addSubview:textView];
}


@end
