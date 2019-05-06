//
//  DrawView.m
//  DrawTouch
//
//  Created by Ibokan on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DrawView.h"



@implementation DrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        lineArray=[[NSMutableArray alloc] init];
        color = [UIColor blackColor];
        tempColor = color;
        lineWidth = 3.0;
        isShow = NO;
        //float btnWidth = (ScreenWidth-20*4)/3;
        
//画笔开关
        seg = [[UISegmentedControl alloc] initWithItems:@[@"画笔",@"橡皮"]];
        seg.frame = CGRectMake(ScreenWidth - 220, ScreenHeight-40, 90, 30);
        seg.selectedSegmentIndex = 0;
        [seg addTarget:self action:@selector(changeToDraw:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:seg];
        
        
        UIButton *buttonLvJing=[UIButton buttonWithType:UIButtonTypeCustom];
        buttonLvJing.frame=CGRectMake(10, ScreenHeight-40, 50, 30);
        [buttonLvJing setTitle:@"滤镜" forState:UIControlStateNormal];
        buttonLvJing.titleLabel.font = [UIFont systemFontOfSize:14];
        [buttonLvJing addTarget:self action:@selector(showLJimage) forControlEvents:UIControlEventTouchUpInside];
        [buttonLvJing setBackgroundColor:[UIColor colorWithRed:0.0 green:122/255.0 blue:255/255.0 alpha:1]];
        buttonLvJing.layer.cornerRadius = 5;
        [self addSubview:buttonLvJing];

//撤销 清除
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(ScreenWidth - 120, ScreenHeight-40, 50, 30);
        [button setTitle:@"撤销" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(unDoStep) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor colorWithRed:0.0 green:122/255.0 blue:255/255.0 alpha:1]];
        button.layer.cornerRadius = 5;
        [self addSubview:button];
        
        UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame=CGRectMake(ScreenWidth-60, ScreenHeight-40, 50, 30);
        [button1 setTitle:@"清除" forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:14];
        [button1 addTarget:self action:@selector(unDoAll) forControlEvents:UIControlEventTouchUpInside];
        [button1 setBackgroundColor:[UIColor colorWithRed:0.0 green:122/255.0 blue:255/255.0 alpha:1]];
        button1.layer.cornerRadius = 5;
        [self addSubview:button1];

//选择颜色
        black=[UIButton buttonWithType:UIButtonTypeCustom];
        black.frame=CGRectMake(5,50, 40, 40);
        //[black setTitle:@"黑" forState:UIControlStateNormal];
        [black addTarget:self action:@selector(changeBlack) forControlEvents:UIControlEventTouchUpInside];
        [black setBackgroundColor:[UIColor blackColor]];
        black.layer.cornerRadius = 20;
        [self addSubview:black];
        
        red=[UIButton buttonWithType:UIButtonTypeCustom];
        red.frame=CGRectMake(5, 50, 40, 40);
        //[red setTitle:@"红" forState:UIControlStateNormal];
        [red addTarget:self action:@selector(changeRed) forControlEvents:UIControlEventTouchUpInside];
        [red setBackgroundColor:[UIColor redColor]];
        red.layer.cornerRadius = 20;
        [self addSubview:red];
        
        green=[UIButton buttonWithType:UIButtonTypeCustom];
        green.frame=CGRectMake(5, 50, 40, 40);
        //[green setTitle:@"绿" forState:UIControlStateNormal];
        [green addTarget:self action:@selector(changeGreen) forControlEvents:UIControlEventTouchUpInside];
        [green setBackgroundColor:[UIColor greenColor]];
        green.layer.cornerRadius = 20;
        [self addSubview:green];
        
        blue=[UIButton buttonWithType:UIButtonTypeCustom];
        blue.frame=CGRectMake(5, 50, 40, 40);
        //[blue setTitle:@"蓝" forState:UIControlStateNormal];
        [blue addTarget:self action:@selector(changeBlue) forControlEvents:UIControlEventTouchUpInside];
        [blue setBackgroundColor:[UIColor blueColor]];
        blue.layer.cornerRadius = 20;
        [self addSubview:blue];
        
        cai=[UIButton buttonWithType:UIButtonTypeCustom];
        cai.frame=CGRectMake(5, 50, 40, 40);
        //[cai setTitle:@"彩色" forState:UIControlStateNormal];
        [cai addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
        [cai setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"colors"]]];
        cai.layer.cornerRadius = 20;
        [self addSubview:cai];
        
        more=[UIButton buttonWithType:UIButtonTypeCustom];
        more.frame=CGRectMake(5, 50, 40, 40);
