//  The MIT License (MIT)
//
//  Copyright (c) 2013 Levi Nunnink
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//
//  Created by Levi Nunnink (@a_band) http://culturezoo.com
//  Copyright (C) Droplr Inc. All Rights Reserved
//


#import "Smooth_Line_ViewViewController.h"

#import <CoreMotion/CoreMotion.h>

@interface Smooth_Line_ViewViewController ()
@property (nonatomic) SmoothLineView * canvas;
@property (atomic) NSMutableArray *storedPath;
@property (strong, nonatomic) IBOutlet UIButton *clearAndReplay;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *clearEverything;

@end

@implementation Smooth_Line_ViewViewController

- (void)viewDidLoad
{
  SmoothLineView * smoothLineView =[[SmoothLineView alloc] initWithFrame:self.view.bounds ];
  self.canvas = smoothLineView;
  smoothLineView.tag = 3;
  [self.view addSubview:smoothLineView];
  [smoothLineView storePath:(id)self.storedPath];
  [smoothLineView clear];
    
  //[self.view addSubview:self.clearAndReplay];
  [self.view addSubview:self.clearEverything];
}

-(BOOL)canBecomeFirstResponder {
  return YES;
}

- (IBAction)clearAndReplay:(UIButton *)sender {
    //clear
    for (UIView *subView in self.view.subviews)
    {
        if (subView.tag == 3)
        {
            [subView removeFromSuperview];
        }
    }
    //replay
    [self viewDidLoad];
}
- (IBAction)clearEverything:(UIButton *)sender {
    //store a copy
    //UIView * copy =[UIView alloc];
   // [copy init].subviews = self.view.subviews;
    //clear
    for (UIView *subView in self.view.subviews)
    {
        if (subView.tag == 3)
        {
            [subView removeFromSuperview];
        }
    }
    
    
    //reload
    /*[self viewDidLoad];*/
    //Use the following to prevent recursive calls
    UIView *parent = self.view.superview;
    [self.view removeFromSuperview];
    self.view = nil; // unloads the view
    [parent addSubview:self.view]; //reloads the view from the nib
    
    
    //replay
    if (self.storedPath.firstObject)
    {
        for (SmoothLineView* trace in self.storedPath)
        {
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSLog(@"Do some work");
            });
            
            [self.view addSubview:trace];
        }
    }
    
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
  //Add stuff to store path
  [self.canvas storePath:(id)self.storedPath];
    
  //END OF added stuff
  [self.canvas clear];
}
@end


