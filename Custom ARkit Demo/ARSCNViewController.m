//
//  ARSCNViewController.m
//  Custom ARkit Demo
//
//  Created by chenxi on 2017/8/1.
//  Copyright © 2017年 BaiZe. All rights reserved.
//

#import "ARSCNViewController.h"
//加载3D游戏框架
#import <SceneKit/SceneKit.h>
//加载AR框架
#import <ARKit/ARKit.h>

@interface ARSCNViewController ()<ARSCNViewDelegate,ARSessionDelegate>

//AR视图：展示3D界面
@property (nonatomic, strong) ARSCNView *arSCNView;

//AR会话：管理相机追踪配置及3D相机坐标
@property (nonatomic, strong) ARSession *arSession;

//会话配置：追踪相机运动
@property (nonatomic, strong) ARConfiguration *arSessionConfiguration;

//3D模型：场景呈现的3D模型
@property (nonatomic, strong) SCNNode *planeNode;

@end

@implementation ARSCNViewController

@synthesize arType = _arType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //将AR视图添加到当前视图
    [self.view addSubview:self.arSCNView];
    //开启AR会话（相机开始工作）
    [self.arSession runWithConfiguration:self.arSessionConfiguration];
    
    //添加返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(self.view.bounds.size.width/2 - 40, self.view.bounds.size.height - 65, 80, 40);
    backBtn.backgroundColor = [UIColor blackColor];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void) back:(UIButton *) btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --点击屏幕添加模型
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.arType == ARTypeStart) {
        //使用场景加载SCN文件（3D模型）
        SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/vase/vase.scn"];
        //获取3D模型节点
        SCNNode *shipNode = scene.rootNode.childNodes[0];
        //调整3D模型位置
        shipNode.scale = SCNVector3Make(2, 2, 2);
        shipNode.position = SCNVector3Make(0, -1, -1);
        //将节点添加到AR视图场景中
        [self.arSCNView.scene.rootNode addChildNode:shipNode];
    }
    
    if (self.arType == ARTypeMove) {
        //使用场景加载SCN文件（3D模型）
        SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/ship.scn"];
        //获取3D模型节点
        SCNNode *shipNode = scene.rootNode.childNodes[0];
        self.planeNode = shipNode;
        //调整3D模型大小、位置
        shipNode.scale = SCNVector3Make(0.3, 0.3, 0.3);
        shipNode.position = SCNVector3Make(0, -8, -20);
        
        //3D建模可能由多个节点拼接，所有子节点都要改
        for (SCNNode *node in shipNode.childNodes) {
            node.scale = SCNVector3Make(0.3, 0.3, 0.3);
            node.position = SCNVector3Make(0, -8, -20);
        }
        
        //将节点添加到AR视图场景中
        [self.arSCNView.scene.rootNode addChildNode:shipNode];
    }
    
    if (self.arType == ARTypeMoon) {
        [self.planeNode removeFromParentNode];
        //使用场景加载SCN文件（3D模型）
        SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/lamp/lamp.scn"];
        //获取3D模型节点
        SCNNode *lampNode = scene.rootNode.childNodes[0];
        
        self.planeNode = lampNode;
        
        //调整3D模型大小、位置
        lampNode.scale = SCNVector3Make(0.4, 0.4, 0.4);
        lampNode.position = SCNVector3Make(0, -4, -10);
        
        //3D建模可能由多个节点拼接，所有子节点都要改
        for (SCNNode *node in lampNode.childNodes) {
            node.scale = SCNVector3Make(0.4, 0.4, 0.4);
            node.position = SCNVector3Make(0, -4, -10);
        }
        
        self.planeNode.position = SCNVector3Make(0, -4, -10);
        
        //环绕相机旋转（核心代码）
        //1、创建一个空节点
        SCNNode *emptyNode = [[SCNNode alloc] init];
        
        //2、空节点位置与相机节点位置一致
        emptyNode.position = self.arSCNView.scene.rootNode.position;
        
        //3、将空节点添加到相机的根节点
        [self.arSCNView.scene.rootNode addChildNode:emptyNode];
        
        //4、将模型节点添加到空节点，若不添加则是模型“自转”而不是“公转”
        [emptyNode addChildNode:self.planeNode];
        
        //5、旋转动画
        CABasicAnimation *moonRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
        
        //6、旋转周期
        moonRotationAnimation.duration = 30;
        
        //7、围绕Y轴旋转360度
        moonRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
        
        //8、重复次数（无穷大，无限旋转）
        moonRotationAnimation.repeatCount = FLT_MAX;
        
        //9、开始旋转
        [emptyNode addAnimation:moonRotationAnimation forKey:@"moon rotation around earth"];
    }
    
}