//        [more setTitle:@"" forState:UIControlStateNormal];
        [more addTarget:self action:@selector(showSelect) forControlEvents:UIControlEventTouchUpInside];
        [more setBackgroundColor:[UIColor grayColor]];
        [more setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        more.layer.cornerRadius = 20;
        [self addSubview:more];
        
        select=[UIButton buttonWithType:UIButtonTypeCustom];
        select.frame=CGRectMake(5,50, 40, 40);
        //[select setTitle:@"选择" forState:UIControlStateNormal];
        [select addTarget:self action:@selector(showBtns) forControlEvents:UIControlEventTouchUpInside];
        [select setBackgroundColor:color];
        [select setBackgroundImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
        [select setBackgroundImage:[UIImage imageNamed:@"pen"] forState:UIControlStateHighlighted];
        select.layer.cornerRadius = 20;
        [self addSubview:select];
    }
    return self;
}

- (void)showLJimage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showLJimage" object:nil];
}

- (void)showBtns
{
    isShow = YES;
    [UIView animateWithDuration:0.3 animations:^{
        black.frame=CGRectMake(5,100+5, 40, 40);
        red.frame=CGRectMake(5, 150+5, 40, 40);
        green.frame=CGRectMake(5, 200+5, 40, 40);
        blue.frame=CGRectMake(5, 250+5, 40, 40);
        cai.frame=CGRectMake(5, 300+5, 40, 40);
        more.frame=CGRectMake(5, 350+5, 40, 40);
    } completion:^(BOOL finished)
     {
        [UIView animateWithDuration:0.2 animations:^{
            black.frame=CGRectMake(5,100, 40, 40);
            red.frame=CGRectMake(5, 150, 40, 40);
            green.frame=CGRectMake(5, 200, 40, 40);
            blue.frame=CGRectMake(5, 250, 40, 40);
            cai.frame=CGRectMake(5, 300, 40, 40);
            more.frame=CGRectMake(5, 350, 40, 40);
        }];
    }];
}

- (void)hideBtns
{
    isShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        black.frame=CGRectMake(5,100+5, 40, 40);
        red.frame=CGRectMake(5, 150+5, 40, 40);
        green.frame=CGRectMake(5, 200+5, 40, 40);
        blue.frame=CGRectMake(5, 250+5, 40, 40);
        cai.frame=CGRectMake(5, 300+5, 40, 40);
        more.frame=CGRectMake(5, 350+5, 40, 40);
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.3 animations:^{
             black.frame=CGRectMake(5, 50, 40, 40);
             red.frame=CGRectMake(5, 50, 40, 40);
             green.frame=CGRectMake(5, 50, 40, 40);
             blue.frame=CGRectMake(5, 50, 40, 40);
             cai.frame=CGRectMake(5, 50, 40, 40);
             more.frame=CGRectMake(5, 50, 40, 40);
         }];
     }];
}

- (void)baseAction
{
    if (isShow)
    {
        [self hideBtns];
    }
    lineWidth = 3.0;
    isChange=NO;
    seg.selectedSegmentIndex = 0;
}

