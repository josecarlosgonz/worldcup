# Fun charts
# How many players are right and lefthanded
format((table(mapData$foot) / length(mapData$foot))*100, digits=2)
# How tall are the players
require(ggplot2)
qplot(mapData$heightCm)
# Weigth
names(mapData)
qplot(mapData$weightKg)
# Position
qplot(mapData$position)
# Club
qplot(mapData$clubId)
