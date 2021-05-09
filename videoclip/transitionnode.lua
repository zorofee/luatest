local apolloengine = require "apolloengine"
local mathfunction = require "mathfunction"
local QuadNode = require "videoclip.quadnode"

local TransitionNode = QuadNode:extend()

function TransitionNode:new(scene)
    TransitionNode.super.new(self,scene,"comm:documents/shaders/transition/rotate.material")
end


return TransitionNode