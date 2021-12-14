module Mutations
    module Resources
      class CreateResource < GraphQL::Schema::Mutation
        argument :name, String, required: true
        argument :url, String, required: true
        argument :folder_id, ID, required: true

        def resolve(name:, url:, folder_id:)
          img = get_image(url)
         
          new_res = Resource.new(name: name, url: url, image: img, folder_id: folder_id)
    
          if new_res.save
            Folder.find(folder_id)
          else
            raise GraphQL::ExecutionError, new_res.errors.full_messages.join(", ")
          end
        end

        private

        def get_image(url)
          page = MetaInspector.new(url)
          img = page.images.best 
          if img.nil?
            img = "https://www.oiml.org/en/ressources/icons/link-icon.png/image_preview"
          end
          img
        end
  
      end
    end
  end