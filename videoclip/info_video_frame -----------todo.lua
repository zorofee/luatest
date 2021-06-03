local VideoFrame = {}

function VideoFrame:new()
    self.videoClipId = 1
    self.logicFrameIndex = 0         --在videoclip内的计数
    self.frameDuration = 70          --单帧时间
    self.timelineTsOffset = 0        --从0开始累计的时间
end


return VideoFrame