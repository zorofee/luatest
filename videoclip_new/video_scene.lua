local Object = require "classic"
local venuscore = require "venuscore"
local BundleSystem = require "venuscore.bundle.bundlesystem"
local apolloengine = require "apollocore"
local mathfunction = require "mathfunction"
local QuadNode = require "videoclip_new.quadnode"
local CameraNode = require "videoclip_new.cameranode"
local VideoScene = Object:extend()


function VideoScene:new()
    WARNING("[VideoScene] new VideoScene")
    self.renderoNodeList = {}
    self.videoScene = apolloengine.SceneManager:CreateScene("VideoScene")
    self.mainCamera = self:_CreateCamera("Default",mathfunction.Color(0.0,1,0,1))
end

function VideoScene:Reset()
    for i=1,#self.renderoNodeList do
        self.renderoNodeList[i].Active = false
    end
end

function VideoScene:AddCameraEffect(effectInfo)
    self.mainCamera:CreatePostEffect(effectInfo)
end

function VideoScene:AddMediaNode(clipInfo)
    self:_CreateMediaNode(clipInfo.pos,clipInfo.scale,clipInfo.path)
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



function VideoScene:_CreateMediaNode(pos,scele,path)
    --local mediaNode = self:_CreateQuad("Default",2,"DEVICE_CAPTURE")
    
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



function VideoScene:_CreateRenderTarget()
    local rt = apolloengine.RenderTargetEntity()
    rt:PushMetadata(
        apolloengine.RenderTargetMetadata(
            apolloengine.RenderTargetEntity.RT_RENDER_TARGET_2D,
            apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
            apolloengine.Framework:GetViewport(),
            apolloengine.Framework:GetResolution()));

    local color = rt:MakeTextureAttachment(apolloengine.RenderTargetEntity.TA_COLOR_0);
          color:PushMetadata(--创建纹理
            apolloengine.TextureRenderMetadata(
            apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
            apolloengine.Framework:GetResolution()));

    rt:CreateResource()
    local fbo = {rendertarget = rt,color = color}
    return fbo
    
end



return VideoScene