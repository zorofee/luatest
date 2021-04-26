local mathfunction = require "mathfunction"
local apolloengine = require "apollocore"
local venusjson = require "venusjson"
local apollonode = require "apolloutility.apollonode"
local VideoSceneView = require "videoclip_new.video_scene_view"
local VideoSceneModel = {}


--[[
typedef struct VideoClipInfo_t {
int mId; //视频id
int mOriginWidth; //原始宽
int mOriginHeight; //原始高
int mType; //图片还是视频
int mOriginDuration; //原始时长
int mCropStartTs; //裁剪开始时间戳
int mCropEndTs; //裁剪结束时间戳
float mSpeed; //变速
bool mMute; //是否静音
bool mMirror; //是否镜像
int mRotation; //旋转角度
float mScale; //缩放
float mOffsetX; //X方向偏移
float mOffsetY; //Y方向偏移
int mLeftTransitionId; //视频开头连接的转场id
int mRightTransitionId; //视频结尾连接的转场id
bool mRevertPlay; //是否倒放
int mCopyFromVideoId; //复制、分割、定格(不包括中间插入的)的根节点视频id
std::string mFileName; //原文件路径
} VideoClipInfo;

struct VideoFrameItem {

    int shortVideoId;            //对应的视频Id

    uint32_t logicFrameIndex;   //对应的逻辑帧序号

    uint32_t frameDuration;      //持续时间

    uint32_t timelineTsOffset;    //距离视频开头的时长

};

]]

local TRACK_ID = 0
local CLIP_ID = 0
local EFFECT_ID = 0

function VideoSceneModel:Initialize()
    LOG("[VideoSceneModel]:Initialize")
    
    TRACK_ID = 0
    CLIP_ID = 0
    EFFECT_ID = 0

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
    local videoClipEffectsMap = self.videoClipEffectsMap
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



function VideoSceneModel:Reset()
    VideoSceneView:Reset()
end



function VideoSceneModel:SetCanvasAspectRatio(ratioX,ratioY)

end


function VideoSceneModel:SetCanvasBGColor(color)
  WARNING("******SetCanvasBGColor********333***")
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
    return clipId
end


function VideoSceneModel:SetClipTransform(clipId,transform)
    self.videoClipTransformMap[clipId] = transform

    VideoSceneView:SetClipPosition(clipId,transform.pos)
    --VideoSceneView:SetClipRotation(clipId,transform.rot)   --需要角度转四元数
    VideoSceneView:SetClipScale(clipId,transform.scale)
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

return VideoSceneModel

