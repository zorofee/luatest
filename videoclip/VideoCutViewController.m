//
//  ViewController.m
//  IosUIDemo
//
//  Created by zhaowanfei on 2021/5/28.
//

#import "VideoCutViewController.h"
#import "VenusWrapper.h"
#import "UIViewFactory.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define TEST_DURATION 100
#define TEST_MAX_PTS 1000

struct FClipInfo {
    int clipId;
    int trackId;
    int startTs;
    int duration;
    int endTs;
    int width;
    int height;
};
typedef struct FClipInfo ClipInfo;

@interface VideoCutViewController ()
{

    UIView *m_venusView;
    

    //controller view
    UIView* m_posCtl;
    UIImageView* m_rotScaleCtl;
    
    
    //main operation view
    UIButton *m_layer1Add;
    UIButton *m_layer2Add;

    UISlider *seekPtsSlider;
    UILabel *seekPtsSliderText;

    UIStackView* layerContainer01;
    UIStackView* layerContainer02;
    
    
    //sub operation view
    UISlider* splitSlider;
    UILabel* splitValueText;
    UISlider* speedSlider;
    UILabel* speedValueText;
    UISlider* cropSlider;
    UILabel* cropValueText;

    UIView* subOperationMenu;
    UILabel* selectClipIdText;


    NSMutableDictionary* m_clipBtnMap;
    NSMutableDictionary* m_clipInfoMap;
    
    //当前激活显示的clip
    int activeClipId;
    //当前选择的轨道id
    int selectedTrackId;


    CGFloat viewRectW;
    CGFloat viewRectH;
    
    UIImagePickerController* videoPicker;

}
@end

@implementation VideoCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    activeClipId = -1;

    viewRectH = self.view.bounds.size.height;
    viewRectW = self.view.bounds.size.width;
    
    m_clipBtnMap = [NSMutableDictionary dictionaryWithCapacity:0];
    m_clipInfoMap = [NSMutableDictionary dictionaryWithCapacity:0];
    

    [self createVenusSceneView];
    [self createClipControler];
    [self createMainOperation];
    [self createSubOperation];
    [self createLayerContainer];
    [self createAlbumPicker];
}



-(void)createVenusSceneView
{
    m_venusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewRectH, viewRectH)];
    [m_venusView setBackgroundColor:UIColor.brownColor];
    [self.view addSubview:m_venusView];
    [VenusWrapper attachToTest:m_venusView];
}



-(void)createMainOperation
{
    CGFloat startPosX = 0;
    CGFloat startPosY = viewRectH - 200;//550;
    CGFloat btnWidth = 60, btnHeight = 40;

    //UISlider
    seekPtsSlider = [UIViewFactory createSlider:0 :TEST_MAX_PTS];//[[UISlider alloc]init];
    seekPtsSlider.frame = CGRectMake(startPosX, startPosY, viewRectW, 40);
    seekPtsSlider.value=TEST_MAX_PTS / 2;
    [seekPtsSlider addTarget:self action:@selector(onProgress) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seekPtsSlider];


    startPosY += 25;
    seekPtsSliderText = [UIViewFactory createLabel:[NSString stringWithFormat:@"pts:%d",(int)TEST_MAX_PTS/2]];
    seekPtsSliderText.frame = CGRectMake(viewRectW/2,startPosY, 80, 40);
    [self.view addSubview:seekPtsSliderText];


    //layer button
    startPosY += 60;
    m_layer1Add = [UIViewFactory createButtonWithTitle:@"轨1 +"];
    [m_layer1Add setFrame:CGRectMake(startPosX, startPosY, btnWidth, btnHeight)];
    [m_layer1Add setBackgroundColor:UIColor.darkGrayColor];
    [self.view addSubview:m_layer1Add];
    

    startPosY += 50;
    m_layer2Add = [UIViewFactory createButtonWithTitle:@"轨2 +"];
    [m_layer2Add setFrame:CGRectMake(startPosX, startPosY, btnWidth, btnHeight)];
    [m_layer2Add setBackgroundColor:UIColor.darkGrayColor];
    [self.view addSubview:m_layer2Add];
    

    //click event
    [m_layer1Add addTarget:self action:@selector(onLayer1AddClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_layer2Add addTarget:self action:@selector(onLayer2AddClick:) forControlEvents:UIControlEventTouchUpInside];

}

/**
 **********************************************************************************************************************
 **                                                       Drag , Rotate ,Scale By Touch                                                          *
 **********************************************************************************************************************
 */
-(void)createClipControler
{
    float posX = viewRectW/2 - 100;
    float posY = viewRectH/2 - 160;
    m_posCtl = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, 200, 320)];
    //[m_posCtl setImage:[UIImage imageNamed:@"test.jpeg"]];
    m_posCtl.backgroundColor = [UIColor greenColor];
    m_posCtl.alpha = 0.1;
    m_posCtl.contentMode = UIViewContentModeScaleAspectFit;
    m_posCtl.userInteractionEnabled = true;
    [self.view addSubview:m_posCtl];
    UIPanGestureRecognizer *dragGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onDrag:)];
    [m_posCtl addGestureRecognizer:dragGes];
    
    
    m_rotScaleCtl = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    m_rotScaleCtl.center = [m_posCtl convertPoint:CGPointMake(200, 0) toView:m_rotScaleCtl];
    m_rotScaleCtl.image = [UIImage imageNamed:@"rotate.jpeg"];
    m_rotScaleCtl.userInteractionEnabled = YES;
    [self.view addSubview:m_rotScaleCtl];
    UIPanGestureRecognizer *rotScaleGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onScaleAndRotate:)];
     [m_rotScaleCtl addGestureRecognizer:rotScaleGes];
}

