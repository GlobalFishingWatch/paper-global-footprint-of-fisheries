Tracking the Global Footprint of Fisheries: Figure 2
================

This code replicates Figure 2, Panel A from the paper Tracking the Global Footprint of Fisheries using the publicly available Big Query tables provided by Global Fishing Watch.

#### Figure Prep

``` r
library(ggplot2)
library(bigrquery)
library(dplyr)

theme_gfw_paper <-  theme(text = element_text(family="Arial", face="bold", size=10),
        axis.text.x = element_text(size = 12, colour = "black"),
        axis.text.y = element_text(size = 12, colour = "black"),
        axis.line.x = element_line(colour = "black", size = .5),
        axis.line.y = element_line(colour = "black", size = .5),
        legend.position = "bottom",
        axis.title.y = element_text(size = 12, margin=margin(0,15,0,0)),
        axis.title.x = element_text(size = 12, margin=margin(15,0,0,0)),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black"),
        plot.margin = unit(c(1,1,1,1), "cm")
        )
```

### Global Patterns Panel

Query to generate the total fishing hours group by latitude, day and year. The original plot provided finer resolution of grouping by 12 hours (0.5 day), but a similar plot is possible using day aggregated data.

``` sql
  SELECT
  SUM(fishing_hours) total_fishing_hours,
  FLOOR((lat_bin/100)*4)/4 lat_bin,
  integer(DAYOFYEAR(date)) day,
  integer(YEAR(date)) year,
  FROM
    [global-fishing-watch:global_footprint_of_fisheries.fishing_effort]
  WHERE
    _PARTITIONTIME >= "2013-01-01 00:00:00"
    AND _PARTITIONTIME < "2017-01-01 00:00:00"
    AND fishing_hours > 0
GROUP BY
  lat_bin,
  day,
  year
```

``` r
head(global_fish_patterns)
```

    FALSE   total_fishing_hours lat_bin day year
    FALSE 1           916.32431   28.00 135 2013
    FALSE 2            75.48111  -41.00 135 2013
    FALSE 3           205.26847   41.00 135 2013
    FALSE 4           160.95694   25.75 135 2013
    FALSE 5           236.71694   41.50 135 2013
    FALSE 6           304.75556   26.50 135 2013

#### Data Processing

Here we processes the dates and replace a date that is irrecoverably missing (2013-05-31). The values for that date are imputed as the mean fishing hours for the preceeding and following day at each latitude.

``` r
global_fish_patterns$date = format(as.Date(paste(global_fish_patterns$year, 
                                                global_fish_patterns$day, 
                                                sep='-'),"%Y-%j"), "%Y-%m-%d")

#get May 30, 2013 and June 1, 2013 and average to substitute for the missing May 31, 2013
may_31_estimate = global_fish_patterns %>% 
    filter(date == as.Date('2013-05-30') | date == as.Date('2013-06-01')) %>%
    group_by(lat_bin) %>%
    summarize(total_fishing_hours = mean(total_fishing_hours, na.rm = TRUE))
may_31_estimate$day = c(rep(151, nrow(may_31_estimate)))
may_31_estimate$year = c(rep(2013, nrow(may_31_estimate)))
may_31_estimate$date = c(rep('2013-05-31', nrow(may_31_estimate)))
global_fish_patterns = rbind(global_fish_patterns, may_31_estimate)
```

Additional processing for generating appropriate color scale

``` r
global_fish_patterns$maxxed_hours = ifelse(global_fish_patterns$total_fishing_hours >= 1000, 
                                           1000, 
                                           global_fish_patterns$total_fishing_hours) #originally 10000
global_fish_patterns$maxxed_hours = ifelse(global_fish_patterns$total_fishing_hours <=1, 
                                           1, 
                                           global_fish_patterns$total_fishing_hours)
global_fish_patterns$maxxed_hours = ifelse(global_fish_patterns$lat_bin < -85, 
                                           0, 
                                           global_fish_patterns$maxxed_hours) #just to clean up a few odd points
```

### Making Plot

``` r
color_grad = c( "#414487", "#2A788E", "#22A884", "#7AD151","#FDE725","#FFC04C")
    back_fill = 'black'
    
global_patterns_plot <- ggplot2::ggplot() +
        ggplot2::geom_raster(data = global_fish_patterns,
                    aes(as.Date(date),lat_bin,
                        fill = log10(maxxed_hours*4)),
                    interpolate = TRUE)+
        ggplot2::scale_fill_gradientn("Fishing Effort     \n",
                             colors = color_grad,
                             na.value = NA,
                             breaks = c(0.60206,1.60206, 2.60206, 3.60206, 4.60206),
                             limits = c(0.60206,4.60206),
                             labels = c('0', '0.4','4','40','>400') #,
                             #guide = 'none'
        ) +
        ggplot2::scale_x_date('Year', date_breaks = 'year', date_labels = '%Y',
                     expand = c(0,0),
                     limits = c(as.Date('2013-01-01'), as.Date('2017-01-01'))) +
        ggplot2::scale_y_continuous('Latitude',
                           limits = c(-90, 90),
                           breaks = c(seq(-90,90, 45)),
                           expand = c(0,0)) +
        theme_gfw_paper +
        theme(text = element_text(family="Arial", face="bold", size=10),
              axis.text.x = element_text(size = 12, colour = "black"),
              axis.text.y = element_text(size = 12, colour = "black"),
              axis.line.x = element_line(colour = "black", size = .5),
              axis.line.y = element_line(colour = "black", size = .5),
              axis.title.y = element_text(size = 12, margin=margin(0,15,0,0)),
              axis.title.x = element_text(size = 12, margin=margin(15,0,0,0)),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              axis.line = element_line(colour = "black"),
              # legend.position = 'bottom',
              # legend.direction = 'horizontal',
              # legend.key.height = unit(.2, 'cm'),
              # legend.key.width = unit(1,'cm'),
              # legend.title.align = 0,
              legend.position = 'none',
              panel.background = element_rect(fill = back_fill ),
              plot.margin = unit(c(1, 1,1,1), 'cm'))
global_patterns_plot
```

![](Tracking_Global_Footprint_Fisheries_Figure2_code_files/figure-markdown_github/unnamed-chunk-7-1.png)

##### Making Legend

Generating a separate legend for the plot for flexibility and convenience.

``` r
library(cowplot)
global_patterns_legend <- ggplot2::ggplot() +
        ggplot2::geom_raster(data = global_fish_patterns,
                    aes(as.Date(date),lat_bin,
                        fill = log10(maxxed_hours*4)),
                    interpolate = TRUE)+
        ggplot2::scale_fill_gradientn("Fishing Effort     \n",
                             colors = color_grad,
                             na.value = NA,
                             breaks = c(0.60206,1.60206, 2.60206, 3.60206, 4.60206),
                             limits = c(0.60206,4.60206),
                             labels = c('0', '0.4','4','40','>400') #,
                             #guide = 'none'
        ) +
        theme_gfw_paper +
        theme(legend.position = 'bottom',
              legend.direction = 'horizontal',
              legend.key.height = unit(.2, 'cm'),
              legend.key.width = unit(1,'cm'),
              legend.title.align = 0,
              panel.background = element_rect(fill = back_fill ),
              plot.margin = unit(c(1, 1,1,1), 'cm'))

global_legend <- get_legend(global_patterns_legend)
```
