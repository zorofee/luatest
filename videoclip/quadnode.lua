local apolloengine = require "apolloengine"
local mathfunction = require "mathfunction"
local SceneNode = require "videoclip.scenenode"

local QuadNode = SceneNode:extend()

function QuadNode:new(scene,mat)
    QuadNode.super.new(self,scene)

    self.trans = self.node:CreateComponent(apolloengine.Node.CT_TRANSFORM)
    self.render = self.node:CreateComponent(apolloengine.Node.CT_RENDER)
    if mat~= nil then
        self:CreateResource(mat)
    else
        self:CreateResource("comm:documents/shaders/opaque/quad_fixed.material")
    end

    --for test
    --self:SetLocalScale(mathfunction.vector3(0.5,0.5,1.0))
    --self:SetLocalPosition(mathfunction.vector3(0.2,0.2,1.0))
    --self:SetLayer("Default")
end


function QuadNode:CreateResource(materialpath, flip, flat)
    self.render:PushMetadata(
      apolloengine.RenderObjectMaterialMetadata(
        apolloengine.PathMetadata(materialpath)));
    flip = flip or false;
    flat = flat or false;
    self.render:PushMetadata(
          apolloengine.RenderObjectMeshMetadate( 
              apolloengine.RenderComponent.RM_TRIANGLES,      
        apolloengine.QuadVertexMetadata(flip, flat),
        apolloengine.QuadIndicesMetadata()));
    return self.render:CreateResource();
end


function QuadNode:SetLocalPosition(pos)
    self.trans:SetLocalPosition(pos)
end

function QuadNode:SetLocalScale(scale)
    self.trans:SetLocalScale(scale)
end

function QuadNode:SetMainTexture(color)
    self.render:SetParameter("_MainTex",color)
end

function QuadNode:BindMainTexture(path)
    local tex = apolloengine.TextureEntity()
    tex:PushMetadata(apolloengine.TextureReferenceMetadata(path))
    tex:CreateResource()
    self.render:SetParameter("_MainTex",tex)
end

function QuadNode:SetParameter(name,value)
    self.render:SetParameter(name,value)
end

function QuadNode:SetLayer(layer)
    self.node:SetLayer(layer)
end

function QuadNode:SetRenderOrder(order)
    self.render:SetRenderOrder(order)
end

function QuadNode:SetActive(bActive)
    self.render.Active = bActive
end

function QuadNode:SetSequence(sequence)
    self.render:SetSequence(sequence)
end

return QuadNode