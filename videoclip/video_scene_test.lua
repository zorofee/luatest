


local mathfunction = require "mathfunction"
local VideoSceneManager = require "videoclip.video_scene_manager"
local VideoSceneTest = {}

--1.初始化
function VideoSceneTest:Initialize()
    VideoSceneManager:Initialize()
end


function VideoSceneTest:Test_AddVideoClips()

  VideoSceneModel:Initialize()
  local clipInfo1 = {
      path = "test:short_video_effect/video_01.mp4",
      logicStartTs = 0,
      originStartTs = 0,
      originEndTs = 20
  }
  local clipInfo2 = {
      path = "test:short_video_effect/video_02.mp4",
      logicStartTs = 21,
      originStartTs = 0,
      originEndTs = 15
  }
  local clipInfo3 = {
      path = "test:short_video_effect/video_03.mp4",
      logicStartTs = 37,
      originStartTs = 0,
      originEndTs = 20
  }
  local clipTransform1 = {
      pos = mathfunction.vector3(-0.2,0.2,1.0),
      rotation = mathfunction.vector3(0.0,0.0,0.0),
      scale = mathfunction.vector3(0.9,0.9,1),
  }
  local clipTransform2 = {
      pos = mathfunction.vector3(0.2,-0.2,1.0),
      rotation = mathfunction.vector3(0.0,0.0,0.0),
      scale = mathfunction.vector3(0.9,0.9,1),
  }
  local clipTransform3 = {
      pos = mathfunction.vector3(0.1,-0.3,1.0),
      rotation = mathfunction.vector3(0.0,0.0,0.0),
      scale = mathfunction.vector3(0.7,0.7,1),
  }



  self.clipId1 = VideoSceneModel:AddVideoClip(1,clipInfo1)
  VideoSceneModel:SetClipTransform(self.clipId1,clipTransform1)
  
  self.clipId2 = VideoSceneModel:AddVideoClip(1,clipInfo2)
  VideoSceneModel:SetClipTransform(self.clipId2,clipTransform2)

  self.clipId3 = VideoSceneModel:AddVideoClip(1,clipInfo3)
  VideoSceneModel:SetClipTransform(self.clipId3,clipTransform2)


  VideoSceneModel:PrintVideoClipMap()

end


function VideoSceneTest:Test_Insert()
  local insertClip = {
      path = "test:short_video_effect/video_03.mp4",
      logicStartTs = -1,
      originStartTs = 0,
      originEndTs = 10
  }
  local insertTransform = {
      pos = mathfunction.vector3(0.2,0.2,1.0),
      rotation = mathfunction.vector3(0.0,0.0,0.0),
      scale = mathfunction.vector3(0.9,0.9,1),
  }

  self.insertId = VideoSceneModel:InsertVideoClip(1,self.clipId1,insertClip)
  LOG("--------INSERT---------" .. self.insertId )
  VideoSceneModel:SetClipTransform(self.insertId,insertTransform)
  VideoSceneModel:PrintVideoClipMap()
end

function VideoSceneTest:Test_Copy()
  self.copyId = VideoSceneModel:CopyVideoClip(self.clipId1)
  LOG("--------COPY---------" .. self.copyId)
  VideoSceneModel:PrintVideoClipMap()
end


function VideoSceneTest:Test_Crop()
  LOG("---------CROP---------")
  VideoSceneModel:CropVideoClip(self.insertId,2,8)
  VideoSceneModel:PrintVideoClipMap()
end
  
function VideoSceneTest:Test_Split()
  LOG("---------SPLIT-------")
  VideoSceneModel:SplitVideoClip(self.clipId3,10)
  VideoSceneModel:PrintVideoClipMap()
end


function VideoSceneTest:Test_AddTransition()
  self.transition1 = VideoSceneModel:AddTransition(5,4,"rotate")
  self.transition2 = VideoSceneModel:AddTransition(2,3,"dissolve2")
  VideoSceneModel:PrintVideoClipMap()
end

function VideoSceneTest:Test_SetSpeed()
  --VideoSceneTest:DeleteTransition()
  VideoSceneModel:SetClipSpeed(self.clipId2,2)
  VideoSceneModel:PrintVideoClipMap()
end





--4.设置背景颜色
function VideoSceneTest:SetCanvasBGColor()
  WARNING("******SetCanvasBGColor********111***")
    VideoSceneManager:SetCanvasBGColor(mathfunction.Color(0.28,0.28,0.28,1))
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

--10.设置mesh可见性
local v = false
function VideoSceneTest:SetVideoClipVisiable()
  VideoSceneManager:SetVideoClipVisiable(self.clip1,v)
  v = not v
end


return VideoSceneTest
