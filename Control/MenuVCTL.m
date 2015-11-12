//
//  MenuVCTL.m
//  VR
//
//  Created by Galen on 15/9/24.
//  Copyright (c) 2015年 XW. All rights reserved.
//

#import "MenuVCTL.h"
#import "SimplePlayerViewController.h"
@interface MenuVCTL ()

@end

@implementation MenuVCTL

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)goToVRPlayer:(id)sender {
    
    SimplePlayerViewController *simVCTL = [[SimplePlayerViewController alloc]init];
    simVCTL.mp4UrlStr = @"巴厘岛短片";
    NSLog(@"%@",simVCTL);
    [self presentViewController:simVCTL animated:YES completion:nil];
}

@end
