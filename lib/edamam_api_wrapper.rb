require 'httparty'

class EdamamApiWrapper
  BASE_URL = "https://api.edamam.com/"
  TOKEN = ENV['EDAMAM_KEY']
  APP_ID = ENV['EDAMAM_ID']

  def self.search(query, token = nil)
    token ||= TOKEN
    url = BASE_URL + "search?q=#{query}&app_id=#{APP_ID}&app_key=#{token}"

    data = HTTParty.get(url)

    if data["hits"]
      recipes = data["hits"].map do |recipe_hash|
        Recipe.new(recipe_hash["recipe"]["label"], recipe_hash["recipe"]["image"], recipe_hash["recipe"]["uri"], source: recipe_hash["recipe"]["source"], url: recipe_hash["recipe"]["url"], ingredients: recipe_hash["recipe"]["ingredientLines"], nutrition: recipe_hash["recipe"]["totalNutrients"])
      end
      return recipes
    else
      return []
    end
  end

  def self.find_recipe(uri, token = nil)
    token ||= TOKEN
    url = BASE_URL + "search?r=#{uri}&app_id=#{APP_ID}&app_key=#{token}"

    data = HTTParty.get(url)

    unless data.empty?
      recipe = Recipe.new(data[0]["label"], data[0]["image"], data[0]["uri"], source: data[0]["source"], url: data[0]["url"], ingredients: data[0]["ingredientLines"], nutrition: data[0]["totalNutrients"])

      return recipe
    else
      return []
    end
  end
end
