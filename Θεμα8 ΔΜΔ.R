n<- 120

x<- runif(n, min = 1, max=20)
y<- (x-10)^2 + runif(n, min = 1, max = 30)

trainingsset<- data.frame(x=x,y=y)
plot(trainingsset)


#poly1

model.x1 <- lm(y~x,data = trainingsset)
abline(model.x1)
y.pred<-predict(model.x1)

points(x,y.pred,col="red")

mean((y-y.pred)^2)

#poly2

poly(x,2)
model.x2<- lm(y~poly(x,2),data = trainingsset)

y.pred.x2<- predict(model.x2)

plot(trainingsset)

points(x,y.pred.x2,col="red")

mean((y-y.pred.x2)^2)

x.pred<- seq(0,20,by=0.1)
y.pred.x2<-predict(model.x2,newdata = data.frame(x=x.pred))

lines(x.pred,y.pred.x2,col="red")

model.x8<-lm(y~poly(x,8))

mean((y-predict(model.x8))^2)

y.pred.x8<-predict(model.x8,newdata = data.frame(x=x.pred))

lines(x.pred,y.pred.x8,col="blue")


x<- runif(n, min = 1, max=40)
y<- (x-10)^2 + runif(n, min = 1, max = 30)

testset<-data.frame(x=x,y=y)
plot(testset,type="n")

points(trainingsset)
points(testset,col="red")

lines(x.pred,y.pred.x8,col="blue")

pred.testset.x8<-predict(model.x8,newdata = testset)
mean((testset$y-pred.testset.x8)^2)

lines(1:40,predict(model.x8,newdata = data.frame(x=1:40)))
lines(1:40,predict(model.x2,newdata = data.frame(x=1:40)),col="red")

pred.testset.x2<-predict(model.x2,newdata = testset)
mean((testset$y-pred.testset.x2)^2)


daten<-data.frame(x=x,y=y)
haelften<-samlpe(rep(1:2,length(x),out=n)
testset<-daten[haelften==1,]
trainingsset<-daten[haelften==2,]                 

plot(testset,xlim=c(0,20))
points(trainingsset,col="red")

model.x2<- lm(y~poly(x,2),data = trainingsset)

y.pred.x2<- predict(model.x2)

plot(trainingsset)

points(trainingsset$x,y.pred.x2,col="red")

y.pred.x2.testset<-predict(model.x2,newdata=testset)

mean((testset$y-y.pred.x2.testset)^2)
mean((trainingsset$y-predict(model.x2))^2)

##
model.x4<- lm(y~poly(x,4),data = trainingsset)

y.pred.x4<- predict(model.x4)

plot(trainingsset)

points(trainingsset$x,y.pred.x4,col="red")

y.pred.x4.testset<-predict(model.x4,newdata=testset)

mean((testset$y-y.pred.x4.testset)^2)

mean((trainingsset$y-predict(model.x4))^2)

 