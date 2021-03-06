


local mathfunction = require "mathfunction"
local VideoSceneManager = require "videoclip_new.video_scene_manager"
local VideoSceneTest = {}

--1.初始化
function VideoSceneTest:Initialize()
    VideoSceneManager:Initialize()
end


--2.在不同的轨道添加视频
function VideoSceneTest:AddVideoClipsInDiffTrack()
    local clipInfo1 = {
      path = "test:short_video_effect/video_01.mp4",
      pos = mathfunction.vector3(-0.2,-0.2,0.0),
      rotation = mathfunction.vector3(0.0,0.0,0.0),
      scale = mathfunction.vector3(0.6,0.5,1),
      startTs = 1,
      endTs = 10
    }
    local clipInfo2 = {
        path = "test:short_video_effect/video_02.mp4",
        pos = mathfunction.vector3(0.2,-0.2,0.0),
        rotation = mathfunction.vector3(0.0,0.0,0.0),
        scale = mathfunction.vector3(0.5,0.5,1),
        startTs = 1,
        endTs = 10
      }
    local trackInfo = {
      width = 720,
      height = 420
    }
  

    local track1 = VideoSceneManager:AddVideoTrack(trackInfo)
    self.clip1 = VideoSceneManager:AddVideoClip(track1,clipInfo1)
    
    local track2 = VideoSceneManager:AddVideoTrack(trackInfo)
    self.clip2 = VideoSceneManager:AddVideoClip(track2,clipInfo2)
  
end


--3.在同一个轨道添加视频
function VideoSceneTest:AddVideoClipsInSameTrack()

    local clipInfo1 = {
        path = "test:short_video_effect/video_01.mp4",
        pos = mathfunction.vector3(-0.2,-0.2,0.0),
        rotation = mathfunction.vector3(0.0,0.0,0.0),
        scale = mathfunction.vector3(0.6,0.5,1),
        startTs = 1,
        endTs = 10
      }
      local clipInfo2 = {
          path = "test:short_video_effect/video_02.mp4",
          pos = mathfunction.vector3(0.2,-0.2,0.0),
          rotation = mathfunction.vector3(0.0,0.0,0.0),
          scale = mathfunction.vector3(0.5,0.5,1),
          startTs = 1,
          endTs = 10
        }
      local trackInfo = {
        width = 720,
        height = 420
      }
  
      local track1 = VideoSceneManager:AddVideoTrack(trackInfo)
      self.clip1 = VideoSceneManager:AddVideoClip(track1,clipInfo1)
      self.clip2 = VideoSceneManager:AddVideoClip(track1,clipInfo2)
    
end

--4.设置背景颜色
function VideoSceneTest:SetCanvasBGColor()
  WARNING("******SetCanvasBGColor********111***")
    VideoSceneManager:SetCanvasBGColor(mathfunction.Color(0.28,0.28,0.28,1))
end
  

--5.设置videoclip位置、旋转、大小
function VideoSceneTest:SetClipTransform()
    local transform = {
      pos = mathfunction.vector3(-0.1,-0.2,0.0),
      rot = mathfunction.Quaternion(10.0,20.0,0.0,0.0),
      scale = mathfunction.vector3(0.5,0.5,0.5),
    }
    VideoSceneManager:SetClipTransform(self.clip1,transform)
  
    local transform2 = {
      pos = mathfunction.vector3(0.1,0.2,0.0),
      rot = mathfunction.Quaternion(10.0,20.0,0.0,0.0),
      scale = mathfunction.vector3(0.5,0.5,0.5),
    }
    VideoSceneManager:SetClipTransform(self.clip2,transform2)
  
end
  

--6.在单个videoclip上添加滤镜
function VideoSceneTest:AddSingleFilter()
    local effectInfo = {
      effectName = "fastblur_alpha",
      path = mPath,
      startTs = 10,
      endTs = 50;
    }
    VideoSceneManager:AddVideoSceneFilter(self.clip1,effectInfo)
    VideoSceneManager:AddVideoSceneFilter(self.clip2,effectInfo)
end
  

--7.添加全局滤镜
function VideoSceneTest:AddGlobalFilter()
    local effectInfo = {
      effectName = "fastblur_alpha",
      path = mPath,
      startTs = 20,
      endTs = 40;
    }
    VideoSceneManager:AddMainSceneFilter(effectInfo)
end
  

--8.清除场景
function VideoSceneTest:ResetScene()
    VideoSceneManager:Reset()
end
  

--9.根据缓存数据重新生成场景
function VideoSceneTest:RebuildScene()
    VideoSceneManager:Deserialization()
end

local v = false
function VideoSceneTest:SetVideoClipVisiable()
  VideoSceneManager:SetVideoClipVisiable(self.clip1,v)
  v = not v
end


return VideoSceneTest
