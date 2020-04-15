#git add Probabilities.R #git commit -m "Navn p� �ndring" #git push #git pull
rm(list=ls())
library(matlib)
setwd("C:/Users/lucas/Desktop/Odd")
#Henter og verificerer data
data <- read.table("kampe_r.csv",header=T,sep=",")
head(data)
str(data)
#fikser datatypes
data$H <- as.character(data$H)
data$U <- as.character(data$U)
attach(data)
#s�tter Y-kontingenstabellen op:
#hjemmesejre
aggregate(data$Hsejr,by=list(H=data$H),FUN=sum)
#udesejre
aggregate(data$Usejr,by=list(U=data$U),FUN=sum)

#Danner loglikelihood funktionen
#testv�rdier
beta = c(1.6758,0.0269404)
theta = 1.59384
dx2x <- deriv(~ x^2, "x") ; 
x <- cbind(c(0.23,4),c(0.67,29),c(0.51,7))
Y <- cbind(c(0,13,12),c(3,0,3),c(5,13,0))
#Opskriver log-likelihoodfunktion
i=1;j=1;sum=0;r=20;
logl <- function(beta,theta,x){
  sum=0;
  for (i in 1:(dim(x)[2]-1)){
    for (j in (i+1):(dim(x)[2])){
      sum = sum +Y[i,j]*(t(x[,i])%*%beta-log(exp(t(x[,i])%*%beta)+theta*exp(t(x[,j])%*%beta)))+
                 Y[j,i]*(t(x[,j])%*%beta-log(exp(t(x[,j])%*%beta)+theta*exp(t(x[,i])%*%beta)))+
                 (r-Y[i,j]-Y[j,i])*(log(theta^2-1)+t(x[,i])%*%beta+t(x[,j])%*%beta-log(exp(t(x[,i])%*%beta)+
                 theta*exp(t(x[,j])%*%beta))-log(exp(t(x[,j])%*%beta)+theta*exp(t(x[,i])%*%beta)))
    }
 }
return(sum)
}
logl(beta,theta,x)
i=1;j=1;sum=0;r=20;
#Definerer dldb til at v�re f�rste afledte ift. beta
db = c(0,0)
#db <- as.vector(db)
dldb <- function(beta,theta,x){
  db=c(0,0);
  for(i in 1:dim(x)[1]){
    for(j in (i+1):(dim(x)[2])) {
      db = db+ ((r-Y[i,j])*(-(theta*exp(t(x[,i])%*%beta))/(exp(t(x[,j])%*%beta)+theta*exp(t(x[,i])%*%beta)))
           +(r-Y[j,i])*((theta*exp(t(x[,j])%*%beta))/(exp(t(x[,i])%*%beta)+theta*exp(t(x[,j])%*%beta)))
           )*(x[,i]-x[,j])
    }
  }
  return(db)
}
dldb(beta,theta,x)#-7.809544e-06 -4.273634e-04 
#T�nker det egentligt er fint, at dldb giver 0,0?
#Det betyder vel bare at det givne data er ved et stationert punkt?