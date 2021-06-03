local mathfunction = require "mathfunction"
local apolloengine = require "apollocore"
local venusjson = require "venusjson"
local apollonode = require "apolloutility.apollonode"
local VideoSceneView = require "videoclip.video_scene_view"
local VideoClip = require "videoclip.info_video_clip"
local TransitionClip = require "videoclip.info_transition_clip"
require "videoclip.vector"
require "videoclip.map"
require "videoclip.videoutility"
local VideoSceneModel = {}


local TRACK_ID = 0
local CLIP_ID = 0
local EFFECT_ID = 0



function VideoSceneModel:Deserialization()

    local videoClipRanks = self.videoClipRanks
    local videoClipInfoMap = self.videoClipInfoMap
    local videoTrackInfoMap = self.videoTrackInfoMap
    local videoClipTransformMap = self.videoClipTransformMap
    local videoEffectInfoMap = self.videoEffectInfoMap

    self:Initialize()

    for id,info in pairs(videoTrackInfoMap) do
        WARNING("---------Deserialization Track------" .. id)
        self:AddVideoTrack(info)
    end

    for id,info in pairs(videoClipInfoMap) do
        WARNING("---------Deserialization Clip------" .. id)
        self:AddVideoClip(info.trackId,info)
    end

    for id,info in pairs(videoClipTransformMap) do
        WARNING("---------Deserialization Transform------" .. id)
        self:SetClipTransform(id,info)
    end

    for id,info in pairs(videoEffectInfoMap) do
        WARNING("---------Deserialization Effects------" .. id)
        if info.bGlobal then
            self:AddMainSceneFilter(info)
        else
            self:AddVideoSceneFilter(info.clipId,info)
        end
    end
end


--重置场景
function VideoSceneModel:Reset()
    VideoSceneView:Reset()
end



--初始化
function VideoSceneModel:Initialize()
    WARNING("VideoSceneModel:Initialize")
    TRACK_ID = 0
    CLIP_ID = 0
    EFFECT_ID = 0
    TRANSITION_ID = 0

    self.videoClipRanks = {}--vector:new()
    self.videoClipInfoMap = {} --map:new()
    self.videoTrackInfoMap = {} --map:new()
    self.videoClipTransformMap = {}

    VideoSceneView:Initialize()
    VideoSceneView:CreateMainScene()
end

--添加视频轨道
function VideoSceneModel:GetOrAddVideoTrack(trackId)

    if self.videoTrackInfoMap[trackId] then
        --已有轨道
    else
        --新增轨道
        self.videoTrackInfoMap[trackId] = ""
        VideoSceneView:AddVideoTrack(trackId)
    end
end


--添加视频(添加到最后)
function VideoSceneModel:AddVideoClip(trackId,params)
    self:GetOrAddVideoTrack(trackId)

    local clipId = self:_NewClipId()
    local clipInfo = VideoClip(trackId,clipId,params)
    VideoSceneView:AddVideoClip(trackId,clipId,clipInfo)

    if self.videoClipRanks[trackId] == nil then
        self.videoClipRanks[trackId] = vector:new()
    end
    
    --可能不是顺序添加,因此需要排序。同一轨道上的视频不会重叠,只需比较startTs
    local insertPos = self.videoClipRanks[trackId]:size()
    for i=1,self.videoClipRanks[trackId]:size() do
        local tempId = self.videoClipRanks[trackId]:at(i)
        local tempInfo = self.videoClipInfoMap[tempId]
        if tempInfo.logicStartTs > clipInfo.logicStartTs then
            WARNING("[VIDEO TEST]Find clip before: " .. tempId .. " ,at " .. tempInfo.logicStartTs)
            --已经是排好序的,只要找到第一个即可
            insertPos = i - 1
            break
        end
    end
    
    --self.videoClipRanks[trackId]:push_back(clipId)
    self.videoClipRanks[trackId]:insert(insertPos,clipId)
    self.videoClipInfoMap[clipId] = clipInfo
    WARNING("[VIDEO TEST]AddVideoClip : " .. clipId)
    return clipId
end

--删除
function VideoSceneModel:RemoveVideoClip(clipId)
    local clipInfo = self.videoClipInfoMap[clipId]
    if clipInfo~= nil then
        self.videoClipRanks[clipInfo.trackId]:delete(clipId)
        self.videoClipInfoMap[clipId] = nil
        self.videoClipTransformMap[clipId] = nil
        VideoSceneView:RemoveVideoClip(clipId)
    end
