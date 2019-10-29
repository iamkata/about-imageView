//
//  ImageScaleInAlbumVC.m
//  ImagePressClass
//
//  Created by EOC on 2017/4/16.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ImageCompressInAlbumVC.h"

@interface ImageCompressInAlbumVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImage *_albumImage;
}

@end

@implementation ImageCompressInAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"压缩相册图片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(openAlbum:)];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    /*
     转化成bitmap  
     */
    [super viewDidAppear:animated];
    _albumImage = [UIImage imageNamed:@"3.jpg"];
    _jpgImageV.image =  _albumImage;

    _albumImage = [self scaleImage:[UIImage imageNamed:@"3.jpg"] size:_pngImageV.frame.size];

    return;
    
    if (_albumImage) {
        [self imageDataLoad];
    }
    
}

//PNG/JPG图片压缩
- (void)imageDataLoad{
    // png  文件属性格式并不会压缩，压缩的是图片内容（像素）
    NSData* pngImageData =  UIImagePNGRepresentation(_albumImage);
    NSData *jpgImageData =  UIImageJPEGRepresentation(_albumImage, 0.1);
    
    _pngImageV.image = [UIImage imageWithData:pngImageData];
    _jpgImageV.image = [UIImage imageWithData:jpgImageData];
    // jpg
    
    NSLog(@"png::%@", [self length:pngImageData.length]);
    NSLog(@"jpg::%@", [self length:jpgImageData.length]);
    
}

//这种压缩方式, 内存占用和图片大小都变小了
// bitmap
- (UIImage*)scaleImage:(UIImage*)image size:(CGSize)imageSize{
    
    UIGraphicsBeginImageContext(imageSize);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

- (NSString*)length:(NSInteger)length{
    
    if (length > 1024 * 1024) {
        
        int mb = length/(1024*1024);
        int kb = (length%(1024*1024))/1024;
        return [NSString stringWithFormat:@"%dMb%dKB",mb, kb];
    }else{
        
        return [NSString stringWithFormat:@"%dKB",length/1024];
    }
    
}

// 保存图片数据到本地
- (void)saveImageToLocal:(NSString*)fileName fromData:(NSData*)data{
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    if ([data writeToFile:filePath atomically:YES]) {
        NSLog(@"sucess");
    }
}



- (IBAction)openAlbum:(id)sender{
    
    UIImagePickerController *imagePickerContr = [[UIImagePickerController alloc] init];
    imagePickerContr.delegate = self;
    imagePickerContr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerContr animated:YES completion:nil];
    
}

#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    NSLog(@"%s", __func__);
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%s", __func__);
    
    _albumImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    NSLog(@"%s", __func__);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
