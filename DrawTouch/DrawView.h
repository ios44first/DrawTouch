//
//  DrawView.h
//  DrawTouch
//
//  Created by Ibokan on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPicker.h"



@interface DrawView : UIView <PaletteDelegate>
{
    NSMutableArray *lineArray;
    int c;
    float lineWidth;
    UIColor *color;
    UIColor *tempColor;
    BOOL isChange;
    BOOL tempChange;
    BOOL isShow;
    UIView *colorPickerView;
    
    UIButton *tempBtn;
    UISegmentedControl *seg;
    
    UIButton *select;
    UIButton *black;
    UIButton *red;
    UIButton *green;
    UIButton *blue;
    UIButton *cai;
    UIButton *more;
}

@end
