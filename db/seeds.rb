# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
:wq
profile = Profile.find_by_facebook_profile_id('726075017').nil?
if(profile == nil)
  profile = Profile.create([{ facebook_profile_id: '726075017' }])
end

photo = Photo.create([{ name: 'F9F116E0-426A-012F-05BE-4040A06C9F37' }])
puts photo.errors

