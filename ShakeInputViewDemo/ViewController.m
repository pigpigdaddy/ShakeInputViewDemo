//
//  ViewController.m
//  ShakeInputViewDemo
//
//  Created by pigpigdaddy on 14-10-6.
//  Copyright (c) 2014年 pigpigdaddy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)UIView *shakeView;
@property (nonatomic, strong)UIButton *button;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button setTitle:@"左右抖动" forState:UIControlStateNormal];
    self.button.frame = CGRectMake(100, 300, 100, 40);
    [self.button addTarget:self action:@selector(shakeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    self.shakeView = [[UIView alloc] initWithFrame:CGRectMake(50, 80, 220, 180)];
    self.shakeView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.shakeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)shakeAction
{
    // 晃动次数
    static int numberOfShakes = 4;
    // 晃动幅度（相对于总宽度）
    static float vigourOfShake = 0.04f;
    // 晃动延续时常（秒）
    static float durationOfShake = 0.5f;
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
//    // 方法一：绘制路径
//    CGRect frame = self.shakeView.frame;
//    // 创建路径
//    CGMutablePathRef shakePath = CGPathCreateMutable();
//    // 起始点
//    CGPathMoveToPoint(shakePath, NULL, CGRectGetMidX(frame), CGRectGetMidY(frame));
//	for (int index = 0; index < numberOfShakes; index++)
//	{
//        // 添加晃动路径 幅度由大变小
//		CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX(frame) - frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
//		CGPathAddLineToPoint(shakePath, NULL,  CGRectGetMidX(frame) + frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
//	}
//    // 闭合
//    CGPathCloseSubpath(shakePath);
//    shakeAnimation.path = shakePath;
//    shakeAnimation.duration = durationOfShake;
//    // 释放
//    CFRelease(shakePath);
    
    // 方法二：关键帧（点）
    CGPoint layerPosition = self.shakeView.layer.position;
    
    // 起始点
    NSValue *value1=[NSValue valueWithCGPoint:self.shakeView.layer.position];
    // 关键点数组
    NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:value1, nil];
    for (int i = 0; i<numberOfShakes; i++) {
        // 左右晃动的点
        NSValue *valueLeft = [NSValue valueWithCGPoint:CGPointMake(layerPosition.x-self.shakeView.frame.size.width*vigourOfShake*(1-(float)i/numberOfShakes), layerPosition.y)];
        NSValue *valueRight = [NSValue valueWithCGPoint:CGPointMake(layerPosition.x+self.shakeView.frame.size.width*vigourOfShake*(1-(float)i/numberOfShakes), layerPosition.y)];
        
        [values addObject:valueLeft];
        [values addObject:valueRight];
    }
    // 最后回归到起始点
    [values addObject:value1];
    
    shakeAnimation.values = values;
    shakeAnimation.duration = durationOfShake;

    [self.shakeView.layer addAnimation:shakeAnimation forKey:kCATransition];
}

@end
