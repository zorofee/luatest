//
//  CanvasBgViewController.m
//  venusiosdemo
//
//  Created by zhaowanfei on 2021/6/3.
//

#import "CanvasBgViewController.h"
#import "VenusWrapper.h"

@interface CanvasBgViewController ()
{
    UIView *m_venusView;
}
@end

@implementation CanvasBgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //[self.view setBackgroundColor:UIColor.greenColor];
    
    

    [self createVenusSceneView];
    
    
    UIButton* btn0 = [self createBtn:@"AddVideo" :CGRectMake(0, 440, 80, 50)];
    UIButton* btn1 = [self createBtn:@"16:9" :CGRectMake(0, 500, 80, 50)];
    UIButton* btn2 = [self createBtn:@"4:3" :CGRectMake(90, 500, 80, 50)];
    UIButton* btn3 = [self createBtn:@"300*300" :CGRectMake(180, 500, 80, 50)];
    UIButton* btn4 = [self createBtn:@"200*300" :CGRectMake(270, 500, 80, 50)];
    
    UIButton* btn5 = [self createBtn:@"bg1" :CGRectMake(0, 560, 80, 50)];
    UIButton* btn6 = [self createBtn:@"bg2" :CGRectMake(90, 560, 80, 50)];
    UIButton* btn7 = [self createBtn:@"bgCol1" :CGRectMake(180, 560, 80, 50)];
    UIButton* btn8 = [self createBtn:@"bgCol2" :CGRectMake(270, 560, 80, 50)];

    [self.view addSubview:btn0];
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
    [self.view addSubview:btn5];
    [self.view addSubview:btn6];
    [self.view addSubview:btn7];
    [self.view addSubview:btn8];
    
    [btn0 addTarget:self action:@selector(onBtn0Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 addTarget:self action:@selector(onBtn1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(onBtn2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(onBtn3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 addTarget:self action:@selector(onBtn4Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 addTarget:self action:@selector(onBtn5Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn6 addTarget:self action:@selector(onBtn6Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn7 addTarget:self action:@selector(onBtn7Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn8 addTarget:self action:@selector(onBtn8Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)createVenusSceneView
{
    int viewRectH = self.view.bounds.size.height;
    int viewRectW = self.view.bounds.size.width;
    
    m_venusView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 200, 300)];
    [m_venusView setBackgroundColor:UIColor.greenColor];
    [self.view addSubview:m_venusView];
    [VenusWrapper attachToTest:m_venusView];
    //[VenusWrapper addVideoClip:1 :0 :20];
}

-(void)onBtn0Clicked:(id)sender
{
    [VenusWrapper addVideoClip:1 :0 :20];
}

-(void)onBtn1Clicked:(id)sender
{
    [VenusWrapper setWindowSize:320:180];
    [m_venusView setFrame:CGRectMake(0, 100, 320, 180)];
}

-(void)onBtn2Clicked:(id)sender
{
    [VenusWrapper setWindowSize:320:240];
    [m_venusView setFrame:CGRectMake(0, 100, 320, 240)];
}

-(void)onBtn3Clicked:(id)sender
{
    [VenusWrapper setWindowSize:300:300];
    [m_venusView setFrame:CGRectMake(0, 100, 300, 300)];
}

-(void)onBtn4Clicked:(id)sender
{
    [VenusWrapper setWindowSize:200:300];
    [m_venusView setFrame:CGRectMake(0, 100, 200, 300)];
}

-(void)onBtn5Clicked:(id)sender
{
    [VenusWrapper setCanvasBGImage:@"root:test.png"];
}

-(void)onBtn6Clicked:(id)sender
{
    [VenusWrapper setCanvasBGImage:@"root:test.jpeg"];
}

-(void)onBtn7Clicked:(id)sender
{
    int r= 127,g=0,b=127;
    int rgb= ((r*256) + g)*256+b;
    [VenusWrapper setCanvasBGColor:rgb];
}

-(void)onBtn8Clicked:(id)sender
{
    int r= 127,g=0,b=0;
    int rgb= ((r*256) + g)*256+b;
    [VenusWrapper setCanvasBGColor:rgb];
}


-(UIButton*)createBtn:(NSString*)title:(CGRect)frame
{
    UIButton* btn = [[UIButton alloc]initWithFrame:frame];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:UIColor.whiteColor];
   
    [self.view addSubview:btn];
    return btn;
}



@end
