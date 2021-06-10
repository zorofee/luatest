local Object = require "classic"
local venuscore = require "venuscore"
local BundleSystem = require "venuscore.bundle.bundlesystem"
local apolloengine = require "apollocore"
local mathfunction = require "mathfunction"
local QuadNode = require "videoclip.quadnode"
local MediaNode = require "videoclip.medianode"
local CameraNode = require "videoclip.cameranode"
local TransitionNode = require "videoclip.transitionnode"
local vp = require "videoprocess"
local VideoScene = Object:extend()

local MAX_RENDERORDER = 100
local MIN_RENDERORDER = 0

function VideoScene:new()
    local defaultLayer = "Default"
    local defaultColor = mathfunction.Color(0.5,0.0,0.0,1)

    self.sceneName = "VideoScene"
    self.renderoNodeList = {}
    self.videoScene = apolloengine.SceneManager:CreateScene("VideoScene")
    self.mainCamera = self:_CreateCamera(defaultLayer,defaultColor)

    self.mediaNodeMap = {}
    self.videoClipInfoMap = {}

    self.bInitTransition = false
    self.transitionNodeMap = {}
end

function VideoScene:Reset()
    for i=1,#self.renderoNodeList do
        self.renderoNodeList[i]:SetActive(false)
    end
end

function VideoScene:AddCameraEffect(effectInfo)
    self.mainCamera:CreatePostEffect(effectInfo)
end



function VideoScene:BindRenderTarget(fbo)
    self.mainCamera:AttachRenderTarget(fbo.rendertarget)
end


function VideoScene:_CreateCamera(layer,clearcolor,fbo)

    local camera = CameraNode(self.videoScene)
    camera:AddLayerMask(layer)
    camera:SetClearColor(clearcolor)
        
    if fbo ~= nil then
        camera:AttachRenderTarget(fbo.rendertarget)
    end
    return camera
end


--添加videoclip
function VideoScene:AddMediaNode(clipInfo)
    local mediaNode = MediaNode(self.videoScene,clipInfo.path)
    self.mediaNodeMap[clipInfo.clipId] = mediaNode
    self.videoClipInfoMap[clipInfo.clipId] = clipInfo
end



--播放视频帧：  绝对时间戳换算成相对时间戳, 通过medianode解出帧
function VideoScene:SeekFrame(clipId,timePointInMs)

    self.mediaNodeMap[clipId]:SetActive(true)
    self.mediaNodeMap[clipId]:SetLayer("Default") 

    local seekTs = timePointInMs - self.videoClipInfoMap[clipId].logicStartTs              --todo:需要换算成相对时间戳
    self.mediaNodeMap[clipId]:Seek(timePointInMs,self.videoClipInfoMap[clipId].speed)    
end


--[[
播放转场:
    1.取到转场关联的前后两段视频帧,通过transitioncamera画fbo传入转场材质中
    2.根据时间戳计算转场progress，传入转场材质中
]]
function VideoScene:UpdateTransition(clipId,timePointInMs)

    local info = self.videoClipInfoMap[clipId]

    self.mediaNodeMap[info.frontVideoId]:SetActive(true) 
    self.mediaNodeMap[info.backVideoId]:SetActive(true)

    self.mediaNodeMap[info.frontVideoId]:SetLayer("transition1") 
    self.mediaNodeMap[info.backVideoId]:SetLayer("transition2") 

    
    self.mediaNodeMap[info.frontVideoId]:Seek(timePointInMs,info.speed)  --todo:需要换算成相对时间戳
    self.mediaNodeMap[info.backVideoId]:Seek(timePointInMs,info.speed)

    local progress = (timePointInMs - info.logicStartTs)/(info.logicEndTs - info.logicStartTs)
    self.transitionNodeMap[clipId]:SetActive(true)
    self.transitionNodeMap[clipId]:SetParameter("_Progress",mathfunction.vector1(progress))

end


function VideoScene:InitTransitionEvn()
    --创建转场需要的拍摄相机和fbo,两段视频纹理需要两个相机拍摄
    local fbo01 = CreateRenderTarget()
    local fbo02 = CreateRenderTarget()
    local transition01CC = self:_CreateCamera("transition1",mathfunction.Color(0.8,0.0,0.0,0),fbo01)  --red
    local transition02CC = self:_CreateCamera("transition2",mathfunction.Color(0.0,0.0,0.8,0),fbo02)  --blue
    transition01CC:AddLayerMask("Background")
    transition02CC:AddLayerMask("Background")
    self.mainCamera:AddLayerMask("Transition");
    self.fbo01 = fbo01
    self.fbo02 = fbo02
    self.bInitTransition = true
end


--添加转场
function VideoScene:AddTransitionNode(transitionInfo)

    if self.bInitTransition == false then
        self:InitTransitionEvn()
    end

    --转场专用quad,转场材质是全屏显示,无法设置transform。接受转场前后两个视频纹理，输出融合纹理
    local transitionMat = "comm:documents/shaders/transition/" .. transitionInfo.path ..".material"
    local transitionNode = TransitionNode(self.videoScene,transitionMat)
    
    --一开始先关闭,seek时再打开
    transitionNode:SetActive(false)
    transitionNode:SetLayer("Transition")
    transitionNode:SetRenderOrder(MAX_RENDERORDER)

    transitionNode:SetParameter("_PrevTexture",self.fbo01.color)
    transitionNode:SetParameter("_NextTexture",self.fbo02.color)
    transitionNode:SetParameter("_Progress",mathfunction.vector1(0.0))

    self.transitionNodeMap[transitionInfo.clipId] = transitionNode
    self.videoClipInfoMap[transitionInfo.clipId] = transitionInfo

end

--todo: 删除转场
function VideoScene:DeleteTransition(id)
    self.transitionNodeMap[id]:SetActive(false)
end


function VideoScene:ClearFbo()
    --关闭不需要显示的medianode
    for _,node in pairs(self.mediaNodeMap) do
        node:SetActive(false)
    end

    for _,node in pairs(self.transitionNodeMap) do
        node:SetActive(false)
    end
end




function VideoScene:SeekTo(clipId,ts)
    self.mediaNodeMap[clipId]:SeekTo(ts)
end


return VideoScene