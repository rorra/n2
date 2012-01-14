require 'factory_girl'

def random_string
  "random-#{rand(1000000000)}"
end

Factory.define :user do |f|
  f.login                   { random_string }
  f.name                    { random_string }
  f.email                   { random_string + "@gmail.com" }
  f.password                { "asdfasdf" }
  f.password_confirmation   { "asdfasdf" }
end

Factory.define :content do |f|
  f.title     { random_string }
  f.url       { "http://#{random_string}.com" }
  f.caption   { random_string }
  f.association :user, :factory => :user
end

Factory.define :article do |f|
  f.body   random_string
  # TODO:: ADD VALIDATION FOR USER
  f.association :author, :factory => :user
  #f.association :content, :factory => :content
  f.content {|a| a.association :content, :user => a.author }
end

Factory.define :gallery do |f|
  f.title       { random_string }
  f.description { random_string }
  f.association :user, :factory => :user
end

Factory.define :gallery_item do |f|
  f.item_url    "http://dummyimage.com/200x200.jpg"
  f.association :gallery, :factory => :gallery
end

Factory.define :video do |f|
  f.remote_video_url  "http://www.youtube.com/watch?v=ObR3qi4Guys"
end

Factory.define :forum do |f|
  f.name        { random_string }
  f.description { random_string }
end

Factory.define :topic do |f|
  f.title       { random_string }
  f.body        { random_string }
  f.association :user, :factory => :user
  f.association :forum, :factory => :forum
end

Factory.define :comment do |f|
  f.comments    { random_string }
  f.association :user, :factory => :user
  f.commentable {|a| a.association :content, :user => a.user }
end

Factory.define :flag do |f|
  f.flag_type   Flag.flag_types.sample
  f.association :flaggable, :factory => :content
  f.association :user, :factory => :user
end

Factory.define :question do |f|
  f.question    { random_string }
  f.association :user, :factory => :user
end

Factory.define :answer do |f|
  f.answer      { random_string }
  f.association :user, :factory => :user
  f.association :question, :factory => :question
end

Factory.define :feed do |f|
  f.association :user, :factory => :user
  f.url       "http://#{random_string}"
  f.rss       "http://#{random_string}/feed.rss"
  f.title       { random_string }
end

Factory.define :newswire do |f|
  f.association :feed, :factory => :feed
  f.association :user, :factory => :user
  f.url         "http://#{random_string}"
  f.title       random_string
  f.caption     random_string
end

Factory.define :event do |f|
  f.association :user, :factory => :user
  f.url         "http://#{random_string}"
  f.name        random_string
end

Factory.define :idea_board do |f|
  f.name        random_string
  f.section     random_string
  f.description random_string
end

Factory.define :idea do |f|
  f.association :user, :factory => :user
  f.association :idea_board, :factory => :idea_board
  f.title       random_string
end

Factory.define :resource_section do |f|
  f.name        random_string
  f.section     random_string
  f.description random_string
end

Factory.define :resource do |f|
  f.association :user, :factory => :user
  f.association :resource_section, :factory => :resource_section
  f.title       random_string
  f.url         "http://#{random_string}"
end

Factory.define :related_item do |f|
  f.association :user, :factory => :user
  f.association :relatable, :factory => :event
  f.title       random_string
  f.url         "http://#{random_string}"
end

Factory.define :classified do |f|
  f.title       random_string
  f.details     random_string
  f.allow       "all"
  f.association :user, :factory => :user
  f.listing_type  "sale"
end

Factory.define :available_classified, :parent => :classified do |f|
  f.aasm_state "available"
end

Factory.define :sale_classified, :parent => :available_classified do |f|
  f.listing_type "sale"
end

Factory.define :free_classified, :parent => :available_classified do |f|
  f.listing_type "free"
end

Factory.define :loan_classified, :parent => :available_classified do |f|
  f.listing_type "loan"
end

Factory.define :category do |f|
  f.name random_string
end

Factory.define :subcategory, :parent => :category do |f|
  f.name random_string
  f.association :parent, :factory => :category
end