-(void)onDrag:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:self.view];
    CGPoint center = gesture.view.center;
    center.x += translation.x ;
    center.y += translation.y ;
    gesture.view.center = center;
    [gesture setTranslation:CGPointZero inView:self.view];
    
    UIView* iv =  gesture.view;
    m_rotScaleCtl.center = [iv convertPoint:CGPointMake(200, 0) toView:self.view];
    

    float width = self.view.bounds.size.width;
    float height = self.view.bounds.size.height;

    float offsetX = translation.x/width;
    float offsetY = -translation.y/height;
    
    
    [VenusWrapper setClipTransform:activeClipId :0 :1 :offsetX :offsetY];

}

-(void)onScaleAndRotate:(UIPanGestureRecognizer*)gesture
{
    UIView *viewCtrl = m_rotScaleCtl;
    UIView *viewImg = m_posCtl;
    
    CGPoint center = viewImg.center;
    CGPoint prePoint = viewCtrl.center;
    CGPoint translation = [gesture translationInView:gesture.view];
    CGPoint curPoint = CGPointMake(prePoint.x+translation.x, prePoint.y+translation.y);
    
    
    // 计算缩放
    CGFloat preDistance = [self getDistance:prePoint withPointB:center];
    CGFloat curDistance = [self getDistance:curPoint withPointB:center];
    CGFloat scale = curDistance / preDistance;
    
    // 计算弧度
    CGFloat preRadius = [self getRadius:center withPointB:prePoint];
    CGFloat curRadius = [self getRadius:center withPointB:curPoint];
    CGFloat radius = curRadius - preRadius;
    radius = - radius;
    
    CGAffineTransform transform = CGAffineTransformScale(viewImg.transform, scale, scale);
    viewImg.transform = CGAffineTransformRotate(transform, radius);
    viewCtrl.center = [viewImg convertPoint:CGPointMake(200, 0) toView:self.view];
    
    [gesture setTranslation:CGPointZero inView:viewCtrl];
    
    
    [VenusWrapper setClipTransform:activeClipId :radius :scale :0 :0];
    
}


-(CGFloat)getDistance:(CGPoint)pointA withPointB:(CGPoint)pointB
{
    CGFloat x = pointA.x - pointB.x;
    CGFloat y = pointA.y - pointB.y;
    
    return sqrt(x*x + y*y);
}

-(CGFloat)getRadius:(CGPoint)pointA withPointB:(CGPoint)pointB
{
    CGFloat x = pointA.x - pointB.x;
    CGFloat y = pointA.y - pointB.y;
    return atan2(x, y);
}






/**
 **********************************************************************************************************************
 **                                                      Change Slider Progress To Seek                                                       *
 **********************************************************************************************************************
 */
- (void) onProgress{
    [self seekPts];
    //关闭面板
    [subOperationMenu setHidden:true];
}



- (void) seekPts{
    int pts = (int)seekPtsSlider.value;
    seekPtsSliderText.text = [NSString stringWithFormat:@"pts:%d",pts];
    [VenusWrapper seekTo:pts];
    [self findActiveClip:pts];
}


