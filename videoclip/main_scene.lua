require "videoclip.videoutility"
local Object = require "classic"
local venuscore = require "venuscore"
local BundleSystem = require "venuscore.bundle.bundlesystem"
local apolloengine = require "apollocore"
local mathfunction = require "mathfunction"
local VideoScene = require "videoclip.video_scene"
local QuadNode = require "videoclip.quadnode"
local MainScene = VideoScene:extend()

local DefaultWidth = 200.0
local DefaultHeight = 300.0
function MainScene:new()

    MainScene.super:new()
    
    WARNING("[ZHAOWANFEI TEST] CREATE MAIN SCENE")
    self.sceneName = "MainScene"
    self.mainCamera:SetClearColor(mathfunction.Color(0.9,0.9,0.0,1))

    self:_CreateBackgroundNode()
    
    --mainscene渲染输出到cutterScene下的main quad
    local mainFbo = CreateRenderTarget()
    self.mainCamera:AttachRenderTarget(mainFbo.rendertarget)

    local cutterScene = apolloengine.SceneManager:GetOrCreateScene("video_cutter")
    local mainQuad = QuadNode(cutterScene)
    mainQuad:SetMainTexture(mainFbo.color)
    self.mainQuad = mainQuad

    self.startRatioX = 9
    self.startRatioY = 16
end


function MainScene:SetCanvasAspectRatio(ratioX,ratioY)
    for i=1,#self.renderoNodeList do
        local scaleX = mathfunction.vector1(DefaultWidth / ratioX)
        local scaleY = mathfunction.vector1(DefaultHeight / ratioY)
        self.renderoNodeList[i]:SetParameter("x",scaleX)
        self.renderoNodeList[i]:SetParameter("y",scaleY)
    end
end


function MainScene:SetCanvasBGImage(path)
    --local path = "root:test.png"
    WARNING("[SetCanvasBGImage]:" .. path)
    local tex = apolloengine.TextureEntity()
    tex:PushMetadata(apolloengine.TextureFileMetadata(
        apolloengine.TextureEntity.TU_STATIC,
        apolloengine.TextureEntity.PF_AUTO,1,false,
        apolloengine.TextureEntity.TW_CLAMP_TO_EDGE,
        apolloengine.TextureEntity.TW_CLAMP_TO_EDGE,
        apolloengine.TextureEntity.TF_LINEAR,
        apolloengine.TextureEntity.TF_LINEAR,
        path))
    
    tex:SetJobType(venuscore.IJob.JT_SYNCHRONOUS)
    tex:CreateResource()
    self.background:SetParameter("_MainTex",tex)
end


function MainScene:SetCanvasBGColor(color)
    self.mainCamera:SetClearColor(color)
end


function MainScene:CreateVideoQuad(trackId,fbo)
    local videoQuad = QuadNode(self.videoScene)
    videoQuad:SetLayer("Default")
    videoQuad:SetRenderOrder(trackId)
    videoQuad:SetMainTexture(fbo)
    videoQuad:SetActive(false)

    table.insert(self.renderoNodeList,videoQuad)
    return videoQuad
end


function MainScene:_CreateBackgroundNode()
    local backgroundNode = QuadNode(self.videoScene)
    backgroundNode:SetLayer("Background")
    backgroundNode:SetRenderOrder(0)
    --backgroundNode:SetLocalPosition(mathfunction.vector3(0.2,0.2,0))
    backgroundNode:SetLocalScale(mathfunction.vector3(0.8,0.8,1))
    self.background = backgroundNode
    self.mainCamera:AddLayerMask("Background");
    
    
end





return MainScene
