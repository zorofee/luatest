local Object = require "classic"
local venuscore = require "venuscore"
local BundleSystem = require "venuscore.bundle.bundlesystem"
local apolloengine = require "apollocore"
local mathfunction = require "mathfunction"
local VideoScene = require "videoclip_new.video_scene"
local QuadNode = require "videoclip_new.quadnode"
local MainScene = VideoScene:extend()

--[[
一、场景结构：
1.cutterScene
    --MainQuad(VideoMainScene) <|-----|
                                      |
                                     fbo
2.mainScene                           |
    --MainCamera  (GlobalFilter) -----|
    --BgQuad      (ClearColor or Image)
    --TransitionQuad (Fbo From Transition Scene) <|-----|
    --VideoQuad01 (VideoScene01) <|----|                |
    --VideoQuad02 (VideoScene02)       |                |
                                       |                |
                                      fbo               |
3.videoScene01                         |               fbo
    --MainCamera(VideoFilter)----------|                |
    --QuadNode(DEVICE_CAPTURE)                          |
                                                        |
4.transitionScene                                       |
    --MainCamera    ------------------------------------|
    --QuadNode(TransitionMaterial)



二、MainScene中的渲染层级
    background < video quads < transition quad
]]

function MainScene:new()
    WARNING("[MainScene] new MainScene")
    self.renderoNodeList = {}

    --new main_video_scnee
    self.videoScene = apolloengine.SceneManager:CreateScene("MainScene")
   
   
    --主相机
    self.mainCamera = self:_CreateCamera("Default",mathfunction.Color(0.28,0.0,0.0,1))   --red
    self.mainCamera:AddLayerMask("Background");
    self.mainCamera:AddLayerMask("Transition");


    --背景
    local background = QuadNode(self.videoScene)
    background:SetLayer("Background")
    background:SetRenderOrder(0)
    background:SetLocalPosition(mathfunction.vector3(0.2,0.2,0))
    background:SetLocalScale(mathfunction.vector3(0.9,0.2,1))



    --创建转场需要的拍摄相机和fbo,两段视频纹理需要两个相机拍摄
    self.fbo01 = self:_CreateRenderTarget()
    self.fbo02 = self:_CreateRenderTarget()
    local transition01CC = self:_CreateCamera("transition1",mathfunction.Color(0.0,1.0,0.0,0),self.fbo01)  --green
    local transition02CC = self:_CreateCamera("transition2",mathfunction.Color(0.0,0.0,1.0,0),self.fbo02)  --blue
    transition01CC:AddLayerMask("Background")
    transition02CC:AddLayerMask("Background")

    --转场专用quad,转场材质是全屏显示,无法设置transform
    local transition = QuadNode(self.videoScene)
    transition:SetLayer("Transition")
    transition:SetRenderOrder(100)
    transition:SetLocalPosition(mathfunction.vector3(-0.2,-0.2,0))
    transition:SetLocalScale(mathfunction.vector3(0.9,0.2,1))
    self.transition = transition



    
    --mainscene渲染输出到cutterScene下的main quad
    local mainFbo = self:_CreateRenderTarget()
    self.mainCamera:AttachRenderTarget(mainFbo.rendertarget)

    local cutterScene = apolloengine.SceneManager:GetOrCreateScene("video_cutter")
    local mainQuad = QuadNode(cutterScene)
    mainQuad:SetLocalScale(mathfunction.vector3(0.9,0.9,1.0))
    mainQuad:SetMainTexture(mainFbo.color)

end


function MainScene:SetCanvasAspectRatio(ratioX,ratioY)
    
end


function MainScene:SetCanvasBGColor(color)
    self.mainCamera:SetClearColor(mathfunction.Color(0.28,0.28,0.0,0.5))
end




function VideoScene:CreateVideoQuad(layer,trackId,fbo)
    local videoQuad = QuadNode(self.videoScene)
    videoQuad:SetLayer(layer)
    videoQuad:BindMainTexture("DEVICE_CAPTURE")
    videoQuad:SetRenderOrder(trackId)
    videoQuad:SetMainTexture(fbo)
    videoQuad:SetActive(false)
    return videoQuad
end


return MainScene
