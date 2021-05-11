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

    --self:_CreateBackgroundNode()
    
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

    --self.mainCamera:SetCameraResolution(mathfunction.vector2(ratioX,ratioY))
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



return MainScene
