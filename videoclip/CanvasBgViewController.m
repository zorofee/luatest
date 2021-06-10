//
//  CanvasBgViewController.m
//  venusiosdemo
//
//  Created by zhaowanfei on 2021/6/3.
//

#import "CanvasBgViewController.h"
#import "VenusWrapper.h"
#import "UIViewFactory.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface CanvasBgViewController ()
{
    UIView *m_venusView;
    
    UIImagePickerController* videoPicker;
    UIImagePickerController* imgPicker;
}
@end

@implementation CanvasBgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createVenusSceneView];
    
    UIButton* btn0 = [self createBtn:@"AddVideo" :CGRectMake(0, 440, 80, 50)];
    UIButton* btn0_1 = [self createBtn:@"AddImg" :CGRectMake(90, 440, 80, 50)];
    UIButton* btn1 = [self createBtn:@"16:9" :CGRectMake(0, 500, 80, 50)];
    UIButton* btn2 = [self createBtn:@"4:3" :CGRectMake(90, 500, 80, 50)];
    UIButton* btn3 = [self createBtn:@"300*300" :CGRectMake(180, 500, 80, 50)];
    UIButton* btn4 = [self createBtn:@"200*300" :CGRectMake(270, 500, 80, 50)];
    
    UIButton* btn5 = [self createBtn:@"bg1" :CGRectMake(0, 560, 80, 50)];
    UIButton* btn6 = [self createBtn:@"bg2" :CGRectMake(90, 560, 80, 50)];
    UIButton* btn7 = [self createBtn:@"bgCol1" :CGRectMake(180, 560, 80, 50)];
    UIButton* btn8 = [self createBtn:@"bgCol2" :CGRectMake(270, 560, 80, 50)];


    [btn0 addTarget:self action:@selector(onBtn0Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn0_1 addTarget:self action:@selector(onBtn0_1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 addTarget:self action:@selector(onBtn1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(onBtn2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(onBtn3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 addTarget:self action:@selector(onBtn4Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 addTarget:self action:@selector(onBtn5Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn6 addTarget:self action:@selector(onBtn6Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn7 addTarget:self action:@selector(onBtn7Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn8 addTarget:self action:@selector(onBtn8Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    videoPicker.delegate = self;
    videoPicker.mediaTypes = @[@"public.movie"];
    
    
    imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.delegate = self;

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString* mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString*)kUTTypeMovie])
    {
        NSURL *URL = info[UIImagePickerControllerMediaURL];
        NSLog(URL.absoluteString);

        if(picker == videoPicker)
        {
            //添加一个video
            int duration = [self getVideoDuration:URL];
            [VenusWrapper addVideoClip:0:0:duration:1280:720:URL.absoluteString];
        }
    }
    else
    {
        if (picker == imgPicker)
        {
            NSURL *URL = info[UIImagePickerControllerImageURL];
            NSLog(URL.absoluteString);
            //以该图片插入一段videoclip
            [VenusWrapper addVideoClip:0:0:20:1280:720:URL.absoluteString];
            
            /*
            UIImage *image = info[UIImagePickerControllerOriginalImage];
            // 设置图片View
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(50, 50, 400, 400);
            imageView.backgroundColor = UIColor.redColor;
            
            NSData *data = [NSData dataWithContentsOfURL:URL];   //根据路径获取image
            UIImage * printerImg = [UIImage imageWithData:data];
            
            // 加载图片
            imageView.image = printerImg;     //info[UIImagePickerControllerOriginalImage]; //直接拿到image
            [self.view addSubview:imageView];

            //设置背景图片
            [VenusWrapper setCanvasBGImage:URL.absoluteString];
             */

        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}





-(void)createVenusSceneView
{
    int viewRectH = self.view.bounds.size.height;
    int viewRectW = self.view.bounds.size.width;
    
    m_venusView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, viewRectH, viewRectW)];
    [m_venusView setBackgroundColor:UIColor.greenColor];
    [self.view addSubview:m_venusView];
    [VenusWrapper attachToTest:m_venusView];
   
}

-(void)onBtn0Clicked:(id)sender
{
    [self presentViewController:videoPicker animated:YES completion:nil];
}

-(void)onBtn0_1Clicked:(id)sender
{
    [self presentViewController:imgPicker animated:YES completion:nil];
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
    uint8_t r=0,g=127,b=127;
    int rgb= ((r*256) + g)*256+b;
    [VenusWrapper setCanvasBGColor:rgb];
}

-(void)onBtn8Clicked:(id)sender
{
    uint8_t r=127,g=0,b=0;
    int rgb= ((r*256) + g)*256+b;
    [VenusWrapper setCanvasBGColor:rgb];
}


-(UIButton*)createBtn:(NSString*)title :(CGRect)frame
{
    UIButton* btn = [UIViewFactory createBtn:title :frame];
    [self.view addSubview:btn];
    return btn;
}




- (int)getVideoDuration:(NSURL*)url
{

    //NSURL *url = [NSURL fileURLWithPath:filePath];
    AVAsset *videoAsset = (AVAsset *)[AVAsset assetWithURL:url];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    int duration = (int)(CMTimeGetSeconds(videoAssetTrack.timeRange.duration)*1000);
    NSLog(@"getVideoDuration：%f,%d",CMTimeGetSeconds(videoAssetTrack.timeRange.duration),duration);
    //NSLog(@"getVideoDuration:%@ ,  %@",filePath,url.absoluteString);
    return duration;
}


@end



