local apolloengine = require "apolloengine"
local mathfunction = require "mathfunction"
local venuscore = require "venuscore"

local screen_space_reflection = {}

screen_space_reflection.Queue = 320;




function screen_space_reflection:Initialize(host, size)
    self.init = true;
  
  --效果参数--
--参数1：世界空间镜像反射距离
self.MarchingDistance = 1.3;
--参数2：ray marching 步长系数
self.MarchingPrecision = 0.2;
--参数3：物体默认厚度阈值
self.Thickness = 0.08;
--参数4：box blur次数，默认1次3*3
self.BlurStrength = 1;
--参数5：box blur step
self.BlurSize = 1.0;
--参数6：反射强度
self.ReflectionIntensity = 1.0;


--参数6（内部）：ray marching 二分优化步数
self.RefinedSteps = 0;

--LOG(size);
--size = mathfunction.vector2(512, 512);

--效果参数结束--

    self.UNIFORM_MarchingDistance = apolloengine.IMaterialSystem:NewParameterSlot(
        apolloengine.ShaderEntity.UNIFORM,
        "_MaxDistance");
    self.UNIFORM_Resolution = apolloengine.IMaterialSystem:NewParameterSlot(
        apolloengine.ShaderEntity.UNIFORM,
        "_Resolution");
    self.UNIFORM_Thickness = apolloengine.IMaterialSystem:NewParameterSlot(
        apolloengine.ShaderEntity.UNIFORM,
        "_Thickness");
    self.UNIFORM_RefinedSteps = apolloengine.IMaterialSystem:NewParameterSlot(
        apolloengine.ShaderEntity.UNIFORM,
        "_RefinedSteps");   
    self.UNIFORM_TexSize = apolloengine.IMaterialSystem:NewParameterSlot(
        apolloengine.ShaderEntity.UNIFORM,
        "texSize");
    self.UNIFORM_Intensity = apolloengine.IMaterialSystem:NewParameterSlot(
        apolloengine.ShaderEntity.UNIFORM,
        "_Intensity");      

    self.TEXTURE_FWD_MASK = apolloengine.IMaterialSystem:NewParameterSlot(
        apolloengine.ShaderEntity.UNIFORM,
        "TEXTURE_FWD_MASK");
      
    self.TEXTURE_RAYMARCH = apolloengine.IMaterialSystem:NewParameterSlot(
        apolloengine.ShaderEntity.UNIFORM,
        "TEXTURE_RAYMARCH");    
    
    self.TEXTURE_MAINTEX = apolloengine.IMaterialSystem:NewParameterSlot(
        apolloengine.ShaderEntity.UNIFORM,
        "TEXTURE_MAINTEX");
    self.TEXTURE_REFLECT = apolloengine.IMaterialSystem:NewParameterSlot(
        apolloengine.ShaderEntity.UNIFORM,
        "TEXTURE_REFLECT");      
    self.TEXTURE_REFLECT_BLUR = apolloengine.IMaterialSystem:NewParameterSlot(
        apolloengine.ShaderEntity.UNIFORM,
        "TEXTURE_REFLECT_BLUR");  
      
    --local pathMask = venuscore.IFileSystem:PathAssembly("comm:documents/material/screen_space_reflection/mask.material");  
    --self.maskRenderObj = host:CreateRenderObject();   
    --self.maskMaterial = host:CreateMaterial(pathMask); 
    
    local pathRayMarching = venuscore.IFileSystem:PathAssembly("comm:documents/material/screen_space_reflection/ray_marching.material");  
    self.rayMarchingRenderObj = host:CreateRenderObject();   
    self.rayMarchingMaterial = host:CreateMaterial(pathRayMarching);   

    local pathReflection = venuscore.IFileSystem:PathAssembly("comm:documents/material/screen_space_reflection/reflection.material");  
    self.reflectionRenderObj = host:CreateRenderObject();
    self.reflectionMaterial = host:CreateMaterial(pathReflection);
    
    local pathBlur = venuscore.IFileSystem:PathAssembly("comm:documents/material/screen_space_reflection/boxblur1d.material");  
    self.blurRenderObj = host:CreateRenderObject();
    self.blurMaterial = host:CreateMaterial(pathBlur);
    
    local pathCollect = venuscore.IFileSystem:PathAssembly("comm:documents/material/screen_space_reflection/collect.material");  
    self.collectRenderObj = host:CreateRenderObject();
    self.collectMaterial = host:CreateMaterial(pathCollect);
    --[[
    self.maskRT = host:CreateRenderTarget(  
          apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
          apolloengine.TextureRenderMetadata(
            apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
            size,
                  apolloengine.TextureEntity.TW_CLAMP_TO_EDGE,
                  apolloengine.TextureEntity.TW_CLAMP_TO_EDGE,
                  apolloengine.TextureEntity.TF_NEAREST,
                  apolloengine.TextureEntity.TF_NEAREST,0
          ) );
     ]] 

    self.rayMarchingRT = host:CreateRenderTarget(  
          apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
          apolloengine.TextureRenderMetadata(
            apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
            size,
                  apolloengine.TextureEntity.TW_CLAMP_TO_EDGE,
                  apolloengine.TextureEntity.TW_CLAMP_TO_EDGE,
                  apolloengine.TextureEntity.TF_NEAREST,
                  apolloengine.TextureEntity.TF_NEAREST,0
          ), mathfunction.vector2(0.5,0.5));
      
    self.reflectionRT = host:CreateRenderTarget( apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
          apolloengine.TextureRenderMetadata(
          apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
          size,
          apolloengine.TextureEntity.TF_LINEAR,apolloengine.TextureEntity.TF_LINEAR, 0) ,mathfunction.vector2(0.5,0.5));
     
    --self.reflectionRT:SetResizeviewFlag(false);

    self.blurRT = host:CreateRenderTarget( apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
          apolloengine.TextureRenderMetadata(
          apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
          size,
          apolloengine.TextureEntity.TF_LINEAR,apolloengine.TextureEntity.TF_LINEAR, 0)
        ,mathfunction.vector2(0.5,0.5));
 
    self.blurRT2 = host:CreateRenderTarget( apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
          apolloengine.TextureRenderMetadata(
          apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
          size,
          apolloengine.TextureEntity.TF_LINEAR,apolloengine.TextureEntity.TF_LINEAR, 0)
        ,mathfunction.vector2(0.5,0.5)); 
  --	self.blurRT = host:CreateRenderTarget( apolloengine.RenderTargetEntity.ST_SWAP_A, size );
  --  self.blurRT2 = host:CreateRenderTarget( apolloengine.RenderTargetEntity.ST_SWAP_B, size );
  
  --[[
    self.collectRT = host:CreateRenderTarget( apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
          apolloengine.TextureRenderMetadata(
          apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
          size,
          apolloengine.TextureEntity.TF_LINEAR,apolloengine.TextureEntity.TF_LINEAR,0) );
      ]]
     --self.reflectionRT:SetResizeviewFlag(false);

    self:UpdateSize(size)
      
   -- LOG(self.size);
    
    host:RegisterScriptParameter(self,"MarchingDistance");
    host:RegisterScriptParameter(self,"MarchingPrecision");
    host:RegisterScriptParameter(self,"Thickness");
    host:RegisterScriptParameter(self,"BlurStrength");
    host:RegisterScriptParameter(self,"BlurSize");
    host:RegisterScriptParameter(self,"ReflectionIntensity");
    
    return self.Queue;
