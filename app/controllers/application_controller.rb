class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def promotions

    mimiEmail = ''
    mimiApiKey = ''

    mimi = MadMimi.new(mimiEmail, mimiApiKey)
    if (mimi)
      promotions = mimi.promotions
      promotionsRoot = promotions['promotions'] || {}
      promotionsChild = promotionsRoot['promotion'] || {}

      results = parse_promotions (promotionsChild)
      render json: results
    end
  end

  def parse_promotions(hash)
    ary = Array.new
    hash.each do |p|
      if (!p['name'])
        next
      end

      if (!p['mimio'])
        next
      end

      title = p['name']
      title = title.sub('(firstname,fallback=Friend), ', '')
      shortCode = p['mimio']

      ary.push({:title => title,
           :url => 'http://mim.io/' + shortCode})
    end
    ary
  end



end