- (void) findActiveClip:(int)pts{
    
    activeClipId = -1;
    for(id key in m_clipInfoMap)
    {
        NSValue* value = [m_clipInfoMap objectForKey:key];
        ClipInfo info;
        [value getValue:&info];
        NSLog(@"findActiveClip:%@={startTs=%d,endTs=%d}",key,info.startTs,info.endTs);
        if(info.startTs<=pts && info.endTs>=pts)
        {
            UIButton* btn = [m_clipBtnMap objectForKey:key];
            btn.backgroundColor = UIColor.blackColor;
            activeClipId = info.clipId;
        }
        else
        {
            UIButton* btn = [m_clipBtnMap objectForKey:key];
            btn.backgroundColor = UIColor.lightGrayColor;
        }
    }
}



/**
 **********************************************************************************************************************
 **                                                             Layer Clip Button  Container                                                       *
 **********************************************************************************************************************
 */
- (void) createLayerContainer
{
    CGFloat y1 = m_layer1Add.center.y - m_layer1Add.bounds.size.height/2;
    CGFloat y2 = m_layer2Add.center.y - m_layer2Add.bounds.size.height/2;
    CGFloat x1 = m_layer1Add.center.x + m_layer1Add.bounds.size.width/2 + 5;
    CGFloat x2 = m_layer2Add.center.x + m_layer2Add.bounds.size.width/2 + 5;
    CGPoint containerSize = CGPointMake(350, 40);
    
    layerContainer01 = [UIViewFactory createStackView:CGRectMake(x1, y1, containerSize.x, containerSize.y):UILayoutConstraintAxisHorizontal];
    layerContainer02 = [UIViewFactory createStackView:CGRectMake(x2, y2, containerSize.x, containerSize.y):UILayoutConstraintAxisHorizontal];
    
    [self.view addSubview:layerContainer01];
    [self.view addSubview:layerContainer02];
}


- (void) insertLayerClipBtn:(UIStackView*)layer :(UIButton*)btn
{
    [layer addArrangedSubview:btn];
    if(layer.frame.size.width <= 350)
    {
        layer.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y, layer.arrangedSubviews.count * 50,layer.frame.size.height);
    }

}

- (void) deleteLayerClipBtn:(UIStackView*)layer :(UIButton*)btn
{
    [btn setHidden:true];
    [layer removeArrangedSubview:btn];

    layer.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y, layer.arrangedSubviews.count * 50,layer.frame.size.height);
}


//layer1 上添加clip
- (void) onLayer1AddClick:(id)sender{

    selectedTrackId = 1;
    //[self onAddVideoClip:trackID];
    [self presentViewController:videoPicker animated:YES completion:nil];
}

//layer2 上添加clip
- (void) onLayer2AddClick:(id)sender{
    selectedTrackId = 2;
    //[self onAddVideoClip:trackID];
    [self presentViewController:videoPicker animated:YES completion:nil];
}

- (void) onAddVideoClip:(int)trackID
{
    int startTs = (int)seekPtsSlider.value;//+= 20;
    int duration = TEST_DURATION;
    int clipId = [VenusWrapper addVideoClip:trackID:startTs:duration:1280:720:@"root:111.mp4"];
    [self addVideoClipInfoAndView:trackID:clipId:startTs:duration:1280:720];
    activeClipId = clipId;
    
}

