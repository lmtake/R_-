
library(CARS) #mtcarsデータ使用のため
head(mtcars)

#latticeExtraを使用してスムージングヒートマップを作成
library(latticeExtra) 
windowsFonts("MEI"=windowsFont("Meiryo"))#メイリオをMEIという名前でフォント指定
#燃費(mpg)に対する排気量(disp)とシリンダー個数(cyl)のプロット
levelplot(mpg ~ disp * cyl, mtcars, 
          panel = panel.levelplot.points, cex = 1.2,
          main="燃費への影響",
          sub ="mtcarsデータより",
          xlab="排気量",
          ylab="シリンダー個数",
          ylim=c(4,8),
          par.settings=list(axis.text=list(fontfamily="MEI"),
                            par.xlab.text=list(fontfamily="MEI"),
                            par.ylab.text=list(fontfamily="MEI"),
                            par.main.text=list(fontfamily="MEI"),
                            par.sub.text=list(fontfamily="MEI"))
          
) + 
  layer_(panel.2dsmoother(..., n = 200))

#等高線マップ作成
#下記は参考サイト
#http://www.okadajp.org/RWiki/?%E3%82%B0%E3%83%A9%E3%83%95%E3%82%A3%E3%83%83%E3%82%AF%E3%82%B9%E5%8F%82%E8%80%83%E5%AE%9F%E4%BE%8B%E9%9B%86%EF%BC%9A%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E5%9B%B3
#https://www.imsbio.co.jp/RGM/R_rdfile?f=akima/man/interp.Rd&d=R_CC

library(akima)#等高線マップは歯抜けのデータでは描けないので補間するためakimaを使用
akima.T <- interp(mtcars$disp,mtcars$cyl,mtcars$mpg,duplicate = "mean")
#akimaのinterpにてdisp,cyl,mpgをx,y,zに補間して格納

par(family="MEI")#フォント指定
image(akima.T$x,akima.T$y,akima.T$z,
      xlab="排気量",
      ylab="シリンダー個数")
contour(akima.T$x,akima.T$y,akima.T$z,add=TRUE)#等高線マップ作成
points(mtcars$disp,mtcars$cyl) # 実際に与えられたデータ点の位置をプロット

####補間を細かく

akima.TF <- interp(mtcars$disp,mtcars$cyl,mtcars$mpg,duplicate = "mean",
                       linear = T,
                       xo=seq(min(mtcars$disp), max(mtcars$disp), length=200),
                       yo=seq(min(mtcars$cyl), max(mtcars$cyl), length=200))
#akimaのinterp2xyzにてdisp,cyl,mpgをx,y,zに補間して格納,細かく標準40区切りを200区切りに

par(family="MEI")#フォント指定
image(akima.TF$x,akima.TF$y,akima.TF$z,
      xlab="排気量",
      ylab="シリンダー個数")
contour(akima.TF$x,akima.TF$y,akima.TF$z,add=TRUE)#等高線マップ作成
points(mtcars$disp,mtcars$cyl) # 実際に与えられたデータ点の位置をプロット
