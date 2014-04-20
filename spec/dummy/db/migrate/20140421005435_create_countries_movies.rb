class CreateCountriesMovies < ActiveRecord::Migration
  def change
    create_table :countries_movies do |t|
      t.integer :country_id
      t.integer :movie_id
    end
  end
end
