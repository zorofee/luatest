require "videoclip.videoutility"
local mathfunction = require "mathfunction"
local apolloengine = require "apollocore"
local venusjson = require "venusjson"
local apollonode = require "apolloutility.apollonode"
local VideoScene = require "videoclip.video_scene"
local MainScene = require "videoclip.main_scene"
local QuadNode = require "videoclip.quadnode"
local VideoSceneView = {}


--[[
一、场景结构：
1.cutterScene
    --MainQuad(VideoMainScene) <|-----|
                                      |
                                     fbo
2.mainScene                           |
    --MainCamera  (GlobalFilter) -----|
    --BgQuad      (ClearColor or Image)
    --TransitionQuad (Fbo From Transition Scene) <|-----|
    --VideoQuad01 (VideoScene01) <|----|                |
    --VideoQuad02 (VideoScene02)       |                |
                                       |                |
                                      fbo               |
3.videoScene01                         |               fbo
    --MainCamera(VideoFilter)----------|                |
    --QuadNode(DEVICE_CAPTURE)                          |
                                                        |
4.transitionScene                                       |
    --MainCamera    ------------------------------------|
    --QuadNode(TransitionMaterial)



二、MainScene中的渲染层级
    background < video quads < transition quad
]]


function VideoSceneView:Initialize()
    --view层缓存场景相关数据
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


------设置相机------
function VideoSceneView:SetCanvasAspectRatio(ratioX,ratioY)
    self.mainScene:SetCanvasAspectRatio(ratioX,ratioY)
end


------设置背景-----
function VideoSceneView:SetCanvasBGImage(path)
    self.mainScene:SetCanvasBGImage(path)
end

function VideoSceneView:SetCanvasBGColor(color)
  self.mainScene:SetCanvasBGColor(color)
end


------添加轨道-----
function VideoSceneView:AddVideoTrack(trackId,trackInfo)
    WARNING("[Add Video Track]" .. trackId)
    --新增一条视频轨道,需要创建新的VideoScene
    local videoScene = VideoScene()
    local fbo = CreateRenderTarget()
    videoScene:BindRenderTarget(fbo)

    --在MainScene中创建显示视频画面的Quad,与VideoScene输出的fbo绑定
    local videoQuad = self.mainScene:CreateVideoQuad(trackId,fbo.color)
    self.trackSceneMap[trackId] = videoScene
    self.trackQuadMap[trackId] = videoQuad
    return trackId
end


------添加视频----
function VideoSceneView:AddVideoClip(trackId,clipId,clipInfo)
    local videoScene = self.trackSceneMap[trackId]
    local videoQuad = self.trackQuadMap[trackId]
    if videoScene ~= nil then
        WARNING("[Add Video Clip]" .. clipId)
        videoScene:AddMediaNode(clipInfo)
        videoQuad:SetActive(true)

        self.videoClipQuadMap[clipId] = videoQuad
        self.videoClipSceneMap[clipId] = videoScene
        return true
    else
        return false
    end
end


------更新transform------
function VideoSceneView:UpdateClipPosition(clipId,pos)
    self.videoClipQuadMap[clipId]:SetLocalPosition(pos)
end

function VideoSceneView:UpdateClipRotation(clipId,rot)
    self.videoClipQuadMap[clipId]:SetLocalRotation(rot)
end

function VideoSceneView:UpdateClipScale(clipId,scale)
    self.videoClipQuadMap[clipId]:SetLocalScale(scale)
end


-------添加滤镜-----
function VideoSceneView:AddVideoSceneFilter(clipId,effectInfo)
    self.videoClipSceneMap[clipId]:AddCameraEffect(effectInfo)
end

function VideoSceneView:AddMainSceneFilter(effectInfo)
    self.mainScene:AddCameraEffect(effectInfo)
end

-------设置可见性-----
function VideoSceneView:SetVideoClipVisiable(clipId,bVisiable)
    self.videoClipQuadMap[clipId]:SetActive(bVisiable)
end



return VideoSceneView