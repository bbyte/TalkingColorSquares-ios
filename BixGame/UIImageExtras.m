#import "UIImageExtras.h"

@implementation UIImage (Extras)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
	UIImage *sourceImage = self;
	UIImage *newImage = nil;        
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
	{
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor > heightFactor) 
			scaleFactor = widthFactor; // scale to fit height
		else
			scaleFactor = heightFactor; // scale to fit width
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
		}
		else 
			if (widthFactor < heightFactor)
			{
				thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
	}       
	
	// UIGraphicsBeginImageContext(targetSize); // this will crop
    UIGraphicsBeginImageContextWithOptions(targetSize, 1.0f, 0.0f);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil) 
		NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}

- (UIImage *) scaleImage: (CGSize)newSize
{
  UIImage *image = self;
  CGSize scaledSize = newSize;
  float scaleFactor = 1.0;
  if( image.size.width > image.size.height ) {
    scaleFactor = image.size.width / image.size.height;
    scaledSize.width = newSize.width;
    scaledSize.height = newSize.height / scaleFactor;
  }
  else {
    scaleFactor = image.size.height / image.size.width;
    scaledSize.height = newSize.height;
    scaledSize.width = newSize.width / scaleFactor;
  }
  
  UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
  CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
  [image drawInRect:scaledImageRect];
  UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return scaledImage;
}

@end