- (void)showSelect
{
    [self baseAction];
    
    colorPickerView = [[UIView alloc] initWithFrame:self.bounds];
    colorPickerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIControl *con = [[UIControl alloc] initWithFrame:colorPickerView.bounds];
    [con addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    [colorPickerView addSubview:con];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ColorPicker"owner:nil options:nil];
    ColorPicker *detailView = [nib objectAtIndex:0];
    detailView.paletteDelegate = self;
    detailView.frame = CGRectMake(50, 50, 250, 330);
    detailView.center = colorPickerView.center;
    detailView.layer.cornerRadius = 10;
    [colorPickerView addSubview:detailView];
    [self addSubview:colorPickerView];

}

-(void)changeColor:(UIColor *)_color
{
    [self baseAction];
    color = [_color copy];
    tempColor = color;
    [select setBackgroundColor:color];
}

- (void)hideSelf
{
    [colorPickerView removeFromSuperview];
}

- (void)changeToDraw:(UISegmentedControl *)sender
{
    if (isShow)
    {
        [self hideBtns];
    }
    
    if (sender.selectedSegmentIndex)
    {
        tempChange = isChange;
        isChange=NO;
        tempColor = color;
        color = [UIColor whiteColor];
       lineWidth = 18.0;
    }
    else
    {
        isChange=tempChange;
         color = tempColor;
        lineWidth = 3.0;
    }
}

-(void)changeBlack
{
    [self baseAction];
    color=[UIColor blackColor];
    [select setBackgroundColor:color];
   /* [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    // UIView setAnimationDidStopSelector:@selector(<#selector#>)
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
 forView:self cache:YES];
    self.backgroundColor=[UIColor blueColor];
    [UIView commitAnimations];*/
}
-(void)changeRed
{
    [self baseAction];
    color=[UIColor redColor];
    [select setBackgroundColor:color];
}
-(void)changeGreen
{
    [self baseAction];
    color=[UIColor greenColor];
    [select setBackgroundColor:color];
}
-(void)changeBlue
{
    [self baseAction];
    color=[UIColor blueColor];
    [select setBackgroundColor:color];
}
-(void)changeColor
{
    [self baseAction];
    if (isChange)
    {
        isChange=NO;
    }
    else
    {
        isChange=YES;
    }
    [select setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"colors"]]];
}
-(void)unDoStep
{
    if (isShow)
    {
        [self hideBtns];
    }
    [lineArray removeLastObject];
    [self setNeedsDisplay];
}
-(void)unDoAll
{
    if (isShow)
    {
        [self hideBtns];
    }
    [lineArray removeAllObjects];
    [self setNeedsDisplay];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isShow)
    {
        [self hideBtns];
    }
    NSMutableArray *pointArray=[[NSMutableArray alloc] init];
    if (isChange) 
    {
        UIColor *colorCai;
        switch (c%8)
        {
            case 0:
                colorCai=[UIColor redColor];
                break;
            case 1:
                colorCai=[UIColor orangeColor];
                break;
            case 2:
                colorCai=[UIColor yellowColor];
                break;
            case 3:
                colorCai=[UIColor greenColor];
                break;
            case 4:
                colorCai=[UIColor cyanColor];
                break;
            case 5:
                colorCai=[UIColor blueColor];
                break;
            case 6:
                colorCai=[UIColor purpleColor];
                break;
            case 7:
                colorCai=[UIColor blackColor];
                break;
        }
        c++;
        [pointArray addObject:colorCai];
    }
    else
        [pointArray addObject:color];
    
    [pointArray addObject:@(lineWidth)];
    [lineArray addObject:pointArray];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    NSValue *v=[NSValue valueWithCGPoint:point];
    NSMutableArray *pointArray=[lineArray lastObject];
    [pointArray addObject:v];
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    for (int i=0; i<[lineArray count]; i++)
    {
        NSMutableArray *pointArray=[lineArray objectAtIndex:i];
        
        UIColor *color1=[pointArray objectAtIndex:0];
        CGContextSetStrokeColorWithColor(context, color1.CGColor);
        CGContextSetShouldAntialias(context, YES);
        CGContextSetLineWidth(context, [[pointArray objectAtIndex:1] floatValue]);
        
            for (int j=2; j<[pointArray count]-2; j++)
            {
                NSValue *a=[pointArray objectAtIndex:j];
                CGPoint pointA=[a CGPointValue];
                NSValue *b=[pointArray objectAtIndex:j+1];
                CGPoint pointB=[b CGPointValue];
                CGContextMoveToPoint(context, pointA.x, pointA.y);
                CGContextAddLineToPoint(context, pointB.x, pointB.y);
                CGContextStrokePath(context);
            }
        
    }
}


@end
