# study-spaces

SETUP:



# CODEOWNERS:

The codeowners file exists as the source of truth for relying on who owns what. Imagine, if code inside this project breaks. With a codeowners file, we can easily track down who owns the code to help resolve an error. Additionally, if you are confused about a piece of code you didn't write, you can always refer to the codeowners file to figure out who wrote it. Lastly, the codeowners file helps define what you are working on. The codeowners file lives in the main directory and should be updated whenever someone creates a folder/file that is not already covered.

### Example 1:
Below, it is saying the user dilanrocco is the owner of the .gitignore file.

```
.gitignore @dilanroocco
```

### Example 2:
Here it is saying that the MapUX team owns the the `mapux` folder. Here the mapux would own all sub-directories in the `mapux` folder.
```
MapUX/ @wedev/mapux
```

In general, it's a good idea to include your team name for a specific file/directory. However, if you are the sole owner of one part of the code, feel free to just tag yourself.





