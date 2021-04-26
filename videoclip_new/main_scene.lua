local Object = require "classic"
local venuscore = require "venuscore"
local BundleSystem = require "venuscore.bundle.bundlesystem"
local apolloengine = require "apollocore"
local mathfunction = require "mathfunction"
local VideoScene = require "videoclip_new.video_scene"
local MainScene = VideoScene:extend()


function MainScene:new()
    WARNING("[MainScene] new MainScene")
    self.renderoNodeList = {}


    --new main_video_scnee
    self.videoScene = apolloengine.SceneManager:CreateScene("MainScene")
    --主相机
    self.mainCamera = self:_CreateCamera("Default",mathfunction.Color(0.28,0.28,0,1))   --red
    self:_AddCameraLayerMask("Background");


    --输出到main quad
    self.mainFbo = self:_CreateRenderTarget()
    self.mainCamera:AttachRenderTarget(self.mainFbo.rendertarget)


    --背景
    local background = self:_CreateQuad("Background2222222",0)
    background:GetComponent(apolloengine.Node.CT_RENDER):SetRenderOrder(0)
    background:GetComponent(apolloengine.Node.CT_TRANSFORM):SetLocalScale(mathfunction.vector3(0.9,0.9,1))
    background:GetComponent(apolloengine.Node.CT_TRANSFORM):SetLocalPosition(mathfunction.vector3(0.0,0.0,0))


    --创建转场需要的拍摄相机和fbo,两段视频纹理需要两个相机拍摄
    self.fbo01 = self:_CreateRenderTarget()
    self.fbo02 = self:_CreateRenderTarget()
    local transition01CC = self:_CreateCamera("transition1",mathfunction.Color(0.0,1.0,0.0,0),self.fbo01)  --green
    local transition02CC = self:_CreateCamera("transition2",mathfunction.Color(0.0,0.0,1.0,0),self.fbo02)  --blue
    transition01CC:AddLayerMask("Background")
    transition02CC:AddLayerMask("Background")

    --转场专用quad,转场材质是全屏显示,无法设置transform
    self.transition = self:_CreateQuad("Transition",1)
    self.transition:GetComponent(apolloengine.Node.CT_RENDER):SetRenderOrder(0)
    self.transition:GetComponent(apolloengine.Node.CT_TRANSFORM):SetLocalScale(mathfunction.vector3(0.6,0.6,1))
    self.transition:GetComponent(apolloengine.Node.CT_TRANSFORM):SetLocalPosition(mathfunction.vector3(0.0,0.0,0))

    self:_CreateMainQuad()

end

function MainScene:SetCanvasAspectRatio(ratioX,ratioY)
    
end

function MainScene:SetCanvasBGColor(color)
    self.mainCamera:SetClearColor(color)
end



function VideoScene:_CreateMainQuad()
    local cutterScane = apolloengine.SceneManager:GetOrCreateScene("video_cutter")
    local quad = cutterScane:CreateNode(apolloengine.Node.CT_NODE)
    local trans = quad:CreateComponent(apolloengine.Node.CT_TRANSFORM)
    local render = quad:CreateComponent(apolloengine.Node.CT_RENDER)
    trans:SetLocalScale(mathfunction.vector3(0.4,0.4,1.0))

    self:CreateRenderResource(render,"comm:documents/shaders/opaque/quad.material")
    render:SetParameter("_MainTex",self.mainFbo.color)

    return quad
end



return MainScene
