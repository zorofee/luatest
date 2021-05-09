require "videoclip.videoutility"
local Object = require "classic"
local venuscore = require "venuscore"
local BundleSystem = require "venuscore.bundle.bundlesystem"
local apolloengine = require "apollocore"
local mathfunction = require "mathfunction"
local VideoScene = require "videoclip.video_scene"
local QuadNode = require "videoclip.quadnode"
local TransitionNode = require "videoclip.transitionnode"
local MainScene = VideoScene:extend()

function MainScene:new()

    MainScene.super:new()
    self.sceneName = "MainScene"
    self.mainCamera:SetClearColor(mathfunction.Color(0.0,0.5,0.0,1))

    self:_CreateBackgroundNode()
    self:_CreateTransitionNode()

    
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
    --self.mainCamera:SetCameraResolution(ratioX,ratioY)
    --self.mainQuad:SetLocalScale(mathfunction.vector3(0.32,0.18,1.0))
    for i=1,#self.renderoNodeList do
        local scaleX = mathfunction.vector1(540.0 / ratioX)
        local scaleY = mathfunction.vector1(960.0 / ratioY)
        self.renderoNodeList[i]:SetParameter("x",scaleX)
        self.renderoNodeList[i]:SetParameter("y",scaleY)
        --self.renderoNodeList[i]:SetLocalScale(mathfunction.vector3(540.0 / ratioX,960.0 / ratioY,1.0))
    end

    self.camera:SetCameraResolution(mathfunction.vector2(ratioX,ratioY))
end


function MainScene:SetCanvasBGImage(path)

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


function MainScene:SetTransitionProgress(progress)
    self.transition:SetParameter("_Progress",progress)
end



function MainScene:_CreateBackgroundNode()
    local backgroundNode = QuadNode(self.videoScene)
    backgroundNode:SetLayer("Background")
    backgroundNode:SetRenderOrder(0)
    backgroundNode:SetLocalPosition(mathfunction.vector3(0.2,0.2,0))
    backgroundNode:SetLocalScale(mathfunction.vector3(0.9,0.9,1))
    self.background = backgroundNode
    self.mainCamera:AddLayerMask("Background");
end


function MainScene:_CreateTransitionNode()

    --创建转场需要的拍摄相机和fbo,两段视频纹理需要两个相机拍摄
    self.fbo01 = CreateRenderTarget()
    self.fbo02 = CreateRenderTarget()
    local transition01CC = self:_CreateCamera("transition1",mathfunction.Color(0.0,0.8,0.0,0),self.fbo01)  --green
    local transition02CC = self:_CreateCamera("transition2",mathfunction.Color(0.0,0.0,0.8,0),self.fbo02)  --blue
    transition01CC:AddLayerMask("Background")
    transition02CC:AddLayerMask("Background")


    --转场专用quad,转场材质是全屏显示,无法设置transform。接受转场前后两个视频纹理，输出融合纹理
    local transitionNode = TransitionNode(self.videoScene)
    transitionNode:SetLayer("Transition")
    transitionNode:SetRenderOrder(1)
    transitionNode:SetLocalPosition(mathfunction.vector3(0.2,0.2,0))
    transitionNode:SetLocalScale(mathfunction.vector3(0.8,0.8,1))

    --transitionNode:SetParameter("_MainTex",self.fbo01.color)
    transitionNode:SetParameter("_PrevTexture",self.fbo01.color)
    transitionNode:SetParameter("_NextTexture",self.fbo02.color)
    transitionNode:SetParameter("_Progress",mathfunction.vector1(0.0))
    self.transition = transitionNode

    self.mainCamera:AddLayerMask("Transition");
end

return MainScene
