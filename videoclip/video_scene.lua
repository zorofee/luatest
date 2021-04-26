local Object = require "classic"
local venuscore = require "venuscore"
local BundleSystem = require "venuscore.bundle.bundlesystem"
local apolloengine = require "apollocore"
local mathfunction = require "mathfunction"
local QuadNode = require "videoclip.quadnode"
local CameraNode = require "videoclip.cameranode"
local VideoScene = Object:extend()


function VideoScene:new()
    local defaultLayer = "Default"
    local defaultColor = mathfunction.Color(0.5,0.0,0.0,1)
    self.renderoNodeList = {}
    self.videoScene = apolloengine.SceneManager:CreateScene("VideoScene")
    self.mainCamera = self:_CreateCamera(defaultLayer,defaultColor)
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

    local mediaNode = QuadNode(self.videoScene)
    mediaNode:BindMainTexture("DEVICE_CAPTURE")
    --测试mediacomponent
    --[[
    local mediaComponent = mediaNode:CreateComponent(apolloengine.Node.CT_MEDIA_PLAYER)
    if mediaComponent ~= nil then
        mediaComponent.path = path
        mediaComponent.renderInfo[1].textureUniformName = "_MainTex"
        mediaComponent.renderInfo[1].chosen = true
        mediaComponent.renderInfo[1].loop = true
        mediaComponent:Play()
    end
    ]]
end


return VideoScene