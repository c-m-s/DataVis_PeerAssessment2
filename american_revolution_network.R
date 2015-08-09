
library(networkD3)
library(stringr)
library(magrittr)

setwd("~/src/R/DataVisualization/DataVis_PeerAssessment2")

        # Check if the "repdata-data-StormData.csv.bz2" file is around. If it is in the
        # current working directory, then just uncompress the file, if the uncompressed
        # file isn't around, download it.
        
        if(!file.exists("brunson_revolution.tar.bz2")) {
                fileURL <- "http://konect.uni-koblenz.de/downloads/tsv/brunson_revolution.tar.bz2"
                download.file(fileURL, destfile="brunson_revolution.tar.bz2", method="curl", mode="wb")
                dateDownloaded <- date()
                print(paste("Downloaded American Revolution data file on", dateDownloaded))
        }

untar("brunson_revolution.tar.bz2")

revolution <- read.delim("brunson_revolution/out.brunson_revolution_revolution",
                         skip= 2, 
                         sep = " ", 
                         stringsAsFactors = FALSE)

names(revolution) <- c("V1", "V2", "V3")

revolution <- revolution[order(revolution$V1, revolution$V2),]
revolution$V3 <- c(1)
name <- unique(revolution$V1)

# I know this is ugly because I did it manually - someday I replace this with a single line call to ddply
group <- c(12,123,1,13,4,5,1,13,4,15,4,4,1,3,3,4,1,4,4,4,1,4,4,1,1,1,15,1,4,1,123,5,4,1,1,2,2,45,3,2,13,4,2,4,
           15,1,4,5,4,2,4,4,1,4,13,3,4,2,1,3,4,1,4,1,1,4,4,4,4,1,1,4,1,2,4,1,3,4,4,1,4,1,4,13,4,1,4,4,23,4,1,
           1,1,1,4,1,4,2,3,4,3,1,1,4,23,124,1,4,1,1,4,5,4,1,1,1,1,3,1,1,4,1,5,2,14,1234,4,4,45,3,1,4,4,2,1,13)
revNodes <- data.frame(name,group)

revNodes$group <- str_replace(revNodes$group, "^12$", "0")
revNodes$group <- str_replace(revNodes$group, "^123$", "6")
revNodes$group <- str_replace(revNodes$group, "^13$", "7")
revNodes$group <- str_replace(revNodes$group, "^15$", "8")
revNodes$group <- str_replace(revNodes$group, "^45$", "9")
revNodes$group <- str_replace(revNodes$group, "^23$", "10")
revNodes$group <- str_replace(revNodes$group, "^124$", "11")
revNodes$group <- str_replace(revNodes$group, "^14$", "12")
revNodes$group <- str_replace(revNodes$group, "^1234$", "13")

revolution$V2 <- paste("group", revolution$V2, sep = "")

src <- revolution$V1

target <- revolution$V2

value <- revolution$V3

revLinks <- data.frame(src, target, value)


simpleNetwork(revLinks, Source="src", Target="target",
              linkDistance = 50, charge = -200,
              fontSize = "14", textColour="red",
              zoom=TRUE, opacity = 0.8,
              linkColour="grey") %>%
saveNetwork(file = 'american_revolution_network.html')

