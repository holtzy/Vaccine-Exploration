function(input, output) {




  # --------------------#
  # --- MAP LEAFLET
  # --------------------#

  # create a reactive value that will store the click position
  data_of_click <- reactiveValues(clickedPolygon=NULL)

  # Leaflet map with 2 markers
  output$map <- renderLeaflet({

    # Select a year:
    myYear <- input$sliderYear
    selectedData <- data %>% filter(year==myYear)
    # Add the vaccines values to the data slot:
    tmp_spdf <- data_spdf
    print(head(tmp_spdf@data))
    tmp_spdf@data <- tmp_spdf@data %>% left_join(selectedData, by=c("NAME" = "state"))
    print(head(tmp_spdf@data))

    # Create a color palette for the map:
    mypalette = colorNumeric( palette="inferno", domain=range(data$count, na.rm=T), na.color="#F0F0F0", reverse=TRUE)

    # Prepare the text for the tooltip:
    mytext <- paste("State: ", tmp_spdf@data$NAME, "<br/>", "Year: ", myYear, "<br/>", "Value: ", tmp_spdf@data$count, "<br/>", "Click state for more", sep="") %>%
      lapply(htmltools::HTML)

    # Create the map
      leaflet( tmp_spdf ) %>%
        addProviderTiles(providers$OpenStreetMap, options = providerTileOptions(minZoom = 3, maxZoom = 7)) %>%
        setView(-96, 37.8, 3) %>%
        addPolygons(
          layerId = ~NAME,
          fillColor = ~mypalette(count), stroke=TRUE, fillOpacity = 0.9, color="white", weight=0.3,
          highlight = highlightOptions( weight = 5, color = "black", dashArray = "", fillOpacity = 0.8, bringToFront = TRUE),
          label = ~NAME,
          labelOptions = labelOptions( style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", direction = "auto")
        ) %>%
        addLegend( pal=mypalette, values=range(data$count, na.rm=T), opacity=0.9, title = "# infected people", position = "bottomleft" )
    })

  # store the click
  observeEvent(input$map_shape_click,{
    data_of_click$clickedShape <- input$map_shape_click
    print(data_of_click$clickedShape$id)
  })





  # --------------------#
  # --- LINE CHART
  # --------------------#


  output$plot_line <- renderPlot({

    # Recover the place that has been clicked
    my_place = data_of_click$clickedShape$id

    p <- data %>%
      ggplot( aes(x=year, y=count, group=state)) +
        geom_line(color="grey") +
        ylab("# of infected people") +
        geom_vline( xintercept=1963, color="black", size=1) +
        annotate("text", x = 1980, y = 2500, label = "vaccine introduction" , color="black", size=5, fontface="bold") +
        theme(
          legend.position = "none"
        ) +
        theme_ipsum()

    # If a state is selected, show it
    if(!is.null(my_place)){
      p <- p +
        geom_line(data = data %>% filter(state==my_place), color="purple", size=2)
    }

    # Show plot
    p


  })






  # --------------------#
  # --- INFO BOX
  # --------------------#


  output$selectedState <- renderText({
    # Recover the place that has been clicked
    my_place <- data_of_click$clickedShape$id
    if(is.null(my_place)){
      my_place <- "Click on the map to select"
    }
    return(my_place)
  })

  output$maxState <- renderText({
    # Recover the place that has been clicked
    my_place <- data_of_click$clickedShape$id
    if(!is.null(my_place)){
      myMax <- data %>% filter(state == my_place) %>% select(count) %>% max(na.rm=T) %>% as.character()
    }else{
      myMax <- "-"
    }
    return(myMax)
  })

  output$minState <- renderText({
    # Recover the place that has been clicked
    my_place <- data_of_click$clickedShape$id
    if(!is.null(my_place)){
      myMin <- data %>% filter(state == my_place) %>% select(count) %>% min(na.rm=T) %>% as.character()
    }else{
      myMin <- "-"
    }
    return(myMin)
  })

  # --------------------#
  # --- HEATMAP
  # --------------------#

  output$plot_heatmap <- renderHighchart({

    fntltp <- JS("function(){
      return this.point.x + ' ' +  this.series.yAxis.categories[this.point.y] + ':<br>' +
      Highcharts.numberFormat(this.point.value, 2);
    }")

    plotline <- list(
      color = "#fde725", value = 1963, width = 2, zIndex = 5,
      label = list(
        text = "Vaccine Intoduced", verticalAlign = "top",
        style = list(color = "#606060"), textAlign = "left",
        rotation = 0, y = -5)
    )

    hchart(vaccines, "heatmap", hcaes(x = year, y = state, value = count)) %>%
      hc_colorAxis(stops = color_stops(10, rev(inferno(10))),
                   type = "logarithmic") %>%
      hc_yAxis(reversed = TRUE, offset = -20, tickLength = 0,
               gridLineWidth = 0, minorGridLineWidth = 0,
               labels = list(style = list(fontSize = "8px"))) %>%
      hc_tooltip(formatter = fntltp) %>%
      hc_xAxis(plotLines = list(plotline)) %>%
      hc_title(text = "Infectious Diseases and Vaccines") %>%
      hc_legend(layout = "vertical", verticalAlign = "top",
                align = "right", valueDecimals = 0) %>%
      hc_size(height = 800)

  })


}
