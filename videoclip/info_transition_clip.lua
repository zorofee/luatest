local Object = require "classic"
local TransitionClip = Object:extend()





function TransitionClip:new(transitionId,params)
    self.clipId = params.clipId
    self.trackId = params.trackId
    self.type = "transition"
    self.duration = params.duration
    self.originStartTs = 0
    self.originEndTs =  self.originStartTs + params.duration
    self.logicStartTs = params.logicStartTs
    self.logicEndTs = params.logicStartTs + self.duration
    self.frontVideoId = params.frontVideoId
    self.backVideoId = params.backVideoId
    self.path = params.path
    self.speed = 1.0
    self.strategy = 2             --1 : 同时只有一个clip在渲染  ;  2 : 同时处理上一段clip和下一段clip
    LOG("[TransitionClip] " .. self.clipId .. ",trackId: " .. self.trackId .. ",logicStartTs: " .. self.logicStartTs .. ",logicEndTs: " .. self.logicEndTs .. ",Duration :" .. self.duration )
end


function TransitionClip:Print()
    LOG(
            "clipId: " .. self.clipId ..
            ",Track: " .. self.trackId ..
            ",type: " .. self.type ..
            ",frontVideoId: " .. self.frontVideoId ..
            ",backVideoId: " .. self.backVideoId ..
            ",originStartTs: " .. self.originStartTs ..
            ",originEndTs: " .. self.originEndTs ..
            ",logicStartTs: " .. self.logicStartTs ..
            ",logicEndTs: " .. self.logicEndTs
            )

end


return TransitionClip
