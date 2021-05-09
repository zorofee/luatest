local apolloengine = require "apolloengine"
local mathfunction = require "mathfunction"
local QuadNode = require "videoclip.quadnode"

local MediaNode = QuadNode:extend()

function MediaNode:new(scene)
    MediaNode.super.new(self,scene)
    self.media = self.node:CreateComponent(apolloengine.Node.CT_MEDIA_PLAYER)
end

function MediaNode:Seek(frameIndex)

end


return MediaNode