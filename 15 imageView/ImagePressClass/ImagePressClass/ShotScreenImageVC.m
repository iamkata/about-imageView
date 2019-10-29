//
//  ShotScreenImageVC.m
//  ImagePressClass
//
//  Created by EOC on 2017/4/16.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ShotScreenImageVC.h"
#import <QuartzCore/QuartzCore.h>
/*
 */
@interface ShotScreenImageVC ()

@end

@implementation ShotScreenImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollerView.contentSize = CGSizeMake(700, 700);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"截图" style:UIBarButtonItemStylePlain target:self action:@selector(imageFromFullView)];
}


- (void)imageFromFullView{
    
    //[self shotScreen:nil];
    //[self shotScreenMain];
    //[self noRectClip];
    [self Blend];
}

//截屏
- (void)shotScreenMain {
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.view.layer renderInContext:context];
    
    CGImageRef imageRef =  CGBitmapContextCreateImage(context);
    
    
    _eocImageV.image = [UIImage imageWithCGImage:imageRef];
    
    
    UIGraphicsEndImageContext();
}


// 规则 截图圆形
- (void)shotScreen:(id)sender{
    
    UIImage *image = [UIImage imageNamed:@"3.jpg"];
    
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //先clip
    CGRect rect = CGRectMake(0, 0, 200, 200);
    CGContextAddEllipseInRect(context, rect); // 画了一个路径path
    CGContextClip(context);
    //根据上面的路径, 再draw
    [image drawInRect:CGRectMake(0, 0, 200, 200)];
    
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    _eocImageV.image = clipImage;
    
}

// 非规则的截图
- (void)noRectClip{
    
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 非规则的path
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPoint lines[] = {
        CGPointMake(0, 0),
        CGPointMake(150, 70),
        CGPointMake(200, 200),
        CGPointMake(50, 120),
        CGPointMake(30, 30)
    };
    CGPathAddLines(pathRef, NULL, lines, 5);
    CGContextAddPath(context, pathRef);
    CGContextClip(context);
    //////////
    
    UIImage *imageTwo = [UIImage imageNamed:@"3.jpg"];
    [imageTwo drawInRect:CGRectMake(0, 0, 200, 200)];
    
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    _eocImageV.image = clipImage;
    
}

// 红色渲染
- (void)Blend{
    
    UIImage *imageTwo = [UIImage imageNamed:@"3.jpg"];
    
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [imageTwo drawInRect:CGRectMake(0, 0, 200, 200)];
    
    UIColor *redColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    
    CGContextSetFillColorWithColor(context, redColor.CGColor);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextFillRect(context, CGRectMake(0, 0, 200, 200));
    
    CGImageRef imageRef =  CGBitmapContextCreateImage(context);
    
    
    _eocImageV.image = [UIImage imageWithCGImage:imageRef];
    
    
    UIGraphicsEndImageContext();
}

@end