end

function screen_space_reflection:UpdateSize(size)  
    self.size = size;
end


function screen_space_reflection:Resizeview(size)
    self:UpdateSize(size)
    self.width = size:x();
    self.height = size:y();
end
--[[
function screen_space_reflection:WriteMask(context, Original, Scene, Output)

    context:BeginRenderPass(Output, apolloengine.RenderTargetEntity.CF_COLOR, mathfunction.Color(0,0,0,0));

    context:Draw(self.maskRenderObj, self.maskMaterial);
    context:EndRenderPass();
end
]]
function screen_space_reflection:RayMarching(context, Original, Scene, Output)

    context:BeginRenderPass(self.rayMarchingRT , apolloengine.RenderTargetEntity.CF_COLOR, mathfunction.Color(0,0,0,0));
--self.rayMarchingMaterial:SetParameter("TEXTURE_GBUFFER_DEPTH_1", Scene:GetAttachment( apolloengine.RenderTargetEntity.TA_DEPTH_STENCIL )); 
 --   self.rayMarchingMaterial:SetParameter(self.TEXTURE_FWD_MASK, Scene:GetAttachment( apolloengine.RenderTargetEntity.TA_COLOR_1 )); 
    self.rayMarchingMaterial:SetParameter(self.UNIFORM_MarchingDistance, mathfunction.vector1(math.max(screen_space_reflection.MarchingDistance,0.1)));  
    self.rayMarchingMaterial:SetParameter(self.UNIFORM_Resolution, mathfunction.vector1(math.max(screen_space_reflection.MarchingPrecision,0.1)));  
    self.rayMarchingMaterial:SetParameter(self.UNIFORM_Thickness, mathfunction.vector1(math.max(screen_space_reflection.Thickness, 0.001)));  
    self.rayMarchingMaterial:SetParameter(self.UNIFORM_RefinedSteps, mathfunction.vector1(screen_space_reflection.RefinedSteps));  
    self.rayMarchingMaterial:SetParameter(self.UNIFORM_TexSize, mathfunction.vector2(self.width,self.height)); 

    context:Draw(self.rayMarchingRenderObj, self.rayMarchingMaterial);
    context:EndRenderPass();
end

