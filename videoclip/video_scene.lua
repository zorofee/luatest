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


local ClipType = {
    VIDEO = 0,
    TRANSITION = 1
}

function VideoScene:new()
    local defaultLayer = "Default"
    local defaultColor = mathfunction.Color(0.5,0.0,0.0,1)

    self.sceneName = "VideoScene"
    self.renderoNodeList = {}
    self.videoScene = apolloengine.SceneManager:CreateScene("VideoScene")
    self.mainCamera = self:_CreateCamera(defaultLayer,defaultColor)

    self.mediaNodeMap = {}
    self.clipInfoMap = {}

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



function VideoScene:AddMediaNode(clipInfo)
    clipInfo.type = ClipType.VIDEO

    local mediaNode = MediaNode(self.videoScene)
    --mediaNode:BindMainTexture("DEVICE_CAPTURE")


    --对视频进行解码和帧数据缓存
    local mediaComponent = mediaNode.node:GetComponent(apolloengine.Node.CT_MEDIA_PLAYER)
    if mediaComponent ~= nil then
        mediaComponent.path = clipInfo.path
        mediaComponent.renderInfo[1].textureUniformName = "_MainTex"
        mediaComponent.renderInfo[1].chosen = true
        mediaComponent.renderInfo[1].loop = true
        mediaComponent:Play()
        WARNING("Media Node Play : " .. clipInfo.path)
    end

    self.clipInfoMap[clipInfo.clipId] = clipInfo
    self.mediaNodeMap[clipInfo.clipId] = mediaNode
    
  
end

-------------------------Seek Frames------------------------------

function VideoScene:Seek(frameIndex)

    --通过比较startTs和endTs来找到frameIndex对应的videoClip
     for clipId,info in pairs(self.clipInfoMap) do
          --先判断当前帧是否为转场
          --[[
          if info.type == ClipType.TRANSITION then
            self.mediaNodeMap[info.frontVideoId]:SetActive(true)
            self.mediaNodeMap[info.frontVideoId]:Seek(frameIndex)
            self.mediaNodeMap[info.backVideoId]:SetActive(true)
            self.mediaNodeMap[info.backVideoId]:Seek(frameIndex)

          end
            ]]
          if frameIndex >=info.startTs and frameIndex <= info.endTs then
              --self.mediaNodeMap[clipId]:SetActive(true)
              self.mediaNodeMap[clipId]:SetRenderOrder(1000)
              self.mediaNodeMap[clipId]:Seek(frameIndex)
              return clipId
              --self.mediaNodeMap[clipId]:SetLocalPosition()
          else
              --self.mediaNodeMap[clipId]:SetActive(false)
          end
     end


end

-------------------------Add Transition----------------------------
function VideoScene:AddTransitionNode(tinfo,fbo1,fbo2)
    --创建一个转场的数据结构,如果frameIndex命中转场效果，则获取前后两个clipId的视频帧,传入到转场材质中

    
    --将前后两个videoClip的时间缩短
    --self.clipInfoMap[tinfo.frontVideoId].endTs = self.clipInfoMap[tinfo.frontVideoId].endTs - 2
    --self.clipInfoMap[tinfo.backVideoId].startTs = self.clipInfoMap[tinfo.frontVideoId].startTs + 2

    local transitionClip = {
        id = tinfo.id,
        type = ClipType.TRANSITION,
        startTs = self.clipInfoMap[tinfo.frontVideoId].endTs - 2,
        endTs = self.clipInfoMap[tinfo.backVideoId].startTs + 2,
        frontVideoId = tinfo.frontVideoId,
        backVideoId = tinfo.backVideoId
    }
    self.clipInfoMap[transitionClip.id] = transitionClip

    self.mediaNodeMap[transitionClip.frontVideoId]:SetLayer("transition1")
    self.mediaNodeMap[transitionClip.backVideoId]:SetLayer("transition2")
    
    --self.transitionNode = TransitionNode(self.videoScene)
    self.transitionCamera = CameraNode(self.videoScene)
    self.transitionCamera:AddLayerMask("transition1")
    self.transitionCamera:AttachRenderTarget(fbo1.rendertarget)

    self.transitionCamera = CameraNode(self.videoScene)
    self.transitionCamera:AddLayerMask("transition2")
    self.transitionCamera:AttachRenderTarget(fbo2.rendertarget)
end







---------------------------Video Frame Data-----------------------------




return VideoScene