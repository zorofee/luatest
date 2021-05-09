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

    self.videoClipQuadMap = {}   --<clipId,videoQuad>
    self.videoClipSceneMap = {}  --<clipId,videoScene>

    --帧数据
    self.videoFrameItemList = {}  --vector<VideoFrameItem>

    self.videoClipInfoMap = {}
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
        videoScene:AddMediaNode(clipInfo)
        videoQuad:SetActive(true)

        self.videoClipQuadMap[clipId] = videoQuad
        self.videoClipSceneMap[clipId] = videoScene
        WARNING("[Add Video Clip]" .. clipId .. " ,sceneNum: " .. #self.videoClipSceneMap)

        self.videoClipInfoMap[clipId] = clipInfo
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




------------Seek Frame---------
function VideoSceneView:Seek(frameIndex)
    --对每个scene中的medianode进行seek
    for trackId,trackScene in pairs(self.trackSceneMap) do
        local clipId = trackScene:Seek(frameIndex)
        if clipId ~= nil then
            WARNING("--------SEEK FRAME---------frame:" .. frameIndex ..",track: " .. trackId .. " , clip:" .. clipId .. "   " .. 
                tostring(self.videoClipInfoMap[clipId].pos) .. "   " .. tostring(self.videoClipInfoMap[clipId].scale))
            
            self.trackQuadMap[trackId]:SetLocalPosition(self.videoClipInfoMap[clipId].pos)
            self.trackQuadMap[trackId]:SetLocalScale(self.videoClipInfoMap[clipId].scale)
            self.trackQuadMap[trackId]:SetActive(true)
        else
            self.trackQuadMap[trackId]:SetActive(false)
        end
    end
end

-----------Add Transition----------
function VideoSceneView:AddTransition(trackId,transitionInfo)

    --隐藏原先的videoquad
    self.videoClipQuadMap[transitionInfo.frontVideoId]:SetActive(false) 
    --self.videoClipQuadMap[transitionInfo.backVideoId]:SetActive(false)

    --新建两个fbo和两个videoquad用来显示需要转场的前后两段视频帧画面
    local fbo1 = CreateRenderTarget()
    local fbo2 = CreateRenderTarget()
    self.trackSceneMap[trackId]:AddTransitionNode(transitionInfo,fbo1,fbo2)

    local transitionQuad1 = self.mainScene:CreateVideoQuad(trackId + 1,fbo1.color)
    transitionQuad1:SetLocalPosition(self.videoClipInfoMap[transitionInfo.frontVideoId].pos)    --pos 和 scale应该与clip保持一致
    transitionQuad1:SetLocalScale(self.videoClipInfoMap[transitionInfo.frontVideoId].scale)    
    transitionQuad1:SetActive(true)
    transitionQuad1:SetLayer("transition1")

    local transitionQuad2 = self.mainScene:CreateVideoQuad(trackId + 1,fbo2.color)
    transitionQuad2:SetLocalPosition(self.videoClipInfoMap[transitionInfo.backVideoId].pos)
    transitionQuad2:SetLocalScale(self.videoClipInfoMap[transitionInfo.backVideoId].scale)
    transitionQuad2:SetActive(true)
    transitionQuad2:SetLayer("transition2")

end

function VideoSceneView:SetTransitionProgress(progress)
    self.mainScene:SetTransitionProgress(progress)
end




return VideoSceneView