# frozen_string_literal: true

RSpec.configure do |config|
  cache_dir = "public/uploads/cache"
  store_dir = "public/uploads/store"
  config.after(:suite) do
    # remove cache directory for shrine (Shrineのキャッシュディレクトリを削除)
    if Dir.exist?(cache_dir)
      FileUtils.rm_rf(cache_dir)
    end
    # remove store directory for shrine (Shrineのストアディレクトリを削除)
    if Dir.exist?(store_dir)
      FileUtils.rm_rf(store_dir)
    end
  end
end
