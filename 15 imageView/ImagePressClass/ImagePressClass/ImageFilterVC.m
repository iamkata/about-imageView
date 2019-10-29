//
//  ImageFilterVC.m
//  ImagePressClass
//
//  Created by EOC on 2017/4/16.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ImageFilterVC.h"
#import <CoreFoundation/CoreFoundation.h>
/*
 */
@interface ImageFilterVC ()

@property (nonatomic, strong)UIImage *image;

@end

@implementation ImageFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片处理";
   
    UIBarButtonItem *origImageBt = [[UIBarButtonItem alloc] initWithTitle:@"还原" style:UIBarButtonItemStylePlain target:self action:@selector(originalImage)];
    UIBarButtonItem *filterImageBt = [[UIBarButtonItem alloc] initWithTitle:@"过滤" style:UIBarButtonItemStylePlain target:self action:@selector(filterImage)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:origImageBt, filterImageBt, nil];
    self.image =  [UIImage imageNamed:@"3.jpg"];
    _filterImageV.image = self.image;
}

- (void)originalImage{ 
    
    _filterImageV.image = self.image;
}

/*
 从图片文件把 图片数据的像素拿出来(RGBA), 对像素进行操作， 进行一个转换（Bitmap （GPU））
 修改完之后，还原（图片的属性 RGBA,RGBA (宽度，高度，色值空间，拿到宽度和高度，每一个画多少个像素，画多少行)）
 //256(11111111)
 */

- (void)filterImage{
    
    CGImageRef imageRef = self.image.CGImage;
    // 1 个字节 = 8bit  每行有 17152 每行有17152*8 位
    size_t width   = CGImageGetWidth(imageRef);
    size_t height  = CGImageGetHeight(imageRef);
    size_t bits    = CGImageGetBitsPerComponent(imageRef); // 8位
    size_t bitsPerrow = CGImageGetBytesPerRow(imageRef); // 就是width * bits
    
    // 颜色空间
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    // AlphaInfo: RGBA  AGBR  RGB
    CGImageAlphaInfo alpInfo =  CGImageGetAlphaInfo(imageRef); //  AlphaInfo 信息
    
    //// Demo
    [self demoDataC];
    
    // bitmap的数据
    CGDataProviderRef providerRef = CGImageGetDataProvider(imageRef);
    CFDataRef bitmapData = CGDataProviderCopyData(providerRef);
    
    NSInteger pixLength = CFDataGetLength(bitmapData);
    // 像素的byte数组
    Byte *pixbuf = CFDataGetMutableBytePtr((CFMutableDataRef)bitmapData);

    // 一个RGBA为一个单元
    for (NSInteger i = 0; i < pixLength; i+=4) {
    
        [self eocImageFiletPixBuf:pixbuf offset:i];
    }
    
    // 准备绘制图片了
    // bitmap 生成一个上下文  再通过上下文生成图片
    CGContextRef contextR = CGBitmapContextCreate(pixbuf, width, height, bits, bitsPerrow, colorSpace, alpInfo);
    
    CGImageRef filterImageRef = CGBitmapContextCreateImage(contextR);
    
    UIImage *filterImage =  [UIImage imageWithCGImage:filterImageRef];
    
    _filterImageV.image = filterImage;
}

- (void)demoDataC{
    
      //NSString *testStr = ;//@"RGBARGBA" ;//@"255255255255"
    NSData *data = [@"1234567890" dataUsingEncoding:NSUTF8StringEncoding];// 1234567890
    NSInteger testLength = data.length;
    Byte *testC = (Byte*)[data bytes]; // 字符数组 testC = "0123456789"

    for (NSInteger i = 0; i < testLength; i++) {
        Byte testChar = (Byte)testC[i]; //  当i=0 testChar=1
        testChar = testChar + 1;
        testC[i] = testChar;
    }

    for (NSInteger i = 0; i < testLength; i++) {
        Byte testChar = (Byte)testC[i]; //  当i=0 testChar=1
        printf("%c", testChar);
    }
}

// RGBA 为一个单元  彩色照变黑白照
- (void)eocImageFiletPixBuf:(Byte*)pixBuf offset:(int)offset{
    
    int offsetR = offset;
    int offsetG = offset + 1;
    int offsetB = offset + 2;
    int offsetA = offset + 3;
    
    int red = pixBuf[offsetR];
    int gre = pixBuf[offsetG];
    int blu = pixBuf[offsetB];
   // int alp = pixBuf[offsetA];
    
    int gray = (red + gre + blu)/3;
    
    pixBuf[offsetR] = gray;
    pixBuf[offsetG] = gray;
    pixBuf[offsetB] = gray;
}

@end
