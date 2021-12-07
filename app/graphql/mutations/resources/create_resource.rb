module Mutations
    module Resources
      class CreateResource < GraphQL::Schema::Mutation
        argument :name, String, required: true
        argument :url, String, required: true
        argument :folder_id, ID, required: true

        def resolve(name:, url:, folder_id:)
          img = get_image(url)
          new_res = Resource.create(
            name: name,
            url: url,
            image: img,
            folder_id: folder_id
          )
    
          Folder.find(folder_id)
        end
  
        private

        def get_image(url)
            page = MetaInspector.new(url)
            page.images.best 
        end
  
      end
    end
  end