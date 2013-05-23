// From cscade on iphonedevbook.com forums
// And Bjorn Sallarp on blog.sallarp.com

@interface UIImage (Extras)

- (UIImage *) imageByScalingAndCroppingForSize: (CGSize)targetSize;
- (UIImage *) scaleImage: (CGSize)newSize;

@end
