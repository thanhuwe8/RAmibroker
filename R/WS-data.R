
#' Title
#'
#' @param ticker
#' @param date
#'
#' @return
#' @export
#'
#' @examples
TickerUrl <- function(ticker, date){
    # date = "%d/%m/%Y"
    # date in form "dd/mm/yyyy"
    url_final <- paste0("http://s.cafef.vn/Lich-su-giao-dich-",ticker,"-6.chn?date=",date)
    return(url_final)
}

#' Title
#'
#' @param df
#'
#' @return
#' @export
#'
#' @examples
HandleData <- function(df){
    df <- df[nrow(df):1,]
    df
}

#' Title
#'
#' @param url
#' @param td
#'
#' @return
#' @export
#'
#' @examples
ReadHFD <- function(url, td){
    dt <- price <- volume <- cum_volume <- ppt <- NULL;
    webpage <- read_html(url)
    table_data <- html_nodes(webpage, 'table')
    hfd <- html_text(html_children(table_data[4]))
    n <- length(hfd)

    for (i in 1:n){
        temp <- strsplit(hfd[i], "\r\n")

        temp_date <- as.POSIXct(paste(td, temp[[1]][1]),
                                format = "%d/%m/%Y %H:%M:%S",
                                tz = "GMT")

        temp_price <- as.numeric(strsplit(gsub("^[[:space:]]+","", temp[[1]][2]), " ")[[1]][1])

        temp_volume <- as.numeric(gsub(",", "", temp[[1]][3]))
        temp_cum_volume <- as.numeric(gsub(",", "", temp[[1]][4]))
        temp_ppt <- as.numeric(gsub("\\(%\\)", "", temp[[1]][5]))

        dt <- append(dt, temp_date)
        price <- append(price, temp_price)
        volume <- append(volume, temp_volume)
        cum_volume <- append(cum_volume, temp_cum_volume)
        ppt <- append(ppt, temp_ppt)

    }
    data.frame(Time=dt, Price=price, Size=volume,
               cum_volume=cum_volume, ppt=ppt)

    #data.frame(date=dt)
}

#' Title
#'
#' @param ticker
#' @param datevec
#'
#' @return
#' @export
#'
#' @examples
LoadHFD <- function(ticker, datevec){
    # listdate should be in order
    # for example c("27/12/2018", "04/01/2019")
    final_data <- NULL
    for (i in 1:length(datevec)){
        url1 <- TickerUrl(ticker, datevec[i])
        data <- ReadHFD(url1, datevec[i])
        data <- HandleData(data)
        final_data <- rbind(final_data, data)
    }
    return(final_data)
}