end

--插入
function VideoSceneModel:InsertVideoClip(trackId,frontId,params)
    local clipId = self:_NewClipId()
    local clipInfo = VideoClip(trackId,clipId,params)
    clipInfo:SetLogicTs(self.videoClipInfoMap[frontId].logicEndTs + 1)
    VideoSceneView:AddVideoClip(trackId,clipId,clipInfo)

    local frontIndex = self.videoClipRanks[trackId]:find(frontId)
    self:UpdateTimeline(trackId,frontIndex+1,clipInfo.duration)
    self.videoClipRanks[trackId]:insert(frontIndex,clipId)
    self.videoClipInfoMap[clipId] = clipInfo
    return clipId
end


--复制
function VideoSceneModel:CopyVideoClip(originId)
    local originInfo= self.videoClipInfoMap[originId]
    local trackId = originInfo.trackId
    local copyId = self:InsertVideoClip(trackId,originId,originInfo)
    self:SetClipTransform(copyId,self.videoClipTransformMap[originId])
    
    return copyId
end

--裁剪
function VideoSceneModel:CropVideoClip(clipId,startTs,endTs,bShrink)
    local clipInfo = self.videoClipInfoMap[clipId]
    local offset = clipInfo:CropTs(startTs,endTs)
    clipInfo:Print()

    --是否需要后面所有的clip一起 shrink
    if bShrink then
        local backIndex = self.videoClipRanks[clipInfo.trackId]:find(clipId) + 1
        self:UpdateTimeline(clipInfo.trackId,backIndex,-offset)
    end
end


--分割
function VideoSceneModel:SplitVideoClip(originId,splitTs)
    --1.复制
    local copyId = self:CopyVideoClip(originId)

    local originInfo = self.videoClipInfoMap[originId]
    local startTs = originInfo.originStartTs
    local endTs = originInfo.originEndTs
    --2.裁剪
    self:CropVideoClip(originId,startTs,splitTs,true)
    self:CropVideoClip(copyId,splitTs+1,endTs,true)
    
    return copyId
end


--变速
function VideoSceneModel:SetClipSpeed(clipId,speed)
    WARNING("[SetClipSpeed] clipId : " .. clipId .. " , speed : " .. speed)
    local info = self.videoClipInfoMap[clipId]
    local offset =  info.duration - info.duration / speed

    info.duration = info.duration / speed
    info.logicEndTs = info.logicStartTs + info.duration
    info.speed = speed

    local backIndex = self.videoClipRanks[info.trackId]:find(clipId)+1
    self:UpdateTimeline(info.trackId,backIndex,-offset)
end


--转场   To do: 和复制/分割/变速等功能的关联处理
function VideoSceneModel:AddTransition(clip1,clip2,inPath)
    local transitionId = self:_NewClipId()

    local testDuration = 10
    local trackId = self.videoClipInfoMap[clip1].trackId
    local startTs = self.videoClipInfoMap[clip1].logicEndTs - testDuration / 2
    local endTs = self.videoClipInfoMap[clip2].logicStartTs + testDuration / 2

    local params = {
        clipId = transitionId,
        trackId = trackId,
        duration = testDuration,
        logicStartTs = startTs,
        logicEndTs = endTs,
        frontVideoId = clip1,
        backVideoId = clip2,
        path = inPath
    }

    local transitionInfo = TransitionClip(transitionId,params)
    VideoSceneView:AddTransition(transitionInfo)

    self.videoClipInfoMap[transitionId] = transitionInfo
    return transitionId
end

function VideoSceneModel:DeleteTransition(id)
    VideoSceneView:DeleteTransition(id) 
end


--从fromindex开始,更新后序所有videoclip时间戳(+offset)
function VideoSceneModel:UpdateTimeline(trackId,fromIndex,offset)
    for i = fromIndex,self.videoClipRanks[trackId]:size() do
        self.videoClipInfoMap[self.videoClipRanks[trackId]:at(i)]:AddLogicTs(offset)
    end
end


