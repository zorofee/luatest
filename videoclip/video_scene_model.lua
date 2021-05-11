local mathfunction = require "mathfunction"
local apolloengine = require "apollocore"
local venusjson = require "venusjson"
local apollonode = require "apolloutility.apollonode"
local VideoSceneView = require "videoclip.video_scene_view"
local VideoSceneModel = {}


local TRACK_ID = 0
local CLIP_ID = 0
local EFFECT_ID = 0

function VideoSceneModel:Initialize()
    LOG("[VideoSceneModel]:Initialize")
    
    TRACK_ID = 0
    CLIP_ID = 0
    EFFECT_ID = 0
    TRANSITION_ID = 0

    --数据层
    self.videoTrackInfoMap = {}             --map<trackId,trackInfo>
    self.videoClipInfoMap = {}              --map<clipId,clipInfo>
    self.videoClipTransformMap = {}         --map<clipId,transform>
    self.videoEffectInfoMap = {}            --map<effectId,effectInfo>

    self.videoClipRanks = {}                

    VideoSceneView:Initialize()
    VideoSceneView:CreateMainScene()
end


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


function VideoSceneModel:SetCanvasAspectRatio(ratioX,ratioY)
    VideoSceneView:SetCanvasAspectRatio(ratioX,ratioY)
end


function VideoSceneModel:SetCanvasBGColor(color)
    VideoSceneView:SetCanvasBGColor(color)
end


function VideoSceneModel:AddVideoTrack(trackInfo)
    local trackId = self:_NewTrackId()
    self.videoTrackInfoMap[trackId] = trackInfo

    VideoSceneView:AddVideoTrack(trackId,trackInfo)
    return trackId
end

function VideoSceneModel:AddVideoClip(trackId,clipInfo)
    local clipId = self:_NewClipId()
    self.videoClipInfoMap[clipId] = clipInfo
    clipInfo.clipId = clipId
    clipInfo.trackId = trackId
    VideoSceneView:AddVideoClip(trackId,clipId,clipInfo)
    WARNING("*********AddMediaNode*********** VideoInfo.duration : " .. clipInfo.duration)
    return clipId
end

function VideoSceneModel:DeleteVideoClip(clipId)
    VideoSceneView:DeleteVideoClip(clipId)
end


function VideoSceneModel:SetClipTransform(clipId,transform)
    self.videoClipTransformMap[clipId] = transform

    VideoSceneView:UpdateClipPosition(clipId,transform.pos)
    --VideoSceneView:UpdateClipRotation(clipId,transform.rot)   
    VideoSceneView:UpdateClipScale(clipId,transform.scale)
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


-------Time Line---------
function VideoSceneModel:GetTotalTime()
    VideoSceneView:GetTotalTime()
end

-------Seek Frame--------
function VideoSceneModel:Seek(frameIndex)
    VideoSceneView:Seek(frameIndex)
end

-------Add Transition------
function VideoSceneModel:AddTransition(transitionInfo)
    local transitionId = self:_NewTransitionId()
    transitionInfo.id = transitionId
    VideoSceneView:AddTransition(transitionInfo)
    return transitionId
end

function VideoSceneModel:DeleteTransition(id)
    VideoSceneView:DeleteTransition(id) 
end


return VideoSceneModel