//插入一个clip button
-(void) addVideoClipInfoAndView:(int)trackId :(int)clipId :(int)startTs :(int)duration :(int)width :(int) height
{
    //add clip button
    NSString* clipInfo = [NSString stringWithFormat:@"%d(%d,%d)",clipId,startTs,startTs + duration];
    UIButton* btn = [UIViewFactory createButtonWithTitle:clipInfo];
    [btn addTarget:self action:@selector(onClipBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* key = [NSString stringWithFormat:@"%d",clipId];
    btn.tag = clipId;
    [m_clipBtnMap setObject:btn forKey:key];
    
    if(trackId == 1)
    {
        [self insertLayerClipBtn:layerContainer01 :btn];
    }
    else
    {
        [self insertLayerClipBtn:layerContainer02 :btn];
    }
    
    
    
    // add clip info
    ClipInfo info;
    info.startTs = startTs;
    info.endTs = startTs + duration;
    info.clipId = clipId;
    info.trackId = trackId;
    info.duration = duration;
    info.width = width;
    info.height = height;
 
    NSValue *value = [NSValue valueWithBytes:&info objCType:@encode(ClipInfo)];
    [m_clipInfoMap setObject:value forKey:key];

}


-(void)updateVideoClipInfoAndView:(ClipInfo)info
{
    NSString* key = [NSString stringWithFormat:@"%d",info.clipId];
    //info.endTs = info.startTs +splitSlider.value;
    UIButton* btn = [m_clipBtnMap objectForKey:key];
    [btn setTitle:[NSString stringWithFormat:@"%d(%d,%d)",info.clipId,info.startTs,info.endTs] forState:UIControlStateNormal];
    NSValue *updateValue = [NSValue valueWithBytes:&info objCType:@encode(ClipInfo)];
    [m_clipInfoMap setObject:updateValue forKey:key];
}


//点击clip button时，出现subOperationMenu选项
- (IBAction)onClipBtnClicked:(UIButton *)sender
{
    NSString* key = [NSString stringWithFormat:@"%d",(int)sender.tag];
    //将进度条移动到对应的clip时间点上
    NSValue* value = [m_clipInfoMap objectForKey:key];
    ClipInfo info;
    [value getValue:&info];
    seekPtsSlider.value = info.startTs;
    [self seekPts];
    
    //seek之后理论上激活的clip已经更新了
    if(activeClipId != sender.tag)
    {
        activeClipId = (int)sender.tag;
    }
    
    //打开操作面板，更新信息
    [subOperationMenu setHidden:false];
    [selectClipIdText setText:[NSString stringWithFormat:@"Clip:%d",(int)sender.tag]];
    [splitSlider setMaximumValue:(int)info.duration];
    [splitSlider setValue:(int)(info.duration/2)];
    [splitValueText setText:[NSString stringWithFormat:@"%d",(int)(info.duration/2)]];
   
    [cropSlider setMaximumValue:(int)info.duration];
    [cropSlider setValue:(int)(info.duration)];
    [cropValueText setText:[NSString stringWithFormat:@"%d",(int)info.duration]];
}


/**
 **********************************************************************************************************************
 **                                      OperationMenu:    Delete,Split,Speed                                                               *
 **********************************************************************************************************************
 */
- (void) createSubOperation
{
    subOperationMenu = [self createSubOperationView:CGRectMake(viewRectW - 200, 120, 200, 300)];
    [self.view addSubview:subOperationMenu];
    [subOperationMenu setHidden:true];
}

- (UIView*) createSubOperationView:(CGRect) frame
{
     //left group : buttons
    selectClipIdText = [UIViewFactory createLabel:@"Clip:1"];
    
    UIButton* delBtn = [UIViewFactory createButtonWithTitle:@"删除"];
    UIButton* copyBtn = [UIViewFactory createButtonWithTitle:@"复制"];
    UIButton* splitBtn = [UIViewFactory createButtonWithTitle:@"分割"];
    UIButton* speedBtn = [UIViewFactory createButtonWithTitle:@"速度"];
    UIButton* cropBtn = [UIViewFactory createButtonWithTitle:@"裁剪"];
    UIButton* addTransitionBtn = [UIViewFactory createButtonWithTitle:@"转场"];
    UIButton* traversalBtn = [UIViewFactory createButtonWithTitle:@"遍历打印"];

    [delBtn addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];
    [copyBtn addTarget:self action:@selector(onCopy:) forControlEvents:UIControlEventTouchUpInside];
    [splitBtn addTarget:self action:@selector(onSplit:) forControlEvents:UIControlEventTouchUpInside];
    [speedBtn addTarget:self action:@selector(onSetSpeed:) forControlEvents:UIControlEventTouchUpInside];
    [cropBtn addTarget:self action:@selector(onCrop:) forControlEvents:UIControlEventTouchUpInside];
    [addTransitionBtn addTarget:self action:@selector(onAddTransition:) forControlEvents:UIControlEventTouchUpInside];
    [traversalBtn addTarget:self action:@selector(onTraversal:) forControlEvents:UIControlEventTouchUpInside];
    
     
    UIStackView* vGroupLeft = [[UIStackView alloc] init];
    vGroupLeft.axis = UILayoutConstraintAxisVertical;
    vGroupLeft.distribution = UIStackViewDistributionFillEqually;
    vGroupLeft.spacing = 5;
     
    [vGroupLeft addArrangedSubview:selectClipIdText];
    [vGroupLeft addArrangedSubview:delBtn];
    [vGroupLeft addArrangedSubview:copyBtn];
    [vGroupLeft addArrangedSubview:splitBtn];
    [vGroupLeft addArrangedSubview:speedBtn];
    [vGroupLeft addArrangedSubview:cropBtn];
    [vGroupLeft addArrangedSubview:addTransitionBtn];
    [vGroupLeft addArrangedSubview:traversalBtn];
     
  
     //right group : slider and other input ui
    UIStackView* vGroupRight = [[UIStackView alloc] init];
    vGroupRight.axis = UILayoutConstraintAxisVertical;
    vGroupRight.distribution = UIStackViewDistributionFillEqually;
    vGroupRight.spacing = 5;

    UIView* placeHolder1 = [[UIView alloc]init];
    UIView* placeHolder2 = [[UIView alloc]init];
    UIView* placeHolder3 = [[UIView alloc]init];
    UIView* placeHolder4 = [[UIView alloc]init];
    UIView* placeHolder5 = [[UIView alloc]init];
    splitSlider = [UIViewFactory createSlider:0 : TEST_DURATION];
    speedSlider = [UIViewFactory createSlider:0 :10];
    cropSlider = [UIViewFactory createSlider:0 :TEST_DURATION];
    splitValueText = [UIViewFactory createLabel:@"0"];
    speedValueText = [UIViewFactory createLabel:@"0"];
    cropValueText = [UIViewFactory createLabel:@"0"];
    [splitSlider addTarget:self action:@selector(onSplitProgressChange) forControlEvents:UIControlEventValueChanged];
    [speedSlider addTarget:self action:@selector(onSpeedProgressChange) forControlEvents:UIControlEventValueChanged];
    [cropSlider addTarget:self action:@selector(onCropProgressChange) forControlEvents:UIControlEventValueChanged];
     
    UIStackView* splitGroup = [[UIStackView alloc]init];
    splitGroup.axis = UILayoutConstraintAxisHorizontal;
    splitGroup.spacing = 2;
    [splitGroup addArrangedSubview:splitValueText];
    [splitGroup addArrangedSubview:splitSlider];
     
    UIStackView* speedGroup = [[UIStackView alloc]init];
    speedGroup.axis = UILayoutConstraintAxisHorizontal;
    speedGroup.spacing = 2;
    [speedGroup addArrangedSubview:speedValueText];
    [speedGroup addArrangedSubview:speedSlider];
    
    
    UIStackView* cropGroup = [[UIStackView alloc]init];
    cropGroup.axis = UILayoutConstraintAxisHorizontal;
    cropGroup.spacing = 2;
    [cropGroup addArrangedSubview:cropValueText];
    [cropGroup addArrangedSubview:cropSlider];
    
     
    [vGroupRight addArrangedSubview:placeHolder1];
    [vGroupRight addArrangedSubview:placeHolder2];
    [vGroupRight addArrangedSubview:placeHolder3];
    [vGroupRight addArrangedSubview:splitGroup];
    [vGroupRight addArrangedSubview:speedGroup];
    [vGroupRight addArrangedSubview:cropGroup];
    [vGroupRight addArrangedSubview:placeHolder4];
    [vGroupRight addArrangedSubview:placeHolder5];

     
    //parent container
    UIStackView* mView = [[UIStackView alloc] initWithFrame:frame];
    mView.axis = UILayoutConstraintAxisHorizontal;
    //mView.distribution = UIStackViewDistributionFillEqually;
    mView.spacing = 5;
    mView.backgroundColor = UIColor.whiteColor;
    [mView addArrangedSubview:vGroupLeft];
    [mView addArrangedSubview:vGroupRight];
     
    return mView;
}



- (void) onDelete:(id)sender
{
    NSLog(@"[Button]onDelete : %d",activeClipId);
    NSString* key = [NSString stringWithFormat:@"%d",activeClipId];
    //[self deleteLayerClipBtn:(UIStackView *) :<#(UIButton *)#>];
    UIButton* btn = [m_clipBtnMap objectForKey:key];
    NSValue* value = [m_clipInfoMap objectForKey:key];
    ClipInfo info;
    [value getValue:&info];
    
    if(info.trackId == 1)
    {
        [self deleteLayerClipBtn:layerContainer01 :btn];
    }
    else
    {
        [self deleteLayerClipBtn:layerContainer02 :btn];
    }
    
    //收起面板
    [subOperationMenu setHidden:true];
    
    //venus remove接口调用
    [VenusWrapper removeVideoClip:activeClipId];
    
    activeClipId = -1;
    
}

- (void) onCopy:(id)sender
{
    int copyId = [VenusWrapper copyVideoClip:activeClipId];
    
    //add copy clip
    NSString* key = [NSString stringWithFormat:@"%d",activeClipId];
    NSValue* value = [m_clipInfoMap objectForKey:key];
    ClipInfo info;
    [value getValue:&info];
    
    int startTs = info.endTs + 1;
    int duration = info.duration;
    [self addVideoClipInfoAndView:info.trackId:copyId:startTs:duration:info.width:info.height];
    
    //关闭面板
    [subOperationMenu setHidden:true];
}

- (void) onSplit:(id)sender
{
    NSString* key = [NSString stringWithFormat:@"%d",activeClipId];
    NSValue* value = [m_clipInfoMap objectForKey:key];
    ClipInfo info;
    [value getValue:&info];
    
    //add new clip
    int newId = [VenusWrapper splitVideoClip:activeClipId :splitSlider.value];
    int startTs = info.startTs + splitSlider.value + 1;
    int duration = info.duration - splitSlider.value -1;
    [self addVideoClipInfoAndView:info.trackId:newId:startTs:duration:info.width:info.height];

    
    //update origin clip info
    info.endTs = info.startTs +splitSlider.value;
    info.duration = info.endTs - info.startTs;
    [self updateVideoClipInfoAndView:info];
    
    //关闭面板
    [subOperationMenu setHidden:true];
}


- (void) onCrop:(id)sender
{
    [VenusWrapper setClipCropRange:activeClipId :0 :(int)cropSlider.value:true];
    
    //update origin clip info
    NSString* key = [NSString stringWithFormat:@"%d",activeClipId];
    NSValue* value = [m_clipInfoMap objectForKey:key];
    ClipInfo info;
    [value getValue:&info];
    info.endTs = info.startTs + cropSlider.value;
    info.duration = info.endTs - info.startTs;
    [self updateVideoClipInfoAndView:info];
    
    //关闭面板
    [subOperationMenu setHidden:true];
}

-(void) onTraversal:(id)sender
{
    [VenusWrapper traversalClips];
}

-(void) onSetSpeed:(id)sender
{
    NSLog(@"[Button]onSetSpeed : %d,%d",activeClipId,(int)speedSlider.value);
}

-(void) onAddTransition:(id)sender
{
    [VenusWrapper addTransition:activeClipId-1 :activeClipId :@"blend"];
}

- (void) onSplitProgressChange
{
    [splitValueText setText:[NSString stringWithFormat:@"%d",(int)splitSlider.value]];
}

- (void) onSpeedProgressChange
{
    [speedValueText setText:[NSString stringWithFormat:@"%d",(int)speedSlider.value]];
}

- (void) onCropProgressChange
{
    [cropValueText setText:[NSString stringWithFormat:@"%d",(int)cropSlider.value]];
}




-(void)createAlbumPicker
{
    videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    videoPicker.delegate = self;
    videoPicker.mediaTypes = @[@"public.movie"]; //@"public.image"
    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString* mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString*)kUTTypeMovie])
    {
        NSURL *URL = info[UIImagePickerControllerMediaURL];
        NSLog(URL.absoluteString);

        //添加一个video
        int duration,width,height,test;
        [self getVideoInfo:URL:&duration:&width:&height];
        int startTs = (int)seekPtsSlider.value;//+= 20;
        int clipId = [VenusWrapper addVideoClip:selectedTrackId:startTs:duration:width:height:URL.absoluteString];

        
        [self addVideoClipInfoAndView:selectedTrackId:clipId:startTs:duration:width:height];
        activeClipId = clipId;
    }
    else
    {
        NSURL *URL = info[UIImagePickerControllerImageURL];
        NSLog(URL.absoluteString);
        //以该图片插入一段videoclip
        int duration = 100;//[self getVideoDuration:URL];
        int startTs = (int)seekPtsSlider.value;//+= 20;
        int clipId = [VenusWrapper addVideoClip:selectedTrackId:startTs:duration:1280:720:URL.absoluteString];
        [self addVideoClipInfoAndView:selectedTrackId:clipId:startTs:duration:1280:720];
        activeClipId = clipId;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)getVideoInfo:(NSURL*)url :(int*)duration :(int*)width :(int*)height
{
    AVAsset *videoAsset = (AVAsset *)[AVAsset assetWithURL:url];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    int Unit = 10;  //1000 毫秒
    *duration = (int)(CMTimeGetSeconds(videoAssetTrack.timeRange.duration)*Unit);
    *width = videoAssetTrack.naturalSize.width;
    *height = videoAssetTrack.naturalSize.height;
    NSLog(@"getVideoDuration：%f,%d , w:%d, h:%d",CMTimeGetSeconds(videoAssetTrack.timeRange.duration),*duration,*width,*height);
}


@end
