class CreateActivePoll < ActiveRecord::Migration
  def self.up
    create_table :active_poll_questions do |t|
      t.column "name",     :string
      t.column "description", :string
      t.column "is_active", :boolean, :default => true
      t.column "multiple",   :boolean, :default => false
      t.column "max_multiple",   :integer, :default => 1
      t.column "start_date",   :datetime
      t.column "end_date",   :datetime
      t.column "target",   :integer, :default => 3
      t.column "product_id", :integer
      t.column "city_id", :integer, :default => 1
      t.column "tags", :string
      t.column "posted_date", :timestamp
      t.timestamps
    end
    create_table :active_poll_answers do |t|
      t.column "description", :string
      t.column "active_poll_question_id",   :integer
      t.column "votes",    :integer, :default => 0
      t.timestamps
    end
    create_table :active_poll_user_answers do |t|
      t.column "user_id", :integer
      t.column "email", :string
      t.column "active_poll_question_id",   :integer
      t.column "active_poll_answer_id",   :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :active_poll_questions
    drop_table :active_poll_answers
    drop_table :active_poll_user_answers
  end
end