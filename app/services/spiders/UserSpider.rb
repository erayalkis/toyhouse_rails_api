class Spiders::UserSpider < Spiders::ToyhouseSpider
  @name = 'user_spider'

  def parse(response, url:, data: {})
    user = {}
    
    user[:name] = response.css('span.display-user-username')[0].text
    unless response.css('div.profile-feature-content').empty?
      user[:featured_character] = {}
      user[:featured_character][:name] = response.css('div.thumb-character-name > a.character-name-badge').text.strip
      user[:featured_character][:profile] = response.css('div.thumb-character-name > a.character-name-badge')[0]['href']
      user[:featured_character][:thumbnail] = response.css('div.profile-feature-thumb > div.thumb-image > a.img-thumbnail > img')[0]['src']
      unless response.css('div.profile-feature-gallery').empty?
        user[:featured_character][:images] = response.css('a.th.img-thumbnail > img').map { |img| img['src'] }
      end
    end

    unless response.css('div.profile-characters-content').empty?
      user[:recent_characters] = []
      response.css('div.gallery-row.mini > div').each do |div|
        character = {}
        character[:name] = div.css('div.thumb-caption > span').text.strip
        character[:profile] = div.css('div.thumb-caption > span > a')[0]['href']
        character[:image] = div.css('div.thumb-image > a > img')[0]['src']
        user[:recent_characters] << character
      end
    end

    unless response.css('div.profile-section.user-content').empty?
      user[:description] = ""
      response.css('div.profile-section.user-content')[0].children.each { |child| user[:description] += "#{child.text}\n " }
    end

    # Add comment fetching in the future if user demand is high
    return user
  end
end