require "rails_helper"

describe "/photos" do
  it "has a functional RCAV", points: 1 do
    visit "/photos"

    expect(page.status_code).to be(200)
  end
end

describe "/photos" do
  it "has a form", points: 1 do
    visit "/photos"

    expect(page).to have_css("form", count: 1)
  end
end

describe "/photos" do
  it "has a label for 'Image'", points: 1, hint: h("copy_must_match label_for_input") do
    visit "/photos"

    expect(page).to have_css("label", text: "Image")
  end
end

describe "/photos" do
  it "has two input elements (for image and owner id)", points: 1, hint: h("label_for_input") do
    visit "/photos"

    expect(page).to have_css("input", count: 2)
  end
end

describe "/photos" do
  it "has a label for 'Caption'", points: 1, hint: h("copy_must_match label_for_input") do
    visit "/photos"

    expect(page).to have_css("label", text: "Caption")
  end
end

describe "/photos" do
  it "has one textarea element (for caption)", points: 1, hint: h("label_for_input") do
    visit "/photos"

    expect(page).to have_css("textarea", count: 1)
  end
end

describe "/photos" do  it "has a button that says 'Add photo'", points: 1, hint: h("copy_must_match") do
    visit "/photos"

    expect(page).to have_css("button", text: "Add photo")
  end
end

describe "/photos" do
  it "creates a photo when submitted", points: 1, hint: h("button_type") do
    initial_number_of_photos = Photo.count

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    test_user = User.new
    test_user.username = "username"
    test_user.save 

    visit "/photos"

    fill_in "Image", with: test_image
    fill_in "Caption", with: test_caption
    fill_in "Owner ID", with: test_user.id

    click_on "Add photo"

    final_number_of_photos = Photo.count

    expect(final_number_of_photos).to eq(initial_number_of_photos + 1)
  end
end

describe "/photos" do
  it "saves the caption when submitted", points: 1, hint: h("label_for_input") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    test_user = User.new
    test_user.username = "username"
    test_user.save 

    visit "/photos"

    fill_in "Image", with: test_image
    fill_in "Caption", with: test_caption
    fill_in "Owner ID", with: test_user.id

    click_on "Add photo"

    last_photo = Photo.order(created_at: :asc).last
    expect(last_photo.caption).to eq(test_caption)
  end
end

describe "/photos" do
  it "saves the image URL when submitted", points: 1, hint: h("label_for_input") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    test_user = User.new
    test_user.username = "username"
    test_user.save 

    visit "/photos"

    fill_in "Image", with: test_image
    fill_in "Caption", with: test_caption
    fill_in "Owner ID", with: test_user.id


    click_on "Add photo"

    last_photo = Photo.order(created_at: :asc).last
    expect(last_photo.image).to eq(test_image)
  end
end

describe "/photos" do
  it "redirects to /photos/[PHOTO ID] when submitted", points: 1, hint: h("redirect_vs_render") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    visit "/photos"

    user = User.new
    user.username = "adora"
    user.save

    fill_in "Image", with: test_image
    fill_in "Caption", with: test_caption
    fill_in "Owner ID", with: user.id

    click_on "Add photo"

    expect(page).to have_current_path("/photos/#{Photo.last.id}")
  end
end

describe "/delete_photo/[PHOTO ID]" do
  it "removes a record from the Photo table", points: 1 do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"
    
    user = User.new
    user.username = "adora"
    user.save
    
    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/delete_photo/#{photo.id}"

    expect(Photo.exists?(photo.id)).to be(false)
  end
end

describe "/delete_photo/[PHOTO ID]" do
  it "redirects to /photos", points: 1, hint: h("redirect_vs_render") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "adora"
    user.save

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/delete_photo/#{photo.id}"

    expect(page).to have_current_path("/photos")
  end
end

describe "/photos/[ID]" do
  it "has at least one form", points: 1 do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save
    
    photo = Photo.new
    photo.image = test_image
    photo.owner_id = user.id
    photo.caption = test_caption
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("form", minimum: 1)
  end
end

describe "/photos/[ID]" do
  it "has all required forms", points: 1 do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save
    
    photo = Photo.new
    photo.image = test_image
    photo.owner_id = user.id
    photo.caption = test_caption
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("form", minimum: 3)
  end
end

describe "/photos/[ID]" do
  it "has a label for 'Image'", points: 1, hint: h("copy_must_match label_for_input") do
 
    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("label", text: "Image")
  end
end

describe "/photos/[ID]" do
  it "has a label for 'Caption'", points: 1, hint: h("copy_must_match label_for_input") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save
    
    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("label", text: "Caption")
  end
end

describe "/photos/[ID]" do
  it "has two textarea (for caption and comment)", points: 1, hint: h("label_for_input") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"


    user = User.new
    user.username = "BagelFace"
    user.save
    
    photo = Photo.new
    photo.image = test_image
    photo.owner_id = user.id
    photo.caption = test_caption
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("textarea", count: 2)
  end
end

describe "/photos/[ID]" do
  it "has a button that says 'Update photo'", points: 1, hint: h("label_for_input") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("button", text: "Update photo")
  end
end

describe "/photos/[ID]" do
  it "has image input prepopulated", points: 1, hint: h("value_attribute") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save
    
    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("input[value='#{test_image}']")
  end
end

describe "/photos/[ID]" do
  it "has caption textarea prepopulated", points: 1, hint: h("prepopulate_textarea") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"


    user = User.new
    user.username = "BagelFace"
    user.save
    
    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_content(test_caption)
  end
