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
    --VideoQuad01 (VideoScene01) <|----|                
    --VideoQuad02 (VideoScene02)       |               
                                       |           
                                      fbo               
3.videoScene01                         |              
    --MainCamera(VideoFilter)----------|                
    --MediaNode01(MediaComponent)                           
    --MediaNode02(MediaComponent)        
    --TransitionQuad <|---------------------------------|------|
                                                      fbo1    fbo2
    --TransitionCamera01  ------------------------------|      |
    --TransitionCamera02  -------------------------------------|


二、VideoScene中的渲染层级
    background < video quads < transition quad
]]


function VideoSceneView:Initialize()
    --view层缓存场景相关数据
    self.mainScene = {}
    self.trackSceneMap = {}           --<trackId,videoScene>
    self.trackQuadMap = {}            --<trackId,videoQuad>
    self.videoClipQuadMap = {}        --<clipId,videoQuad>
    self.videoClipSceneMap = {}       --<clipId,videoScene>
    self.videoClipTransformMap = {}   --<clipId,transform>
    self.videoClipInfoMap = {}        --<clipId,clipInfo>
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
function VideoSceneView:AddVideoTrack(trackId)
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
        videoQuad:SetRenderOrder(trackId)
        videoQuad:SetActive(true)

        self.videoClipQuadMap[clipId] = videoQuad
        self.videoClipSceneMap[clipId] = videoScene
        self.videoClipInfoMap[clipId] = clipInfo
        return true
    else
        return false
    end
end

function VideoSceneView:RemoveVideoClip(clipId)
    self.videoClipQuadMap[clipId]:SetActive(false)
    self.videoClipSceneMap[clipId]:DeleteMediaNode(clipId)
end


------更新transform------
function VideoSceneView:UpdateClipPosition(clipId,pos)
    self.videoClipQuadMap[clipId]:SetLocalPosition(pos)
end

function VideoSceneView:UpdateClipRotation(clipId,rot)
    local rotation = mathfunction.Quaternion()
    rotation:RotateXYZ(rot:x(),rot:y(),rot:z())
    self.videoClipQuadMap[clipId]:SetLocalRotation(rotation)
end

function VideoSceneView:UpdateClipScale(clipId,scale)
    self.videoClipQuadMap[clipId]:SetLocalScale(scale)
end

function VideoSceneView:UpdateClipTransform(clipId)

    local transform = self.videoClipTransformMap[clipId]
    self:UpdateClipPosition(clipId,transform.pos)
    self:UpdateClipRotation(clipId,transform.rotation)
    self:UpdateClipScale(clipId,transform.scale)
    self.videoClipQuadMap[clipId]:SetActive(true)
end

function VideoSceneView:SetClipTransform(clipId,transform)
    self.videoClipTransformMap[clipId] = transform
    self:UpdateClipTransform(clipId)
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



--Todo: 镜像翻转
function VideoSceneView:SetClipMirror(clipId)

end

--Todo: 设置静音
function VideoSceneView:SetClipAudioMute(clipId,bMute)

end



--转场  Todo : Delete,Modify,Copy
function VideoSceneView:AddTransition(transitionInfo)
    local frontVideoId = transitionInfo.frontVideoId
    local backVideoId = transitionInfo.frontVideoId
    local videoScene = self.videoClipSceneMap[frontVideoId]

    self.videoClipSceneMap[transitionInfo.clipId] = videoScene
    self.videoClipInfoMap[transitionInfo.clipId] = transitionInfo
    
    videoScene:AddTransitionNode(transitionInfo)
end

function VideoSceneView:DeleteTransition(id)
    self.videoClipSceneMap[id]:DeleteTransition(id)
end


--先清除所有显示的quad以及scene中的状态, 后续可优化
function VideoSceneView:ClearFbo()
    for id,quad in pairs(self.videoClipQuadMap) do
        quad:SetActive(false)
    end

    for id,scene in pairs(self.trackSceneMap) do
        scene:ClearFbo()
    end

end


--[[
ids:所有在当前时间戳需要显示的VideoClipId; ts:当前时间戳
1.关闭所有的VideoQuad
2.将需要显示的VideoQuad激活,并更新位置
3.找到对应的VideoScene,通过Scene中的medianode完成seekframe

todo:SeekFrame需要根据换算成相对时间戳
]]
function VideoSceneView:ProcessVideo(ids,ts)
    for i=1,#ids do
        local id = ids[i]
        self:UpdateClipTransform(id)
        self.videoClipSceneMap[id]:SeekFrame(id,ts)
    end

end

--[[
ids:所有在当前时间戳需要显示的TransitionClipId; ts:当前时间戳
1.由于转场帧一定发生在VideoClip帧后,因此不需要做状态上的重置
2.找到对应的VideoScene,通过Scene中的medianode完成seekframe; 转场可能需要seek前后两个视频的帧
]]
function VideoSceneView:ProcessTransition(ids,ts)
    for i=1,#ids do
        local id = ids[i]
        local info = self.videoClipInfoMap[id]
        local progress = (ts - info.logicStartTs)/(info.logicEndTs - info.logicStartTs)

        --update video quad
        if progress <= 0.5 then
            self:UpdateClipTransform(info.frontVideoId)
        else
            self:UpdateClipTransform(info.backVideoId)
        end


        --update video frame
        if info.strategy == 1 then
            --同时只有一个clip在渲染
            if progress <= 0.5 then
                self.videoClipSceneMap[id]:SeekFrame(info.frontVideoId,ts)
            else
                self.videoClipSceneMap[id]:SeekFrame(info.backVideoId,ts)
            end

        elseif info.strategy == 2 then
            --同时有两个clip在渲染
            self.videoClipSceneMap[id]:SeekFrame(info.frontVideoId,ts)
            self.videoClipSceneMap[id]:SeekFrame(info.backVideoId,ts)
        end

        --update transition
        self.videoClipSceneMap[id]:UpdateTransition(id,ts)
    end
end





function VideoSceneView:SeekTo(clipId,ts)
    self.videoClipSceneMap[clipId]:SeekTo(clipId,ts)
end



return VideoSceneView
