local apolloengine = require "apolloengine"
local mathfunction = require "mathfunction"
local QuadNode = require "videoclip.quadnode"

local MediaNode = QuadNode:extend()

function MediaNode:new(scene,path)
    MediaNode.super.new(self,scene)
    local mediaComponent = self.node:CreateComponent(apolloengine.Node.CT_MEDIA_PLAYER)
    mediaComponent.path = path
    mediaComponent.renderInfo[1].textureUniformName = "_MainTex"
    mediaComponent.renderInfo[1].chosen = true
    mediaComponent.renderInfo[1].loop = true
    mediaComponent:Play()
    
    --self:BindMainTexture("DEVICE_CAPTURE")

    self.media = mediaComponent
    self.path = path
    --self.duration = self.media:GetDuration(0)
end


function MediaNode:Seek(timePointInMs,speed)
    --local ret = self.media:SeekFrame(timePointInMs)
    WARNING("[MediaNode] Seek     Ts: " .. timePointInMs .. ", Speed : " .. speed .. ", path : " .. self.path)
    --self.media:GetDuration(timePointInMs)
end

function MediaNode:SeekTo(ts)
    WARNING("[MediaNode] Seek     Ts: " .. ts ..  ", path : " .. self.path)
    self.media:GetDuration(ts)
    --self.media:Pause()
end


function MediaNode:GetDuration()
    return self.duration           --单位是微秒,
end

return MediaNode
