local apolloengine = require "apolloengine"
local mathfunction = require "mathfunction"
local SceneNode = require "videoclip_new.scenenode"
local PostEffect = require "apolloutility.apollonode.posteffect"

local CameraNode = SceneNode:extend()

function CameraNode:new(scene)
    CameraNode.super:new(scene)
    self.camera = self.node:CreateComponent(apolloengine.Node.CT_CAMERA)
    local near = 0.1
    local far = 1000
    local pos = mathfunction.vector3(0,0,1)
    local resolution = mathfunction.vector2(320,420)
    local lookat = mathfunction.vector3(0,0,0)
    local up = mathfunction.vector3(0,1,0)

    --cameraComponent:FixedResolution(resolution)
    self.camera:CreatePerspectiveProjection(near,far)
    self.camera:LookAt(pos,lookat,up)
    self.camera:Recalculate()
    self.camera:Activate()
end


function CameraNode:AttachRenderTarget(rt)
    self.camera:AttachRenderTarget(rt)
end

function CameraNode:GetCameraComponent()
    return self.camera
end

function CameraNode:AddLayerMask(layer)
    self.camera:AddLayerMask(layer)
end


function CameraNode:SetClearColor(clearcolor)
    self.camera:SetClearColor(clearcolor)
end

function CameraNode:AddLayerMask(layer)
    self.camera:AddLayerMask(layer)
end

function CameraNode:CreatePostEffect(effectInfo)
    self.post = PostEffect(self.camera:CreatePostEffect())
    self.post:CreateResource("comm:script/apolloengine/posteffect/" .. effectInfo.effectName ..".lua") 
    self.post:RegisterParameter("Blurriness");
    self.post:Blurriness(10);
end

return CameraNode