#pragma mark -ARKit搭建

//加载AR视图
- (ARSCNView *) arSCNView
{
    if (_arSCNView != nil) {
        return _arSCNView;
    }
    //创建AR视图
    _arSCNView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
    //设置视图会话
    _arSCNView.session = self.arSession;
    //自动刷新灯光
    _arSCNView.automaticallyUpdatesLighting = YES;
    
    // 显示统计数据（statistics）如 fps 和 时长信息
    _arSCNView.showsStatistics = YES;
    _arSCNView.autoenablesDefaultLighting = YES;
    
    // 开启 debug 选项以查看世界原点并渲染所有 ARKit 正在追踪的特征点
    _arSCNView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    
    _arSCNView.delegate = self;
    
    return _arSCNView;
}

//加载会话
- (ARSession *) arSession
{
    if (_arSession != nil) {
        return _arSession;
    }
    //创建会话
    _arSession = [[ARSession alloc] init];
    
    _arSession.delegate = self;
    
    return _arSession;
}

//加载会话追踪配置
- (ARConfiguration *) arSessionConfiguration
{
    if (_arSessionConfiguration != nil) {
        return _arSessionConfiguration;
    }
    //创建世界追踪会话配置（使用ARWorldTrackingSessionConfiguration效果个更好）
    ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc] init];
    //设置追踪方向（追踪平面）
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    //自适应灯光
    configuration.lightEstimationEnabled = YES;
    
    _arSessionConfiguration = configuration;
    
    return _arSessionConfiguration;
}

#pragma mark -- ARSCNViewDelegate

//添加节点后调用
- (void) renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"添加节点后调用");
    if(self.arType != ARTypePlane)
    {
        return;
    }
    if ([anchor isMemberOfClass:[ARPlaneAnchor class]]) {
        NSLog(@"捕捉到平面");

        //1、获取捕捉到的平面锚点
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;

        //2、创建一个3D物体模型
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x * 0.4 height:0 length:planeAnchor.extent.x * 0.4 chamferRadius:0];

        //3、使用meterial渲染模型
        plane.firstMaterial.diffuse.contents = [UIColor greenColor];

        //4、创建基于模型的节点
        SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];

        //5、设置节点的位置为捕捉平面锚点的中心位置
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);

        [node addChildNode:planeNode];

        //2秒后开始添加3D模型
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            //1、创建花瓶场景
            SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/baize/baize.scn"];

            //2、获取花瓶节点
            SCNNode *vaseNode = scene.rootNode.childNodes[0];

            //3、设置花瓶位置
            vaseNode.scale = SCNVector3Make(0.08, 0.08, 0.08);
            vaseNode.position = SCNVector3Make(planeAnchor.center.x, 0.05, planeAnchor.center.z);

            //4、将花瓶添加到当前屏幕
            [node addChildNode:vaseNode];
        });
    }
}

//更新节点前调用
- (void) renderer:(id<SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"更新节点前调用");
}

//更新节点后调用
- (void) renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"更新节点后调用");
}

//删除节点后调用
- (void) renderer:(id<SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"删除节点后调用");
}

#pragma mark -- ARSessionDelegate

//相机移动后调用
- (void) session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    NSLog(@"相机移动后调用");
    if (self.arType != ARTypeMove) {
        return;
    }
    
    if (self.planeNode) {
        //根据相机移动物体节点位置
        self.planeNode.position = SCNVector3Make(frame.camera.transform.columns[3].x, frame.camera.transform.columns[3].y, frame.camera.transform.columns[3].z);
    }
}

//添加锚点后调用
- (void) session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor *> *)anchors
{
    NSLog(@"添加锚点后调用");
}

//更新锚点后调用
- (void) session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor *> *)anchors
{
    NSLog(@"更新锚点后调用");
}

//删除锚点后调用
- (void) session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor *> *)anchors
{
    NSLog(@"删除锚点后调用");
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
