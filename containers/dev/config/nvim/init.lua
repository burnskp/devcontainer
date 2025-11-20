if os.getenv("NVIM_MINIMAL") ~= nil then
  require("config.minimal")
else
  require("config.lazy")
end
