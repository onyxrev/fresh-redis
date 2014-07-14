class FreshRedis
  def self.get(name)
    content = $redis.get(name)
    return content.present? ? JSON.parse(content) : content
  end

  def self.freshen(name, expire_age = nil, format = :ruby, &blk)
    self.unset(name) if self.skip_cache?

    unless contents = $redis.get(name)
      contents = self.set(name, blk.call())
      $redis.expire(name, expire_age.seconds) if expire_age
    end

    contents = JSON.parse(contents) unless (format == :json)

    return contents
  end

  def self.set(name, contents)
    contents = JSON.generate(contents)
    $redis.set(name, contents)

    return contents
  end

  def self.unset(name)
    return $redis.del(name) == 1
  end

  private

  def self.skip_cache?
    return ["development", "test"].include? RAILS_ENV
  end
end
