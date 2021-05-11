local Object = require "classic"
local venuscore = require "venuscore"
local BundleSystem = require "venuscore.bundle.bundlesystem"
local apolloengine = require "apollocore"
local mathfunction = require "mathfunction"
local QuadNode = require "videoclip.quadnode"
local MediaNode = require "videoclip.medianode"
local CameraNode = require "videoclip.cameranode"
local TransitionNode = require "videoclip.transitionnode"
local vp = require "videoprocess"
local VideoScene = Object:extend()


local ClipType = {
    VIDEO = 0,
    TRANSITION = 1
}

function VideoScene:new()
    local defaultLayer = "Default"
    local defaultColor = mathfunction.Color(0.5,0.0,0.0,1)

    self.sceneName = "VideoScene"
    self.renderoNodeList = {}
    self.videoScene = apolloengine.SceneManager:CreateScene("VideoScene")
    self.mainCamera = self:_CreateCamera(defaultLayer,defaultColor)

    self.mediaNodeMap = {}
    self.clipInfoMap = {}
    self.clipRankList = {}
    self.transitionInfoMap = {}


end

function VideoScene:Reset()
    for i=1,#self.renderoNodeList do
        self.renderoNodeList[i]:SetActive(false)
    end
end

function VideoScene:AddCameraEffect(effectInfo)
    self.mainCamera:CreatePostEffect(effectInfo)
end



function VideoScene:BindRenderTarget(fbo)
    self.mainCamera:AttachRenderTarget(fbo.rendertarget)
end


function VideoScene:_CreateCamera(layer,clearcolor,fbo)

    local camera = CameraNode(self.videoScene)
    camera:AddLayerMask(layer)
    camera:SetClearColor(clearcolor)
        
    if fbo ~= nil then
        camera:AttachRenderTarget(fbo.rendertarget)
    end
    return camera
end


--添加
function VideoScene:AddMediaNode(clipInfo)
    clipInfo.type = ClipType.VIDEO

    local mediaNode = MediaNode(self.videoScene,clipInfo.path)
    --mediaNode:BindMainTexture("DEVICE_CAPTURE")
    clipInfo.duration = mediaNode:GetDuration()

    if clipInfo.startTs == -1 then
        --如果没有设定startTs,在末尾插入
        local lastClip = self:_GetLastVideoClip()
        if lastClip ~= nil then
            --非第一个
            clipInfo.startTs = lastClip.endTs + 1
        else
            --第一个
            clipInfo.startTs = 0
        end
    end

    clipInfo.endTs = clipInfo.startTs + clipInfo.duration
    
    self.clipInfoMap[clipInfo.clipId] = clipInfo
    self.mediaNodeMap[clipInfo.clipId] = mediaNode
    table.insert(self.clipRankList,clipInfo.clipId)
end


--删除
function VideoScene:DeleteMediaNode(clipId)
    --1.删除medianode

    --2.删除关联的转场
end

--分割
function VideoScene:SplitVideoClip()

end

--裁剪
function VideoScene:CropVideoClip()

end




------------------------Time Line-----------------------------
function VideoScene:GetTotalTime()
    --本轨道视频总时长,就是最后一个视频的endTs
    local lastClip = self:_GetLastVideoClip()
    if lastClip ~= nil then
        return lastClip.endTs
    else
        return 0
    end
end


-------------------------Seek Frames------------------------------
function VideoScene:Seek(frameIndex)

    --videoclip seek frame
    for clipId,info in pairs(self.clipInfoMap) do
        WARNING("Clip StartTs : " .. info.startTs .. ",Duration : " .. info.duration .. ",EndTs : " .. info.endTs)
        if frameIndex >=info.startTs and frameIndex <= info.endTs then
            self.mediaNodeMap[clipId]:SetRenderOrder(1000)
            self.mediaNodeMap[clipId]:Seek(frameIndex)
            return clipId
        else
            --self.mediaNodeMap[clipId]:SetActive(false)
        end
    end

    --play transition
    for _,info in pairs(self.transitionInfoMap) do
        if frameIndex >=info.startTs and frameIndex <= info.endTs then
            if info.type == ClipType.TRANSITION then
                local progress = (frameIndex - info.startTs)/(info.endTs - info.startTs)
                self.transition:SetParameter("_Progress",mathfunction.vector1(progress))
            end
        end
    end
    
    --post effect



end

-------------------------Add Transition----------------------------
function VideoScene:AddTransitionNode(tinfo)
    --local duration = 20
    local tStartTs = self.clipInfoMap[tinfo.frontVideoId].endTs - tinfo.duration/2
    local tEndTs = self.clipInfoMap[tinfo.backVideoId].startTs + tinfo.duration/2
    local transitionInfo = {
        id = tinfo.id,
        type = ClipType.TRANSITION,
        startTs = tStartTs,
        endTs = tEndTs,
        frontVideoId = tinfo.frontVideoId,
        backVideoId = tinfo.backVideoId
    }
    self.transitionInfoMap[transitionInfo.id] = transitionInfo


    --创建转场需要的拍摄相机和fbo,两段视频纹理需要两个相机拍摄
    self.fbo01 = CreateRenderTarget()
    self.fbo02 = CreateRenderTarget()
    local transition01CC = self:_CreateCamera("transition1",mathfunction.Color(0.0,0.8,0.0,0),self.fbo01)  --green
    local transition02CC = self:_CreateCamera("transition2",mathfunction.Color(0.0,0.0,0.8,0),self.fbo02)  --blue
    transition01CC:AddLayerMask("Background")
    transition02CC:AddLayerMask("Background")


    --转场专用quad,转场材质是全屏显示,无法设置transform。接受转场前后两个视频纹理，输出融合纹理
    --"comm:documents/shaders/transition/rotate.material"
    local transitionMat = "comm:documents/shaders/transition/" .. tinfo.path ..".material"
    local transitionNode = TransitionNode(self.videoScene,transitionMat)
    transitionNode:SetLayer("Transition")
    transitionNode:SetRenderOrder(10000)
    transitionNode:SetLocalPosition(mathfunction.vector3(0.2,0.2,1.0))
    transitionNode:SetLocalScale(mathfunction.vector3(0.8,0.8,1))

    --transitionNode:SetParameter("_MainTex",self.fbo01.color)
    transitionNode:SetParameter("_PrevTexture",self.fbo01.color)
    transitionNode:SetParameter("_NextTexture",self.fbo02.color)
    transitionNode:SetParameter("_Progress",mathfunction.vector1(0.0))
    self.transition = transitionNode

    self.mainCamera:AddLayerMask("Transition");
end


function VideoScene:DeleteTransition(id)
    self.transition:SetActive(false)
end





---------------------------Private-----------------------------

function VideoScene:_GetLastVideoClip()
    if #self.clipRankList > 0 then
        local clipId = self.clipRankList[#self.clipRankList]
        WARNING("Find last video clip : " .. clipId)
        return self.clipInfoMap[clipId]
    else
        return nil 
    end

end


return VideoScene