require "rails_helper"

describe "/photos/[SOME ID]" do
  it "automatically associates photo with signed in user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit "/sign_in"
    
    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end
    
    visit "/photos/#{photo.id}"


    expect(page).to have_text("Update photo")
  end
end

describe "/photos/[SOME ID]" do
  it "automatically associates like with signed in user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.likes_count = 0
    photo.save

    visit "/sign_in"
    
    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end
    
    visit "/photos/#{photo.id}"
    old_likes_count = 0

    click_on "Like"

    expect(photo.likes_count).to eql(old_likes_count + 1)
  end
end

describe "/photos/[ID] — Add comment form" do
  it "automatically associates comment with signed in user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit "/sign_in"
    
    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end

    test_comment = "Hey, what a nice app you're building!"

    visit "/photos/#{photo.id}"

    fill_in "Comment", with: test_comment

    click_on "Add comment"

    added_comment = Comment.where({ :author_id => first_user.id, :photo_id => photo.id, :body => test_comment }).at(0)

    expect(added_comment).to_not be_nil
  end
end

# describe "/photos/[ID]" do
#   it "shows edit form when photo belongs to signed in user", points: 1 do

#     image = "https://some.test/image-#{Time.now.to_i}.jpg"
#     test_caption = "Some test caption #{Time.now.to_i}"

#     user = User.new
#     user.username = "BagelFace"
#     user.save
    
#     photo = Photo.new
#     photo.image = image
#     photo.caption = test_caption
#     photo.owner_id = user.id
#     photo.save

#     log_in user

#     visit "/photos/#{photo.id}"

#     page.find_button("Update photo").click




#   end
# end