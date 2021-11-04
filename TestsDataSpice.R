### load dataspice

renv::restore()

## Check the files we have

Files <- list.files("FakeData/", pattern = ".csv", full.names = T)

## Create a dataspice

create_spice()

## Editing the creators

edit_creators()

### Preparing and editing the access

for(i in 1:length(Files)){
  prep_access(data_path = Files[i])
}

edit_access()


### Preparing and editing the attributes

for(i in 1:length(Files)){
  prep_attributes(data_path = Files[i])
}

edit_attributes()

### Editing the bibliofile

edit_biblio()

## Now we create the dataspice json file

write_spice()

## And turn it into a html webpage

build_site()


### Now turn it into a EML file

EMLTest <- spice_to_eml()
write_eml(EMLTest,  "docs/test.xml")
