
local apolloengine = require "apollocore"

function CreateRenderTarget()
    local rt = apolloengine.RenderTargetEntity()
    rt:PushMetadata(
        apolloengine.RenderTargetMetadata(
            apolloengine.RenderTargetEntity.RT_RENDER_TARGET_2D,
            apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
            apolloengine.Framework:GetViewport(),
            apolloengine.Framework:GetResolution()));

    local color = rt:MakeTextureAttachment(apolloengine.RenderTargetEntity.TA_COLOR_0);
          color:PushMetadata(--创建纹理
            apolloengine.TextureRenderMetadata(
            apolloengine.RenderTargetEntity.ST_SWAP_UNIQUE,
            apolloengine.Framework:GetResolution()));

    rt:CreateResource()
    local fbo = {rendertarget = rt,color = color}
    return fbo
end


function DeepCopy(srcTable)
    if srcTable == nil then
        return nil
    end

    local dstTable = {}
    for k,v in pairs(srcTable) do
        if type(v) == 'table' then
            dstTable[k] = table.DeepCopy(v)
        else
            dstTable[k] = v
        end
    end
    return dstTable
end