function screen_space_reflection:Reflection(context, Original, Scene, Output)

    context:BeginRenderPass(self.reflectionRT, apolloengine.RenderTargetEntity.CF_COLOR);
  
    self.reflectionMaterial:SetParameter(self.TEXTURE_RAYMARCH, self.rayMarchingRT:GetAttachment( apolloengine.RenderTargetEntity.TA_COLOR_0 ));  
    self.reflectionMaterial:SetParameter(self.TEXTURE_MAINTEX,  Scene:GetAttachment( apolloengine.RenderTargetEntity.TA_COLOR_0 ));
    self.reflectionMaterial:SetParameter(self.UNIFORM_TexSize, mathfunction.vector2(self.width,self.height)); 
    
    context:Draw(self.reflectionRenderObj, self.reflectionMaterial);
    context:EndRenderPass();
end

function screen_space_reflection:BoxBlur(context, Original, Scene, Output)
 
  local blurStrength = math.max(math.ceil(self.BlurStrength), 1);
  local rt1, rt2;
  if math.fmod(blurStrength, 2) == 1 then
    rt1 = self.blurRT;
    rt2 = self.blurRT2;
  else
    rt2 = self.blurRT;
    rt1 = self.blurRT2;
  end
  
  local lastRT = self.reflectionRT;
  for i = 1, blurStrength do
    
    context:BeginRenderPass(rt1, apolloengine.RenderTargetEntity.CF_COLOR);
    
    self.blurMaterial:SetParameter(self.TEXTURE_REFLECT, lastRT:GetAttachment( apolloengine.RenderTargetEntity.TA_COLOR_0 ));  
    self.blurMaterial:SetParameter(self.UNIFORM_TexSize, mathfunction.vector2(self.width,self.height)); 
    --self.blurMaterial:SetParameter(self.UNIFORM_BlurSize, mathfunction.vector1(math.max(self.BlurSize, 1))); 
    
    context:Draw(self.blurRenderObj, self.blurMaterial);
    
    context:EndRenderPass();
    
    lastRT = rt1;
    rt1 = rt2;
    rt2 = lastRT;
  end
end

function screen_space_reflection:BoxBlur1D(context, Original, Scene, Output)
 
  local blurStrength = math.max(math.ceil(self.BlurStrength), 1);
  local lastRT = self.reflectionRT;
  local rad = math.max(math.ceil(self.BlurSize),1.0);
  for i = 1, blurStrength do
    
    context:BeginRenderPass(self.blurRT2, apolloengine.RenderTargetEntity.CF_COLOR);    
    self.blurMaterial:SetParameter(self.TEXTURE_REFLECT, lastRT:GetAttachment( apolloengine.RenderTargetEntity.TA_COLOR_0 ));  
    self.blurMaterial:SetParameter("step", mathfunction.vector2(rad/self.width,0));     
    context:Draw(self.blurRenderObj, self.blurMaterial);    
    context:EndRenderPass();
    
    context:BeginRenderPass(self.blurRT, apolloengine.RenderTargetEntity.CF_COLOR);    
    self.blurMaterial:SetParameter(self.TEXTURE_REFLECT, self.blurRT2:GetAttachment( apolloengine.RenderTargetEntity.TA_COLOR_0 ));  
    self.blurMaterial:SetParameter("step", mathfunction.vector2(0, rad/self.height));     
    context:Draw(self.blurRenderObj, self.blurMaterial);    
    context:EndRenderPass();
    
    lastRT = self.blurRT;
  end
end

function screen_space_reflection:Collect(context, Original, Scene, Output)

    context:BeginRenderPass(Output, apolloengine.RenderTargetEntity.CF_COLOR);
  
    --self.collectMaterial:SetParameter(self.TEXTURE_REFLECT, self.blurRT:GetAttachment( apolloengine.RenderTargetEntity.TA_COLOR_0 ));  
    self.collectMaterial:SetParameter(self.TEXTURE_REFLECT_BLUR, self.blurRT:GetAttachment( apolloengine.RenderTargetEntity.TA_COLOR_0 ));  
    self.collectMaterial:SetParameter(self.TEXTURE_MAINTEX, Scene:GetAttachment( apolloengine.RenderTargetEntity.TA_COLOR_0 ));
    self.collectMaterial:SetParameter(self.UNIFORM_Intensity, mathfunction.vector1(self.ReflectionIntensity));  
    
    context:Draw(self.collectRenderObj, self.collectMaterial);
    context:EndRenderPass();
end

function screen_space_reflection:Process(context, Original, Scene, Output)
  if self.init  then
   -- self:WriteMask(context, Original, Scene, Output);
    self:RayMarching(context, Original, Scene, Output);
    self:Reflection(context, Original, Scene, Output);
    self:BoxBlur1D(context, Original, Scene, Output);
    self:Collect(context, Original, Scene, Output);
  end
end

return screen_space_reflection;

