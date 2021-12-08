# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create(name: 'Erika', email: 'eak@example.com')
base = user.folders.create(name: 'erika_base', base: true)
user.folders.create(name: 'erika_sub1', base: false, parent_id: base.id)
user.folders.create(name: 'erika_sub2', base: false, parent_id: base.id)
base.resources.create(
    name: 'Stack Overflow', 
    url: 'https://stackoverflow.com/questions/35226357/change-foreign-key-column-name-in-rails', 
    image: 'https://cdn.sstatic.net/Sites/stackoverflow/Img/apple-touch-icon@2.png?v=73d79a89bded')
