RuCaptcha.configure do
  # self.cache_store = :mem_cache_store
  self.cache_store = :redis_cache_store
end
