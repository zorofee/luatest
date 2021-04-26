local mathfunction = require "mathfunction"
local apolloengine = require "apollocore"
local venusjson = require "venusjson"
local apollonode = require "apolloutility.apollonode"
local VideoScene = require "videoclip_new.video_scene"
local MainScene = require "videoclip_new.main_scene"
local VideoSceneView = {}

function VideoSceneView:Initialize()
    --显示层
    self.mainScene = {}
    self.trackSceneMap = {}      --<trackId,videoScene>
    self.trackQuadMap = {}       --<trackId,videoQuad>

    self.videoClipQuadMap = {}   --<clipId,videoScene>
    self.videoClipSceneMap = {}  --<clipId,videoQuad>
end


function VideoSceneView:Reset()
   self.mainScene:Reset()
   for _,scene in pairs(self.trackSceneMap) do
        scene:Reset()
   end
   self:Initialize()
end


function VideoSceneView:CreateMainScene()
    self.mainScene = MainScene()
end



function VideoSceneView:SetCanvasAspectRatio(ratioX,ratioY)
    self.mainScene:SetCanvasAspectRatio(ratioX,ratioY)
end

function VideoSceneView:SetCanvasBGColor(color)
    self.mainScene:SetCanvasBGColor(color)
end


function VideoSceneView:AddVideoTrack(trackId,trackInfo)
    WARNING("****************Add Video Track**************" .. trackId)
    --新增一条视频轨道,需要创建新的VideoScene
    local videoScene = VideoScene()
    local fbo = self:_CreateRenderTarget()
    videoScene:BindRenderTarget(fbo)

    --在MainScene中创建显示视频画面的Quad,与VideoScene输出的fbo绑定
    local videoQuad = self.mainScene:CreateRenderNode("Default")
    videoQuad:GetComponent(apolloengine.Node.CT_RENDER):SetParameter("_MainTex",fbo.color)
    videoQuad.Active = false
    self.trackSceneMap[trackId] = videoScene
    self.trackQuadMap[trackId] = videoQuad
    return trackId
end

function VideoSceneView:AddVideoClip(trackId,clipId,clipInfo)
    local videoScene = self.trackSceneMap[trackId]
    local videoQuad = self.trackQuadMap[trackId]
    if videoScene ~= nil then
        WARNING("****************Add Video Clip**************" .. clipId)
        videoScene:AddMediaNode(clipInfo)
        videoQuad.Active = true
        self.videoClipQuadMap[clipId] = videoQuad
        self.videoClipSceneMap[clipId] = videoScene
        return true
    else
        return false
    end
end


function VideoSceneView:SetClipPosition(clipId,pos)
    self.videoClipQuadMap[clipId]:GetComponent(apolloengine.Node.CT_TRANSFORM):SetLocalPosition(pos)
end

function VideoSceneView:SetClipRotation(clipId,rot)
    self.videoClipQuadMap[clipId]:GetComponent(apolloengine.Node.CT_TRANSFORM):SetLocalRotation(rot)
end

function VideoSceneView:SetClipScale(clipId,scale)
    self.videoClipQuadMap[clipId]:GetComponent(apolloengine.Node.CT_TRANSFORM):SetLocalScale(scale)
end


function VideoSceneView:AddVideoSceneFilter(clipId,effectInfo)
    self.videoClipSceneMap[clipId]:AddCameraEffect(effectInfo)
end

function VideoSceneView:AddMainSceneFilter(effectInfo)
    self.mainScene:AddCameraEffect(effectInfo)
end














--创建quad,承载其他场景渲染的纹理
function VideoSceneView:_CreateQuad(layer,defaultmat)
    local quad = self.mainScene:CreateNode(apolloengine.Node.CT_NODE)
    local trans = quad:CreateComponent(apolloengine.Node.CT_TRANSFORM)
    local render = quad:CreateComponent(apolloengine.Node.CT_RENDER)
    quad:SetLayer(layer)

    if defaultmat == nil then
        render:PushMetadata(
            --这里的quad shader有修改过
            apolloengine.RenderObjectMaterialMetadata(apolloengine.PathMetadata("comm:documents/shaders/opaque/quad.material"))
        )
    elseif defaultmat ~= "" then
        render:PushMetadata(
            --这里的quad材质有修改过
            apolloengine.RenderObjectMaterialMetadata(apolloengine.PathMetadata(defaultmat))
        )
    end

    render:PushMetadata(
        apolloengine.RenderObjectMeshFileMetadate("comm:documents/basicobjects/quad/data/plane001.mesh")
    )
    render:CreateResource();


    return quad
end

--创建FBO和纹理
function VideoSceneView:_CreateRenderTarget()
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


return VideoSceneView