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

    self.media = mediaComponent
    self.duration = self.media:GetDuration(0)
end


function MediaNode:Seek(timePointInMs)
   -- local ret = self.media:SeekFrame(timePointInMs)
end


function MediaNode:GetDuration()
    return self.duration/100000    --4300 000  返回的单位是微秒,
end

return MediaNode