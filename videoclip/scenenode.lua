local apolloengine = require "apolloengine"
local mathfunction = require "mathfunction"
local Object = require "classic"
local SceneNode = Object:extend()

function SceneNode:new(scene)
    self.node = scene:CreateNode(apolloengine.Node.CT_NODE)
end

function SceneNode:CreateComponent(comtype)

end

function SceneNode:GetComponent(type)
    return self.node:GetComponent(type)
end

function SceneNode:GetName()
    return self.node:GetName()
end

return SceneNode