local mathfunction = require "mathfunction"
local apolloengine = require "apollocore"
local venusjson = require "venusjson"
local apollonode = require "apolloutility.apollonode"
local VideoSceneView = require "videoclip.video_scene_view"
local VideoSceneModel = require "videoclip.video_scene_model"

local VideoSceneManager = {}

function VideoSceneManager:Initialize()
    VideoSceneModel:Initialize()
end

function VideoSceneManager:Reset()
    VideoSceneModel:Reset()
end

function VideoSceneManager:Deserialization()
    VideoSceneModel:Deserialization()
end

function VideoSceneManager:SetCanvasAspectRatio(ratioX,ratioY)
    VideoSceneModel:SetCanvasAspectRatio(ratioX,ratioY)
end

function VideoSceneManager:SetCanvasBGColor(color)
    VideoSceneModel:SetCanvasBGColor(color)
end

function VideoSceneManager:AddVideoTrack(trackInfo)
    return VideoSceneModel:AddVideoTrack(trackInfo)
end

function VideoSceneManager:AddVideoClip(trackId,clipInfo)
    return VideoSceneModel:AddVideoClip(trackId,clipInfo)
end

function VideoSceneManager:DeleteVideoClip(clipId)
    return VideoSceneModel:DeleteVideoClip(clipId)
end

function VideoSceneManager:SetClipTransform(clipId,transform)
    VideoSceneModel:SetClipTransform(clipId,transform)
end

function VideoSceneManager:AddVideoSceneFilter(clipId,effectInfo)
    VideoSceneModel:AddVideoSceneFilter(clipId,effectInfo)
end

function VideoSceneManager:AddMainSceneFilter(effectInfo)
    VideoSceneModel:AddMainSceneFilter(effectInfo)
end

function VideoSceneManager:SetVideoClipVisiable(clipId,bVisiable)
    VideoSceneModel:SetVideoClipVisiable(clipId,bVisiable)
end


-------Time Line---------
function VideoSceneManager:GetTotalTime()
    VideoSceneModel:GetTotalTime()
end

----------------Seek Frame-------------
function VideoSceneManager:Seek(frameIndex)
    VideoSceneModel:Seek(frameIndex)
end


-------Add Transition------
function VideoSceneManager:AddTransition(transitionInfo)
    return VideoSceneModel:AddTransition(transitionInfo)
end

function VideoSceneManager:DeleteTransition(id)
    VideoSceneModel:DeleteTransition(id)
end

return VideoSceneManager