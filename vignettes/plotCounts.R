## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(ramp.pf.infection)

## -----------------------------------------------------------------------------
plotContour=function(surfObj, ylb, mlb, alim=NULL, blim=NULL,nclr=20, bks=NULL, dd=1){with(surfObj,{
 if(!is.null(alim)) {
    surf = surf[,1:alim]
    y = y[1:alim]
  } 
  if(!is.null(blim)){
    surf = surf[-c(1:blim),]
    x = x[-c(1:blim)]
  } 
  labX = pretty(x)
  Xtk = seq(0,1,length.out=length(labX)) 
  labY = pretty(y) 
  Ytk = seq(0,1,length.out=length(labY)) 
  if(is.null(bks)){
    clrs = viridis(nclr, option="A", direction=dd)
    filled.contour(surf, main = mlb, xlab = expression(list(alpha, "Parasite Cohort Age (in Days)")), ylab = ylb, xaxt = "n", yaxt = "n", nlevels=nclr, col = clrs, plot.axes={axis(2, Ytk, labY); axis(1,Xtk, labX)})
  } 
  if(!is.null(bks)){
    clrs = c(viridis(length(bks)+1, option="A", direction=dd))
    #clrs = c("black", viridis(length(bks), option="A", direction=dd)) 
    filled.contour(surf, main = mlb, xlab = expression(list(alpha, "Parasite Cohort Age (in Days)")), ylab = ylb, xaxt = "n", yaxt = "n", levels=bks, col = clrs, plot.axes={axis(2, Ytk, labY); axis(1,Xtk, labX)})
  }
})}

## -----------------------------------------------------------------------------
mufig = function(){
  aa5 = 8:200
  plot(aa5, alpha2mu(aa5, 0, parMu.0()), type = "l", ylim = c(0,13), xlim = c(-10, 200), lwd=2, xlab = expression(list(alpha, "Parasite Cohort Age (in Days)")), ylab= expression(mu(alpha)))
  lines(aa5, alpha2mu(aa5, 5, parMu.W(Sw=1/30)), col = clrs8d[1])
  lines(aa5, alpha2mu(aa5, 10, parMu.W(Sw=1/30)), col = clrs8d[3])
  lines(aa5, alpha2mu(aa5, 15, parMu.W(Sw=1/30)), col = clrs8d[5])
  lines(aa5, alpha2mu(aa5, 20, parMu.W(Sw=1/30)), col = clrs8d[7])
  text(5, 11.5, "Acute
  Growth
  Phase", cex=0.8)

  text(35, 11.5, "Chronic
  Decay
  Phase", cex=0.8)

  segments(20,0,20,12, col = grey(0.5), lwd=2, lty=2)
  segments(7,0,7,6, col = "darkred", lwd=2, lty=2)
  points(0,0, pch = 19, col = "purple")
  text(-2, 1, "Bite", col = "purple")
}

## -----------------------------------------------------------------------------
Pfig = function(){
  par(mfrow = c(1,2), mar = c(5,4,2,5))
  aa5 = 8:400
  meshX = seq(0,13,by=0.01)
  W = Wda(5*365, foiP3, par=par_Wda.delta())
  muA = alpha2mu(aa5, W, par=par_alpha2mu.W())
  aoi = dAoI(aa5, 5*365, foiP3) 

  plot(aa5, muA, lwd=2, type="l", ylim = c(0,13), xlab = expression(list(alpha, "Parasite Cohort Age (in Days)")), ylab = expression(mu(alpha)))
  lines(aa5, aoi*max(muA)/max(aoi), col = "darkred")
  #plot(muA, aa5, lwd=2, type="l", xlim = c(0,13), ylab = expression(list(a, "Host Cohort Age (in Days)")), xlab = expression(log[10](xi)))
  #lines(aoi*max(muA)/max(aoi), aa5, col = "darkred")
  ax4 = round(1e4*c(0, max(aoi)/2, max(aoi)))*1e-4
  axis(4, ax4*max(muA)/max(aoi), ax4, col = "darkred", col.ticks="darkred")
  mtext("a)", 3, 1, at=-1)
  #axis(3, ax4*max(muA)/max(aoi), ax4, col = "darkred", col.ticks="darkred")
  mtext(expression(A),  4, line=2, col = "darkred")
  #plot(meshX, dDensityPa(meshX, 5*365, foiP3), type = "l", xlim = c(0,13), lwd=2, xlab = expression(list(log[10](xi), "Logged Parasite Densities")), ylab= expression(mu(alpha)))
  plot( dDensityPa(meshX, 5*365, foiP3), meshX, type = "l", ylim = c(0,13), lwd=2, ylab = expression(log[10](xi)), xlab= expression(list(P, "Parasite Cohort Density")))
  mtext("b)", 3, 1, at=0)
}

