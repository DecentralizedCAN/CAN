# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200124181558) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actdissents", force: :cascade do |t|
    t.string "title"
    t.bigint "activity_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_actdissents_on_activity_id"
    t.index ["user_id"], name: "index_actdissents_on_user_id"
  end

  create_table "activities", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "activation"
    t.text "participants"
    t.integer "deadline"
    t.integer "expiration"
    t.bigint "solution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "creator"
    t.index ["solution_id"], name: "index_activities_on_solution_id"
  end

  create_table "activities_users", id: false, force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "user_id", null: false
    t.index ["activity_id", "user_id"], name: "index_activities_users_on_activity_id_and_user_id"
    t.index ["user_id", "activity_id"], name: "index_activities_users_on_user_id_and_activity_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "discussion_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discussion_id"], name: "index_comments_on_discussion_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "crialts", force: :cascade do |t|
    t.string "alternative"
    t.bigint "criterium_id"
    t.integer "transferred_user_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["criterium_id"], name: "index_crialts_on_criterium_id"
  end

  create_table "cridissents", force: :cascade do |t|
    t.string "title"
    t.bigint "criterium_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["criterium_id"], name: "index_cridissents_on_criterium_id"
    t.index ["user_id"], name: "index_cridissents_on_user_id"
  end

  create_table "criteria", force: :cascade do |t|
    t.string "title"
    t.text "alternatives"
    t.bigint "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "creator"
    t.index ["problem_id"], name: "index_criteria_on_problem_id"
  end

  create_table "criteria_users", id: false, force: :cascade do |t|
    t.bigint "criterium_id", null: false
    t.bigint "user_id", null: false
    t.index ["criterium_id", "user_id"], name: "index_criteria_users_on_criterium_id_and_user_id"
    t.index ["user_id", "criterium_id"], name: "index_criteria_users_on_user_id_and_criterium_id"
  end

  create_table "discussions", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "post_id"
    t.bigint "problem_id"
    t.bigint "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "comment_id"
    t.bigint "solution_id"
    t.string "creator"
    t.index ["activity_id"], name: "index_discussions_on_activity_id"
    t.index ["comment_id"], name: "index_discussions_on_comment_id"
    t.index ["post_id"], name: "index_discussions_on_post_id"
    t.index ["problem_id"], name: "index_discussions_on_problem_id"
    t.index ["solution_id"], name: "index_discussions_on_solution_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.text "details"
    t.bigint "user_id"
    t.bigint "criterium_id"
    t.bigint "activity_id"
    t.bigint "problem_id"
    t.bigint "discussion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_notifications_on_activity_id"
    t.index ["criterium_id"], name: "index_notifications_on_criterium_id"
    t.index ["discussion_id"], name: "index_notifications_on_discussion_id"
    t.index ["problem_id"], name: "index_notifications_on_problem_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "polls", force: :cascade do |t|
    t.integer "answer"
    t.bigint "criterium_id"
    t.bigint "solution_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["criterium_id"], name: "index_polls_on_criterium_id"
    t.index ["solution_id"], name: "index_polls_on_solution_id"
    t.index ["user_id"], name: "index_polls_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.boolean "visible", default: true
    t.bigint "problem_id"
    t.bigint "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "discussion_id"
    t.index ["activity_id"], name: "index_posts_on_activity_id"
    t.index ["discussion_id"], name: "index_posts_on_discussion_id"
    t.index ["problem_id"], name: "index_posts_on_problem_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "suggestion_min"
    t.integer "updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "creator"
  end

  create_table "problems_users", id: false, force: :cascade do |t|
    t.bigint "problem_id", null: false
    t.bigint "user_id", null: false
    t.index ["problem_id", "user_id"], name: "index_problems_users_on_problem_id_and_user_id"
    t.index ["user_id", "problem_id"], name: "index_problems_users_on_user_id_and_problem_id"
  end

  create_table "rolls", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "minimum"
    t.integer "maximum"
    t.bigint "activity_id"
    t.bigint "solution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_rolls_on_activity_id"
    t.index ["solution_id"], name: "index_rolls_on_solution_id"
  end

  create_table "rolls_users", id: false, force: :cascade do |t|
    t.bigint "roll_id", null: false
    t.bigint "user_id", null: false
    t.index ["roll_id", "user_id"], name: "index_rolls_users_on_roll_id_and_user_id"
    t.index ["user_id", "roll_id"], name: "index_rolls_users_on_user_id_and_roll_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "title"
    t.boolean "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "solutions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "score"
    t.bigint "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "discussion_id"
    t.string "creator"
    t.index ["discussion_id"], name: "index_solutions_on_discussion_id"
    t.index ["problem_id"], name: "index_solutions_on_problem_id"
  end

  create_table "solutions_users", id: false, force: :cascade do |t|
    t.bigint "solution_id", null: false
    t.bigint "user_id", null: false
    t.index ["solution_id", "user_id"], name: "index_solutions_users_on_solution_id_and_user_id"
    t.index ["user_id", "solution_id"], name: "index_solutions_users_on_user_id_and_solution_id"
  end

  create_table "upvotes", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "comment_id"
    t.index ["comment_id"], name: "index_upvotes_on_comment_id"
    t.index ["post_id"], name: "index_upvotes_on_post_id"
    t.index ["user_id"], name: "index_upvotes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "email_notifications", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "last_posted"
  end

  add_foreign_key "actdissents", "activities"
  add_foreign_key "actdissents", "users"
  add_foreign_key "comments", "discussions"
  add_foreign_key "comments", "users"
  add_foreign_key "crialts", "criteria"
  add_foreign_key "cridissents", "criteria"
  add_foreign_key "cridissents", "users"
  add_foreign_key "criteria", "problems"
  add_foreign_key "discussions", "activities"
  add_foreign_key "discussions", "comments"
  add_foreign_key "discussions", "posts"
  add_foreign_key "discussions", "problems"
  add_foreign_key "discussions", "solutions"
  add_foreign_key "notifications", "activities"
  add_foreign_key "notifications", "criteria"
  add_foreign_key "notifications", "discussions"
  add_foreign_key "notifications", "problems"
  add_foreign_key "notifications", "users"
  add_foreign_key "polls", "criteria"
  add_foreign_key "polls", "solutions"
  add_foreign_key "polls", "users"
  add_foreign_key "posts", "activities"
  add_foreign_key "posts", "discussions"
  add_foreign_key "posts", "problems"
  add_foreign_key "rolls", "activities"
  add_foreign_key "rolls", "solutions"
  add_foreign_key "solutions", "discussions"
  add_foreign_key "solutions", "problems"
  add_foreign_key "upvotes", "comments"
  add_foreign_key "upvotes", "posts"
  add_foreign_key "upvotes", "users"
end
