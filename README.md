# Thumbtack API

[![thumbtack-turing](https://circleci.com/gh/thumbtack-turing/thumbtack_api.svg?style=svg)](https://app.circleci.com/pipelines/github/thumbtack-turing/thumbtack_api)

Thumbtack API allows a user to store internet resources within a folder structure of their own making. A user can add resources to their base folder, or they can create folders within their base folder to store resources by category/topic.

This application is deployed on [Heroku](https://thumbtack-api.herokuapp.com/graphql) and utilizes a single endpoint for all queries and mutations:
* `post thumbtack-api.herokuapp.com/graphql`

## Local Setup

**Ruby version:**
* `ruby '2.7.2'`
* `'rails', '~> 6.1.4', '>= 6.1.4.1'`

**System dependencies:**
* PostgresQL `'pg', '~> 1.1'`
* GraphQL `'graphql'`
* [MetaInspector](https://github.com/metainspector/metainspector) `metainspector`
* Rack CORS `rack-cors`
* `group :development`
  * Graphiql `graphiql-rails`
* `group :test`
  * RSpec `rspec-rails`
  * [Shoulda-Matchers](https://matchers.shoulda.io/docs/v5.0.0/) `shoulda-matchers`
  * [Simplecov](https://github.com/simplecov-ruby/simplecov) `simplecov`

**Configuration:**
* `git clone git@github.com:thumbtack-turing/thumbtack_api.git`
* `bundle install`
* `rails db:{create,migrate}`

**Testing:**
* `bundle exec rspec`
* Manual testing can be done using http://localhost:3000/graqhiql by running `rails s` from the command line

## Database Schema
![Schema](https://user-images.githubusercontent.com/83834410/145138692-f0944d05-2d60-41c7-af28-76b4b7d5e69a.png)

## Queries:

### Get User
```
query {
      getUser(email: "eak@example.com") {
        name
        email
        id
        baseFolder{
              id
              name
              base
      }
  }

```

### Get Folder
```
query {
      getFolder (id: 1) {
        id
        name
        base
        parentId
        childFolders {
            id
            name
            base
            parentId
        }
        childResources {
            id
            name
            url
            image
            createdAt
        }
      }
    }
```

## Mutations:

### Create Resource
```
mutation {
  createResource(
    name: "I am a resource",
    url: "https://stackoverflow.com",
    folderId: 1) {
    id
    name
    base
    parentId
    childResources {
      id
      name
      url
      image
      createdAt
    }
    childFolders {
      id
      name
      base
      parentId
    }
  }
}
```

### Update Resource
requires resource id, folderId, and one or both of: newFolderId (new folder destination) or name (new name of resource)
```
mutation {
  updateResource (id: 1, folderId: 2, newFolderId: 3, name: "New name") {
      updatedResource {
        id
        name
        url
        image
        folderId
        folder {
          id
          name
          base
          parentId
          childFolders {
            id
            name
            base
            parentId
          }
          childResources {
            id
            name
            url
            image
            createdAt
          }
        }
      }
      originalParent {
        id
        name
        base
        parentId
        childFolders {
          id
          name
          base
          parentId
        }
        childResources {
          id
          name
          url
          image
          createdAt
        }
      }
    }
  }
```
### Delete Resource
```
mutation {
      deleteResource(
          id: 1
      ){
        id
        name
        base
        parentId
        childResources {
            id
            name
            url
            image
            createdAt
        }
        childFolders {
            id
            name
            base
            parentId
        }
      }
}
```

### Create User
```
mutation {
    createUser(
      name: "Odell",
      email: "odellthedog@test.com"
    ) {
        name
        email
        baseFolder {
          id
          name
        }
      }
  }
```

### Delete User
```
mutation {
    deleteUser(
     id: 2
    ) {
        id
        name
        email
      }
  }
```

### Create Folder
```
 mutation {
      createFolder(
          userId: 1
          parentId: 1
          name: "Shallan"
        )
      {
        parentFolder {
          id
          name
          base
          parentId
          childFolders {
            id
            name
            base
            parentId
          }
          childResources {
            id
            name
            url
            image
            createdAt
          }
        }
        newFolder {
          id
          name
          base
          parentId
          childFolders {
            name
          }
        }
      }
    }
```

### Update Folder

Update folder name
```
 mutation {
      folders: updateFolder (
        id: 2
        name: "Husband")
        {
        updatedFolder {
          id
          name
          base
          parentId
        }
        originalParent {
          id
          name
          base
          childFolders {
            id
            name
            base
            parentId
          }
          childResources{
            id
            name
            url
            image
            createdAt
          }
        }
      }
    }
```

Update parent folder

```
 mutation {
      folders: updateFolder (
        id: 2
        newParentId: 5
        name: "Honor is dead.")
        {
        updatedFolder {
          id
          name
          base
          parentId
        }
        originalParent {
          id
          name
          base
          childFolders {
            id
            name
            base
            parentId
          }
        }
        errors
      }
    }
 ```
### Delete Folder

```
 mutation {
      deleteFolder (
      id: 8
    ) {
        id
        name
        base
        parentId
      }
    }
```

## Contributors
* Rowan DeLong - rowanwinzer@gmail.com - [LinkedIn](https://www.linkedin.com/in/rowandelong/)
* Erika Kischuk - erika.kischuk@gmail.com - [LinkedIn](https://www.linkedin.com/in/erika-kischuk/)
* Jamie Pace - jamiejpace@gmail.com - [LinkedIn](https://www.linkedin.com/in/jamiejpace/)
