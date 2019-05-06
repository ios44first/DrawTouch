//
//  ColorPicker.h
//  DrawTouch
//
//  Created by mac on 14/12/2.
//
//

#import <UIKit/UIKit.h>

@protocol PaletteDelegate
- (void)changeColor:(UIColor *)_color;
@end

@interface ColorPicker : UIView <UITextFieldDelegate>

@property(strong,nonatomic)UIImage *image;
@property (strong, nonatomic) id<PaletteDelegate> paletteDelegate;
- (void)logTouchInfo:(UITouch *)touch;

@property (retain, nonatomic) IBOutlet UIView *resultView;

@property (retain, nonatomic) IBOutlet UIImageView *pickerView;

@property (retain, nonatomic) IBOutlet UITextField *redInput;
@property (retain, nonatomic) IBOutlet UITextField *greenInput;
@property (retain, nonatomic) IBOutlet UITextField *blueInput;

@property (retain, nonatomic) IBOutlet UISlider *redSlider;
@property (retain, nonatomic) IBOutlet UISlider *greenSlider;
@property (retain, nonatomic) IBOutlet UISlider *blueSlider;


- (IBAction)colorValueChanged:(UISlider *)sender;
- (IBAction)btnAction:(UIButton *)sender;


@end
