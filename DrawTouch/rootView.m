//
//  rootView.m
//  DrawTouch
//
//  Created by Ibokan on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "rootView.h"
#import "CIImageViewController.h"


@implementation RootView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    DrawView *draw=[[DrawView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    //draw.backgroundColor=[UIColor whiteColor];
    //DrawViewTest *draw=[[DrawViewTest alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    draw.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:draw];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLJimage) name:@"showLJimage" object:nil];
    
}

- (void)showLJimage
{
    CIImageViewController *ci =[CIImageViewController new];
    [self presentViewController:ci animated:YES completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
