local Object = require "classic"
local VideoSceneManager = require "video_scene_manager"
local VideoTrack = Object:extend()

function VideoTrack:new()

end

function VideoTrack:AddVideoClip(clipInfo)
    self.VideoSceneManager:AddVideoClip(clipInfo)
end
