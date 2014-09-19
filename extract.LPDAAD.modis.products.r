# install.packages("MODISTools")
library("MODISTools", lib.loc="~/R/win-library/3.0")

if (sessionInfo()[[2]]=="x86_64-apple-darwin10.8.0 (64-bit)") folder<-"/Users/mlc/manels docs/manel/investigacao/modis_time_composites" #folder<-"/Volumes/HP v125w/modis_time_composites/" 
if (sessionInfo()[[2]]!="x86_64-apple-darwin10.8.0 (64-bit)") folder<-"Z:\\manel\\investigacao\\modis_time_composites"
gofile<-function(name){paste(folder,name,sep="/")}

source(gofile("functions.r"))
source(gofile("constants.r"))

savedir<-"C:\\Users\\mlc\\Documents\\investigacao\\modistools_data_ascii"

# list modis products available at LP DAAC
GetProducts()

prd<-"MCD43A1"

# lists fields for the product
GetBands(prd)
# [1] "BRDF_Albedo_Parameters_Band1.Num_Parameters_01"     "BRDF_Albedo_Parameters_Band1.Num_Parameters_02"    
# [3] "BRDF_Albedo_Parameters_Band1.Num_Parameters_03"     "BRDF_Albedo_Parameters_Band2.Num_Parameters_01"    

# lists available dates in Ayyyyddd format for a location
GetDates(Product= prd,Lat=c(pos$lat$ns),Long=c(pos$long$ns))

# define locations to extract data by lat/long (in decimal)
# can use ConvertToDD to convert 51d24.106'N to 51.40177
# dates specified in POSIXlt (?POSIXlt)
modis.subset<-data.frame(lat=c(pos$lat$ns,pos$lat$ew),long=c(pos$long$ns,pos$long$ew),start.date=c(2014, 2014),end.date=c(2014,2014))

# lê e copia para um ficheiro ascii as observações de um clip de tamanho size
# há tantos ficheiros quando localizações definidas em modis.subset
#Size in integers (km) (first along col, second along row)
MODISSubsets(LoadDat = modis.subset, Products = prd,
             Bands = c("BRDF_Albedo_Parameters_Band2.Num_Parameters_01" , "BRDF_Albedo_Parameters_Band2.Num_Parameters_02"  , "BRDF_Albedo_Parameters_Band2.Num_Parameters_03"  ),
             Size = round(c(clip$col$ns/2000,clip$row$ns/2000)),
             SaveDir=savedir)

# look at contents of first file (one location)
subset.string <- read.csv(paste(savedir,list.files(path=savedir,pattern = ".asc")[1],sep="/"),header = FALSE, as.is = TRUE)
