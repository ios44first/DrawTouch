//
//  ColorPicker.m
//  DrawTouch
//
//  Created by mac on 14/12/2.
//
//

#import "ColorPicker.h"

@implementation ColorPicker

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-50, self.frame.size.width, self.frame.size.height);
    }];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+50, self.frame.size.width, self.frame.size.height);
    }];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (textField.tag)
    {
        case 1:
            self.redSlider.value = [textField.text intValue]/255.0;
            break;
        case 2:
            self.greenSlider.value = [textField.text intValue]/255.0;
            break;
        case 3:
            self.blueSlider.value = [textField.text intValue]/255.0;
            break;
        default:
            break;
    }
    
    self.resultView.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1];
    
    return YES;
}

- (IBAction)colorValueChanged:(UISlider *)sender
{
    if (sender.tag == 1)
    {
        self.redInput.text = [NSString stringWithFormat:@"%d",(int)(sender.value * 255)];
    }
    else if (sender.tag ==2)
    {
        self.greenInput.text = [NSString stringWithFormat:@"%d",(int)(sender.value * 255)];
    }
    else if (sender.tag == 3)
    {
        self.blueInput.text = [NSString stringWithFormat:@"%d",(int)(sender.value * 255)];
    }
    
    self.resultView.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1];
}

- (IBAction)btnAction:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        [self.paletteDelegate changeColor:[UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1]];
    }

    [[self superview] removeFromSuperview];
}


- (void)logTouchInfo:(UITouch *)touch
{
    CGPoint locInSelf = [touch locationInView:self.pickerView];
    //CGPoint locInImage = CGPointMake(locInSelf.x-100, locInSelf.y-10);
    NSLog(@"touch.locationInView = {%2.3f, %2.3f}", locInSelf.x, locInSelf.y);
    UIColor *color = [self getPixelColorAtLocation:locInSelf];
//    UIColor *color = [self colorAtPixel:locInSelf];
    NSLog(@"color = %@", color);
    
    
    double red,green,blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    
    self.redInput.text = [NSString stringWithFormat:@"%d",(int)(red * 255)];
    self.greenInput.text = [NSString stringWithFormat:@"%d",(int)(green * 255)];
    self.blueInput.text = [NSString stringWithFormat:@"%d",(int)(blue * 255)];
    
    self.redSlider.value = red;
    self.greenSlider.value = green;
    self.blueSlider.value = blue;
    
    self.resultView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if ((point.x>=100&&point.x<=235) && (point.y>=10&&point.y<=145))
    {
        [self logTouchInfo:touch];
    }
    
    [self.redInput resignFirstResponder];
    [self.greenInput resignFirstResponder];
    [self.blueInput resignFirstResponder];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if ((point.x>=100&&point.x<=235) && (point.y>=10&&point.y<=145))
    {
        [self logTouchInfo:touch];
    }
    
    [self.redInput resignFirstResponder];
    [self.greenInput resignFirstResponder];
    [self.blueInput resignFirstResponder];
}

- (UIColor*) getPixelColorAtLocation:(CGPoint)point {
    UIColor* color = nil;
    
    self.image = [UIImage imageNamed:@"全色"];
    
    CGImageRef inImage = self.image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil;  }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
            int offset = 4*((w*round(point.y))+round(point.x));
            NSLog(@"offset: %d", offset);
            int alpha =  data[offset];
            int red = data[offset+1];
            int green = data[offset+2];
            int blue = data[offset+3];
            NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        }
        @catch (NSException * e) {
            NSLog(@"%@",[e reason]);
        }
        @finally {
        }
        
    }
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}
- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}


//获取图片某一点的颜色
/*
 作者：瞬csr
 链接：https://www.jianshu.com/p/51a0e32c8016
 來源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */
- (UIColor *)colorAtPixel:(CGPoint)point
{
    self.image = [UIImage imageNamed:@"全色"];
    
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.image.size.width, self.image.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.image.CGImage;
    NSUInteger width = self.image.size.width;
    NSUInteger height = self.image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


- (void)dealloc {
    [_resultView release];
    [_pickerView release];
    [_redInput release];
    [_greenInput release];
    [_blueInput release];
    [_redSlider release];
    [_greenSlider release];
    [_blueSlider release];
    [super dealloc];
}

@end
