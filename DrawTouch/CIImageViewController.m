//
//  CIImageViewController.m
//  DrawTouch
//
//  Created by mac on 15/6/5.
//
//

#import "CIImageViewController.h"

@interface CIImageViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIImageView *showImage;
    NSArray *items;
    UIImage *orgImage;
}
@end

@implementation CIImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    orgImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"me" ofType:@"jpg"]];
    
    showImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, ScreenWidth-40, ScreenHeight/3.0*2.0)];
    showImage.image = orgImage;
    showImage.contentMode = UIViewContentModeScaleAspectFill;
    showImage.layer.masksToBounds = YES;
    showImage.userInteractionEnabled = YES;
    [self.view addSubview:showImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    [showImage addGestureRecognizer:tap];
    
    UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(20, showImage.frame.size.height+20+20, ScreenWidth-40, 100)];
    pick.delegate = self;
    pick.dataSource = self;
    [self.view addSubview:pick];

    items = [[NSArray alloc] initWithObjects:@"Original",@"CILinearToSRGBToneCurve",@"CIPhotoEffectChrome",@"CIPhotoEffectFade",@"CIPhotoEffectInstant",@"CIPhotoEffectMono",@"CIPhotoEffectNoir",@"CIPhotoEffectProcess",@"CIPhotoEffectTonal",@"CIPhotoEffectTransfer",@"CISRGBToneCurveToLinear",@"CISepiaTone",@"CIVignetteEffect", nil];
    
    NSArray *properties = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSLog(@"count=%d\n%@", properties.count, properties);
    for (NSString *filterName in properties) {
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        NSLog(@"%@", [fltr attributes]);
    }
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:orgImage];
    CIFilter *fileter = [CIFilter filterWithName:items[row] keysAndValues:kCIInputImageKey,ciImage, nil];
    [fileter setDefaults];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outImage = [fileter outputImage];
    CGImageRef cgimage = [context createCGImage:outImage fromRect:[outImage extent]];
    
    showImage.image = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return items.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return items[row];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
