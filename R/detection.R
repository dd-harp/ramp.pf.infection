







Detect = function(xi, a=0, Cpar=par_nbCounts()){
  UseMethod("Detect", Cpar)
}

dCounts = function(hatxi, xi, a=0, Cpar=par_nbCounts()){
  UseMethod("dCounts", Cpar)
}

pCounts = function(hatxi, xi, a=0, Cpar=par_nbCounts()){
  UseMethod("pCounts", Cpar)
}

binnedCounts = function(xi, TensBins=TRUE, a=0, Cpar=par_nbCounts()){
  UseMethod("binnedCounts", Cpar)
}

par_nbCounts = function(q=6, sz=0.31, bvm = par_lRBC.0()){
  par = list()
  class(par) <- "nb"
  par$q=q
  par$sz=sz
  par$bvm = bvm
  par
}

Detect.nb = function(xi, a=0, Cpar=par_nbCounts()){with(Cpar,{
  lRBC = log10RBC(a, bvm)
  1-dnbinom(0, mu=10^(xi-lRBC+q), size=sz)
})}





dCounts.nb = function(hatxi, xi, a=0, Cpar=par_nbCounts()){with(Cpar,{
  lRBC = log10RBC(a, bvm)
  dnbinom(round(10^hatxi), mu=10^(xi-lRBC+q), size=sz)
})}





pCounts.nb = function(hatxi, xi, a=0, Cpar=par_nbCounts()){with(Cpar,{
  lRBC = log10RBC(a, bvm)
  pnbinom(10^hatxi, mu=10^(xi-lRBC+q), size=sz)
})}





binnedCounts.nb = function(xi, a=0, Cpar=par_nbCounts(), bins=NULL){
  if(is.null(bins)) bins=c(1:5,13)
  p0 = Detect(xi,a,Cpar)
  p1 = pCounts(bins, xi, a, Cpar)
  diff(c(1-p0,p1))/p0
}







par_poisCounts = function(q=6, bvm = par_lRBC.0()){
  par = list()
  class(par) <- "pois"
  par$q=q
  par$bvm = bvm
  par
}

Detect.pois = function(xi, a=0, Cpar=par_poisCounts()){with(Cpar,{
  lRBC = log10RBC(a, bvm)
  1-dpois(0, 10^(xi-lRBC+q))
})}





dCounts.pois = function(hatxi, xi, a=0, Cpar=par_poisCounts()){with(Cpar,{
  lRBC = log10RBC(a, bvm)
  dpois(round(10^hatxi), 10^(xi-lRBC+q))
})}





pCounts.pois = function(hatxi, xi, a=0, Cpar=par_poisCounts()){with(Cpar,{
  lRBC = log10RBC(a, bvm)
  ppois(10^hatxi, 10^(xi-lRBC+q))
})}





binnedCounts.pois = function(xi, a=0, Cpar=par_poisCounts(), bins=NULL){
  if(is.null(bins)) bins=c(1:5,13)
  p0 = Detect(xi,a,Cpar)
  p1 = pCounts(bins, xi, a, Cpar)
  diff(c(1-p0,p1))/p0
}




plotCounts.TensBins = function(pdf, llwd=2, tol = 1e-3, clr="black", mtl=""){
  plot(1:6, pdf, type = "h", lwd=llwd, xaxt = "n", xlab = expression(P), ylab="Frequency", xlim = c(0,7), ylim = c(0,1), col = clr, main = mtl)
  axis(1, c(1:7)-0.5, c(1, expression(10), expression(10^2), expression(10^3), expression(10^4), expression(10^5), expression(infinity)))
}

addCounts.TensBins = function(pdf, llwd=2, offset = 0.1, clr="darkgreen"){
  lines(1:6+offset, pdf, type = "h", lwd=llwd, col = clr)
}

DetectPa = function(a, FoIpar,
                    hhat=NULL,tau=0, r=1/200,
                    pMu=par_alpha2mu.0(),
                    pRBC=par_lRBC.0(),
                    pSig=par_sigma.0(),
                    pWda=par_Wda.delta(),
                    pC = par_nbCounts()){
  pD = function(a, FoIpar, hhat, tau, r, pMu, pRBC, pSig, pWda, pC){
    Dx = function(x, a, FoIpar, hhat, tau, r, pMu, pRBC, pSig, pWda, pC){
      dDensityPa(x, a, FoIpar, hhat, tau, r, pMu, pRBC, pSig, pWda)*Detect(x,a,pC)
    }
    hatb=log10RBC(a,pRBC)
    integrate(Dx, 0, hatb, a=a, FoIpar=FoIpar, hhat=hhat,tau=tau,r=r,pMu=pMu,pRBC=pRBC, pSig=pSig,pWda=pWda, pC=pC)$value
  }
  if(length(a)==1) return(pD(a, FoIpar, hhat, tau, r, pMu, pRBC, pSig, pWda, pC))
  return (sapply(a, pD, FoIpar=FoIpar, hhat=hhat, tau=tau, r=r, pMu=pMu, pSig=pSig, pRBC=pRBC, pWda=pWda, pC=pC))
}



DetectPM = function(a, FoIpar,
                    hhat=NULL,tau=0, r=1/200,
                    pMu=par_alpha2mu.0(),
                    pRBC=par_lRBC.0(),
                    pSig=par_sigma.0(),
                    pWda=par_Wda.delta(),
                    pC = par_nbCounts()){

  moi = meanMoI(a, FoIpar, hhat, tau, r)
  D = DetectPa(a, FoIpar, hhat, tau, r, pMu, pRBC, pSig, pWda, pC)
  1 - exp(-moi*D)
}



DetectBda = function(a, FoIpar, dx=0.1,
                     hhat=NULL,tau=0, r=1/200,
                     pMu=par_alpha2mu.0(),
                     pRBC=par_lRBC.0(),
                     pSig=par_sigma.0(),
                     pWda=par_Wda.delta(),
                     pC = par_nbCounts()){

  lRBC = log10RBC(a, pRBC)
  meshX = seq(0, lRBC, by = dx)
  Bx = Bda(meshX, a, FoIpar, hhat, tau, r, pMu, pRBC, pSig, pWda)$PDFm
  Bx = Bx/sum(Bx)
  t(Detect(meshX, a, pC)) -> Bs
  sum(Bx*Bs)
}



MoIPM = function(a, FoIpar,
                 hhat=NULL,tau=0, r=1/200,
                 pMu=par_alpha2mu.0(),
                 pRBC=par_lRBC.0(),
                 pSig=par_sigma.0(),
                 pWda=par_Wda.delta(),
                 pC = par_nbCounts()){

  moi = meanMoI(a, FoIpar, hhat, tau, r)
  D = DetectPa(a, FoIpar, hhat, tau, r, pMu, pRBC, pSig, pWda, pC)
  moi*D/(1-exp(-moi*D))
}