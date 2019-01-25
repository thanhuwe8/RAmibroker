#' Title
#'
#' @param data
#' @param tickerlist
#'
#' @return
#' @export
#'
#' @examples
#' dataraw <- read.table("data-raw/FULLDATA20132018.txt", sep = ",", header=T)
#' tickerlist <- data(tickerlist2)
#' ImportAmibroker(dataraw, tickerlist) # Auto assignm variables.
ImportAmibroker <- function(data, tickerlist){
    tryCatch(for(i in tickerlist){
        temp <- data[data$Ticker==i,]
        if (nrow(temp)==0){
            print(paste0("Cannot find the data of ticker ",i))
        } else {
            nor <- nrow(temp)
            rownames(temp) <- 1:nor
            assign(i, temp, envir = parent.frame())
            print(paste0("Ticker ",i, " is loaded sucessfully"))
        }

    },
    error = function(c) "error, check function arguments",
    warning = function(c) "warning",
    message = function(c) "message"
    )
}

#' Title
#'
#' @param data
#' @param tickerlist
#'
#' @return
#' @export
#'
#' @examples
#' #' dataraw <- read.table("data-raw/FULLDATA20132018.txt", sep = ",", header=T)
#' tickerlist <- data(tickerlist2)
#' final_data <- ImportAmibroker(dataraw, tickerlist)

ImportAmibrokerDF <- function(data, tickerlist){
    options(warn=-1)
    final_frame <- NULL
    for (i in tickerlist){
        temp <- data[data$Ticker==i,]
        if (nrow(temp)==0){
            print(paste0("Cannot find the data of ticker ",i))
        } else {
            if (is.null(final_frame)){
                nor <- nrow(temp)
                rownames(temp) <- 1:nor
                final_frame <- temp[,c("Date", "Close")]
            } else{
                nor <- nrow(temp)
                rownames(temp) <- 1:nor
                merge_temp <- temp[,c("Date", "Close")]
                final_frame <- merge(final_frame, temp[,c("Date", "Close")], by = "Date", all = T)
            }

            print(paste0("Ticker ",i, " is loaded sucessfully"))
        }

    }
    return(final_frame)
}


