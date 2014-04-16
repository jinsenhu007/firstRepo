//
//  PhotoBrowserVC.m
//  huabo
//
//  Created by admin on 14-4-16.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "PhotoBrowserVC.h"
#import "SDWebImageManager.h"
#import "JsDevice.h"
#import "UIViewExt.h"
#import "WeiboModel.h"

@interface PhotoBrowserVC ()

@end

@implementation PhotoBrowserVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*_arrSource.count, self.scrollView.height);
    self.pageControl.numberOfPages = _arrSource.count;
    self.pageControl.currentPage = _currIndex;
    self.scrollView.contentOffset = CGPointMake(_currIndex*kScreenWidth, 0);
    
    
        UIImageView *iView = [[UIImageView alloc]initWithFrame:CGRectZero];
   // NSLog(@"%f %f %f %f",_scrollView.left,_scrollView.top,_scrollView.width,_scrollView.height);
        AttachmentInfo *att = [_arrSource objectAtIndex:_currIndex];
    NSLog(@"0--- %@",att.ImageBigPath);
    
        SDWebImageManager *mange = [SDWebImageManager sharedManager];
    
 
    
    [mange downloadWithURL:[NSURL URLWithString:att.ImageBigPath] options:SDWebImageLowPriority|SDWebImageProgressiveDownload
                  progress:^(NSUInteger receivedSize, long long expectedSize) {
                      //NSLog(@"receiveSize %d expectedSize %d",receivedSize,expectedSize);
                  }
                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                     // iView.image = [PhotoBrowserVC imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(kScreenWidth,kScreenHeight-60-88)];
                     
                     //iView.image = [PhotoBrowserVC imageWithImage:image scaledToSize:CGSizeMake(kScreenWidth,kScreenHeight-60-88)];
                     iView.image = image;
                     iView.frame = CGRectMake(_currIndex*kScreenWidth, 0,kScreenWidth, kScreenWidth-60-88);
                     iView.center = self.view.center;
                     iView.contentMode = UIViewContentModeScaleAspectFill;
                     NSLog(@"%f %f ",iView.width,iView.height);
                     iView.backgroundColor = [UIColor yellowColor];
                     
                     
                 }];
    
        [self.scrollView addSubview:iView];
    
}


- (IBAction)pageControlClicked:(UIPageControl *)sender {
    
}

- (UIImage *)rescaleImageToSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
   // [self drawInRect:rect];  // scales image to rect
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
    
}



+ (UIImage*)imageWithImage :( UIImage*)sourceImage scaledToSize :(CGSize)newSize;
{
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp ||sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, M_PI_2);
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation ==UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, -M_PI_2);
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown){
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth,targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

+ (UIImage*)imageWithImage :( UIImage*)sourceImage scaledToSizeWithSameAspectRatio :( CGSize)targetSize;
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp ||sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, M_PI_2);
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation ==UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, -M_PI_2);
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown){
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x,thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}
@end
