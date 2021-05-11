local apolloengine = require "apolloengine"
local mathfunction = require "mathfunction"
local QuadNode = require "videoclip.quadnode"

local TransitionNode = QuadNode:extend()

function TransitionNode:new(scene,matPath)
    TransitionNode.super.new(self,scene,matPath)
end


return TransitionNode