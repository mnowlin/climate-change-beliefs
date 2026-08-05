dir.create("data")
dir.create("scripts")
dir.create("output")
dir.create("manuscript")


## set-up manuscript folder 
project_folder <- "/Users/matthewnowlin/Library/CloudStorage/OneDrive-UTArlington/01-IN PROGRESS/Research/climate-beliefs"

file.copy("/Users/matthewnowlin/Library/CloudStorage/Dropbox/Projects/Manuscript-Files/template.qmd",
          to=project_folder, copy.mode = TRUE)