end

describe "/photos/[ID]" do
  it "updates caption when submitted", points: 1, hint: h("label_for_input button_type") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    old_caption = "Some test caption #{Time.now.to_i}"


    user = User.new
    user.username = "BagelFace"
    user.save

    photo = Photo.new
    photo.image = test_image
    photo.caption = old_caption
    photo.owner_id = user.id
    photo.save

    new_caption = "New caption #{Time.now.to_i}"

    visit "/photos/#{photo.id}"
    fill_in "Caption", with: new_caption
    click_on "Update photo"

    photo_as_revised = Photo.find(photo.id)

    expect(photo_as_revised.caption).to eq(new_caption)
  end
end

describe "/photos/[ID]" do
  it "updates image image when submitted", points: 1, hint: h("label_for_input button_type") do

    old_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save
    
    photo = Photo.new
    photo.image = old_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    new_image = "http://new.image/image_#{Time.now.to_i}.jpg"

    visit "/photos/#{photo.id}"
    fill_in "Image", with: new_image
    click_on "Update photo"

    photo_as_revised = Photo.find(photo.id)

    expect(photo_as_revised.image).to eq(new_image)
  end
end

describe "/photos/[ID]" do
  it "redirects to the photo's details page", points: 1, hint: h("embed_vs_interpolate redirect_vs_render") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save
    
    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"
    click_on "Update photo"

    expect(page).to have_current_path("/photos/#{photo.id}")
  end
end

describe "/photos/[ID] — Add fan form" do
  it "has a label for 'Author ID'", points: 1, hint: h("copy_must_match label_for_input") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save
    
    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("label", text: "Author ID")
  end
end

describe "/photos/[ID] — Add fan form" do
  it "has an input containing the photo's ID", points: 0 do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("input[value='#{photo.id}']", visible: false)
  end
end

describe "/photos/[ID] — Add fan form" do
  it "has a button that says 'Add fan'", points: 1 do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("button", text: "Add fan")
  end
end

describe "/photos/[ID] — Add fan form" do
  it "works", points: 1 do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    first_other_user = User.new
    first_other_user.username = "bob_#{Time.now.to_i}"
    first_other_user.save

    second_other_user = User.new
    second_other_user.username = "carol_#{Time.now.to_i}"
    second_other_user.save

    visit "/photos/#{photo.id}"

    fill_in "Fan ID", with: second_other_user.id

    click_on "Add fan"

    new_like = Like.find_by(photo_id: photo.id, fan_id: second_other_user.id)

    expect(new_like).to_not be_nil
  end
end

describe "/photos/[ID] — Add fan form" do
  it "redirects back to the same page", points: 1 do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    first_other_user = User.new
    first_other_user.username = "bob_#{Time.now.to_i}"
    first_other_user.save

    second_other_user = User.new
    second_other_user.username = "carol_#{Time.now.to_i}"
    second_other_user.save

    visit "/photos/#{photo.id}"

    fill_in "Author ID", with: second_other_user.id

    click_on "Add fan"

    expect(page).to have_current_path("/photos/#{photo.id}")
  end
end

describe "/photos/[ID] — Add comment form" do
  it "has a label for 'Author ID'", points: 1, hint: h("copy_must_match label_for_input") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"
    
    user = User.new
    user.username = "BagelFace"
    user.save

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("label", text: "Author ID")
  end
end

describe "/photos/[ID] — Add comment form" do
  it "has a label for 'Comment'", points: 1, hint: h("copy_must_match label_for_input") do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("label", text: "Comment")
  end
end

describe "/photos/[ID] — Add comment form" do
  it "has a textarea for the comment", points: 1 do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("textarea")
  end
end

describe "/photos/[ID] — Add comment form" do
  it "has a button that says 'Add comment'", points: 1 do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    user = User.new
    user.username = "BagelFace"
    user.save 

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"

    expect(page).to have_css("button", text: "Add comment")
  end
end

describe "/photos/[ID] — Add comment form" do
  it "works", points: 1 do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"
    test_comment = "Some new comment #{Time.now.to_i}"
    
    first_other_user = User.new
    first_other_user.username = "bob_#{Time.now.to_i}"
    first_other_user.save

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = first_other_user.id
    photo.save

    second_other_user = User.new
    second_other_user.username = "carol_#{Time.now.to_i}"
    second_other_user.save

    visit "/photos/#{photo.id}"

    fill_in "Comment", with: test_comment
    fill_in "Author ID", with: second_other_user.id

    click_on "Add comment"

    new_comment = Comment.find_by(author_id: second_other_user.id, body: test_comment)

    expect(new_comment).to_not be_nil
  end
end

describe "/photos/[ID] — Add comment form" do
  it "redirects back to the same page", points: 1 do

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"
    test_comment = "Some new comment #{Time.now.to_i}"

    first_other_user = User.new
    first_other_user.username = "bob_#{Time.now.to_i}"
    first_other_user.save

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = first_other_user.id
    photo.save
    
    second_other_user = User.new
    second_other_user.username = "carol_#{Time.now.to_i}"
    second_other_user.save

    visit "/photos/#{photo.id}"
    fill_in "Comment", with: test_comment
    fill_in "Author ID", with: second_other_user.id

    click_on "Add comment"

    expect(page).to have_current_path("/photos/#{photo.id}")
  end
end