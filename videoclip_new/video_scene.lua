local Object = require "classic"
local venuscore = require "venuscore"
local BundleSystem = require "venuscore.bundle.bundlesystem"
local apolloengine = require "apollocore"
local mathfunction = require "mathfunction"
local PostEffect = require "apolloutility.apollonode.posteffect"
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
    self.post = PostEffect(self.mainCamera:CreatePostEffect())
    self.post:CreateResource("comm:script/apolloengine/posteffect/" .. effectInfo.effectName ..".lua") 
    self.post:RegisterParameter("Blurriness");
    self.post:Blurriness(10);
end

function VideoScene:AddMediaNode(clipInfo)
    self:_CreateMediaNode(clipInfo.pos,clipInfo.scale,clipInfo.path)
end


function VideoScene:BindRenderTarget(fbo)
    self.mainCamera:AttachRenderTarget(fbo.rendertarget)
end


function VideoScene:CreateRenderNode(layer)
    local node = self:_CreateQuad(layer,3)
    return node
end




function VideoScene:_CreateCamera(layer,clearcolor,fbo)
    local camera = self.videoScene:CreateNode(apolloengine.Node.CT_NODE)
    local cameraComponent = camera:CreateComponent(apolloengine.Node.CT_CAMERA)
    local near = 0.1
    local far = 1000
    local pos = mathfunction.vector3(0,0,1)
    local resolution = mathfunction.vector2(320,420)
    local lookat = mathfunction.vector3(0,0,0)
    local up = mathfunction.vector3(0,1,0)

    cameraComponent:AddLayerMask(layer)
    --cameraComponent:FixedResolution(resolution)
    cameraComponent:CreatePerspectiveProjection(near,far)
    cameraComponent:LookAt(pos,lookat,up)
    cameraComponent:Recalculate()
    cameraComponent:Activate()
    cameraComponent:SetClearColor(clearcolor)
    
    if fbo ~= nil then
        cameraComponent:AttachRenderTarget(fbo.rendertarget)
    end

    return cameraComponent
end

function VideoScene:_AddCameraLayerMask(layer)
    self.mainCamera:AddLayerMask(layer)
end


function VideoScene:_CreateMediaNode(pos,scele,path)
    local mediaNode = self:_CreateQuad("Default",2)

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


function VideoScene:_CreateQuad(layer,renderOrder)
    local quad = self.videoScene:CreateNode(apolloengine.Node.CT_NODE)
    local trans = quad:CreateComponent(apolloengine.Node.CT_TRANSFORM)
    local render = quad:CreateComponent(apolloengine.Node.CT_RENDER)
    trans:SetLocalScale(mathfunction.vector3(0.5,0.5,1.0))
    quad:SetLayer(layer)

    -- render:PushMetadata(
    --     --这里的quad shader有修改过
    --     --apolloengine.RenderObjectMaterialMetadata(apolloengine.PathMetadata("comm:documents/shaders/opaque/quad.material"))
    --     apolloengine.RenderObjectMaterialMetadata(apolloengine.PathMetadata("comm:documents/material/imageblit.material"))
    -- )

    -- render:PushMetadata(
    --     apolloengine.RenderObjectMeshFileMetadate("comm:documents/basicobjects/quad/data/plane001.mesh")
    -- )
    -- render:CreateResource();
    self:CreateRenderResource(render,"comm:documents/shaders/opaque/quad.material")

    render:SetRenderOrder(renderOrder)
    
    local entity = apolloengine.TextureEntity()
    entity:PushMetadata(apolloengine.TextureReferenceMetadata("DEVICE_CAPTURE"))
    entity:CreateResource()
    render:SetParameter("_MainTex",entity)

    table.insert(self.renderoNodeList,quad)
    return quad
end


function VideoScene:CreateRenderResource(render,materialpath, flip, flat)
    render:PushMetadata(
      apolloengine.RenderObjectMaterialMetadata(
        apolloengine.PathMetadata(materialpath)));
    flip = flip or false;
    flat = flat or false;
    render:PushMetadata(
          apolloengine.RenderObjectMeshMetadate( 
              apolloengine.RenderComponent.RM_TRIANGLES,      
        apolloengine.QuadVertexMetadata(flip, flat),
        apolloengine.QuadIndicesMetadata()));
    return render:CreateResource();
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