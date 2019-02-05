dashboardPage(

  # Choose general theme
  skin = "purple",

  # Header
  dashboardHeader( title = "Vaccines"),

  # Sidebar
  dashboardSidebar(
    sidebarMenu(
      HTML("<center><p><i><br>An application to explore<br>the potential impact of<br>vaccination on diseases.</i></p></center>"),
      hr(),
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Heatmap", tabName = "heatmap", icon = icon("th")),
      menuItem("About", tabName = "about", icon = icon("plus"))
    )
  ),



  dashboardBody(

    # Load specific css
    tags$head( tags$link(rel = "stylesheet", type = "text/css", href = "custom.css") ),

    tabItems(

      # ------ FIRST TAB = MAP + LINE
      tabItem(tabName = "dashboard",
        fluidRow(

          # MAP
          box(
            title = "Geographic distribution", status = "primary", solidHeader = TRUE,
            # This set the height to almost 100%. Looks good on Macbook pro at least
            tags$style(type = "text/css", "#map {height: calc(80vh - 100px) !important;}"),
            leafletOutput("map"),
            sliderInput("sliderYear", "Year of observation", 1928, 2003, 1932)
          ),

          # LINE PLOT
          box(
            title = "Evolution through years", status = "primary", solidHeader = TRUE,
            plotOutput("plot_line"),
            footer = "Click on the map to highlight a state"
          ),

          # INFOBOX
          infoBox("State", textOutput("selectedState"), icon = icon("map-marker"), fill = TRUE, width=3, color="purple"),
          infoBox("Max recorded", textOutput("maxState"), icon = icon("level-up"), fill = FALSE, width=3, color="purple"),
          infoBox("Min recorded", textOutput("minState"), icon = icon("level-down"), fill = FALSE, width=3, color="purple"),
          infoBox("", "Click on a state to see the detail of its evolution", fill = FALSE, width=3, color="purple")
        )
      ),



      # ------ SECOND TAB = HEATMAP
      tabItem(tabName = "heatmap",
        highchartOutput("plot_heatmap", height = 640)
      ),



      # ------ TAB ABOUT
      tabItem(tabName = "about",
        column(6,
          box(
            h2("About"),
            "This app has been created by Yan Holtz as a demo of shiny skills. It took about 15 minutes to visit the highchart webpage, pick a dataset and think about a dashboard setup. It then took about 1h to create the app, host it on my shiny server and put the code on github."
          ),
          box(
            h2("Code"),
            "Code is fully available on",
            a(href="https://github.com/holtzy/Vaccine-Exploration", "github")
          ),
          box(
            h2("Contact"),
            "Please contact me at",
            a(href='mailto:yan.holtz.data@gmail.com', 'yan.holtz.data@gmail.com'),
            "for more information concerning this work.",
            br(),
            "Also, please visit",
            a(href="https://www.yan-holtz.com", "yan-holtz.com"),
            "for more information concerning my profile."
          )
        )
      )

    )
  )

)
