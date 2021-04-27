require "videoclip.videoutility"
local Object = require "classic"
local venuscore = require "venuscore"
local BundleSystem = require "venuscore.bundle.bundlesystem"
local apolloengine = require "apollocore"
local mathfunction = require "mathfunction"
local VideoScene = require "videoclip.video_scene"
local QuadNode = require "videoclip.quadnode"
local MainScene = VideoScene:extend()

function MainScene:new()

    MainScene.super:new()

    self.mainCamera:AddLayerMask("Background");
    self.mainCamera:AddLayerMask("Transition");
    self.mainCamera:SetClearColor(mathfunction.Color(0.0,0.5,0.0,1))

    --背景
    local background = QuadNode(self.videoScene)
    background:SetLayer("Background")
    background:SetRenderOrder(0)
    background:SetLocalPosition(mathfunction.vector3(0.2,0.2,0))
    background:SetLocalScale(mathfunction.vector3(0.9,0.2,1))


    --创建转场需要的拍摄相机和fbo,两段视频纹理需要两个相机拍摄
    self.fbo01 = CreateRenderTarget()
    self.fbo02 = CreateRenderTarget()
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
    local mainFbo = CreateRenderTarget()
    self.mainCamera:AttachRenderTarget(mainFbo.rendertarget)

    local cutterScene = apolloengine.SceneManager:GetOrCreateScene("video_cutter")
    local mainQuad = QuadNode(cutterScene)
    mainQuad:SetLocalScale(mathfunction.vector3(0.9,0.9,1.0))
    mainQuad:SetMainTexture(mainFbo.color)
end


function MainScene:SetCanvasAspectRatio(ratioX,ratioY)
    
end


function MainScene:SetCanvasBGImage(path)

end


function MainScene:SetCanvasBGColor(color)
    self.mainCamera:SetClearColor(color)
end



function VideoScene:CreateVideoQuad(trackId,fbo)
    local videoQuad = QuadNode(self.videoScene)
    videoQuad:SetLayer("Default")
    videoQuad:BindMainTexture("DEVICE_CAPTURE")
    videoQuad:SetRenderOrder(trackId)
    videoQuad:SetMainTexture(fbo)
    videoQuad:SetActive(false)

    table.insert(self.renderoNodeList,videoQuad)
    return videoQuad
end


return MainScene