--[[
logicStartTs：VideoClip在时间轴上的起始时间戳
logicEndTs：  VideoClip在时间轴上的结束时间戳
1.seekframe时，遍历所有的videoclip，根据每个videoclip的 logicStartTs 和 logicEndTs,找到当前时间戳命中的videoclip;
2.所有命中的 videoclip 执行seekframe(通过MediaComponent)，非激活状态的videoclip被关闭
]]
function VideoSceneModel:SeekFrame(timePointInMs)
    LOG("[VideoSceneMode] SeekFrame : " .. timePointInMs)
    local findVideos = {}
    local findTransitions = {}
    
    for clipId,clipInfo in pairs(self.videoClipInfoMap) do
        if (timePointInMs>=clipInfo.logicStartTs and timePointInMs<=clipInfo.logicEndTs) then
            self:PrintVideoClipInfo(clipId)
            if clipInfo.type == "transition" then
                table.insert(findTransitions,clipId)
            else
                table.insert(findVideos,clipId)
            end
        end
    end

    VideoSceneView:ClearFbo()

    --多轨视频
    if #findVideos >0 then VideoSceneView:ProcessVideo(findVideos,timePointInMs)  end
    if #findTransitions >0 then VideoSceneView:ProcessTransition(findTransitions,timePointInMs) end
    
end

function VideoSceneModel:SetClipTransform(clipId,transform)
    WARNING("VideoSceneModel : SetClipTransform " .. clipId)
    if self.videoClipInfoMap[clipId]~=nil then
        self.videoClipTransformMap[clipId] = transform
        VideoSceneView:SetClipTransform(clipId,transform)
    end

   
end


function VideoSceneModel:SetCanvasAspectRatio(ratioX,ratioY)
    VideoSceneView:SetCanvasAspectRatio(ratioX,ratioY)
end


function VideoSceneModel:SetCanvasBGColor(color)
    VideoSceneView:SetCanvasBGColor2(color)
end

function VideoSceneModel:AddVideoSceneFilter(clipId,effectInfo)
    local effectId = self:_NewEffectId()
    self.videoEffectInfoMap[effectId] = effectInfo
    
    effectInfo.effectId = effectId
    effectInfo.bGlobal = false
    effectInfo.clipId = clipId
    VideoSceneView:AddVideoSceneFilter(clipId,effectInfo)
    return effectId
end

function VideoSceneModel:AddMainSceneFilter(effectInfo)
    local effectId = self:_NewEffectId()
    self.videoEffectInfoMap[effectId] = effectInfo

    effectInfo.effectId = effectId
    effectInfo.bGlobal = true
    VideoSceneView:AddMainSceneFilter(effectInfo)
    return effectId
end

function VideoSceneModel:SetVideoClipVisiable(clipId,bVisiable)
    VideoSceneView:SetVideoClipVisiable(clipId,bVisiable)
end



--镜像
function VideoSceneModel:SetClipMirror(clipId)
    VideoSceneView:SetClipMirror(clipId)
end

--静音
function VideoSceneModel:SetClipAudioMute(clipId,bMute)
    VideoSceneView:SetClipAudioMute(clipId,bMute)
end

--重新排序
function VideoSceneModel:Reorder(clipId,index)

end

--定格,选定视频某一帧,扩展为一个单独的片段
function VideoSceneModel:FreezeFrame()

end


function VideoSceneModel:PrintVideoClipMap()
    for id,_ in pairs(self.videoClipInfoMap) do
        self:PrintVideoClipInfo(id)
    end

    for trackId,rank in pairs(self.videoClipRanks) do
        WARNING("The ranks of track " .. trackId)
        rank:print()
    end
end

function VideoSceneModel:PrintVideoClipInfo(clipId)
    local info = self.videoClipInfoMap[clipId]
    if info ~= nil then
        info:Print()
    end
end


function VideoSceneModel:_NewTrackId()
    TRACK_ID = TRACK_ID + 1 
    return TRACK_ID
end


function VideoSceneModel:_NewClipId()
    CLIP_ID = CLIP_ID + 1 
    return CLIP_ID
end

function VideoSceneModel:_NewEffectId()
    EFFECT_ID = EFFECT_ID + 1 
    return EFFECT_ID
end

function VideoSceneModel:_NewTransitionId()
    TRANSITION_ID = TRANSITION_ID + 1
    return TRANSITION_ID
end








function VideoSceneModel:SeekTo(clipId,ts)
    VideoSceneView:SeekTo(clipId,ts)
end



return VideoSceneModel

