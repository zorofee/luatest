local Object = require "classic"
local VideoClip = Object:extend()

--[[

0               10              20                 30                 40               50         55         Timeline

|--------------------------------------------------||---------------------------------------------|
|originStartTs=0    duration=30    originEndTs=30  || originStartTs=0  duration=25  originEndTs=25|           
|logicStartTs=0                    logicEndTs=30   || logiStartTs=31                logicEndTs=55 |           Track01
|--------------------------------------------------||---------------------------------------------|
                    clip01                                               clip02
]]

function VideoClip:new(trackId,clipId,params)
    self.trackId = trackId
    self.clipId = clipId
    self.type = "video"
    self.originStartTs = params.originStartTs
    self.originEndTs = params.originEndTs
    self.duration = self.originEndTs - self.originStartTs
    self.logicStartTs = params.logicStartTs
    self.logicEndTs = params.logicStartTs + self.duration
    self.width = 0
    self.height = 0
    self.frameNum = 0
    self.speed = 1.0
    self.path = params.path

    LOG("[VideoClip] " .. self.clipId .. ",originEndTs: " .. self.originEndTs .. ",originStartTs: " .. self.originStartTs .. ",Duration :" .. self.duration )
end

function VideoClip:AddLogicTs(addTs)
    if addTs > 0 then
        self.logicStartTs = self.logicStartTs + addTs + 1
    else
        self.logicStartTs = self.logicStartTs + addTs
    end
    self.logicEndTs = self.logicStartTs + self.duration
end

function VideoClip:SetLogicTs(startTs)
    self.logicStartTs = startTs
    self.logicEndTs = self.logicStartTs + self.duration
end



--主轨道上,视频裁剪之后会联动后面的视频改变
function VideoClip:CropTs(startTs,endTs)

    local satrtTsOffset = startTs - self.originStartTs
    local endTsOffset = self.originEndTs - endTs
    local offset = satrtTsOffset + endTsOffset
    self.logicEndTs = self.logicEndTs - offset

    self.originStartTs = startTs
    self.originEndTs = endTs
    self.duration = endTs - startTs

    return offset

end

function VideoClip:Print()
    LOG(
            "clipId: " .. self.clipId ..
            ",Track: " .. self.trackId ..
            ",type: " .. self.type ..
            ",originStartTs: " .. self.originStartTs ..
            ",originEndTs: " .. self.originEndTs ..
            ",logicStartTs: " .. self.logicStartTs ..
            ",logicEndTs: " .. self.logicEndTs
            )

end

return VideoClip
