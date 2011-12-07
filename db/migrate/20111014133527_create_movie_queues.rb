class CreateMovieQueues < ActiveRecord::Migration
  def change
    create_table :movie_queues do |t|

      t.timestamps
    end
  end
end
