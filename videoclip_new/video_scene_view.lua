local mathfunction = require "mathfunction"
local apolloengine = require "apollocore"
local venusjson = require "venusjson"
local apollonode = require "apolloutility.apollonode"
local VideoScene = require "videoclip_new.video_scene"
local MainScene = require "videoclip_new.main_scene"
local QuadNode = require "videoclip_new.quadnode"
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
  WARNING("******SetCanvasBGColor********444***")
  self.mainScene:SetCanvasBGColor(color)
end


function VideoSceneView:AddVideoTrack(trackId,trackInfo)
    WARNING("****************Add Video Track**************" .. trackId)
    --新增一条视频轨道,需要创建新的VideoScene
    local videoScene = VideoScene()
    local fbo = self:_CreateRenderTarget()
    videoScene:BindRenderTarget(fbo)

    --在MainScene中创建显示视频画面的Quad,与VideoScene输出的fbo绑定
    local videoQuad = self.mainScene:CreateVideoQuad("Default",trackId,fbo.color)
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
        videoQuad:SetActive(true)

        self.videoClipQuadMap[clipId] = videoQuad
        self.videoClipSceneMap[clipId] = videoScene
        return true
    else
        return false
    end
end


function VideoSceneView:SetClipPosition(clipId,pos)
    self.videoClipQuadMap[clipId]:SetLocalPosition(pos)
end

function VideoSceneView:SetClipRotation(clipId,rot)
    self.videoClipQuadMap[clipId]:SetLocalRotation(rot)
end

function VideoSceneView:SetClipScale(clipId,scale)
    self.videoClipQuadMap[clipId]:SetLocalScale(scale)
end


function VideoSceneView:AddVideoSceneFilter(clipId,effectInfo)
    self.videoClipSceneMap[clipId]:AddCameraEffect(effectInfo)
end

function VideoSceneView:AddMainSceneFilter(effectInfo)
    self.mainScene:AddCameraEffect(effectInfo)
end

function VideoSceneView:SetVideoClipVisiable(clipId,bVisiable)
    self.videoClipQuadMap[clipId]:SetActive(bVisiable)
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