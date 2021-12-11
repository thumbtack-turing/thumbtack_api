# Thumbtack API

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

## Mutations

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
        errors
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
